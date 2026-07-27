import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardShadow = Theme.of(context).extension<RideFlowTokens>()!.cardShadow;
    final fabShadow = Theme.of(context).extension<RideFlowTokens>()!.fabShadow;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final memberSince = DateFormat('MMMM yyyy').format(user.createdAt);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          children: [
            // ─── Header Card ────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.space5),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(24),
                boxShadow: cardShadow,
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surfaceLight, width: 4),
                        ),
                        child: Center(
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                            style: AppTypography.displayMedium.copyWith(color: AppColors.onPrimary),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/edit-profile'),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceLight,
                            shape: BoxShape.circle,
                            boxShadow: fabShadow,
                          ),
                          child: Icon(Icons.edit_rounded, size: 20, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    user.name.isEmpty ? 'User' : user.name,
                    style: AppTypography.h3.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    user.phone,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  if (user.email != null && user.email!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      user.email!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.space3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Member since $memberSince',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // ─── Quick Links Grid ───────────────────────────────────────────
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.space4,
              crossAxisSpacing: AppSpacing.space4,
              childAspectRatio: 1.2,
              children: [
                _buildGridItem(
                  context: context,
                  title: 'History',
                  icon: Icons.history_rounded,
                  color: AppColors.info,
                  onTap: () => context.push('/history'),
                  isDark: isDark,
                  cardShadow: cardShadow,
                ),
                _buildGridItem(
                  context: context,
                  title: 'Statistics',
                  icon: Icons.bar_chart_rounded,
                  color: AppColors.success,
                  onTap: () => context.push('/statistics'),
                  isDark: isDark,
                  cardShadow: cardShadow,
                ),
                _buildGridItem(
                  context: context,
                  title: 'Payment',
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.warning,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment settings coming soon')),
                  ),
                  isDark: isDark,
                  cardShadow: cardShadow,
                ),
                _buildGridItem(
                  context: context,
                  title: 'Settings',
                  icon: Icons.settings_rounded,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  onTap: () => context.push('/settings'),
                  isDark: isDark,
                  cardShadow: cardShadow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
    required List<BoxShadow> cardShadow,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: AppSpacing.space3),
            Text(
              title,
              style: AppTypography.subtitle.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
