import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';

/// Manual fare input field (PRD §FR-HOME-005)
/// Accepts ₹1–₹99,999 with numeric keyboard and rupee prefix
class FareInputField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const FareInputField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<FareInputField> createState() => _FareInputFieldState();
}

class _FareInputFieldState extends State<FareInputField> {
  late TextEditingController _controller;
  String? _errorText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant FareInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String value) {
    if (value.isEmpty) return null;
    final amount = int.tryParse(value);
    if (amount == null) return 'Enter a valid number';
    if (amount < 1) return 'Minimum fare is ₹1';
    if (amount > 99999) return 'Maximum fare is ₹99,999';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Enter Your Fare (₹)',
          style: AppTypography.label.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: AppSpacing.space2),
        Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(
                color: hasError
                    ? AppColors.error
                    : _isFocused
                        ? AppColors.primary
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: _isFocused || hasError ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                // Rupee prefix
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space4,
                      vertical: AppSpacing.space4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.input - 1),
                      bottomLeft: Radius.circular(AppRadius.input - 1),
                    ),
                  ),
                  child: Text(
                    '₹',
                    style: AppTypography.subtitle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Amount input
                Expanded(
                  child: Semantics(
                    label: 'Manual Fare Entry',
                    hint: 'Enter your proposed fare in rupees',
                    textField: true,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                      style: AppTypography.title.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: AppTypography.title.copyWith(
                          color: isDark
                              ? AppColors.textDisabledDark
                              : AppColors.textDisabledLight,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space4,
                            vertical: AppSpacing.space4),
                      ),
                      onChanged: (value) {
                        setState(() => _errorText = _validate(value));
                        widget.onChanged(value);
                      },
                    ),
                  ),
                ),
                // Clear button
                if (_controller.text.isNotEmpty)
                  Semantics(
                    label: 'Clear fare amount',
                    button: true,
                    child: IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _errorText = null);
                        widget.onChanged('');
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.space1),
          Text(
            _errorText!,
            style: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ],
        if (!hasError && _controller.text.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.space1),
          Text(
            'Fare will be paid to driver on completion',
            style: AppTypography.caption.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }
}
