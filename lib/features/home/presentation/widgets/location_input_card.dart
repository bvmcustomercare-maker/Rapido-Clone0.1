import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../../../domain/entities/place.dart';

/// Floating card showing pickup + destination inputs (PRD §FR-HOME-002)
class LocationInputCard extends StatelessWidget {
  final Place? pickup;
  final Place? destination;
  final VoidCallback onPickupTap;
  final VoidCallback onDestinationTap;

  const LocationInputCard({
    super.key,
    this.pickup,
    this.destination,
    required this.onPickupTap,
    required this.onDestinationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.space5),
        boxShadow: Theme.of(context).extension<RideFlowTokens>()!.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Pickup Row ──────────────────────────────────────────────
          _LocationInputRow(
            icon: Icons.my_location_rounded,
            iconColor: AppColors.accent,
            hintText: 'Your current location',
            value: pickup?.name,
            onTap: onPickupTap,
            isDark: isDark,
          ),

          // ─── Divider with connection dot ─────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.space6),
            child: Row(
              children: [
                Container(
                  width: 1.5,
                  height: AppSpacing.space5,
                  color: (isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
              ],
            ),
          ),

          // ─── Destination Row ─────────────────────────────────────────
          _LocationInputRow(
            icon: Icons.location_on_rounded,
            iconColor: AppColors.error,
            hintText: 'Where to go?',
            value: destination?.name,
            onTap: onDestinationTap,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _LocationInputRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String hintText;
  final String? value;
  final VoidCallback onTap;
  final bool isDark;

  const _LocationInputRow({
    required this.icon,
    required this.iconColor,
    required this.hintText,
    this.value,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return Semantics(
      button: true,
      label: hintText,
      value: hasValue ? value : null,
      onTapHint: 'Tap to change location',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Text(
                hasValue ? value! : hintText,
                style: hasValue
                    ? AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      )
                    : AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasValue)
              Icon(
                Icons.edit_rounded,
                size: 14,
                color: isDark
                    ? AppColors.textDisabledDark
                    : AppColors.textDisabledLight,
              ),
          ],
        ),
      ),
    );
  }
}
