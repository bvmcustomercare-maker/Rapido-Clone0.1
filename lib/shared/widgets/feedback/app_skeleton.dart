import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class AppSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isDark;

  const AppSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    required this.isDark,
  });

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    final baseColor = widget.isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight;
    final highlightColor = widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    _colorAnimation = ColorTween(
      begin: baseColor,
      end: highlightColor,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AppSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark != widget.isDark) {
      final baseColor = widget.isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight;
      final highlightColor = widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

      _colorAnimation = ColorTween(
        begin: baseColor,
        end: highlightColor,
      ).animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
