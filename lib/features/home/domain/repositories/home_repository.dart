import '../../../../core/utils/result.dart';
import '../entities/place.dart';
import '../entities/vehicle.dart';

/// Clean Architecture repository contract for the Home module (ENGINEERING_GUIDE.md §6.2)
abstract class HomeRepository {
  /// Get the list of recently used places (max 10, sorted by recency)
  Future<Result<List<Place>>> getRecentPlaces();

  /// Get only favourite places
  Future<Result<List<Place>>> getFavouritePlaces();

  /// Add a place to recent history (deduplicates by id)
  Future<Result<void>> addRecentPlace(Place place);

  /// Toggle the favourite status of a place
  Future<Result<Place>> toggleFavourite(Place place);

  /// Remove a place from recent history
  Future<Result<void>> removeRecentPlace(String placeId);

  /// Clear all recent places
  Future<Result<void>> clearRecentPlaces();

  /// Get the list of available vehicle types
  Future<Result<List<Vehicle>>> getVehicleTypes();
}
