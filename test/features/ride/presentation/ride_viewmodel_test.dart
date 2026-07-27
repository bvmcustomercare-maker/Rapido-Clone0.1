import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking_application/features/home/domain/entities/place.dart';
import 'package:ride_booking_application/features/home/domain/entities/vehicle.dart';
import 'package:ride_booking_application/features/ride/domain/entities/ride.dart';
import 'package:ride_booking_application/features/ride/domain/enums/ride_status.dart';
import 'package:ride_booking_application/features/ride/presentation/providers/ride_provider.dart';
import 'package:ride_booking_application/features/ride/presentation/viewmodels/ride_viewmodel.dart';
import 'package:ride_booking_application/features/ride/data/datasources/ride_simulation_data_source.dart';
import 'package:ride_booking_application/features/ride/data/repositories/ride_repository_impl.dart';
import 'package:ride_booking_application/features/ride/domain/usecases/ride_usecases.dart';

void main() {
  group('RideViewModel Tests', () {
    late ProviderContainer container;
    
    final dummyPickup = Place(
      id: 'p1',
      name: 'Connaught Place',
      address: 'New Delhi, Delhi',
      latitude: 28.6315,
      longitude: 77.2167,
    );
    
    final dummyDestination = Place(
      id: 'd1',
      name: 'India Gate',
      address: 'New Delhi, Delhi',
      latitude: 28.6129,
      longitude: 77.2295,
    );
    
    final dummyVehicle = Vehicle(
      id: 'cab',
      name: 'Cab',
      description: 'Comfortable cars',
      capacity: '4 seats',
      iconAsset: 'assets/images/car.png',
    );
    
    final initialRide = Ride(
      id: 'ride_1',
      pickup: dummyPickup,
      destination: dummyDestination,
      vehicle: dummyVehicle,
      fare: '150',
      createdAt: DateTime.now(),
      status: RideStatus.confirming,
    );

    setUp(() {
      container = ProviderContainer(
        overrides: [
          // We could mock the data source, but for a quick test we'll use the real simulation one
          // which has artificial delays. We might need to override the data source to avoid delays in tests.
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state is empty', () {
      final state = container.read(rideViewModelProvider);
      expect(state.currentRide, isNull);
      expect(state.isLoading, isFalse);
    });

    test('Initialize ride sets current ride to confirming state', () {
      final notifier = container.read(rideViewModelProvider.notifier);
      notifier.initializeRide(initialRide);
      
      final state = container.read(rideViewModelProvider);
      expect(state.currentRide, isNotNull);
      expect(state.currentRide!.status, equals(RideStatus.confirming));
    });
    
    test('Cancel ride sets status to cancelled', () async {
      final notifier = container.read(rideViewModelProvider.notifier);
      notifier.initializeRide(initialRide);
      
      await notifier.cancelRide();
      
      final state = container.read(rideViewModelProvider);
      expect(state.currentRide!.status, equals(RideStatus.cancelled));
    });
  });
}
