import 'package:hive/hive.dart';
import '../../domain/entities/ride.dart';
import '../../domain/enums/ride_status.dart';
import '../../../home/data/models/place_dto.dart';
import '../../../home/domain/entities/vehicle.dart';
import 'driver_dto.dart';

part 'ride_dto.g.dart';

@HiveType(typeId: 4)
class RideDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final PlaceDto pickup;

  @HiveField(2)
  final PlaceDto destination;

  // We only store vehicle id and name here for simplicity
  @HiveField(3)
  final String vehicleId;

  @HiveField(4)
  final String vehicleName;

  @HiveField(5)
  final String fare;

  @HiveField(6)
  final String paymentMethod;

  @HiveField(7)
  final String statusName;

  @HiveField(8)
  final DriverDto? driver;

  @HiveField(9)
  final int createdAtMillis;

  @HiveField(10)
  final int estimatedTimeSeconds;

  @HiveField(11)
  final double estimatedDistanceKm;

  RideDto({
    required this.id,
    required this.pickup,
    required this.destination,
    required this.vehicleId,
    required this.vehicleName,
    required this.fare,
    required this.paymentMethod,
    required this.statusName,
    this.driver,
    required this.createdAtMillis,
    required this.estimatedTimeSeconds,
    required this.estimatedDistanceKm,
  });

  factory RideDto.fromEntity(Ride entity) {
    return RideDto(
      id: entity.id,
      pickup: PlaceDto.fromEntity(entity.pickup),
      destination: PlaceDto.fromEntity(entity.destination),
      vehicleId: entity.vehicle.id,
      vehicleName: entity.vehicle.name,
      fare: entity.fare,
      paymentMethod: entity.paymentMethod,
      statusName: entity.status.name,
      driver: entity.driver != null ? DriverDto.fromEntity(entity.driver!) : null,
      createdAtMillis: entity.createdAt.millisecondsSinceEpoch,
      estimatedTimeSeconds: entity.estimatedTimeSeconds,
      estimatedDistanceKm: entity.estimatedDistanceKm,
    );
  }

  Ride toEntity() {
    return Ride(
      id: id,
      pickup: pickup.toEntity(),
      destination: destination.toEntity(),
      vehicle: Vehicle(
        id: vehicleId,
        name: vehicleName,
        description: '', // Fallback, not needed in history
        capacity: '',
        iconAsset: '',
      ),
      fare: fare,
      paymentMethod: paymentMethod,
      status: RideStatus.values.firstWhere(
        (e) => e.name == statusName,
        orElse: () => RideStatus.completed,
      ),
      driver: driver?.toEntity(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
      estimatedTimeSeconds: estimatedTimeSeconds,
      estimatedDistanceKm: estimatedDistanceKm,
    );
  }
}
