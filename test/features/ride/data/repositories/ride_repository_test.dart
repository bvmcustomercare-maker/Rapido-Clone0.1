import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rideflow/features/home/domain/entities/place.dart';
import 'package:rideflow/features/home/domain/entities/vehicle.dart';
import 'package:rideflow/features/ride/data/datasources/ride_local_data_source.dart';
import 'package:rideflow/features/ride/data/datasources/ride_simulation_data_source.dart';
import 'package:rideflow/features/ride/data/models/ride_dto.dart';
import 'package:rideflow/features/ride/data/repositories/ride_repository_impl.dart';
import 'package:rideflow/features/ride/domain/entities/ride.dart';
import 'package:rideflow/features/ride/domain/enums/ride_status.dart';

class MockRideSimulationDataSource extends Mock implements RideSimulationDataSource {}
class MockRideLocalDataSource extends Mock implements RideLocalDataSource {}

void main() {
  late RideRepositoryImpl repository;
  late MockRideSimulationDataSource mockSimulationDataSource;
  late MockRideLocalDataSource mockLocalDataSource;

  final testPlace = Place(
    id: 'p1',
    name: 'Home',
    address: '123 Test St',
    latitude: 1.0,
    longitude: 1.0,
  );

  final testVehicle = Vehicle(
    id: 'v1',
    name: 'Auto',
    baseFare: 30,
    perKmRate: 15,
    etaMinutes: 2,
    assetPath: 'assets/auto.png',
  );

  final testRide = Ride(
    id: 'ride1',
    pickup: testPlace,
    destination: testPlace,
    vehicle: testVehicle,
    fare: 150,
    status: RideStatus.completed,
    createdAt: DateTime.now(),
  );

  final testRideDto = RideDto.fromEntity(testRide);

  setUp(() {
    mockSimulationDataSource = MockRideSimulationDataSource();
    mockLocalDataSource = MockRideLocalDataSource();
    repository = RideRepositoryImpl(mockSimulationDataSource, mockLocalDataSource);
    
    registerFallbackValue(testRideDto);
  });

  group('RideRepositoryImpl Tests', () {
    test('saveRide saves successfully', () async {
      when(() => mockLocalDataSource.saveRide(any())).thenAnswer((_) async {});

      final result = await repository.saveRide(testRide);

      expect(result.isSuccess, true);
      verify(() => mockLocalDataSource.saveRide(any())).called(1);
    });

    test('getRideHistory retrieves and maps rides', () async {
      when(() => mockLocalDataSource.getAllRides()).thenAnswer((_) async => [testRideDto]);

      final result = await repository.getRideHistory();

      expect(result.isSuccess, true);
      expect(result.getOrNull()?.length, 1);
      expect(result.getOrNull()?.first.id, testRide.id);
    });

    test('simulateDriverSearch delegates correctly', () async {
      when(() => mockSimulationDataSource.simulateDriverSearch(testRide)).thenAnswer((_) async => testRide);

      final result = await repository.simulateDriverSearch(testRide);

      expect(result.isSuccess, true);
      expect(result.getOrNull(), testRide);
    });
  });
}
