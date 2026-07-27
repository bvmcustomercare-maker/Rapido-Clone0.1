import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../../history/presentation/viewmodels/ride_history_viewmodel.dart';
import '../../ride/domain/entities/ride.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardShadow = Theme.of(context).extension<RideFlowTokens>()!.cardShadow;
    
    final historyState = ref.watch(rideHistoryViewModelProvider);
    final rides = historyState.allRides;

    final totalRides = rides.length;
    final totalSpent = rides.fold(0.0, (sum, ride) => sum + (double.tryParse(ride.fare) ?? 0.0));
    // Simulate distance as 4km per ride
    final simulatedDistance = totalRides * 4.2; 
    
    // Find favorite payment method
    String favoritePayment = 'None';
    if (rides.isNotEmpty) {
      final paymentCounts = <String, int>{};
      for (var r in rides) {
        paymentCounts[r.paymentMethod] = (paymentCounts[r.paymentMethod] ?? 0) + 1;
      }
      favoritePayment = paymentCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Header Info ────────────────────────────────
            Text(
              'Your Activity',
              style: AppTypography.h3.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              'Simulated statistics based on your ride history.',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.space6),

            // ─── Grid Stats ──────────────────────────────────
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.space4,
              crossAxisSpacing: AppSpacing.space4,
              childAspectRatio: 1.1,
              children: [
                _buildStatCard(
                  title: 'Total Rides',
                  value: totalRides.toDouble(),
                  prefix: '',
                  suffix: '',
                  icon: Icons.directions_car_rounded,
                  color: AppColors.primary,
                  isDark: isDark,
                  cardShadow: cardShadow,
                  isInteger: true,
                ),
                _buildStatCard(
                  title: 'Total Spent',
                  value: totalSpent,
                  prefix: '₹',
                  suffix: '',
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.success,
                  isDark: isDark,
                  cardShadow: cardShadow,
                ),
                _buildStatCard(
                  title: 'Distance',
                  value: simulatedDistance,
                  prefix: '',
                  suffix: ' km',
                  icon: Icons.map_rounded,
                  color: AppColors.info,
                  isDark: isDark,
                  cardShadow: cardShadow,
                ),
                _buildTextStatCard(
                  title: 'Top Payment',
                  value: favoritePayment,
                  icon: Icons.star_rounded,
                  color: AppColors.warning,
                  isDark: isDark,
                  cardShadow: cardShadow,
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.space8),
            // Mock Chart Section
            Container(
              padding: const EdgeInsets.all(AppSpacing.space4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: AppTypography.subtitle.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (index) {
                        final val = (index * 13 + 7) % 50 + 10.0;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedBuilder(
                              animation: _anim,
                              builder: (context, child) {
                                return Container(
                                  width: 24,
                                  height: (val * _anim.value).clamp(0, 100),
                                  decoration: BoxDecoration(
                                    color: index == 6 ? AppColors.primary : (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ['M','T','W','T','F','S','S'][index],
                              style: AppTypography.caption.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required double value,
    required String prefix,
    required String suffix,
    required IconData icon,
    required Color color,
    required bool isDark,
    required List<BoxShadow> cardShadow,
    bool isInteger = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.space2),
          AnimatedBuilder(
            animation: _anim,
            builder: (context, child) {
              final currentVal = value * _anim.value;
              final displayStr = isInteger ? currentVal.toInt().toString() : currentVal.toStringAsFixed(1);
              return Text(
                '$prefix$displayStr$suffix',
                style: AppTypography.h3.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
    required List<BoxShadow> cardShadow,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.space2),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
