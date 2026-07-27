import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/ride_flow_tokens.dart';
import '../../../domain/entities/vehicle.dart';

/// Horizontal scrollable vehicle selection list (PRD §FR-HOME-004)
class VehicleSelectionList extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Vehicle? selectedVehicle;
  final void Function(Vehicle) onVehicleSelected;

  const VehicleSelectionList({
    super.key,
    required this.vehicles,
    this.selectedVehicle,
    required this.onVehicleSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (vehicles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
          child: Text(
            'Choose a ride',
            style: AppTypography.subtitle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space3),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space4),
            itemCount: vehicles.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.space3),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final isSelected = vehicle.id == selectedVehicle?.id;
              return _VehicleChip(
                vehicle: vehicle,
                isSelected: isSelected,
                onTap: () => onVehicleSelected(vehicle),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VehicleChip extends StatelessWidget {
  final Vehicle vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleChip({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _vehicleIcon {
    switch (vehicle.id) {
      case 'bike':
        return Icons.two_wheeler_rounded;
      case 'auto':
        return Icons.electric_rickshaw_rounded;
      case 'cab':
      default:
        return Icons.local_taxi_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = Theme.of(context).extension<RideFlowTokens>()!;

    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: '${vehicle.name} vehicle, capacity ${vehicle.capacity}',
        onTapHint: 'Select this vehicle type',
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 100,
            padding: const EdgeInsets.all(AppSpacing.space3),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? AppColors.secondaryContainerDark
                      : AppColors.primaryLight)
                  : (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceLight),
              borderRadius: BorderRadius.circular(AppRadius.vehicleCard),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: isSelected
                  ? tokens.vehicleCardSelectedShadow
                  : tokens.cardShadow,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.15)
                          : (isDark
                              ? AppColors.surfaceVariantDark
                              : AppColors.surfaceVariantLight),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _vehicleIcon,
                      color: isSelected
                          ? AppColors.onPrimary
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  vehicle.name,
                  style: AppTypography.caption.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight)
                        : (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_rounded,
                        size: 9,
                        color: isDark
                            ? AppColors.textDisabledDark
                            : AppColors.textDisabledLight),
                    const SizedBox(width: 2),
                    Text(
                      vehicle.capacity,
                      style: AppTypography.caption.copyWith(
                        fontSize: 9,
                        color: isDark
                            ? AppColors.textDisabledDark
                            : AppColors.textDisabledLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
