import 'dart:math';

class DriverGenerator {
  final Random _random;
  
  DriverGenerator([Random? random]) : _random = random ?? Random();

  String generateName() {
    final names = [
      'Rahul Kumar',
      'Amit Singh',
      'Suresh Sharma',
      'Vikram Patel',
      'Manoj Gupta',
      'Ramesh Yadav',
      'Deepak Reddy',
      'Ravi Verma',
      'Sanjay Das',
      'Arjun Nair'
    ];
    return names[_random.nextInt(names.length)];
  }

  double generateRating() {
    // Rating between 4.1 and 4.9
    final rating = 4.1 + _random.nextDouble() * 0.8;
    return double.parse(rating.toStringAsFixed(1));
  }

  String generateAvatarUrl() {
    // Provide some placeholder avatar URLs or assets. For this simulation we will stick to one asset
    // or simulate different ones if available. We will use a generic one.
    return 'assets/images/driver_avatar.png';
  }

  String generatePhoneNumber() {
    final digits = _random.nextInt(99999999).toString().padLeft(8, '0');
    return '98$digits';
  }

  String generateOtp() {
    return (_random.nextInt(9000) + 1000).toString();
  }
}
