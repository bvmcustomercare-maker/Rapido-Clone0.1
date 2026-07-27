import 'package:hive/hive.dart';
import '../../domain/entities/driver.dart';

part 'driver_dto.g.dart';

@HiveType(typeId: 3)
class DriverDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String photoUrl;

  @HiveField(3)
  final double rating;

  @HiveField(4)
  final String vehicleNumber;

  @HiveField(5)
  final String vehicleModel;

  @HiveField(6)
  final String vehicleColor;

  @HiveField(7)
  final String phoneNumber;

  @HiveField(8)
  final String otp;

  DriverDto({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.rating,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.phoneNumber,
    required this.otp,
  });

  factory DriverDto.fromEntity(Driver entity) {
    return DriverDto(
      id: entity.id,
      name: entity.name,
      photoUrl: entity.photoUrl,
      rating: entity.rating,
      vehicleNumber: entity.vehicleNumber,
      vehicleModel: entity.vehicleModel,
      vehicleColor: entity.vehicleColor,
      phoneNumber: entity.phoneNumber,
      otp: entity.otp,
    );
  }

  Driver toEntity() {
    return Driver(
      id: id,
      name: name,
      photoUrl: photoUrl,
      rating: rating,
      vehicleNumber: vehicleNumber,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      phoneNumber: phoneNumber,
      otp: otp,
    );
  }
}
