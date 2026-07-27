import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../providers/ride_provider.dart';

/// Bottom sheet for driver rating (PRD §14.18)
class RatingSheet extends ConsumerStatefulWidget {
  const RatingSheet({super.key});

  @override
  ConsumerState<RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends ConsumerState<RatingSheet> {
  int _rating = 0;
  bool _isSubmitting = false;

  void _submitRating() async {
    if (_rating == 0) return;
    
    setState(() => _isSubmitting = true);
    final success = await ref.read(rideViewModelProvider.notifier).submitRating(_rating.toDouble(), null);
    
    if (mounted && success) {
      final ride = ref.read(rideViewModelProvider).currentRide;
      if (ride != null) {
        await ref.read(rideViewModelProvider.notifier).saveAndConfirmRide(ride);
      }
      if (mounted) context.go('/home');
    } else if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  void _skip() async {
    final ride = ref.read(rideViewModelProvider).currentRide;
    if (ride != null) {
      await ref.read(rideViewModelProvider.notifier).saveAndConfirmRide(ride);
    }
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rideViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;
    
    if (state.currentRide?.driver == null) return const SizedBox.shrink();
    
    final driver = state.currentRide!.driver!;

    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.space4,
        left: AppSpacing.space4,
        right: AppSpacing.space4,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        boxShadow: tokens.bottomSheetShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space5),
          
          Text(
            'Rate your ride',
            style: AppTypography.title.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.space5),
          
          // Driver Avatar
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Icon(Icons.person_rounded, color: AppColors.accent, size: 48),
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'How was your trip with ${driver.name}?',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.space6),

          // Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: AppColors.warning,
                    size: 40,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.space6),
          
          AppButton(
            text: 'Submit Rating',
            isLoading: _isSubmitting,
            onPressed: _rating > 0 && !_isSubmitting ? _submitRating : null,
          ),
          const SizedBox(height: AppSpacing.space3),
          
          AppButton(
            text: 'Skip',
            variant: AppButtonVariant.text,
            onPressed: _skip,
          ),
        ],
      ),
    );
  }
}
