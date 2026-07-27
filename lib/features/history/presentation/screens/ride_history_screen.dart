import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../../../../shared/widgets/feedback/app_skeleton.dart';
import '../../../../shared/widgets/feedback/app_empty_state.dart';
import '../../ride/domain/entities/ride.dart';
import '../../ride/domain/enums/ride_status.dart';
import '../../ride/presentation/providers/ride_provider.dart';
import '../../../../shared/widgets/buttons/app_button.dart';

class RideHistoryScreen extends ConsumerWidget {
  const RideHistoryScreen({super.key});

  void _confirmDelete(BuildContext context, WidgetRef ref, Ride ride, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(
          'Delete Ride',
          style: AppTypography.h3.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        content: Text(
          'Are you sure you want to permanently delete this ride from your history?',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          AppButton(
            text: 'Cancel',
            variant: AppButtonVariant.text,
            isFullWidth: false,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          AppButton(
            text: 'Delete',
            variant: AppButtonVariant.danger,
            isFullWidth: false,
            onPressed: () {
              ref.read(rideHistoryViewModelProvider.notifier).deleteRide(ride.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ride deleted successfully'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rideHistoryViewModelProvider);
    final viewModel = ref.read(rideHistoryViewModelProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardShadow = Theme.of(context).extension<RideFlowTokens>()!.cardShadow;
    
    final displayedRides = viewModel.filteredAndSortedRides;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Ride History'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      ),
      body: state.isLoading 
        ? _buildLoadingSkeleton(isDark)
        : Column(
            children: [
              // ─── Statistics Header ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppSpacing.space4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  boxShadow: cardShadow,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Rides',
                        '${state.totalRides}',
                        Icons.directions_car_rounded,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: _buildStatCard(
                        'Total Spent',
                        '₹${state.totalSpent.toStringAsFixed(0)}',
                        Icons.account_balance_wallet_rounded,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ),
              
              // ─── Search & Filters ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: TextEditingController(text: state.searchQuery)..selection = TextSelection.fromPosition(TextPosition(offset: state.searchQuery.length)),
                      onChanged: viewModel.setSearchQuery,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by location...',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
                        filled: true,
                        fillColor: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    
                    // Filter Row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: state.selectedStatusFilter,
                                isExpanded: true,
                                icon: Icon(Icons.filter_list_rounded, color: AppColors.primary, size: 20),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                                dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                                items: ['All', 'Completed', 'Cancelled'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) viewModel.setStatusFilter(value);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space3),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: state.selectedSortOption,
                                isExpanded: true,
                                icon: Icon(Icons.sort_rounded, color: AppColors.primary, size: 20),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                                dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                                items: [
                                  'Date (Newest)', 
                                  'Date (Oldest)', 
                                  'Fare (High to Low)', 
                                  'Fare (Low to High)'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value.split(' ')[0], 
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) viewModel.setSortOption(value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ─── List ───────────────────────────────────────────────────
              Expanded(
                child: displayedRides.isEmpty
                  ? AppEmptyState(
                      title: 'No Rides Found',
                      subtitle: 'You have not taken any rides yet, or none match your filters.',
                      icon: Icons.directions_car_filled_outlined,
                      isDark: isDark,
                      actionLabel: state.searchQuery.isNotEmpty || state.selectedStatusFilter != 'All' ? 'Clear Filters' : null,
                      onAction: state.searchQuery.isNotEmpty || state.selectedStatusFilter != 'All'
                          ? () {
                              viewModel.setSearchQuery('');
                              viewModel.setStatusFilter('All');
                            }
                          : null,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
                      itemCount: displayedRides.length,
                      itemBuilder: (context, index) {
                        final ride = displayedRides[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 400 + (index * 100).clamp(0, 400)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: Dismissible(
                            key: Key(ride.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              _confirmDelete(context, ref, ride, isDark);
                              return false; // Wait for dialog confirmation
                            },
                            background: Container(
                              margin: const EdgeInsets.only(bottom: AppSpacing.space3),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete_rounded, color: Colors.white),
                            ),
                            child: _buildRideCard(context, ref, ride, isDark, cardShadow),
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideCard(BuildContext context, WidgetRef ref, Ride ride, bool isDark) {
    final dateStr = DateFormat('MMM d, yyyy • h:mm a').format(ride.createdAt);
    
    return GestureDetector(
      onTap: () {
        ref.read(rideViewModelProvider.notifier).initializeRide(ride);
        context.push('/ride-summary');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.space3),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: AppTypography.caption.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ride.status == RideStatus.completed 
                        ? AppColors.success.withOpacity(0.2) 
                        : (ride.status == RideStatus.cancelled
                            ? AppColors.error.withOpacity(0.2)
                            : AppColors.accent.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ride.status.name.toUpperCase(),
                    style: AppTypography.caption.copyWith(
                      color: ride.status == RideStatus.completed 
                          ? AppColors.success 
                          : (ride.status == RideStatus.cancelled 
                              ? AppColors.error 
                              : AppColors.accent),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(Icons.circle, size: 12, color: AppColors.accent),
                    Container(height: 20, width: 2, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    Icon(Icons.location_on, size: 16, color: AppColors.error),
                  ],
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.pickup.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.space3),
                      Text(
                        ride.destination.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${ride.fare}',
                      style: AppTypography.title.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          ride.paymentMethod == 'Cash' ? Icons.money_rounded : Icons.payment_rounded, 
                          size: 14, 
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ride.paymentMethod,
                          style: AppTypography.caption.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.space4),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.space3),
          padding: const EdgeInsets.all(AppSpacing.space4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: Theme.of(context).extension<RideFlowTokens>()!.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppSkeleton(width: 120, height: 20, isDark: isDark),
                  AppSkeleton(width: 60, height: 24, borderRadius: 12, isDark: isDark),
                ],
              ),
              const SizedBox(height: AppSpacing.space3),
              Row(
                children: [
                  const Icon(Icons.circle, size: 12, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(child: AppSkeleton(width: double.infinity, height: 16, isDark: isDark)),
                ],
              ),
              const SizedBox(height: AppSpacing.space2),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 12, color: AppColors.error),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(child: AppSkeleton(width: double.infinity, height: 16, isDark: isDark)),
                ],
              ),
              const SizedBox(height: AppSpacing.space3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppSkeleton(width: 80, height: 16, isDark: isDark),
                  AppSkeleton(width: 60, height: 16, isDark: isDark),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
