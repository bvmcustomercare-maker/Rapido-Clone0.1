import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/place.dart';

/// Horizontally scrollable list of recent places (PRD §FR-HOME-003)
class RecentPlacesList extends StatelessWidget {
  final List<Place> places;
  final void Function(Place) onPlaceTap;
  final void Function(Place) onFavouriteTap;

  const RecentPlacesList({
    super.key,
    required this.places,
    required this.onPlaceTap,
    required this.onFavouriteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
          child: Text(
            'Recent Places',
            style: AppTypography.label.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space2),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
            itemCount: places.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.space3),
            itemBuilder: (context, index) {
              final place = places[index];
              return _RecentPlaceChip(
                place: place,
                isDark: isDark,
                onTap: () => onPlaceTap(place),
                onFavouriteTap: () => onFavouriteTap(place),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentPlaceChip extends StatelessWidget {
  final Place place;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;

  const _RecentPlaceChip({
    required this.place,
    required this.isDark,
    required this.onTap,
    required this.onFavouriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        button: true,
        label: '${place.name}, ${place.address}',
        onTapHint: 'Select this recent place',
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 140,
            padding: const EdgeInsets.all(AppSpacing.space3),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    const Spacer(),
                    Semantics(
                      button: true,
                      label: place.isFavourite ? 'Remove from favourites' : 'Add to favourites',
                      child: GestureDetector(
                        onTap: onFavouriteTap,
                        child: Icon(
                          place.isFavourite ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 16,
                          color: place.isFavourite
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.textDisabledDark
                                  : AppColors.textDisabledLight),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  place.name,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  place.address,
                  style: AppTypography.caption.copyWith(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
