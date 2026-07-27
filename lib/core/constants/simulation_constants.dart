/// Settings and constants driving the simulation engine behavior (teck-stack.md §4)
abstract class SimulationConstants {
  static const int minDriverMatchDelaySec = 3;
  static const int maxDriverMatchDelaySec = 6;
  
  static const double baseFareBike = 40.0;
  static const double baseFareAuto = 60.0;
  static const double baseFareCab = 100.0;
  
  static const double perKmFareBike = 8.0;
  static const double perKmFareAuto = 12.0;
  static const double perKmFareCab = 20.0;

  static const double defaultLatitude = 28.6315; // Delhi Connaught Place
  static const double defaultLongitude = 77.2167;
}
