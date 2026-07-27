import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../ride/presentation/providers/ride_provider.dart';
import '../../../../shared/widgets/buttons/app_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showDeleteHistoryDialog(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text('Delete History', style: AppTypography.h3.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        content: Text('Are you sure you want to permanently delete all your ride history? This action cannot be undone.',
            style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        actions: [
          AppButton(
            text: 'Cancel',
            variant: AppButtonVariant.text,
            isFullWidth: false,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          AppButton(
            text: 'Delete',
            variant: AppButtonVariant.danger,
            isFullWidth: false,
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Hive.box('rides').clear();
              // Trigger a refresh of the history provider so UI updates
              ref.invalidate(rideHistoryViewModelProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ride history deleted successfully.'), backgroundColor: AppColors.success),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showResetAppDialog(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text('Reset Application', style: AppTypography.h3.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        content: Text('Are you sure you want to completely wipe the simulator data? This will clear all local storage and sign you out.',
            style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        actions: [
          AppButton(
            text: 'Cancel',
            variant: AppButtonVariant.text,
            isFullWidth: false,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          AppButton(
            text: 'Reset',
            variant: AppButtonVariant.danger,
            isFullWidth: false,
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Hive.box('settings').clear();
              await Hive.box('sessions').clear();
              await Hive.box('users').clear();
              await Hive.box('places').clear();
              await Hive.box('rides').clear();
              
              ref.read(authProvider.notifier).logout();
              context.go('/onboarding');
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text('Logout', style: AppTypography.h3.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        content: Text('Are you sure you want to log out?',
            style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        actions: [
          AppButton(
            text: 'Cancel',
            variant: AppButtonVariant.text,
            isFullWidth: false,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          AppButton(
            text: 'Logout',
            variant: AppButtonVariant.primary,
            isFullWidth: false,
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardShadow = Theme.of(context).extension<RideFlowTokens>()!.cardShadow;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        children: [
          // ─── App Preferences ─────────────────────────────
          Text(
            'Preferences',
            style: AppTypography.subtitle.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          _buildSettingsCard(
            isDark: isDark,
            cardShadow: cardShadow,
            children: [
              ListTile(
                leading: Icon(Icons.palette_rounded, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                title: Text('Theme', style: AppTypography.bodyLarge.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<ThemeMode>(
                    value: settings.themeMode,
                    dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    items: const [
                      DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                      DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                    ],
                    onChanged: (mode) {
                      if (mode != null) {
                        ref.read(settingsProvider.notifier).setThemeMode(mode);
                      }
                    },
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.language_rounded, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                title: Text('Language', style: AppTypography.bodyLarge.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: settings.language,
                    dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    items: const [
                      DropdownMenuItem(value: 'English', child: Text('English')),
                      DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                      DropdownMenuItem(value: 'French', child: Text('French')),
                    ],
                    onChanged: (lang) {
                      if (lang != null) {
                        ref.read(settingsProvider.notifier).setLanguage(lang);
                      }
                    },
                  ),
                ),
              ),
              const Divider(),
              SwitchListTile(
                activeColor: AppColors.primary,
                secondary: Icon(Icons.notifications_active_rounded, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                title: Text('Notifications', style: AppTypography.bodyLarge.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                value: settings.notificationsEnabled,
                onChanged: (_) {
                  ref.read(settingsProvider.notifier).toggleNotifications();
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),

          // ─── Information ─────────────────────────────
          Text(
            'Information',
            style: AppTypography.subtitle.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          _buildSettingsCard(
            isDark: isDark,
            cardShadow: cardShadow,
            children: [
              ListTile(
                leading: Icon(Icons.info_outline_rounded, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                title: Text('About', style: AppTypography.bodyLarge.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/about'),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                title: Text('Privacy Policy', style: AppTypography.bodyLarge.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/privacy'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),

          // ─── Account Actions ─────────────────────────────
          Text(
            'Account Management',
            style: AppTypography.subtitle.copyWith(
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          _buildSettingsCard(
            isDark: isDark,
            cardShadow: cardShadow,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_sweep_rounded, color: AppColors.error),
                title: Text('Clear Ride History', style: AppTypography.bodyLarge.copyWith(color: AppColors.error)),
                onTap: () => _showDeleteHistoryDialog(context, ref, isDark),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.restore_rounded, color: AppColors.error),
                title: Text('Reset Application', style: AppTypography.bodyLarge.copyWith(color: AppColors.error)),
                onTap: () => _showResetAppDialog(context, ref, isDark),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.primary),
                title: Text('Logout', style: AppTypography.bodyLarge.copyWith(color: AppColors.primary)),
                onTap: () => _showLogoutDialog(context, ref, isDark),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space8),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required bool isDark, required List<BoxShadow> cardShadow, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: cardShadow,
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
