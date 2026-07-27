import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rideflow/core/utils/result.dart';
import 'package:rideflow/features/auth/domain/entities/user_entity.dart';
import 'package:rideflow/features/auth/domain/usecases/auth_usecases.dart';
import 'package:rideflow/features/auth/presentation/providers/auth_provider.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}
class MockSignupUseCase extends Mock implements SignupUseCase {}
class MockUpdateUserUseCase extends Mock implements UpdateUserUseCase {}

void main() {
  late AuthNotifier authNotifier;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockSignupUseCase mockSignupUseCase;
  late MockUpdateUserUseCase mockUpdateUserUseCase;

  final testUser = UserEntity(
    id: 'user_123',
    name: 'Test User',
    phone: '1234567890',
  );

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockSignupUseCase = MockSignupUseCase();
    mockUpdateUserUseCase = MockUpdateUserUseCase();

    // Default mock behavior for initialization
    when(() => mockGetCurrentUserUseCase()).thenAnswer((_) async => Result.failure(Failure('No user')));

    authNotifier = AuthNotifier(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      logoutUseCase: mockLogoutUseCase,
      loginUseCase: mockLoginUseCase,
      verifyOtpUseCase: mockVerifyOtpUseCase,
      signupUseCase: mockSignupUseCase,
      updateUserUseCase: mockUpdateUserUseCase,
    );
  });

  group('AuthNotifier Tests', () {
    test('Initial state should be null if no session', () async {
      await authNotifier.loadSession(); // Give the future time to complete
      expect(authNotifier.state, isNull);
    });

    test('Initial state should be user if session exists', () async {
      when(() => mockGetCurrentUserUseCase()).thenAnswer((_) async => Result.success(testUser));
      await authNotifier.loadSession();
      expect(authNotifier.state, testUser);
    });

    test('login calls LoginUseCase', () async {
      when(() => mockLoginUseCase(any())).thenAnswer((_) async => Result.success(true));
      final result = await authNotifier.login('1234567890');
      expect(result.isSuccess, true);
      verify(() => mockLoginUseCase('1234567890')).called(1);
    });

    test('verifyOtp updates state on success', () async {
      when(() => mockVerifyOtpUseCase(any(), any())).thenAnswer((_) async => Result.success(testUser));
      final result = await authNotifier.verifyOtp('1234567890', '123456');
      expect(result.isSuccess, true);
      expect(authNotifier.state, testUser);
    });

    test('logout clears state', () async {
      when(() => mockGetCurrentUserUseCase()).thenAnswer((_) async => Result.success(testUser));
      await authNotifier.loadSession();
      expect(authNotifier.state, testUser);

      when(() => mockLogoutUseCase()).thenAnswer((_) async {});
      await authNotifier.logout();
      expect(authNotifier.state, isNull);
    });
  });
}
