import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  danger,
  success,
}

/// Reusable AppButton Widget adhering strictly to design.md §8 Button System
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // 100ms press animation (design.md §8 / §15)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      // 120ms release bounce (design.md §8)
      _controller.animateTo(0.0, duration: const Duration(milliseconds: 120), curve: Curves.easeOutBack);
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enabled = widget.onPressed != null && !widget.isLoading;

    // Define colors & dimensions based on state/variant
    Color backgroundColor;
    Color textColor;
    double height = 56.0;
    double radius = AppRadius.button;
    Border? border;

    if (!enabled) {
      backgroundColor = AppColors.disabled;
      textColor = AppColors.onDisabledLight;
    } else {
      switch (widget.variant) {
        case AppButtonVariant.primary:
          backgroundColor = AppColors.primary;
          textColor = AppColors.onPrimary;
          break;
        case AppButtonVariant.secondary:
          backgroundColor = isDark ? AppColors.textPrimaryDark : AppColors.secondary;
          textColor = isDark ? AppColors.secondary : AppColors.surfaceLight;
          break;
        case AppButtonVariant.outlined:
          backgroundColor = Colors.transparent;
          textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
          height = 52.0;
          border = Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.5,
          );
          break;
        case AppButtonVariant.text:
          backgroundColor = Colors.transparent;
          textColor = AppColors.primaryDark;
          height = 44.0;
          radius = 8.0;
          break;
        case AppButtonVariant.danger:
          backgroundColor = AppColors.error;
          textColor = Colors.white;
          break;
        case AppButtonVariant.success:
          backgroundColor = AppColors.success;
          textColor = Colors.white;
          break;
      }
    }

    // Apply loading opacity
    if (widget.isLoading) {
      backgroundColor = backgroundColor.withOpacity(0.8);
    }

    Widget child = Container(
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      child: widget.isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: AppTypography.button.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );

    if (widget.isFullWidth) {
      child = SizedBox(width: double.infinity, child: child);
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: enabled ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      ),
    );
  }
}
