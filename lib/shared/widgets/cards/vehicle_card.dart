import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';

/// Reusable VehicleCard Widget adhering to design.md §10 Card System
class VehicleCard extends StatelessWidget {
  final String title;
  final String capacity;
  final String description;
  final String eta;
  final String price;
  final Widget vehicleIllustration;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.title,
    required this.capacity,
    required this.description,
    required this.eta,
    required this.price,
    required this.vehicleIllustration,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.secondaryContainerDark : AppColors.primaryLight)
              : (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(AppRadius.vehicleCard),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected ? tokens.vehicleCardSelectedShadow : tokens.cardShadow,
        ),
        child: Row(
          children: [
            // Vehicle Illustration
            SizedBox(
              width: 64,
              height: 64,
              child: Center(child: vehicleIllustration),
            ),
            const SizedBox(width: 16),

            // Vehicle Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Capacity Chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person, size: 10),
                            const SizedBox(width: 2),
                            Text(
                              capacity,
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    eta,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Fare Price
            const SizedBox(width: 12),
            Text(
              price,
              style: AppTypography.subtitle.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
