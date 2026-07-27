import 'package:flutter/foundation.dart';

/// Domain entity representing a vehicle type for ride selection (PRD §FR-HOME-004)
@immutable
class Vehicle {
  final String id;
  final String name;
  final String description;
  final String capacity;
  final String iconAsset;

  const Vehicle({
    required this.id,
    required this.name,
    required this.description,
    required this.capacity,
    required this.iconAsset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
