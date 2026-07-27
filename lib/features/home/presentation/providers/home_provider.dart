import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/datasources/home_local_data_source.dart';
import '../../data/models/place_dto.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/home_usecases.dart';
import '../viewmodels/home_state.dart';
import '../viewmodels/home_viewmodel.dart';

// ─── Data Source Provider ────────────────────────────────────────────────────

final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  final placesBox = Hive.box<PlaceDto>('places');
  return HomeLocalDataSourceImpl(placesBox: placesBox);
});

// ─── Repository Provider ─────────────────────────────────────────────────────

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final dataSource = ref.watch(homeLocalDataSourceProvider);
  return HomeRepositoryImpl(dataSource);
});

// ─── Use Case Providers ──────────────────────────────────────────────────────

final getRecentPlacesUseCaseProvider = Provider<GetRecentPlacesUseCase>((ref) {
  return GetRecentPlacesUseCase(ref.watch(homeRepositoryProvider));
});

final getFavouritePlacesUseCaseProvider =
    Provider<GetFavouritePlacesUseCase>((ref) {
  return GetFavouritePlacesUseCase(ref.watch(homeRepositoryProvider));
});

final addRecentPlaceUseCaseProvider = Provider<AddRecentPlaceUseCase>((ref) {
  return AddRecentPlaceUseCase(ref.watch(homeRepositoryProvider));
});

final toggleFavouriteUseCaseProvider = Provider<ToggleFavouriteUseCase>((ref) {
  return ToggleFavouriteUseCase(ref.watch(homeRepositoryProvider));
});

final getVehicleTypesUseCaseProvider = Provider<GetVehicleTypesUseCase>((ref) {
  return GetVehicleTypesUseCase(ref.watch(homeRepositoryProvider));
});

final clearRecentPlacesUseCaseProvider =
    Provider<ClearRecentPlacesUseCase>((ref) {
  return ClearRecentPlacesUseCase(ref.watch(homeRepositoryProvider));
});

// ─── ViewModel Provider ──────────────────────────────────────────────────────

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(
    getRecentPlaces: ref.watch(getRecentPlacesUseCaseProvider),
    getFavouritePlaces: ref.watch(getFavouritePlacesUseCaseProvider),
    addRecentPlace: ref.watch(addRecentPlaceUseCaseProvider),
    toggleFavourite: ref.watch(toggleFavouriteUseCaseProvider),
    getVehicleTypes: ref.watch(getVehicleTypesUseCaseProvider),
    clearRecentPlaces: ref.watch(clearRecentPlacesUseCaseProvider),
  );
});
