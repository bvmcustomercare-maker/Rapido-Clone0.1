import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

/// Clean Architecture Repository contract for User Authentication
abstract class AuthRepository {
  Future<Result<bool>> loginWithPhone(String phone);
  Future<Result<UserEntity>> verifyOtp(String phone, String otp);
  Future<Result<UserEntity>> signup({required String name, required String phone, String? email});
  Future<Result<UserEntity?>> getCurrentUser();

  /// Updates the currently authenticated user's profile.
  Future<Result<UserEntity>> updateUser({required String name, String? email});

  /// Clears the session.
  Future<Result<void>> logout();
}
