import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/datasources/ride_local_data_source.dart';
import '../../data/datasources/ride_simulation_data_source.dart';
import '../../domain/simulation/simulation_config.dart';
import '../../domain/simulation/simulation_engine.dart';
import '../../domain/entities/ride.dart';
import '../../data/models/ride_dto.dart';
import '../../data/repositories/ride_repository_impl.dart';
import '../../domain/repositories/ride_repository.dart';
import '../../domain/usecases/ride_usecases.dart';
import '../viewmodels/ride_state.dart';
import '../viewmodels/ride_viewmodel.dart';
import '../../history/presentation/viewmodels/ride_history_viewmodel.dart';

// ─── Data Source Provider ────────────────────────────────────────────────────

final simulationEngineProvider = Provider<SimulationEngine>((ref) {
  return SimulationEngine(config: const SimulationConfig());
});

final rideSimulationDataSourceProvider = Provider<RideSimulationDataSource>((ref) {
  return RideSimulationDataSourceImpl(engine: ref.watch(simulationEngineProvider));
});

final rideLocalDataSourceProvider = Provider<RideLocalDataSource>((ref) {
  return RideLocalDataSourceImpl(Hive.box<RideDto>('rides'));
});

// ─── Repository Provider ─────────────────────────────────────────────────────

final rideRepositoryProvider = Provider<RideRepository>((ref) {
  final simulationDataSource = ref.watch(rideSimulationDataSourceProvider);
  final localDataSource = ref.watch(rideLocalDataSourceProvider);
  return RideRepositoryImpl(simulationDataSource, localDataSource);
});

// ─── Use Case Providers ──────────────────────────────────────────────────────

final simulateDriverSearchUseCaseProvider = Provider<SimulateDriverSearchUseCase>((ref) {
  return SimulateDriverSearchUseCase(ref.watch(rideRepositoryProvider));
});

final simulateDriverArrivingUseCaseProvider = Provider<SimulateDriverArrivingUseCase>((ref) {
  return SimulateDriverArrivingUseCase(ref.watch(rideRepositoryProvider));
});

final simulateRideProgressUseCaseProvider = Provider<SimulateRideProgressUseCase>((ref) {
  return SimulateRideProgressUseCase(ref.watch(rideRepositoryProvider));
});

final submitPaymentUseCaseProvider = Provider<SubmitPaymentUseCase>((ref) {
  return SubmitPaymentUseCase(ref.watch(rideRepositoryProvider));
});

final submitRatingUseCaseProvider = Provider<SubmitRatingUseCase>((ref) {
  return SubmitRatingUseCase(ref.watch(rideRepositoryProvider));
});

final cancelRideUseCaseProvider = Provider<CancelRideUseCase>((ref) {
  return CancelRideUseCase(ref.watch(rideRepositoryProvider));
});

final saveRideUseCaseProvider = Provider<SaveRideUseCase>((ref) {
  return SaveRideUseCase(ref.watch(rideRepositoryProvider));
});

final getRideHistoryUseCaseProvider = Provider<GetRideHistoryUseCase>((ref) {
  return GetRideHistoryUseCase(ref.watch(rideRepositoryProvider));
});

final deleteRideUseCaseProvider = Provider<DeleteRideUseCase>((ref) {
  return DeleteRideUseCase(ref.watch(rideRepositoryProvider));
});

// ─── ViewModel Provider ──────────────────────────────────────────────────────

final rideHistoryViewModelProvider = StateNotifierProvider<RideHistoryViewModel, RideHistoryState>((ref) {
  return RideHistoryViewModel(
    getRideHistory: ref.watch(getRideHistoryUseCaseProvider),
    deleteRide: ref.watch(deleteRideUseCaseProvider),
  );
});

final rideViewModelProvider = StateNotifierProvider<RideViewModel, RideState>((ref) {
  return RideViewModel(
    simulateDriverSearch: ref.watch(simulateDriverSearchUseCaseProvider),
    simulateDriverArriving: ref.watch(simulateDriverArrivingUseCaseProvider),
    simulateRideProgress: ref.watch(simulateRideProgressUseCaseProvider),
    submitPayment: ref.watch(submitPaymentUseCaseProvider),
    submitRating: ref.watch(submitRatingUseCaseProvider),
    cancelRide: ref.watch(cancelRideUseCaseProvider),
    saveRide: ref.watch(saveRideUseCaseProvider),
  );
});
