import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Reusable AppInput Text Field adhering strictly to design.md §9 Input System
class AppInput extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isDisabled;
  final String? errorText;
  final bool isSuccess;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const AppInput({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isDisabled = false,
    this.errorText,
    this.isSuccess = false,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    // 300ms total shake time (design.md §9 / §15)
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // ±4px, 3 cycles (sine wave over 3 cycles: 3 * 2 * pi)
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.linear),
    );
  }

  @override
  void didUpdateWidget(covariant AppInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If error text is newly set, trigger shake animation
    if (widget.errorText != null && oldWidget.errorText == null) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.errorText != null;

    // Resolve border styling depending on active states
    InputBorder border;
    if (widget.isDisabled) {
      border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide.none,
      );
    } else if (hasError) {
      border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      );
    } else if (widget.isSuccess) {
      border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.success, width: 2),
      );
    } else {
      border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      );
    }

    Widget inputField = TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      enabled: !widget.isDisabled,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      style: AppTypography.bodyLarge.copyWith(
        color: widget.isDisabled
            ? (isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight)
            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
        ),
        filled: true,
        fillColor: widget.isDisabled
            ? (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight)
            : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix ?? _buildDefaultSuffix(hasError, widget.isSuccess),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: border,
        enabledBorder: border,
        focusedBorder: widget.isDisabled
            ? border
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
        disabledBorder: border,
      ),
    );

    // Apply translation shake effect if error occurs
    Widget animatedInput = AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        // Compute offset using a sine wave over 3 cycles
        final offset = sin(_shakeAnimation.value * 3 * 2 * pi) * 4.0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: inputField,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTypography.label.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 6),
        ],
        animatedInput,
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget? _buildDefaultSuffix(bool hasError, bool isSuccess) {
    if (hasError) {
      return const Icon(Icons.error_outline_rounded, color: AppColors.error);
    }
    if (isSuccess) {
      return const Icon(Icons.check_circle_outline_rounded, color: AppColors.success);
    }
    return null;
  }
}
