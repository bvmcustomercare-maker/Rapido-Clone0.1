import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_dto.g.dart';

@HiveType(typeId: 0)
class UserDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final DateTime createdAt;

  UserDto({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.createdAt,
  });

  /// Factory mapper from Domain UserEntity
  factory UserDto.fromEntity(UserEntity entity) {
    return UserDto(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      createdAt: entity.createdAt,
    );
  }

  /// Map back to clean Domain UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      phone: phone,
      email: email,
      createdAt: createdAt,
    );
  }
}
