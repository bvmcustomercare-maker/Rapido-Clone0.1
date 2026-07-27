import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case to trigger SMS OTP send (simulated)
class LoginUseCase {
  final AuthRepository repository;
  const LoginUseCase(this.repository);

  Future<Result<bool>> call(String phone) {
    return repository.loginWithPhone(phone);
  }
}

/// Use case to verify code and authenticate user
class VerifyOtpUseCase {
  final AuthRepository repository;
  const VerifyOtpUseCase(this.repository);

  Future<Result<UserEntity>> call(String phone, String otp) {
    return repository.verifyOtp(phone, otp);
  }
}

/// Use case to register a new user profile
class SignupUseCase {
  final AuthRepository repository;
  const SignupUseCase(this.repository);

  Future<Result<UserEntity>> call({
    required String name,
    required String phone,
    String? email,
  }) {
    return repository.signup(name: name, phone: phone, email: email);
  }
}

/// Use case to fetch the logged-in session user
class GetCurrentUserUseCase {
  final AuthRepository repository;
  const GetCurrentUserUseCase(this.repository);

  Future<Result<UserEntity?>> call() {
    return repository.getCurrentUser();
  }
}

/// Use case to logout and clear session state
class LogoutUseCase {
  final AuthRepository repository;
  const LogoutUseCase(this.repository);

  Future<Result<void>> call() {
    return repository.logout();
  }
}

/// Use case to update user profile
class UpdateUserUseCase {
  final AuthRepository repository;
  const UpdateUserUseCase(this.repository);

  Future<Result<UserEntity>> call({required String name, String? email}) {
    return repository.updateUser(name: name, email: email);
  }
}
