import 'package:flutter/foundation.dart';
import '../../home/domain/entities/place.dart';
import '../../home/domain/entities/vehicle.dart';
import '../enums/ride_status.dart';
import 'driver.dart';

/// Domain entity representing a simulated ride booking.
@immutable
class Ride {
  final String id;
  final Place pickup;
  final Place destination;
  final Vehicle vehicle;
  final String fare;
  final String paymentMethod;
  final RideStatus status;
  final Driver? driver;
  final DateTime createdAt;
  final int estimatedTimeSeconds;
  final double estimatedDistanceKm;

  const Ride({
    required this.id,
    required this.pickup,
    required this.destination,
    required this.vehicle,
    required this.fare,
    this.paymentMethod = 'Cash',
    this.status = RideStatus.confirming,
    this.driver,
    required this.createdAt,
    this.estimatedTimeSeconds = 0,
    this.estimatedDistanceKm = 0.0,
  });

  Ride copyWith({
    String? id,
    Place? pickup,
    Place? destination,
    Vehicle? vehicle,
    String? fare,
    String? paymentMethod,
    RideStatus? status,
    Driver? driver,
    DateTime? createdAt,
    int? estimatedTimeSeconds,
    double? estimatedDistanceKm,
  }) {
    return Ride(
      id: id ?? this.id,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      vehicle: vehicle ?? this.vehicle,
      fare: fare ?? this.fare,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      driver: driver ?? this.driver,
      createdAt: createdAt ?? this.createdAt,
      estimatedTimeSeconds: estimatedTimeSeconds ?? this.estimatedTimeSeconds,
      estimatedDistanceKm: estimatedDistanceKm ?? this.estimatedDistanceKm,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ride && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
