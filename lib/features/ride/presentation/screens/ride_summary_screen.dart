import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/route_paths.dart';
import '../../../../../shared/widgets/buttons/app_button.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../providers/ride_providers.dart';

class RideSummaryScreen extends ConsumerWidget {
  const RideSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideState = ref.watch(rideViewModelProvider);
    final ride = rideState.currentRide;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (ride == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ride Summary')),
        body: const Center(child: Text('No ride details available.')),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Ride Confirmed'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.success,
                size: 64,
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                'Your ride has been successfully booked!',
                textAlign: TextAlign.center,
                style: AppTypography.title.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: AppSpacing.space6),
              
              // Ride Details Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.space4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Pickup', ride.pickup.name, isDark),
                    const Divider(height: AppSpacing.space4),
                    _buildSummaryRow('Destination', ride.destination.name, isDark),
                    const Divider(height: AppSpacing.space4),
                    _buildSummaryRow('Vehicle', ride.vehicle.name, isDark),
                    const Divider(height: AppSpacing.space4),
                    _buildSummaryRow('Agreed Fare', '₹${ride.fare}', isDark, isHighlight: true),
                  ],
                ),
              ),
              const Spacer(),
              
              // Done Button
              AppButton(
                text: 'Back to Home',
                onPressed: () {
                  context.go(RoutePaths.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: isHighlight 
                  ? AppColors.primary 
                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
        ),
      ],
    );
  }
}
