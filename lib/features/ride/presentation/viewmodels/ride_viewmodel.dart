import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/ride.dart';
import '../../domain/enums/ride_status.dart';
import '../../domain/usecases/ride_usecases.dart';
import 'ride_state.dart';

class RideViewModel extends StateNotifier<RideState> {
  final SimulateDriverSearchUseCase _simulateDriverSearch;
  final SimulateDriverArrivingUseCase _simulateDriverArriving;
  final SimulateRideProgressUseCase _simulateRideProgress;
  final SubmitPaymentUseCase _submitPayment;
  final SubmitRatingUseCase _submitRating;
  final CancelRideUseCase _cancelRide;
  final SaveRideUseCase _saveRide;

  Timer? _etaTimer;

  RideViewModel({
    required SimulateDriverSearchUseCase simulateDriverSearch,
    required SimulateDriverArrivingUseCase simulateDriverArriving,
    required SimulateRideProgressUseCase simulateRideProgress,
    required SubmitPaymentUseCase submitPayment,
    required SubmitRatingUseCase submitRating,
    required CancelRideUseCase cancelRide,
    required SaveRideUseCase saveRide,
  })  : _simulateDriverSearch = simulateDriverSearch,
        _simulateDriverArriving = simulateDriverArriving,
        _simulateRideProgress = simulateRideProgress,
        _submitPayment = submitPayment,
        _submitRating = submitRating,
        _cancelRide = cancelRide,
        _saveRide = saveRide,
        super(const RideState());

  @override
  void dispose() {
    _etaTimer?.cancel();
    super.dispose();
  }

  void initializeRide(Ride ride) {
    state = state.copyWith(currentRide: ride, clearError: true);
  }

  /// Skips driver simulation, saves the ride, and marks it as confirmed/completed
  Future<void> saveAndConfirmRide(Ride ride) async {
    initializeRide(ride);
    AppLogger.d('Saving and confirming ride...');
    
    state = state.copyWith(isLoading: true);
    final result = await _saveRide(ride);
    
    result.fold(
      (_) {
        state = state.copyWith(
          currentRide: ride.copyWith(status: RideStatus.completed),
          isLoading: false,
        );
        AppLogger.d('Ride saved successfully');
      },
      (failure) {
        AppLogger.e('Failed to save ride: ${failure.message}');
        state = state.copyWith(
          errorMessage: failure.message,
          isLoading: false,
        );
      },
    );
  }

  /// Initiates the search for a driver
  Future<void> confirmRide() async {
    if (state.currentRide == null) return;
    
    // Transition to searching
    final searchingRide = state.currentRide!.copyWith(status: RideStatus.searching);
    state = state.copyWith(currentRide: searchingRide);
    
    AppLogger.d('Searching for driver...');

    final result = await _simulateDriverSearch(searchingRide);
    result.fold(
      (assignedRide) {
        state = state.copyWith(
          currentRide: assignedRide,
          // ETA is typically a random 2-8 minutes for driver arrival
          remainingEtaSeconds: 120 + (DateTime.now().millisecondsSinceEpoch % 360),
        );
        AppLogger.d('Driver assigned: ${assignedRide.driver?.name}');
        _startEtaTimer(
          onComplete: () => _driverArriving(),
        );
      },
      (failure) {
        AppLogger.e('Failed to assign driver: ${failure.message}');
        state = state.copyWith(
          currentRide: state.currentRide!.copyWith(status: RideStatus.confirming), // fallback
          errorMessage: failure.message,
        );
      },
    );
  }

  /// Triggered automatically when ETA nears zero
  Future<void> _driverArriving() async {
    if (state.currentRide == null || state.currentRide!.status != RideStatus.assigned) return;

    final result = await _simulateDriverArriving(state.currentRide!);
    result.fold(
      (arrivingRide) {
        // ETA for driver to reach pickup
        final arrivalEtaSeconds = 5; // e.g. 5 seconds for animation
        state = state.copyWith(
          currentRide: arrivingRide,
          remainingEtaSeconds: arrivalEtaSeconds,
        );
        AppLogger.d('Driver is arriving');
        
        _startEtaTimer(
          onComplete: () {
            state = state.copyWith(
              currentRide: state.currentRide!.copyWith(status: RideStatus.arrived),
              remainingEtaSeconds: 0,
            );
            AppLogger.d('Driver has arrived at pickup');
          },
        );
      },
      (failure) {
        AppLogger.e('Error during driver arriving: ${failure.message}');
      },
    );
  }

  /// Verifies OTP and starts the ride if correct
  Future<bool> verifyOtp(String enteredOtp) async {
    if (state.currentRide?.driver == null) return false;
    
    if (state.currentRide!.driver!.otp == enteredOtp) {
      await startRide();
      return true;
    }
    return false;
  }

  /// Start the actual ride
  Future<void> startRide() async {
    if (state.currentRide == null) return;

    final result = await _simulateRideProgress(state.currentRide!);
    result.fold(
      (startedRide) {
        state = state.copyWith(
          currentRide: startedRide,
          remainingEtaSeconds: startedRide.estimatedTimeSeconds,
        );
        AppLogger.d('Ride started');
        _startEtaTimer(
          onComplete: () => _completeRide(),
        );
      },
      (failure) {
        AppLogger.e('Error starting ride: ${failure.message}');
      },
    );
  }

  /// Triggered automatically when ride ETA reaches zero
  void _completeRide() {
    if (state.currentRide == null) return;
    
    final completedRide = state.currentRide!.copyWith(status: RideStatus.completed);
    state = state.copyWith(currentRide: completedRide);
    AppLogger.d('Ride completed');
  }

  /// Simulates payment processing
  Future<bool> processPayment() async {
    if (state.currentRide == null) return false;
    
    state = state.copyWith(isLoading: true);
    final result = await _submitPayment(
      state.currentRide!.id,
      state.currentRide!.paymentMethod,
      state.currentRide!.fare,
    );
    
    state = state.copyWith(isLoading: false);
    return result.fold(
      (_) => true,
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }

  /// Simulates submitting a rating
  Future<bool> submitRating(double rating, String? comment) async {
    if (state.currentRide == null) return false;
    
    state = state.copyWith(isLoading: true);
    final result = await _submitRating(state.currentRide!.id, rating, comment);
    
    state = state.copyWith(isLoading: false);
    return result.fold(
      (_) => true,
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<void> cancelRide() async {
    if (state.currentRide == null) return;
    
    _etaTimer?.cancel();
    
    // In a real app we'd call an API. Here we simulate local cancel.
    await _cancelRide(state.currentRide!.id);
    final cancelledRide = state.currentRide!.copyWith(status: RideStatus.cancelled);
    state = state.copyWith(currentRide: cancelledRide);
  }

  void _startEtaTimer({required VoidCallback onComplete}) {
    _etaTimer?.cancel();
    _etaTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingEtaSeconds > 0) {
        // Real-time decrement for smooth animation sync
        final newValue = state.remainingEtaSeconds - 1;
        state = state.copyWith(remainingEtaSeconds: newValue > 0 ? newValue : 0);
      } else {
        timer.cancel();
        onComplete();
      }
    });
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
