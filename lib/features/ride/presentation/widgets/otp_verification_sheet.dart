import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../providers/ride_provider.dart';

class OtpVerificationSheet extends ConsumerStatefulWidget {
  const OtpVerificationSheet({super.key});

  @override
  ConsumerState<OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends ConsumerState<OtpVerificationSheet> {
  final _otpController = TextEditingController();
  bool _hasError = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    final success = await ref.read(rideViewModelProvider.notifier).verifyOtp(_otpController.text);
    if (!success && mounted) {
      setState(() {
        _hasError = true;
      });
    }
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
        top: 0,
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
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
            ),
            alignment: Alignment.center,
            child: Text(
              'Driver Arrived',
              style: AppTypography.label.copyWith(color: AppColors.onPrimary),
            ),
          ),
          
          const SizedBox(height: AppSpacing.space2),
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
          const SizedBox(height: AppSpacing.space4),

          Text(
            'Enter OTP to Start Ride',
            style: AppTypography.title.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Your driver ${driver.name} is waiting at the pickup location.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.space5),
          
          // OTP Input
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 4,
            style: AppTypography.title.copyWith(letterSpacing: 8, fontSize: 24),
            decoration: InputDecoration(
              hintText: '----',
              errorText: _hasError ? 'Invalid OTP. Please try again.' : null,
              filled: true,
              fillColor: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              counterText: '',
            ),
            onChanged: (val) {
              if (_hasError) setState(() => _hasError = false);
              if (val.length == 4) {
                _verifyOtp();
              }
            },
          ),
          const SizedBox(height: AppSpacing.space5),

          // Actions
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Cancel Ride',
                  variant: AppButtonVariant.outlined,
                  onPressed: () {
                    ref.read(rideViewModelProvider.notifier).cancelRide();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: AppButton(
                  text: 'Verify',
                  variant: AppButtonVariant.primary,
                  onPressed: _verifyOtp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
