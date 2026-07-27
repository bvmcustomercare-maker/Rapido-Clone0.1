import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../../../home/presentation/widgets/confirm_ride_button.dart';
import '../providers/ride_provider.dart';

/// Bottom sheet for Ride Confirmation (PRD §14.11)
class RideConfirmationSheet extends ConsumerWidget {
  const RideConfirmationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rideViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;
    
    if (state.currentRide == null) return const SizedBox.shrink();

    final ride = state.currentRide!;

    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.space4,
        left: AppSpacing.space4,
        right: AppSpacing.space4,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        boxShadow: tokens.bottomSheetShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          
          Text(
            'Confirm your ride',
            style: AppTypography.title.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.space5),

          // Details Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(
                context,
                Icons.directions_car_rounded,
                ride.vehicle.name,
                isDark,
              ),
              _buildDetailItem(
                context,
                Icons.payments_rounded,
                '₹${ride.fare}',
                isDark,
              ),
              _buildDetailItem(
                context,
                Icons.wallet_rounded,
                ride.paymentMethod,
                isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          
          ConfirmRideButton(
            isEnabled: true,
            onTap: () {
              ref.read(rideViewModelProvider.notifier).confirmRide();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String text, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.space3),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.space2),
        Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
