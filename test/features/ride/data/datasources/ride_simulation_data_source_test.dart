import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rideflow/features/home/domain/entities/place.dart';
import 'package:rideflow/features/home/domain/entities/vehicle.dart';
import 'package:rideflow/features/ride/data/datasources/ride_simulation_data_source.dart';
import 'package:rideflow/features/ride/domain/entities/driver.dart';
import 'package:rideflow/features/ride/domain/entities/ride.dart';
import 'package:rideflow/features/ride/domain/enums/ride_status.dart';
import 'package:rideflow/features/ride/domain/simulation/simulation_engine.dart';

class MockSimulationEngine extends Mock implements SimulationEngine {}

void main() {
  late RideSimulationDataSourceImpl dataSource;
  late MockSimulationEngine mockEngine;

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
    status: RideStatus.searching,
    createdAt: DateTime.now(),
  );

  final updatedRide = testRide.copyWith(status: RideStatus.assigned);

  setUp(() {
    mockEngine = MockSimulationEngine();
    dataSource = RideSimulationDataSourceImpl(engine: mockEngine);
  });

  group('RideSimulationDataSource Tests', () {
    test('simulateDriverSearch delegates to engine', () async {
      when(() => mockEngine.simulateDriverSearch(any())).thenAnswer((_) async => updatedRide);
      
      final result = await dataSource.simulateDriverSearch(testRide);
      
      expect(result, updatedRide);
      verify(() => mockEngine.simulateDriverSearch(testRide)).called(1);
    });

    test('simulateDriverArriving delegates to engine', () async {
      when(() => mockEngine.simulateDriverArriving(any())).thenAnswer((_) async => updatedRide);
      
      final result = await dataSource.simulateDriverArriving(testRide);
      
      expect(result, updatedRide);
      verify(() => mockEngine.simulateDriverArriving(testRide)).called(1);
    });

    test('submitPayment delegates to engine', () async {
      when(() => mockEngine.submitPayment()).thenAnswer((_) async {});
      
      await dataSource.submitPayment('ride1', 'Cash', '150');
      
      verify(() => mockEngine.submitPayment()).called(1);
    });
  });
}
