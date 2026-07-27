import 'package:hive/hive.dart';
import '../../domain/entities/place.dart';

part 'place_dto.g.dart';

/// Hive-persistable data transfer object for Place (typeId: 2)
@HiveType(typeId: 2)
class PlaceDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final bool isFavourite;

  @HiveField(6)
  final int lastUsedAtMillis;

  PlaceDto({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.isFavourite = false,
    required this.lastUsedAtMillis,
  });

  /// Convert from domain entity to data model
  factory PlaceDto.fromEntity(Place entity) {
    return PlaceDto(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isFavourite: entity.isFavourite,
      lastUsedAtMillis: entity.lastUsedAt?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Convert from data model to domain entity
  Place toEntity() {
    return Place(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      isFavourite: isFavourite,
      lastUsedAt: DateTime.fromMillisecondsSinceEpoch(lastUsedAtMillis),
    );
  }
}
