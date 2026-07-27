import 'package:flutter_test/flutter_test.dart';
import 'package:rideflow/features/home/domain/entities/place.dart';
import 'package:rideflow/features/home/domain/entities/vehicle.dart';
import 'package:rideflow/features/home/presentation/viewmodels/home_state.dart';

void main() {
  group('Place entity', () {
    const place = Place(
      id: 'p1',
      name: 'India Gate',
      address: 'Rajpath, New Delhi',
      latitude: 28.6129,
      longitude: 77.2295,
    );

    test('copyWith preserves fields not overridden', () {
      final updated = place.copyWith(name: 'Red Fort');
      expect(updated.id, 'p1');
      expect(updated.name, 'Red Fort');
      expect(updated.address, 'Rajpath, New Delhi');
    });

    test('equality is based on id', () {
      final place2 = place.copyWith(name: 'Different name');
      expect(place, equals(place2));
    });

    test('hashCode is based on id', () {
      expect(place.hashCode, 'p1'.hashCode);
    });

    test('isFavourite defaults to false', () {
      expect(place.isFavourite, isFalse);
    });

    test('copyWith toggles isFavourite', () {
      final fav = place.copyWith(isFavourite: true);
      expect(fav.isFavourite, isTrue);
    });
  });

  group('Vehicle entity', () {
    const bike = Vehicle(
      id: 'bike',
      name: 'Bike',
      description: 'Affordable rides',
      capacity: '1',
      iconAsset: 'assets/icons/ic_bike.png',
    );

    test('equality is based on id', () {
      const bike2 = Vehicle(
        id: 'bike',
        name: 'Different',
        description: 'x',
        capacity: '2',
        iconAsset: '',
      );
      expect(bike, equals(bike2));
    });

    test('hashCode is based on id', () {
      expect(bike.hashCode, 'bike'.hashCode);
    });
  });

  group('HomeState', () {
    const pickup = Place(
      id: 'p1',
      name: 'Pickup',
      address: 'Address A',
      latitude: 0,
      longitude: 0,
    );
    const destination = Place(
      id: 'p2',
      name: 'Destination',
      address: 'Address B',
      latitude: 1,
      longitude: 1,
    );
    const vehicle = Vehicle(
      id: 'bike',
      name: 'Bike',
      description: 'd',
      capacity: '1',
      iconAsset: '',
    );

    test('canConfirmRide is false with empty state', () {
      expect(const HomeState().canConfirmRide, isFalse);
    });

    test('canConfirmRide is false when destination is missing', () {
      final state = const HomeState().copyWith(
        pickup: pickup,
        selectedVehicle: vehicle,
        fareInput: '100',
      );
      expect(state.canConfirmRide, isFalse);
    });

    test('canConfirmRide is false when fare is empty', () {
      final state = const HomeState().copyWith(
        pickup: pickup,
        destination: destination,
        selectedVehicle: vehicle,
        fareInput: '',
      );
      expect(state.canConfirmRide, isFalse);
    });

    test('canConfirmRide is false when fare is 0', () {
      final state = const HomeState().copyWith(
        pickup: pickup,
        destination: destination,
        selectedVehicle: vehicle,
        fareInput: '0',
      );
      expect(state.canConfirmRide, isFalse);
    });

    test('canConfirmRide is false when fare exceeds 99999', () {
      final state = const HomeState().copyWith(
        pickup: pickup,
        destination: destination,
        selectedVehicle: vehicle,
        fareInput: '100000',
      );
      expect(state.canConfirmRide, isFalse);
    });

    test('canConfirmRide is true when all required fields are set', () {
      final state = const HomeState().copyWith(
        pickup: pickup,
        destination: destination,
        selectedVehicle: vehicle,
        fareInput: '250',
      );
      expect(state.canConfirmRide, isTrue);
    });

    test('canConfirmRide is true with min fare of 1', () {
      final state = const HomeState().copyWith(
        destination: destination,
        selectedVehicle: vehicle,
        fareInput: '1',
      );
      expect(state.canConfirmRide, isTrue);
    });

    test('canConfirmRide is true with max fare of 99999', () {
      final state = const HomeState().copyWith(
        destination: destination,
        selectedVehicle: vehicle,
        fareInput: '99999',
      );
      expect(state.canConfirmRide, isTrue);
    });

    test('copyWith clearPickup removes pickup', () {
      final state = const HomeState().copyWith(pickup: pickup);
      expect(state.pickup, isNotNull);
      final cleared = state.copyWith(clearPickup: true);
      expect(cleared.pickup, isNull);
    });

    test('copyWith clearDestination removes destination', () {
      final state = const HomeState().copyWith(destination: destination);
      final cleared = state.copyWith(clearDestination: true);
      expect(cleared.destination, isNull);
    });

    test('copyWith clearError removes errorMessage', () {
      final state = const HomeState().copyWith(errorMessage: 'Error!');
      expect(state.errorMessage, isNotNull);
      final cleared = state.copyWith(clearError: true);
      expect(cleared.errorMessage, isNull);
    });

    test('isLoading defaults to false', () {
      expect(const HomeState().isLoading, isFalse);
    });
  });
}
