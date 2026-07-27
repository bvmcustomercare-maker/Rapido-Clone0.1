import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';

/// Reusable RideSummaryCard Widget adhering to design.md §10 Card System
class RideSummaryCard extends StatelessWidget {
  final String pickupAddress;
  final String dropAddress;
  final String fareTitle;
  final String fareAmount;
  final Map<String, String> breakdown;

  const RideSummaryCard({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.fareTitle,
    required this.fareAmount,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.vehicleCard),
        boxShadow: tokens.cardShadow,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Simulated/Fake map preview header background
          Container(
            height: 120,
            color: isDark ? AppColors.secondaryContainerDark : AppColors.primaryLight,
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_rounded, color: AppColors.primaryDark),
                  SizedBox(width: 8),
                  Text('Route Preview Map Map Preview'),
                ],
              ),
            ),
          ),

          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route address timeline
                Row(
                  children: [
                    const Icon(Icons.radio_button_checked, color: AppColors.success, size: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        pickupAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: SizedBox(
                    height: 12,
                    child: VerticalDivider(width: 2, thickness: 1.5),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.error, size: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dropAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Fare Breakdown Table
                ...breakdown.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        Text(
                          entry.value,
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }),

                const Divider(height: 24),

                // Total Fare row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      fareTitle,
                      style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      fareAmount,
                      style: AppTypography.title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
