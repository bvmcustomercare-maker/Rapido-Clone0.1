import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/result.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/models/user_dto.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

// 1. Dependency Injection Providers
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final userBox = Hive.box<UserDto>('users');
  final sessionStorage = ref.watch(sharedPrefsStorageProvider);
  return AuthLocalDataSourceImpl(userBox: userBox, sessionStorage: sessionStorage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(localDataSource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyOtpUseCase(repository);
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignupUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final updateUserUseCaseProvider = Provider<UpdateUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateUserUseCase(repository);
});

// 2. AuthStateNotifier to manage the logged-in UserEntity
class AuthNotifier extends StateNotifier<UserEntity?> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final LoginUseCase _loginUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SignupUseCase _signupUseCase;
  final UpdateUserUseCase _updateUserUseCase;

  AuthNotifier({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
    required LoginUseCase loginUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required SignupUseCase signupUseCase,
    required UpdateUserUseCase updateUserUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _logoutUseCase = logoutUseCase,
        _loginUseCase = loginUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _signupUseCase = signupUseCase,
        _updateUserUseCase = updateUserUseCase,
        super(null) {
    loadSession();
  }

  Future<void> loadSession() async {
    final result = await _getCurrentUserUseCase();
    result.fold(
      (user) => state = user,
      (failure) => state = null,
    );
  }

  Future<Result<bool>> login(String phone) async {
    return await _loginUseCase(phone);
  }

  Future<Result<UserEntity>> verifyOtp(String phone, String otp) async {
    final result = await _verifyOtpUseCase(phone, otp);
    result.fold(
      (user) => state = user,
      (failure) => null,
    );
    return result;
  }

  Future<Result<UserEntity>> signup({required String name, required String phone, String? email}) async {
    final result = await _signupUseCase(name: name, phone: phone, email: email);
    result.fold(
      (user) => state = user,
      (failure) => null,
    );
    return result;
  }

  Future<void> logout() async {
    await _logoutUseCase();
    state = null;
  }

  Future<Result<UserEntity>> updateUser({required String name, String? email}) async {
    final result = await _updateUserUseCase(name: name, email: email);
    result.fold(
      (user) => state = user,
      (failure) {},
    );
    return result;
  }
}

/// Global provider for authentication state containing the active UserEntity
final authProvider = StateNotifierProvider<AuthNotifier, UserEntity?>((ref) {
  return AuthNotifier(
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    loginUseCase: ref.watch(loginUseCaseProvider),
    verifyOtpUseCase: ref.watch(verifyOtpUseCaseProvider),
    signupUseCase: ref.watch(signupUseCaseProvider),
    updateUserUseCase: ref.watch(updateUserUseCaseProvider),
  );
});
