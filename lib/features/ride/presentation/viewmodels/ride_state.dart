import '../../domain/entities/ride.dart';
import '../../domain/enums/ride_status.dart';

class RideState {
  final Ride? currentRide;
  final bool isLoading;
  final String? errorMessage;
  
  // Simulation specific state
  final int remainingEtaSeconds;

  const RideState({
    this.currentRide,
    this.isLoading = false,
    this.errorMessage,
    this.remainingEtaSeconds = 0,
  });

  RideStatus? get status => currentRide?.status;

  RideState copyWith({
    Ride? currentRide,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    int? remainingEtaSeconds,
  }) {
    return RideState(
      currentRide: currentRide ?? this.currentRide,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      remainingEtaSeconds: remainingEtaSeconds ?? this.remainingEtaSeconds,
    );
  }
}
