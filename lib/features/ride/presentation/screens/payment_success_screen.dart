import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../providers/ride_provider.dart';
import 'rating_sheet.dart';

/// Screen for processing and confirming simulated payment (PRD §14.17)
class PaymentSuccessScreen extends ConsumerStatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  ConsumerState<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

enum PaymentStep { select, processing, success, error }

class _PaymentSuccessScreenState extends ConsumerState<PaymentSuccessScreen> {
  PaymentStep _step = PaymentStep.select;
  String _selectedMethod = 'UPI';
  
  final List<String> _methods = ['UPI', 'Card', 'Wallet', 'Cash'];

  Future<void> _processPayment() async {
    setState(() {
      _step = PaymentStep.processing;
    });
    
    // Update the ride with the selected method
    final state = ref.read(rideViewModelProvider);
    if (state.currentRide != null) {
      final updatedRide = state.currentRide!.copyWith(paymentMethod: _selectedMethod);
      ref.read(rideViewModelProvider.notifier).initializeRide(updatedRide);
    }
    
    final success = await ref.read(rideViewModelProvider.notifier).processPayment();
    
    if (mounted) {
      setState(() {
        _step = success ? PaymentStep.success : PaymentStep.error;
      });
    }
  }

  void _showRatingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RatingSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rideViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (state.currentRide == null) return const Scaffold();
    
    final ride = state.currentRide!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _step == PaymentStep.select ? AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ) : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space4),
          child: _buildContent(ride, isDark),
        ),
      ),
    );
  }
  
  Widget _buildContent(ride, bool isDark) {
    switch (_step) {
      case PaymentStep.select:
        return _buildSelection(ride, isDark);
      case PaymentStep.processing:
        return _buildProcessing(ride, isDark);
      case PaymentStep.success:
        return _buildSuccess(ride, isDark);
      case PaymentStep.error:
        return _buildError(isDark);
    }
  }

  Widget _buildSelection(ride, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Amount to Pay',
          style: AppTypography.subtitle.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space2),
        Text(
          '₹${ride.fare}',
          style: AppTypography.h1.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space6),
        Text(
          'Select Payment Method',
          style: AppTypography.title.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.space3),
        ..._methods.map((method) => _buildMethodCard(method, isDark)),
        const Spacer(),
        AppButton(
          text: 'Pay ₹${ride.fare}',
          onPressed: _processPayment,
        ),
      ],
    );
  }

  Widget _buildMethodCard(String method, bool isDark) {
    final isSelected = _selectedMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.space3),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _getIconForMethod(method),
              color: isSelected ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(width: AppSpacing.space3),
            Text(
              method,
              style: AppTypography.bodyLarge.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: AppColors.primary)
            else
              Icon(Icons.circle_outlined, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ],
        ),
      ),
    );
  }
  
  IconData _getIconForMethod(String method) {
    switch (method) {
      case 'Cash': return Icons.money_rounded;
      case 'UPI': return Icons.qr_code_scanner_rounded;
      case 'Card': return Icons.credit_card_rounded;
      case 'Wallet': return Icons.account_balance_wallet_rounded;
      default: return Icons.payment_rounded;
    }
  }

  Widget _buildProcessing(ride, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.space5),
        Text(
          'Processing ${ride.paymentMethod} Payment...',
          style: AppTypography.title.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuccess(ride, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        // Success Animation / Icon
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_rounded, color: AppColors.success, size: 72),
          ),
        ),
        const SizedBox(height: AppSpacing.space6),
        
        Text(
          'Payment Successful',
          style: AppTypography.h2.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space3),
        
        // Receipt Card
        Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.space4),
          padding: const EdgeInsets.all(AppSpacing.space4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            children: [
              _buildReceiptRow('Amount Paid', '₹${ride.fare}', isDark, isBold: true),
              const Divider(height: 24),
              _buildReceiptRow('Payment Method', ride.paymentMethod, isDark),
              const SizedBox(height: 12),
              _buildReceiptRow('Transaction ID', 'TXN${DateTime.now().millisecondsSinceEpoch}', isDark),
              const SizedBox(height: 12),
              _buildReceiptRow('Date & Time', '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}', isDark),
            ],
          ),
        ),
        
        const Spacer(),
        
        AppButton(
          text: 'Rate your driver',
          onPressed: _showRatingSheet,
        ),
      ],
    );
  }
  
  Widget _buildReceiptRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: isBold 
            ? AppTypography.title.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
            : AppTypography.bodyLarge.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        ),
      ],
    );
  }

  Widget _buildError(bool isDark) {
    final state = ref.watch(rideViewModelProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_rounded, color: AppColors.error, size: 72),
        const SizedBox(height: AppSpacing.space4),
        Text(
          'Payment Failed',
          style: AppTypography.title.copyWith(color: AppColors.error),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space2),
        Text(
          state.errorMessage ?? 'Unknown error',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space4),
        AppButton(
          text: 'Try Again',
          variant: AppButtonVariant.secondary,
          isFullWidth: false,
          onPressed: () {
            setState(() {
              _step = PaymentStep.select;
            });
          },
        ),
      ],
    );
  }
}
