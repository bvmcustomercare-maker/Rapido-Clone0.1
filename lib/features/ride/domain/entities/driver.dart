import 'package:flutter/foundation.dart';

/// Domain entity representing a simulated driver (PRD §FR-BOOK-004)
@immutable
class Driver {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final String vehicleNumber;
  final String vehicleModel;
  final String vehicleColor;
  final String phoneNumber;
  final String otp;

  const Driver({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Driver && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
