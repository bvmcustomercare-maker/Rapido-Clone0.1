import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardShadow = Theme.of(context).extension<RideFlowTokens>()!.cardShadow;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              isDark: isDark,
              cardShadow: cardShadow,
              title: 'Offline First',
              content: 'All your data, including profile information, generated ride history, and simulated locations, are stored entirely offline on your device using local databases.',
              icon: Icons.wifi_off_rounded,
            ),
            const SizedBox(height: AppSpacing.space4),
            _buildSection(
              isDark: isDark,
              cardShadow: cardShadow,
              title: 'No Data Collection',
              content: 'RideFlow Simulator does not collect, transmit, or share any personal information. There are no analytics trackers or remote servers connected to this application.',
              icon: Icons.shield_rounded,
            ),
            const SizedBox(height: AppSpacing.space4),
            _buildSection(
              isDark: isDark,
              cardShadow: cardShadow,
              title: 'Simulated Payments',
              content: 'Any payment methods, credit card numbers, or transaction histories shown in this app are completely simulated. No real financial transactions ever take place.',
              icon: Icons.credit_card_off_rounded,
            ),
            const SizedBox(height: AppSpacing.space4),
            _buildSection(
              isDark: isDark,
              cardShadow: cardShadow,
              title: 'Data Deletion',
              content: 'You have full control over your data. You can clear your ride history or completely reset the application from the Settings menu at any time.',
              icon: Icons.delete_forever_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required bool isDark,
    required List<BoxShadow> cardShadow,
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: AppSpacing.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.subtitle.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  content,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
