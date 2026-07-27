import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../providers/ride_provider.dart';

/// Overlay for live ride tracking (PRD §14.15)
class LiveTrackingOverlay extends ConsumerWidget {
  const LiveTrackingOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rideViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;
    
    if (state.currentRide == null) return const SizedBox.shrink();

    final etaSeconds = state.remainingEtaSeconds;
    final etaText = etaSeconds < 60 ? 'Almost there' : '${(etaSeconds / 60).ceil()} min left';

    return Container(
      margin: const EdgeInsets.all(AppSpacing.space4),
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: tokens.cardShadow,
      ),
      child: Row(
        children: [
          // Simulated progress indicator (determinate or animated)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.navigation_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etaText,
                  style: AppTypography.title.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Heading to ${state.currentRide!.destination.name}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Share trip button
          IconButton(
            icon: Icon(Icons.share_rounded, color: AppColors.accent),
            onPressed: () {}, // Simulated share
          ),
        ],
      ),
    );
  }
}
