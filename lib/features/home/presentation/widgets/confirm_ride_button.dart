import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';

/// Animated confirm ride button (PRD §FR-HOME-006)
class ConfirmRideButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback? onTap;

  const ConfirmRideButton({
    super.key,
    required this.isEnabled,
    this.onTap,
  });

  @override
  State<ConfirmRideButton> createState() => _ConfirmRideButtonState();
}

class _ConfirmRideButtonState extends State<ConfirmRideButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _pressController;
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (widget.isEnabled) _pressController.reverse();
  }

  void _onTapUp(_) {
    if (widget.isEnabled) {
      _pressController.forward();
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    _pressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: widget.isEnabled,
      label: 'Confirm Ride',
      onTapHint: 'Confirm the selected ride',
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: widget.isEnabled
                  ? AppColors.primary
                  : (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.surfaceVariantDark
                      : AppColors.surfaceVariantLight),
              borderRadius: BorderRadius.circular(AppRadius.buttonPill),
              boxShadow: widget.isEnabled
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.directions_car_rounded,
                    color: widget.isEnabled
                        ? AppColors.onPrimary
                        : (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textDisabledDark
                            : AppColors.textDisabledLight),
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.space2),
                  Text(
                    'Confirm Ride',
                    style: AppTypography.button.copyWith(
                      color: widget.isEnabled
                          ? AppColors.onPrimary
                          : (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textDisabledDark
                              : AppColors.textDisabledLight),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
