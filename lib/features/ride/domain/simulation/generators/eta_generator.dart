import 'dart:math';
import '../simulation_config.dart';

class EtaGenerator {
  final Random _random;
  final SimulationConfig config;

  EtaGenerator(this.config, [Random? random]) : _random = random ?? Random();

  double generateDistanceKm() {
    // Generate a distance between 2.0 and 12.0 km
    final distance = 2.0 + _random.nextDouble() * 10.0;
    return double.parse(distance.toStringAsFixed(2));
  }

  int calculateEtaSeconds(double distanceKm) {
    return (distanceKm * config.secondsPerKm).round();
  }

  int generateRandomDelay(int minSeconds, int maxSeconds) {
    if (minSeconds >= maxSeconds) return minSeconds;
    return minSeconds + _random.nextInt(maxSeconds - minSeconds + 1);
  }
}
