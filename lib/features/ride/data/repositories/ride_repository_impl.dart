import '../../../../core/repository/base_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/ride.dart';
import '../../domain/repositories/ride_repository.dart';
import '../datasources/ride_local_data_source.dart';
import '../datasources/ride_simulation_data_source.dart';
import '../models/ride_dto.dart';

class RideRepositoryImpl extends BaseRepository implements RideRepository {
  final RideSimulationDataSource _simulationDataSource;
  final RideLocalDataSource _localDataSource;

  const RideRepositoryImpl(this._simulationDataSource, this._localDataSource);

  @override
  Future<Result<Ride>> simulateDriverSearch(Ride currentRide) {
    return executeSafe(() => _simulationDataSource.simulateDriverSearch(currentRide));
  }

  @override
  Future<Result<Ride>> simulateDriverArriving(Ride currentRide) {
    return executeSafe(() => _simulationDataSource.simulateDriverArriving(currentRide));
  }

  @override
  Future<Result<Ride>> simulateRideProgress(Ride currentRide) {
    return executeSafe(() => _simulationDataSource.simulateRideProgress(currentRide));
  }

  @override
  Future<Result<void>> submitPayment(String rideId, String paymentMethod, String amount) {
    return executeSafe(() => _simulationDataSource.submitPayment(rideId, paymentMethod, amount));
  }

  @override
  Future<Result<void>> submitRating(String rideId, double rating, String? comment) {
    return executeSafe(() => _simulationDataSource.submitRating(rideId, rating, comment));
  }

  @override
  Future<Result<void>> cancelRide(String rideId) {
    return executeSafe(() => _simulationDataSource.cancelRide(rideId));
  }

  @override
  Future<Result<void>> saveRide(Ride ride) {
    return executeSafe(() async {
      final dto = RideDto.fromEntity(ride);
      await _localDataSource.saveRide(dto);
    });
  }

  @override
  Future<Result<List<Ride>>> getRideHistory() {
    return executeSafe(() async {
      final dtos = await _localDataSource.getAllRides();
      return dtos.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<Result<void>> deleteRide(String id) {
    return executeSafe(() async {
      await _localDataSource.deleteRide(id);
    });
  }
}
