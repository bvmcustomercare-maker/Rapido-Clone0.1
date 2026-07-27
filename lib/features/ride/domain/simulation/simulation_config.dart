class SimulationConfig {
  final int minSearchDelaySeconds;
  final int maxSearchDelaySeconds;
  final int minArrivalDelaySeconds;
  final int maxArrivalDelaySeconds;
  final double driverAcceptanceProbability;
  final int secondsPerKm;

  const SimulationConfig({
    this.minSearchDelaySeconds = 3,
    this.maxSearchDelaySeconds = 8,
    this.minArrivalDelaySeconds = 2,
    this.maxArrivalDelaySeconds = 5,
    this.driverAcceptanceProbability = 0.85,
    this.secondsPerKm = 180, // ~3 mins per km
  });
}
