import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/inputs/app_input.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  void _onLogin() async {
    final phone = _phoneController.text.trim();
    if (!Validators.isValidPhone(phone)) {
      setState(() {
        _errorText = 'Please enter a valid 10-digit mobile number';
      });
      return;
    }

    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    final result = await ref.read(authProvider.notifier).login(phone);
    result.fold(
      (success) {
        setState(() {
          _isLoading = false;
        });
        context.push('${RoutePaths.otp}?phone=$phone');
      },
      (failure) {
        setState(() {
          _isLoading = false;
          _errorText = failure.message;
        });
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // Logo lockup
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_car_filled_rounded,
                  size: 28,
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to ${AppConstants.appName}',
                style: AppTypography.heading.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your phone number to continue',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),

              const SizedBox(height: 36),

              // Phone Number Input
              AppInput(
                labelText: 'Phone Number',
                hintText: 'Enter 10-digit number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                errorText: _errorText,
                prefix: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '+91 ',
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Send OTP CTA
              AppButton(
                text: 'Send OTP',
                isLoading: _isLoading,
                onPressed: _onLogin,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
