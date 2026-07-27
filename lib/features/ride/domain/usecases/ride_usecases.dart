import '../../../../core/utils/result.dart';
import '../entities/ride.dart';
import '../repositories/ride_repository.dart';

class SimulateDriverSearchUseCase {
  final RideRepository repository;
  const SimulateDriverSearchUseCase(this.repository);

  Future<Result<Ride>> call(Ride ride) => repository.simulateDriverSearch(ride);
}

class SimulateDriverArrivingUseCase {
  final RideRepository repository;
  const SimulateDriverArrivingUseCase(this.repository);

  Future<Result<Ride>> call(Ride ride) => repository.simulateDriverArriving(ride);
}

class SimulateRideProgressUseCase {
  final RideRepository repository;
  const SimulateRideProgressUseCase(this.repository);

  Future<Result<Ride>> call(Ride ride) => repository.simulateRideProgress(ride);
}

class SubmitPaymentUseCase {
  final RideRepository repository;
  const SubmitPaymentUseCase(this.repository);

  Future<Result<void>> call(String rideId, String paymentMethod, String amount) =>
      repository.submitPayment(rideId, paymentMethod, amount);
}

class SubmitRatingUseCase {
  final RideRepository repository;
  const SubmitRatingUseCase(this.repository);

  Future<Result<void>> call(String rideId, double rating, String? comment) =>
      repository.submitRating(rideId, rating, comment);
}

class CancelRideUseCase {
  final RideRepository repository;
  const CancelRideUseCase(this.repository);

  Future<Result<void>> call(String rideId) => repository.cancelRide(rideId);
}

class SaveRideUseCase {
  final RideRepository repository;
  const SaveRideUseCase(this.repository);

  Future<Result<void>> call(Ride ride) => repository.saveRide(ride);
}

class GetRideHistoryUseCase {
  final RideRepository repository;
  const GetRideHistoryUseCase(this.repository);

  Future<Result<List<Ride>>> call() => repository.getRideHistory();
}

class DeleteRideUseCase {
  final RideRepository repository;
  const DeleteRideUseCase(this.repository);

  Future<Result<void>> call(String id) => repository.deleteRide(id);
}
