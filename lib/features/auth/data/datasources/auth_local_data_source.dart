import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/db_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_dto.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserDto user);
  Future<UserDto?> getUser(String id);
  Future<void> saveSession(String userId);
  Future<String?> getSession();
  Future<void> deleteSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserDto> _userBox;
  final StorageService _sessionStorage;

  AuthLocalDataSourceImpl({
    required Box<UserDto> userBox,
    required StorageService sessionStorage,
  })  : _userBox = userBox,
        _sessionStorage = sessionStorage;

  @override
  Future<void> saveUser(UserDto user) async {
    await _userBox.put(user.id, user);
  }

  @override
  Future<UserDto?> getUser(String id) async {
    return _userBox.get(id);
  }

  @override
  Future<void> saveSession(String userId) async {
    await _sessionStorage.setString(DbConstants.keyLoggedInUserId, userId);
  }

  @override
  Future<String?> getSession() async {
    return _sessionStorage.getString(DbConstants.keyLoggedInUserId);
  }

  @override
  Future<void> deleteSession() async {
    await _sessionStorage.remove(DbConstants.keyLoggedInUserId);
  }
}
