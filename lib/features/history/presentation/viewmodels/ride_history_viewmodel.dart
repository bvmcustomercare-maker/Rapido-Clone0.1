import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/logger.dart';
import '../../../ride/domain/entities/ride.dart';
import '../../../ride/domain/usecases/ride_usecases.dart';

class RideHistoryState {
  final List<Ride> allRides;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final String selectedStatusFilter; // 'All', 'Completed', 'Cancelled'
  final String selectedSortOption; // 'Date (Newest)', 'Date (Oldest)', 'Fare (High to Low)', 'Fare (Low to High)'

  const RideHistoryState({
    this.allRides = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedStatusFilter = 'All',
    this.selectedSortOption = 'Date (Newest)',
  });

  RideHistoryState copyWith({
    List<Ride>? allRides,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? selectedStatusFilter,
    String? selectedSortOption,
  }) {
    return RideHistoryState(
      allRides: allRides ?? this.allRides,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
    );
  }
}

class RideHistoryViewModel extends StateNotifier<RideHistoryState> {
  final GetRideHistoryUseCase _getRideHistory;
  final DeleteRideUseCase _deleteRide;

  RideHistoryViewModel({
    required GetRideHistoryUseCase getRideHistory,
    required DeleteRideUseCase deleteRide,
  })  : _getRideHistory = getRideHistory,
        _deleteRide = deleteRide,
        super(const RideHistoryState()) {
    loadRides();
  }

  Future<void> loadRides() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getRideHistory();
    result.fold(
      (rides) {
        state = state.copyWith(allRides: rides, isLoading: false);
      },
      (failure) {
        AppLogger.e('Failed to load history: ${failure.message}');
        state = state.copyWith(errorMessage: failure.message, isLoading: false);
      },
    );
  }

  Future<void> deleteRide(String id) async {
    final result = await _deleteRide(id);
    result.fold(
      (_) {
        final updatedRides = state.allRides.where((r) => r.id != id).toList();
        state = state.copyWith(allRides: updatedRides);
      },
      (failure) {
        AppLogger.e('Failed to delete ride: ${failure.message}');
      },
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(String status) {
    state = state.copyWith(selectedStatusFilter: status);
  }

  void setSortOption(String sort) {
    state = state.copyWith(selectedSortOption: sort);
  }

  // Derived filtered & sorted list
  List<Ride> get filteredAndSortedRides {
    var list = List<Ride>.from(state.allRides);

    // Filter by status
    if (state.selectedStatusFilter != 'All') {
      list = list.where((r) => r.status.name.toLowerCase() == state.selectedStatusFilter.toLowerCase()).toList();
    }

    // Filter by search query (pickup or destination)
    if (state.searchQuery.trim().isNotEmpty) {
      final query = state.searchQuery.trim().toLowerCase();
      list = list.where((r) {
        return r.pickup.name.toLowerCase().contains(query) ||
               r.destination.name.toLowerCase().contains(query);
      }).toList();
    }

    // Sort
    switch (state.selectedSortOption) {
      case 'Date (Newest)':
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Date (Oldest)':
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Fare (High to Low)':
        list.sort((a, b) => b.fare.compareTo(a.fare));
        break;
      case 'Fare (Low to High)':
        list.sort((a, b) => a.fare.compareTo(b.fare));
        break;
    }

    return list;
  }
  
  // Statistics
  int get totalRides => state.allRides.length;
  
  double get totalSpent {
    return state.allRides.fold(0.0, (sum, ride) => sum + (double.tryParse(ride.fare) ?? 0.0));
  }
}
