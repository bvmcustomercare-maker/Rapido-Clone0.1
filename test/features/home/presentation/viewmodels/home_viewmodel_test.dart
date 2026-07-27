import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rideflow/core/utils/result.dart';
import 'package:rideflow/features/home/domain/entities/place.dart';
import 'package:rideflow/features/home/domain/entities/vehicle.dart';
import 'package:rideflow/features/home/domain/usecases/home_usecases.dart';
import 'package:rideflow/features/home/presentation/viewmodels/home_viewmodel.dart';

class MockGetRecentPlacesUseCase extends Mock implements GetRecentPlacesUseCase {}
class MockGetFavouritePlacesUseCase extends Mock implements GetFavouritePlacesUseCase {}
class MockAddRecentPlaceUseCase extends Mock implements AddRecentPlaceUseCase {}
class MockToggleFavouriteUseCase extends Mock implements ToggleFavouriteUseCase {}
class MockGetVehicleTypesUseCase extends Mock implements GetVehicleTypesUseCase {}
class MockClearRecentPlacesUseCase extends Mock implements ClearRecentPlacesUseCase {}

void main() {
  late HomeViewModel viewModel;
  late MockGetRecentPlacesUseCase mockGetRecentPlaces;
  late MockGetFavouritePlacesUseCase mockGetFavouritePlaces;
  late MockAddRecentPlaceUseCase mockAddRecentPlace;
  late MockToggleFavouriteUseCase mockToggleFavourite;
  late MockGetVehicleTypesUseCase mockGetVehicleTypes;
  late MockClearRecentPlacesUseCase mockClearRecentPlaces;

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

  setUp(() {
    mockGetRecentPlaces = MockGetRecentPlacesUseCase();
    mockGetFavouritePlaces = MockGetFavouritePlacesUseCase();
    mockAddRecentPlace = MockAddRecentPlaceUseCase();
    mockToggleFavourite = MockToggleFavouriteUseCase();
    mockGetVehicleTypes = MockGetVehicleTypesUseCase();
    mockClearRecentPlaces = MockClearRecentPlacesUseCase();

    // Default mock behaviors
    when(() => mockGetRecentPlaces()).thenAnswer((_) async => Result.success([]));
    when(() => mockGetFavouritePlaces()).thenAnswer((_) async => Result.success([]));
    when(() => mockGetVehicleTypes()).thenAnswer((_) async => Result.success([testVehicle]));

    viewModel = HomeViewModel(
      getRecentPlaces: mockGetRecentPlaces,
      getFavouritePlaces: mockGetFavouritePlaces,
      addRecentPlace: mockAddRecentPlace,
      toggleFavourite: mockToggleFavourite,
      getVehicleTypes: mockGetVehicleTypes,
      clearRecentPlaces: mockClearRecentPlaces,
    );
  });

  group('HomeViewModel Tests', () {
    test('Initialization loads vehicles and selects the first one', () async {
      await Future.delayed(Duration.zero); // Wait for microtasks (initialization)
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.vehicleTypes.length, 1);
      expect(viewModel.state.selectedVehicle, testVehicle);
    });

    test('setPickup updates state and adds to recents', () async {
      when(() => mockAddRecentPlace(any())).thenAnswer((_) async => Result.success(testPlace));
      when(() => mockGetRecentPlaces()).thenAnswer((_) async => Result.success([testPlace]));
      
      await viewModel.setPickup(testPlace);
      
      expect(viewModel.state.pickup, testPlace);
      expect(viewModel.state.recentPlaces.length, 1);
      verify(() => mockAddRecentPlace(testPlace)).called(1);
    });

    test('updateFare updates state', () {
      viewModel.updateFare('150');
      expect(viewModel.state.fareInput, '150');
    });

    test('clearPickup removes pickup', () {
      viewModel.clearPickup();
      expect(viewModel.state.pickup, isNull);
    });
  });
}
