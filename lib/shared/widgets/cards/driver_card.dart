import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../core/theme/ride_flow_tokens.dart';

/// Reusable DriverCard Widget adhering to design.md §10 Card System
class DriverCard extends StatelessWidget {
  final String name;
  final double rating;
  final int totalRides;
  final String vehicleName;
  final String vehicleColor;
  final String vehiclePlate;
  final String otp;
  final Widget avatar;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback? onCancel;

  const DriverCard({
    super.key,
    required this.name,
    required this.rating,
    required this.totalRides,
    required this.vehicleName,
    required this.vehicleColor,
    required this.vehiclePlate,
    required this.otp,
    required this.avatar,
    required this.onCall,
    required this.onMessage,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: tokens.cardShadow,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row: Avatar, Name, Rating, and OTP
          Row(
            children: [
              // 56px Circular Avatar
              SizedBox(
                width: 56,
                height: 56,
                child: ClipOval(child: avatar),
              ),
              const SizedBox(width: 14),

              // Name & Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Rating Chip
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$rating',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          ' ($totalRides rides)',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // OTP Container (design.md §9/§10)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'OTP',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      otp,
                      style: AppTypography.subtitle.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Middle Row: Vehicle Details & Plate Number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicleName,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    'Color: $vehicleColor',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              // License Plate Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Text(
                  vehiclePlate,
                  style: AppTypography.label.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bottom Row: Communications Call/Message Buttons & Cancel trigger
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Call',
                  variant: AppButtonVariant.outlined,
                  icon: Icons.call,
                  onPressed: onCall,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: 'Message',
                  variant: AppButtonVariant.outlined,
                  icon: Icons.message,
                  onPressed: onMessage,
                ),
              ),
            ],
          ),

          if (onCancel != null) ...[
            const SizedBox(height: 8),
            AppButton(
              text: 'Cancel Ride',
              variant: AppButtonVariant.text,
              onPressed: onCancel,
            ),
          ],
        ],
      ),
    );
  }
}
