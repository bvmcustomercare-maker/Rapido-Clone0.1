import '../../../../core/utils/result.dart';
import '../entities/place.dart';
import '../entities/vehicle.dart';
import '../repositories/home_repository.dart';

/// Use case to retrieve recent places (PRD §FR-HOME-003)
class GetRecentPlacesUseCase {
  final HomeRepository repository;
  const GetRecentPlacesUseCase(this.repository);

  Future<Result<List<Place>>> call() {
    return repository.getRecentPlaces();
  }
}

/// Use case to retrieve favourite places (PRD §FR-HOME-003)
class GetFavouritePlacesUseCase {
  final HomeRepository repository;
  const GetFavouritePlacesUseCase(this.repository);

  Future<Result<List<Place>>> call() {
    return repository.getFavouritePlaces();
  }
}

/// Use case to add a place to recents (PRD §FR-LOC-003)
class AddRecentPlaceUseCase {
  final HomeRepository repository;
  const AddRecentPlaceUseCase(this.repository);

  Future<Result<void>> call(Place place) {
    return repository.addRecentPlace(place);
  }
}

/// Use case to toggle favourite on a place (PRD §FR-HOME-003)
class ToggleFavouriteUseCase {
  final HomeRepository repository;
  const ToggleFavouriteUseCase(this.repository);

  Future<Result<Place>> call(Place place) {
    return repository.toggleFavourite(place);
  }
}

/// Use case to get available vehicle types (PRD §FR-HOME-004)
class GetVehicleTypesUseCase {
  final HomeRepository repository;
  const GetVehicleTypesUseCase(this.repository);

  Future<Result<List<Vehicle>>> call() {
    return repository.getVehicleTypes();
  }
}

/// Use case to clear all recent places
class ClearRecentPlacesUseCase {
  final HomeRepository repository;
  const ClearRecentPlacesUseCase(this.repository);

  Future<Result<void>> call() {
    return repository.clearRecentPlaces();
  }
}
