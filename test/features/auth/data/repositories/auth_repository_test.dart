import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rideflow/core/utils/result.dart';
import 'package:rideflow/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:rideflow/features/auth/data/models/user_dto.dart';
import 'package:rideflow/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthLocalDataSource mockDataSource;

  final testUserDto = UserDto(
    id: 'user_123',
    name: 'Test User',
    phone: '1234567890',
  );

  setUp(() {
    mockDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('AuthRepositoryImpl Tests', () {
    test('login returns success', () async {
      final result = await repository.login('1234567890');
      expect(result.isSuccess, true);
    });

    test('verifyOtp fetches user from local data source and saves session', () async {
      when(() => mockDataSource.getUserByPhone('1234567890')).thenAnswer((_) async => testUserDto);
      when(() => mockDataSource.saveSession(testUserDto.id)).thenAnswer((_) async {});

      final result = await repository.verifyOtp('1234567890', '123456');

      expect(result.isSuccess, true);
      expect(result.getOrNull()?.name, 'Test User');
      verify(() => mockDataSource.getUserByPhone('1234567890')).called(1);
      verify(() => mockDataSource.saveSession(testUserDto.id)).called(1);
    });

    test('getCurrentUser returns failure if no session', () async {
      when(() => mockDataSource.getSession()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result.isFailure, true);
    });

    test('getCurrentUser returns user if session exists', () async {
      when(() => mockDataSource.getSession()).thenAnswer((_) async => 'user_123');
      when(() => mockDataSource.getUserById('user_123')).thenAnswer((_) async => testUserDto);

      final result = await repository.getCurrentUser();

      expect(result.isSuccess, true);
      expect(result.getOrNull()?.name, 'Test User');
    });

    test('logout clears session', () async {
      when(() => mockDataSource.clearSession()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockDataSource.clearSession()).called(1);
    });
  });
}
