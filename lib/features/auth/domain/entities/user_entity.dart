import 'package:flutter/foundation.dart';

/// Clean Architecture Domain User Entity
@immutable
class UserEntity {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.createdAt,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
