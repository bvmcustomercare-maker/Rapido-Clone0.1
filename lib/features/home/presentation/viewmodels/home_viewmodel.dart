import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/usecases/home_usecases.dart';
import 'home_state.dart';

/// ViewModel managing all Home screen state (ENGINEERING_GUIDE.md §StateNotifier pattern)
class HomeViewModel extends StateNotifier<HomeState> {
  final GetRecentPlacesUseCase _getRecentPlaces;
  final GetFavouritePlacesUseCase _getFavouritePlaces;
  final AddRecentPlaceUseCase _addRecentPlace;
  final ToggleFavouriteUseCase _toggleFavourite;
  final GetVehicleTypesUseCase _getVehicleTypes;
  final ClearRecentPlacesUseCase _clearRecentPlaces;

  HomeViewModel({
    required GetRecentPlacesUseCase getRecentPlaces,
    required GetFavouritePlacesUseCase getFavouritePlaces,
    required AddRecentPlaceUseCase addRecentPlace,
    required ToggleFavouriteUseCase toggleFavourite,
    required GetVehicleTypesUseCase getVehicleTypes,
    required ClearRecentPlacesUseCase clearRecentPlaces,
  })  : _getRecentPlaces = getRecentPlaces,
        _getFavouritePlaces = getFavouritePlaces,
        _addRecentPlace = addRecentPlace,
        _toggleFavourite = toggleFavourite,
        _getVehicleTypes = getVehicleTypes,
        _clearRecentPlaces = clearRecentPlaces,
        super(const HomeState()) {
    _initialize();
  }

  /// Load initial data on creation
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.wait([
      _loadRecentPlaces(),
      _loadFavouritePlaces(),
      _loadVehicleTypes(),
    ]);
    state = state.copyWith(isLoading: false);
  }

  Future<void> _loadRecentPlaces() async {
    final result = await _getRecentPlaces();
    result.fold(
      (places) => state = state.copyWith(recentPlaces: places),
      (failure) {
        AppLogger.w('Failed to load recent places: ${failure.message}');
      },
    );
  }

  Future<void> _loadFavouritePlaces() async {
    final result = await _getFavouritePlaces();
    result.fold(
      (places) => state = state.copyWith(favouritePlaces: places),
      (failure) {
        AppLogger.w('Failed to load favourite places: ${failure.message}');
      },
    );
  }

  Future<void> _loadVehicleTypes() async {
    final result = await _getVehicleTypes();
    result.fold(
      (vehicles) {
        state = state.copyWith(
          vehicleTypes: vehicles,
          // Auto-select first vehicle on load
          selectedVehicle: vehicles.isNotEmpty ? vehicles.first : null,
        );
      },
      (failure) {
        AppLogger.w('Failed to load vehicle types: ${failure.message}');
      },
    );
  }

  // ─── Location Actions ────────────────────────────────────────────────────

  /// Set pickup location and persist to recents
  Future<void> setPickup(Place place) async {
    state = state.copyWith(pickup: place);
    await _addRecentPlace(place);
    await _loadRecentPlaces();
    AppLogger.d('Pickup set: ${place.name}');
  }

  /// Set destination and persist to recents
  Future<void> setDestination(Place place) async {
    state = state.copyWith(destination: place);
    await _addRecentPlace(place);
    await _loadRecentPlaces();
    AppLogger.d('Destination set: ${place.name}');
  }

  /// Clear pickup selection
  void clearPickup() {
    state = state.copyWith(clearPickup: true);
  }

  /// Clear destination selection
  void clearDestination() {
    state = state.copyWith(clearDestination: true);
  }

  // ─── Vehicle Actions ─────────────────────────────────────────────────────

  /// Select a vehicle type
  void selectVehicle(Vehicle vehicle) {
    state = state.copyWith(selectedVehicle: vehicle);
    AppLogger.d('Vehicle selected: ${vehicle.name}');
  }

  // ─── Fare Actions ────────────────────────────────────────────────────────

  /// Update manual fare input
  void updateFare(String value) {
    state = state.copyWith(fareInput: value);
  }

  // ─── Favourite Actions ───────────────────────────────────────────────────

  /// Toggle favourite status of a place
  Future<void> toggleFavourite(Place place) async {
    final result = await _toggleFavourite(place);
    result.fold(
      (updatedPlace) async {
        await _loadRecentPlaces();
        await _loadFavouritePlaces();
      },
      (failure) {
        AppLogger.w('Failed to toggle favourite: ${failure.message}');
        state = state.copyWith(errorMessage: failure.message);
      },
    );
  }

  /// Clear all recent places
  Future<void> clearRecentPlaces() async {
    final result = await _clearRecentPlaces();
    result.fold(
      (_) => state = state.copyWith(recentPlaces: []),
      (failure) {
        AppLogger.w('Failed to clear recents: ${failure.message}');
        state = state.copyWith(errorMessage: failure.message);
      },
    );
  }

  /// Dismiss error banner
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Full refresh (pull-to-refresh)
  Future<void> refresh() async {
    await _initialize();
  }
}
