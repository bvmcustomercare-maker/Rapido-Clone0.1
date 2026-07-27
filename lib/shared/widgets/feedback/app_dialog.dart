import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';

/// Reusable AppDialog Component adhering to design.md §7 Dialog Elevation & §6 Radius
class AppDialog extends StatelessWidget {
  final String title;
  final String content;
  final Widget? confirmButton;
  final Widget? cancelButton;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmButton,
    this.cancelButton,
  });

  /// Static helper to trigger themed AppDialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    Widget? confirmButton,
    Widget? cancelButton,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        content: content,
        confirmButton: confirmButton,
        cancelButton: cancelButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.dialog),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.dialog),
          boxShadow: tokens.dialogShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: AppTypography.heading.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 12),

            // Content
            Text(
              content,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),

            // Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (cancelButton != null) ...[
                  cancelButton!,
                  const SizedBox(width: 12),
                ],
                if (confirmButton != null) ...[
                  confirmButton!,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
