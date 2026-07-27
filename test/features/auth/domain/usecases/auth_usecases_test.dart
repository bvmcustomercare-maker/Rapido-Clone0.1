import 'package:flutter_test/flutter_test.dart';
import 'package:rideflow/core/error/failures.dart';
import 'package:rideflow/core/utils/result.dart';
import 'package:rideflow/features/auth/domain/entities/user_entity.dart';
import 'package:rideflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:rideflow/features/auth/domain/usecases/auth_usecases.dart';

class MockAuthRepository implements AuthRepository {
  UserEntity? mockUser;
  bool shouldFail = false;
  bool loginCalled = false;
  bool verifyCalled = false;
  bool signupCalled = false;
  bool logoutCalled = false;

  @override
  Future<Result<bool>> loginWithPhone(String phone) async {
    loginCalled = true;
    if (shouldFail) {
      return const FailureResult(UnknownFailure('Login failed'));
    }
    return const Success(true);
  }

  @override
  Future<Result<UserEntity>> verifyOtp(String phone, String otp) async {
    verifyCalled = true;
    if (shouldFail) {
      return const FailureResult(UnknownFailure('Verification failed'));
    }
    return Success(mockUser ?? UserEntity(id: '1', name: 'Test', phone: phone, createdAt: DateTime.now()));
  }

  @override
  Future<Result<UserEntity>> signup({required String name, required String phone, String? email}) async {
    signupCalled = true;
    if (shouldFail) {
      return const FailureResult(UnknownFailure('Signup failed'));
    }
    return Success(UserEntity(id: '1', name: name, phone: phone, email: email, createdAt: DateTime.now()));
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    if (shouldFail) {
      return const FailureResult(UnknownFailure('Session read failed'));
    }
    return Success(mockUser);
  }

  @override
  Future<Result<void>> logout() async {
    logoutCalled = true;
    if (shouldFail) {
      return const FailureResult(UnknownFailure('Logout failed'));
    }
    return const Success(null);
  }
}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase loginUseCase;
  late VerifyOtpUseCase verifyOtpUseCase;
  late SignupUseCase signupUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;
  late LogoutUseCase logoutUseCase;

  setUp(() {
    repository = MockAuthRepository();
    loginUseCase = LoginUseCase(repository);
    verifyOtpUseCase = VerifyOtpUseCase(repository);
    signupUseCase = SignupUseCase(repository);
    getCurrentUserUseCase = GetCurrentUserUseCase(repository);
    logoutUseCase = LogoutUseCase(repository);
  });

  group('Auth UseCases Unit Tests', () {
    test('LoginUseCase should call loginWithPhone on repository and return success', () async {
      final result = await loginUseCase('9876543210');
      expect(repository.loginCalled, true);
      expect(result, isA<Success<bool>>());
    });

    test('VerifyOtpUseCase should call verifyOtp on repository and return user', () async {
      final result = await verifyOtpUseCase('9876543210', '1234');
      expect(repository.verifyCalled, true);
      expect(result, isA<Success<UserEntity>>());
    });

    test('SignupUseCase should call signup on repository and return registered user', () async {
      final result = await signupUseCase(name: 'Jane Doe', phone: '9876543210', email: 'jane@example.com');
      expect(repository.signupCalled, true);
      expect(result, isA<Success<UserEntity>>());
      result.fold(
        (user) {
          expect(user.name, 'Jane Doe');
          expect(user.email, 'jane@example.com');
        },
        (failure) => fail('Should not return failure'),
      );
    });

    test('GetCurrentUserUseCase should retrieve active user state from repository', () async {
      repository.mockUser = UserEntity(id: '1', name: 'John Doe', phone: '9876543210', createdAt: DateTime.now());
      final result = await getCurrentUserUseCase();
      result.fold(
        (user) => expect(user?.name, 'John Doe'),
        (failure) => fail('Should not return failure'),
      );
    });

    test('LogoutUseCase should invoke logout on repository', () async {
      final result = await logoutUseCase();
      expect(repository.logoutCalled, true);
      expect(result, isA<Success<void>>());
    });
  });
}
