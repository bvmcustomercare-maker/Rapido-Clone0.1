import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/repository/base_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_dto.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<Result<bool>> loginWithPhone(String phone) {
    return executeSafe(() async {
      // Simulate network delay for SMS dispatch
      await Future.delayed(const Duration(milliseconds: 1000));
      return true;
    });
  }

  @override
  Future<Result<UserEntity>> verifyOtp(String phone, String otp) {
    return executeSafe(() async {
      // Simulate verification delay
      await Future.delayed(const Duration(milliseconds: 1000));

      if (otp.length != 4) {
        throw const DatabaseException('OTP must be exactly 4 digits.');
      }

      // Check if user already exists
      final String? sessionUserId = await _localDataSource.getSession();
      UserDto? userDto;

      if (sessionUserId != null) {
        userDto = await _localDataSource.getUser(sessionUserId);
      }

      // Otherwise, scan database by phone
      if (userDto == null) {
        // Simple search in local mock database
        // In real app, we would query the box. Since we are using Hive, we search all values.
      }

      if (userDto != null && userDto.phone == phone) {
        await _localDataSource.saveSession(userDto.id);
        return userDto.toEntity();
      }

      // If user is new, return a temporary entity with empty name (forces Profile Setup/Signup screen)
      final newId = const Uuid().v4();
      final tempUser = UserEntity(
        id: newId,
        name: '',
        phone: phone,
        createdAt: DateTime.now(),
      );
      
      // Save session immediately so they are authenticated
      await _localDataSource.saveSession(newId);
      return tempUser;
    });
  }

  @override
  Future<Result<UserEntity>> signup({
    required String name,
    required String phone,
    String? email,
  }) {
    return executeSafe(() async {
      final String? existingSessionId = await _localDataSource.getSession();
      final userId = existingSessionId ?? const Uuid().v4();

      final userDto = UserDto(
        id: userId,
        name: name,
        phone: phone,
        email: email,
        createdAt: DateTime.now(),
      );

      await _localDataSource.saveUser(userDto);
      await _localDataSource.saveSession(userId);

      return userDto.toEntity();
    });
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() {
    return executeSafe(() async {
      final userId = await _localDataSource.getSession();
      if (userId == null) return null;

      final userDto = await _localDataSource.getUser(userId);
      return userDto?.toEntity();
    });
  }

  @override
  Future<Result<void>> logout() {
    return executeSafe(() async {
      await _localDataSource.deleteSession();
    });
  }

  @override
  Future<Result<UserEntity>> updateUser({required String name, String? email}) {
    return executeSafe(() async {
      final userId = await _localDataSource.getSession();
      if (userId == null) {
        throw const DatabaseException('No active session.');
      }

      final userDto = await _localDataSource.getUser(userId);
      if (userDto == null) {
        throw const DatabaseException('User not found.');
      }

      final updatedDto = UserDto(
        id: userDto.id,
        name: name,
        phone: userDto.phone,
        email: email ?? userDto.email,
        createdAt: userDto.createdAt,
      );

      await _localDataSource.saveUser(updatedDto);
      return updatedDto.toEntity();
    });
  }
}
