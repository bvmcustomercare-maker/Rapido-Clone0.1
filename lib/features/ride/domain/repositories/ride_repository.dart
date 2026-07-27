import '../../../../core/utils/result.dart';
import '../entities/ride.dart';

/// Clean Architecture repository contract for the Ride module (ENGINEERING_GUIDE.md §6.2)
abstract class RideRepository {
  /// Simulates searching for a driver. Returns an updated Ride with assigned driver after a delay.
  Future<Result<Ride>> simulateDriverSearch(Ride currentRide);

  /// Simulates driver arriving at the pickup location.
  Future<Result<Ride>> simulateDriverArriving(Ride currentRide);

  /// Simulates ride progress and completion.
  Future<Result<Ride>> simulateRideProgress(Ride currentRide);

  /// Submit mock payment.
  Future<Result<void>> submitPayment(String rideId, String paymentMethod, String amount);

  /// Submit rating for driver.
  Future<Result<void>> submitRating(String rideId, double rating, String? comment);

  /// Cancel an ongoing ride search or ride.
  Future<Result<void>> cancelRide(String rideId);

  /// Saves the ride locally.
  Future<Result<void>> saveRide(Ride ride);

  /// Retrieves all locally saved rides.
  Future<Result<List<Ride>>> getRideHistory();

  /// Deletes a ride from local storage.
  Future<Result<void>> deleteRide(String id);
}
