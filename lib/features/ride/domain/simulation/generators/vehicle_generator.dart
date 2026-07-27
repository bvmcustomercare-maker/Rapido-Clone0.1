import 'dart:math';

class VehicleGenerator {
  final Random _random;

  VehicleGenerator([Random? random]) : _random = random ?? Random();

  String generateVehicleNumber() {
    final states = ['DL', 'HR', 'UP', 'KA', 'MH', 'TS', 'TN'];
    final stateCode = states[_random.nextInt(states.length)];
    final num1 = _random.nextInt(9) + 1;
    final num2 = _random.nextInt(9999).toString().padLeft(4, '0');
    final char1 = String.fromCharCode(65 + _random.nextInt(26));
    final char2 = String.fromCharCode(65 + _random.nextInt(26));
    return '$stateCode $num1$char1 $char2$char2 $num2';
  }

  String generateVehicleModel(String vehicleType) {
    final models = {
      'bike': ['Honda Activa', 'Bajaj Pulsar', 'Hero Splendor', 'TVS Jupiter', 'Suzuki Access'],
      'auto': ['Bajaj RE', 'TVS King', 'Piaggio Ape', 'Mahindra Treo'],
      'cab': ['Maruti Dzire', 'Hyundai Accent', 'Toyota Etios', 'Tata Indica', 'Honda Amaze'],
    };

    final vehicleModels = models[vehicleType] ?? models['cab']!;
    return vehicleModels[_random.nextInt(vehicleModels.length)];
  }

  String generateColor() {
    final colors = ['White', 'Silver', 'Grey', 'Black', 'Blue', 'Red'];
    return colors[_random.nextInt(colors.length)];
  }
}
