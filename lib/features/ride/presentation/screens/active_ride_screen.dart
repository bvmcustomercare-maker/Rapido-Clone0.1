import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../../home/presentation/widgets/simulated_map_widget.dart';
import '../../domain/enums/ride_status.dart';
import '../providers/ride_provider.dart';
import '../widgets/driver_arriving_sheet.dart';
import '../widgets/driver_assigned_sheet.dart';
import '../widgets/live_tracking_overlay.dart';
import '../widgets/otp_verification_sheet.dart';
import '../widgets/ride_complete_sheet.dart';
import '../widgets/ride_confirmation_sheet.dart';
import '../widgets/searching_driver_overlay.dart';

/// Main screen displaying the active ride lifecycle (PRD §6.4).
class ActiveRideScreen extends ConsumerStatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  ConsumerState<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends ConsumerState<ActiveRideScreen> {
  @override
  Widget build(BuildContext context) {
    final currentRide = ref.watch(rideViewModelProvider.select((s) => s.currentRide));
    final status = ref.watch(rideViewModelProvider.select((s) => s.status));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (currentRide == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: const Center(child: Text('No active ride')),
      );
    }

    if (status == RideStatus.cancelled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // ─── Map Background ──────────────────────────────────────────
          Positioned.fill(
            child: Consumer(
              builder: (context, ref, _) {
                final etaSeconds = ref.watch(rideViewModelProvider.select((s) => s.remainingEtaSeconds));
                return SimulatedMapWidget(
                  pickup: currentRide.pickup,
                  destination: currentRide.destination,
                  status: status,
                  etaSeconds: etaSeconds,
                );
              },
            ),
          ),

          // ─── Back Button (Only when confirming or searching) ────────
          if (status == RideStatus.confirming || status == RideStatus.searching)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: Tooltip(
                message: status == RideStatus.searching ? 'Cancel Ride' : 'Go Back',
                child: Semantics(
                  button: true,
                  label: status == RideStatus.searching ? 'Cancel Ride' : 'Go Back',
                  onTapHint: status == RideStatus.searching ? 'Cancel the current ride search' : 'Return to previous screen',
                  child: GestureDetector(
                    onTap: () {
                      if (status == RideStatus.searching) {
                        ref.read(rideViewModelProvider.notifier).cancelRide();
                      } else {
                        context.pop();
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight).withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: Theme.of(context).extension<RideFlowTokens>()!.fabShadow,
                      ),
                      child: Icon(
                        status == RideStatus.searching ? Icons.close_rounded : Icons.arrow_back_rounded,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ─── Dynamic Overlay based on Ride Status ────────────────────
          _buildOverlayForStatus(status!),
        ],
      ),
    );
  }

  Widget _buildOverlayForStatus(RideStatus status) {
    switch (status) {
      case RideStatus.confirming:
        return const Align(
          alignment: Alignment.bottomCenter,
          child: RideConfirmationSheet(),
        );
      case RideStatus.searching:
        return const Positioned.fill(
          child: SearchingDriverOverlay(),
        );
      case RideStatus.assigned:
        return const Align(
          alignment: Alignment.bottomCenter,
          child: DriverAssignedSheet(),
        );
      case RideStatus.arriving:
        return const Align(
          alignment: Alignment.bottomCenter,
          child: DriverArrivingSheet(),
        );
      case RideStatus.arrived:
        return const Align(
          alignment: Alignment.bottomCenter,
          child: OtpVerificationSheet(),
        );
      case RideStatus.started:
        return const Align(
          alignment: Alignment.bottomCenter,
          child: LiveTrackingOverlay(),
        );
      case RideStatus.completed:
        return const Align(
          alignment: Alignment.bottomCenter,
          child: RideCompleteSheet(),
        );
      case RideStatus.cancelled:
      default:
        return const SizedBox.shrink();
    }
  }
}
