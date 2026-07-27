import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/inputs/app_input.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final String phone;

  const SignupScreen({super.key, required this.phone});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _nameError;
  String? _emailError;
  bool _isLoading = false;

  void _onSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    bool isValid = true;

    if (name.isEmpty) {
      setState(() {
        _nameError = 'Name is required';
      });
      isValid = false;
    } else {
      setState(() {
        _nameError = null;
      });
    }

    if (email.isNotEmpty && !Validators.isValidEmail(email)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
      isValid = false;
    } else {
      setState(() {
        _emailError = null;
      });
    }

    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    final result = await ref.read(authProvider.notifier).signup(
          name: name,
          phone: widget.phone,
          email: email.isEmpty ? null : email,
        );

    result.fold(
      (user) {
        setState(() {
          _isLoading = false;
        });
        // Clear backstack and go home
        context.go(RoutePaths.home);
      },
      (failure) {
        setState(() {
          _isLoading = false;
          _nameError = failure.message;
        });
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Profile Setup'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Create Your Profile',
                style: AppTypography.heading.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please provide your details to complete setup',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),

              const SizedBox(height: 36),

              // Full Name Input
              AppInput(
                labelText: 'Full Name',
                hintText: 'Enter your name',
                controller: _nameController,
                errorText: _nameError,
              ),

              const SizedBox(height: 20),

              // Email Input (Optional)
              AppInput(
                labelText: 'Email Address (Optional)',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),

              const Spacer(),

              // Submit Setup CTA
              AppButton(
                text: 'Complete Setup',
                isLoading: _isLoading,
                onPressed: _onSignup,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
