import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Reusable SettingsCard Widget adhering to design.md §10 Card System
class SettingsCard extends StatelessWidget {
  final String label;
  final IconData leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsCard({
    super.key,
    required this.label,
    required this.leadingIcon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          leadingIcon,
          color: isDark ? AppColors.textPrimaryDark : AppColors.secondary,
        ),
        title: Text(
          label,
          style: AppTypography.subtitle.copyWith(
            fontWeight: FontWeight.normal,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
            ),
        onTap: onTap,
      ),
    );
  }
}
