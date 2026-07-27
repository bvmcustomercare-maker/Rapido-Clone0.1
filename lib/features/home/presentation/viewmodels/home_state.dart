import '../../domain/entities/place.dart';
import '../../domain/entities/vehicle.dart';

/// Immutable state class for the Home screen ViewModel
class HomeState {
  /// Recently used places (max 10)
  final List<Place> recentPlaces;

  /// Favourite places
  final List<Place> favouritePlaces;

  /// Available vehicle types
  final List<Vehicle> vehicleTypes;

  /// Currently selected pickup location
  final Place? pickup;

  /// Currently selected destination
  final Place? destination;

  /// Currently selected vehicle
  final Vehicle? selectedVehicle;

  /// Manual fare entered by user (₹)
  final String fareInput;

  /// True while loading places or vehicles
  final bool isLoading;

  /// Non-null when an error has occurred
  final String? errorMessage;

  const HomeState({
    this.recentPlaces = const [],
    this.favouritePlaces = const [],
    this.vehicleTypes = const [],
    this.pickup,
    this.destination,
    this.selectedVehicle,
    this.fareInput = '',
    this.isLoading = false,
    this.errorMessage,
  });

  /// Whether the confirm ride button should be enabled (PRD §FR-HOME-006)
  bool get canConfirmRide =>
      destination != null &&
      fareInput.isNotEmpty &&
      int.tryParse(fareInput) != null &&
      int.parse(fareInput) >= 1 &&
      int.parse(fareInput) <= 99999 &&
      selectedVehicle != null;

  HomeState copyWith({
    List<Place>? recentPlaces,
    List<Place>? favouritePlaces,
    List<Vehicle>? vehicleTypes,
    Place? pickup,
    bool clearPickup = false,
    Place? destination,
    bool clearDestination = false,
    Vehicle? selectedVehicle,
    String? fareInput,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      recentPlaces: recentPlaces ?? this.recentPlaces,
      favouritePlaces: favouritePlaces ?? this.favouritePlaces,
      vehicleTypes: vehicleTypes ?? this.vehicleTypes,
      pickup: clearPickup ? null : (pickup ?? this.pickup),
      destination:
          clearDestination ? null : (destination ?? this.destination),
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      fareInput: fareInput ?? this.fareInput,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
