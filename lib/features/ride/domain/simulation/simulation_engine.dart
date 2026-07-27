import '../entities/driver.dart';
import '../entities/ride.dart';
import '../enums/ride_status.dart';
import 'generators/driver_generator.dart';
import 'generators/eta_generator.dart';
import 'generators/vehicle_generator.dart';
import 'simulation_config.dart';

class SimulationEngine {
  final SimulationConfig config;
  final DriverGenerator driverGenerator;
  final VehicleGenerator vehicleGenerator;
  final EtaGenerator etaGenerator;

  SimulationEngine({
    this.config = const SimulationConfig(),
    DriverGenerator? driverGenerator,
    VehicleGenerator? vehicleGenerator,
    EtaGenerator? etaGenerator,
  })  : driverGenerator = driverGenerator ?? DriverGenerator(),
        vehicleGenerator = vehicleGenerator ?? VehicleGenerator(),
        etaGenerator = etaGenerator ?? EtaGenerator(config);

  Future<Ride> simulateDriverSearch(Ride currentRide) async {
    final delaySeconds = etaGenerator.generateRandomDelay(
      config.minSearchDelaySeconds, 
      config.maxSearchDelaySeconds,
    );
    await Future.delayed(Duration(seconds: delaySeconds));

    final driver = _generateDriver(currentRide.vehicle.id);
    final distanceKm = etaGenerator.generateDistanceKm();
    final timeSeconds = etaGenerator.calculateEtaSeconds(distanceKm);

    return currentRide.copyWith(
      status: RideStatus.assigned,
      driver: driver,
      estimatedDistanceKm: distanceKm,
      estimatedTimeSeconds: timeSeconds,
    );
  }

  Future<Ride> simulateDriverArriving(Ride currentRide) async {
    final delaySeconds = etaGenerator.generateRandomDelay(
      config.minArrivalDelaySeconds, 
      config.maxArrivalDelaySeconds,
    );
    await Future.delayed(Duration(seconds: delaySeconds));

    return currentRide.copyWith(status: RideStatus.arriving);
  }

  Future<Ride> simulateRideProgress(Ride currentRide) async {
    // Just marking as started; the frontend typically handles the interval progress.
    await Future.delayed(const Duration(milliseconds: 500));
    return currentRide.copyWith(status: RideStatus.started);
  }
  
  Future<void> submitPayment() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }
  
  Future<void> submitRating() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
  
  Future<void> cancelRide() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Driver _generateDriver(String vehicleType) {
    return Driver(
      id: 'driver_${DateTime.now().millisecondsSinceEpoch}',
      name: driverGenerator.generateName(),
      photoUrl: driverGenerator.generateAvatarUrl(),
      rating: driverGenerator.generateRating(),
      vehicleNumber: vehicleGenerator.generateVehicleNumber(),
      vehicleModel: vehicleGenerator.generateVehicleModel(vehicleType),
      vehicleColor: vehicleGenerator.generateColor(),
      phoneNumber: driverGenerator.generatePhoneNumber(),
      otp: driverGenerator.generateOtp(),
    );
  }
}
