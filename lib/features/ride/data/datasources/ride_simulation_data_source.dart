import '../../domain/entities/driver.dart';
import '../../domain/entities/ride.dart';
import '../../domain/enums/ride_status.dart';
import '../../domain/simulation/simulation_engine.dart';

abstract class RideSimulationDataSource {
  Future<Ride> simulateDriverSearch(Ride currentRide);
  Future<Ride> simulateDriverArriving(Ride currentRide);
  Future<Ride> simulateRideProgress(Ride currentRide);
  Future<void> submitPayment(String rideId, String paymentMethod, String amount);
  Future<void> submitRating(String rideId, double rating, String? comment);
  Future<void> cancelRide(String rideId);
}

class RideSimulationDataSourceImpl implements RideSimulationDataSource {
  final SimulationEngine _engine;

  RideSimulationDataSourceImpl({SimulationEngine? engine})
      : _engine = engine ?? SimulationEngine();

  @override
  Future<Ride> simulateDriverSearch(Ride currentRide) {
    return _engine.simulateDriverSearch(currentRide);
  }

  @override
  Future<Ride> simulateDriverArriving(Ride currentRide) {
    return _engine.simulateDriverArriving(currentRide);
  }

  @override
  Future<Ride> simulateRideProgress(Ride currentRide) {
    return _engine.simulateRideProgress(currentRide);
  }

  @override
  Future<void> submitPayment(String rideId, String paymentMethod, String amount) {
    return _engine.submitPayment();
  }

  @override
  Future<void> submitRating(String rideId, double rating, String? comment) {
    return _engine.submitRating();
  }

  @override
  Future<void> cancelRide(String rideId) {
    return _engine.cancelRide();
  }
}
