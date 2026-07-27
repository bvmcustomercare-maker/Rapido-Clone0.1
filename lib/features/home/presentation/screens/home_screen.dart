import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../viewmodels/home_state.dart';
import '../widgets/confirm_ride_button.dart';
import '../widgets/fare_input_field.dart';
import '../widgets/location_input_card.dart';
import '../widgets/location_search_overlay.dart';
import '../widgets/recent_places_list.dart';
import '../widgets/simulated_map_widget.dart';
import '../widgets/vehicle_selection_list.dart';
import '../../ride/domain/entities/ride.dart';
import '../../ride/presentation/providers/ride_provider.dart';

/// Main Home screen – the primary UI after authentication (PRD §6.2)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sheetController;
  late Animation<double> _sheetAnim;
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _sheetAnim = CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutCubic,
    );
    _sheetController.forward();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  // ─── Navigation helpers ──────────────────────────────────────────────────

  Future<void> _openPickupSearch(HomeState state) async {
    await Navigator.of(context).push<void>(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => LocationSearchOverlay(
          title: 'Set Pickup',
          recentPlaces: state.recentPlaces,
          favouritePlaces: state.favouritePlaces,
          onPlaceSelected: (place) {
            Navigator.of(context).pop();
            ref.read(homeViewModelProvider.notifier).setPickup(place);
          },
        ),
      ),
    );
  }

  Future<void> _openDestinationSearch(HomeState state) async {
    await Navigator.of(context).push<void>(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => LocationSearchOverlay(
          title: 'Set Destination',
          recentPlaces: state.recentPlaces,
          favouritePlaces: state.favouritePlaces,
          onPlaceSelected: (place) {
            Navigator.of(context).pop();
            ref.read(homeViewModelProvider.notifier).setDestination(place);
          },
        ),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // ─── Map (full screen background) ───────────────────────────
          Positioned.fill(
            child: Consumer(
              builder: (context, ref, _) {
                final pickup = ref.watch(homeViewModelProvider.select((s) => s.pickup));
                final destination = ref.watch(homeViewModelProvider.select((s) => s.destination));
                return SimulatedMapWidget(
                  pickup: pickup,
                  destination: destination,
                );
              },
            ),
          ),

          // ─── Top bar with user greeting + menu ─────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space4, vertical: AppSpacing.space3),
                child: Row(
                  children: [
                    // ── Greeting card ──────────────────────────────────
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space4,
                            vertical: AppSpacing.space3),
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.surfaceLight)
                              .withOpacity(0.95),
                          borderRadius: BorderRadius.circular(AppSpacing.space4),
                          boxShadow: tokens.cardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _greeting(),
                              style: AppTypography.caption.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            Text(
                              user?.name ?? 'Rider',
                              style: AppTypography.subtitle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space3),

                    // ── History Button ────────────────────────────────
                    Tooltip(
                      message: 'Ride History',
                      child: Semantics(
                        button: true,
                        label: 'Ride History',
                        onTapHint: 'View past rides',
                        child: GestureDetector(
                          onTap: () => context.push('/history'),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
                              shape: BoxShape.circle,
                              boxShadow: tokens.cardShadow,
                            ),
                            child: Icon(
                              Icons.history_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space3),

                    // ── Profile avatar ────────────────────────────────
                    Tooltip(
                      message: 'Profile',
                      child: Semantics(
                        button: true,
                        label: 'Profile',
                        onTapHint: 'Open profile settings',
                        child: GestureDetector(
                          onTap: () => context.push(RoutePaths.profile),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: tokens.fabShadow,
                            ),
                            child: Center(
                              child: Text(
                                _initials(user?.name ?? 'R'),
                                style: AppTypography.subtitle.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Error banner ───────────────────────────────────────────
          Consumer(
            builder: (context, ref, _) {
              final errorMessage = ref.watch(homeViewModelProvider.select((s) => s.errorMessage));
              if (errorMessage == null) return const SizedBox.shrink();
              return Positioned(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
                left: AppSpacing.space4,
                right: AppSpacing.space4,
                child: _ErrorBanner(
                  message: errorMessage,
                  onDismiss: () =>
                      ref.read(homeViewModelProvider.notifier).clearError(),
                ),
              );
            },
          ),

          // ─── Bottom draggable sheet ─────────────────────────────────
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(_sheetAnim),
            child: NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                if (notification.extent > 0.8) {
                  FocusScope.of(context).unfocus();
                }
                return false;
              },
              child: DraggableScrollableSheet(
                controller: _draggableController,
                initialChildSize: 0.48,
                minChildSize: 0.18,
                maxChildSize: 0.88,
                snap: true,
                snapSizes: const [0.18, 0.48, 0.88],
                builder: (context, scrollController) {
                  return Consumer(
                    builder: (context, ref, child) {
                      final state = ref.watch(homeViewModelProvider);
                      return Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          boxShadow: tokens.bottomSheetShadow,
                        ),
                        child: state.isLoading
                            ? _buildLoadingState(isDark)
                            : _buildSheetContent(context, scrollController, state, isDark),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _buildSheetContent(
    BuildContext context,
    ScrollController scrollController,
    HomeState state,
    bool isDark,
  ) {
    return CustomScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [
        // ── Drag handle ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Semantics(
            label: 'Swipe up to expand or down to collapse menu',
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.space2),
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppColors.borderDark : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
              ],
            ),
          ),
        ),

        // ── Location Input Card ──────────────────────────────────────
        SliverToBoxAdapter(
          child: LocationInputCard(
            pickup: state.pickup,
            destination: state.destination,
            onPickupTap: () => _openPickupSearch(state),
            onDestinationTap: () => _openDestinationSearch(state),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.space5),
        ),

        // ── Recent places ────────────────────────────────────────────
        SliverToBoxAdapter(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: state.recentPlaces.isNotEmpty
                ? RecentPlacesList(
                    places: state.recentPlaces,
                    onPlaceTap: (place) {
                      // Tap a recent place → auto-set as destination
                      ref
                          .read(homeViewModelProvider.notifier)
                          .setDestination(place);
                    },
                    onFavouriteTap: (place) {
                      ref
                          .read(homeViewModelProvider.notifier)
                          .toggleFavourite(place);
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.space5),
        ),

        // ── Vehicle selection ────────────────────────────────────────
        SliverToBoxAdapter(
          child: VehicleSelectionList(
            vehicles: state.vehicleTypes,
            selectedVehicle: state.selectedVehicle,
            onVehicleSelected: (v) =>
                ref.read(homeViewModelProvider.notifier).selectVehicle(v),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.space5),
        ),

        // ── Fare input ───────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
            child: FareInputField(
              value: state.fareInput,
              onChanged: (v) =>
                  ref.read(homeViewModelProvider.notifier).updateFare(v),
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.space5),
        ),

        // ── Confirm ride button ──────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
            child: ConfirmRideButton(
              isEnabled: state.canConfirmRide,
              onTap: state.canConfirmRide
                  ? () => _onConfirmRide(state)
                  : null,
            ),
          ),
        ),

        // Bottom padding for home indicator
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom + AppSpacing.space6,
          ),
        ),
      ],
    );
  }

  void _onConfirmRide(HomeState state) async {
    if (!state.canConfirmRide) return;
    
    final ride = Ride(
      id: 'ride_${DateTime.now().millisecondsSinceEpoch}',
      pickup: state.pickup!,
      destination: state.destination!,
      vehicle: state.selectedVehicle!,
      fare: state.manualFare!,
      createdAt: DateTime.now(),
    );
    
    ref.read(rideViewModelProvider.notifier).initializeRide(ride);
    if (context.mounted) {
      context.push('/ride');
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 👋';
    if (hour < 17) return 'Good afternoon 👋';
    return 'Good evening 👋';
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'R';
  }
}

// ─── Error Banner ─────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ErrorBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4, vertical: AppSpacing.space3),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
          const SizedBox(width: AppSpacing.space2),
          Expanded(
            child: Text(
              message,
              style:
                  AppTypography.bodySmall.copyWith(color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: const Icon(Icons.close_rounded,
                color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
