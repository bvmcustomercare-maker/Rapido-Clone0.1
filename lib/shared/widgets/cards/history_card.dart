import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';

/// Reusable HistoryCard Widget adhering to design.md §10 Card System
class HistoryCard extends StatelessWidget {
  final String pickupAddress;
  final String dropAddress;
  final String date;
  final String fare;
  final VoidCallback onTap;

  const HistoryCard({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.date,
    required this.fare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: tokens.cardShadow,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vertical route indicator column (pickup dot -> line -> drop pin)
            Column(
              children: [
                const SizedBox(height: 4),
                const Icon(Icons.radio_button_checked, color: AppColors.success, size: 16),
                Container(
                  width: 2,
                  height: 36,
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                const Icon(Icons.location_on, color: AppColors.error, size: 16),
              ],
            ),
            const SizedBox(width: 14),

            // Addresses & Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pickup',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  Text(
                    pickupAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Destination',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  Text(
                    dropAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    date,
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Fare & Arrow
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  fare,
                  style: AppTypography.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 24),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
