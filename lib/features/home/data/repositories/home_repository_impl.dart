import '../../../../core/repository/base_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../models/place_dto.dart';

/// Concrete implementation of HomeRepository using local data sources (ENGINEERING_GUIDE.md §6.2)
class HomeRepositoryImpl extends BaseRepository implements HomeRepository {
  final HomeLocalDataSource _localDataSource;

  const HomeRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<Place>>> getRecentPlaces() {
    return executeSafe(() async {
      final dtos = await _localDataSource.getRecentPlaces();
      return dtos.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<Place>>> getFavouritePlaces() {
    return executeSafe(() async {
      final dtos = await _localDataSource.getFavouritePlaces();
      return dtos.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<Result<void>> addRecentPlace(Place place) {
    return executeSafe(() async {
      final dto = PlaceDto.fromEntity(
        place.copyWith(lastUsedAt: DateTime.now()),
      );
      await _localDataSource.savePlace(dto);
    });
  }

  @override
  Future<Result<Place>> toggleFavourite(Place place) {
    return executeSafe(() async {
      final toggled = place.copyWith(isFavourite: !place.isFavourite);
      final dto = PlaceDto.fromEntity(toggled);
      await _localDataSource.savePlace(dto);
      return toggled;
    });
  }

  @override
  Future<Result<void>> removeRecentPlace(String placeId) {
    return executeSafe(() async {
      await _localDataSource.removePlace(placeId);
    });
  }

  @override
  Future<Result<void>> clearRecentPlaces() {
    return executeSafe(() async {
      await _localDataSource.clearAll();
    });
  }

  @override
  Future<Result<List<Vehicle>>> getVehicleTypes() {
    return executeSafe(() async {
      // Hardcoded vehicle types per PRD §FR-HOME-004
      // No backend — vehicles are static simulation data
      return const [
        Vehicle(
          id: 'bike',
          name: 'Bike',
          description: 'Affordable rides on two wheels',
          capacity: '1',
          iconAsset: 'assets/icons/ic_bike.png',
        ),
        Vehicle(
          id: 'auto',
          name: 'Auto',
          description: 'Comfortable three-wheeler rides',
          capacity: '3',
          iconAsset: 'assets/icons/ic_auto.png',
        ),
        Vehicle(
          id: 'cab',
          name: 'Cab',
          description: 'Premium four-wheeler experience',
          capacity: '4',
          iconAsset: 'assets/icons/ic_cab.png',
        ),
      ];
    });
  }
}
