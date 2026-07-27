import 'package:flutter/foundation.dart';

/// Domain entity representing a geographic place (PRD §6.2/§6.3)
@immutable
class Place {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final bool isFavourite;
  final DateTime? lastUsedAt;

  const Place({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.isFavourite = false,
    this.lastUsedAt,
  });

  Place copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    bool? isFavourite,
    DateTime? lastUsedAt,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFavourite: isFavourite ?? this.isFavourite,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Place && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
