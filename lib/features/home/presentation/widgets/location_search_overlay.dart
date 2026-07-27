import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/place.dart';

/// Simulated location data for the offline demo (PRD §FR-LOC-001)
class SimulatedLocations {
  static const List<Place> presets = [
    Place(id: 'loc_001', name: 'Connaught Place', address: 'Connaught Place, New Delhi, Delhi 110001', latitude: 28.6315, longitude: 77.2167),
    Place(id: 'loc_002', name: 'India Gate', address: 'Rajpath, India Gate, New Delhi, Delhi 110001', latitude: 28.6129, longitude: 77.2295),
    Place(id: 'loc_003', name: 'Lotus Temple', address: 'Lotus Temple Rd, Bahapur, New Delhi, Delhi 110019', latitude: 28.5535, longitude: 77.2588),
    Place(id: 'loc_004', name: 'Red Fort', address: 'Netaji Subhash Marg, Lal Qila, Chandni Chowk, New Delhi, Delhi 110006', latitude: 28.6562, longitude: 77.2410),
    Place(id: 'loc_005', name: 'Humayun\'s Tomb', address: 'Mathura Rd, Hazrat Nizamuddin, New Delhi, Delhi 110013', latitude: 28.5933, longitude: 77.2507),
    Place(id: 'loc_006', name: 'Qutub Minar', address: 'Mehrauli, New Delhi, Delhi 110030', latitude: 28.5245, longitude: 77.1855),
    Place(id: 'loc_007', name: 'Hauz Khas Village', address: 'Hauz Khas, New Delhi, Delhi 110016', latitude: 28.5494, longitude: 77.2001),
    Place(id: 'loc_008', name: 'Sarojini Nagar Market', address: 'Sarojini Nagar, New Delhi, Delhi 110023', latitude: 28.5742, longitude: 77.1965),
    Place(id: 'loc_009', name: 'Cyber Hub', address: 'DLF Cyber Hub, Gurugram, Haryana 122002', latitude: 28.4943, longitude: 77.0886),
    Place(id: 'loc_010', name: 'IGI Airport Terminal 3', address: 'NH 48, New Delhi, Delhi 110037', latitude: 28.5562, longitude: 77.1000),
    Place(id: 'loc_011', name: 'Lajpat Nagar Market', address: 'Lajpat Nagar II, New Delhi, Delhi 110024', latitude: 28.5678, longitude: 77.2430),
    Place(id: 'loc_012', name: 'Khan Market', address: 'Khan Market, New Delhi, Delhi 110003', latitude: 28.6000, longitude: 77.2267),
    Place(id: 'loc_013', name: 'DLF Mall of India', address: 'Sector 18, Noida, Uttar Pradesh 201301', latitude: 28.5675, longitude: 77.3211),
    Place(id: 'loc_014', name: 'Select Citywalk', address: 'A-3, District Centre, Saket, New Delhi, Delhi 110017', latitude: 28.5274, longitude: 77.2159),
    Place(id: 'loc_015', name: 'New Delhi Railway Station', address: 'Bhavbhuti Marg, Paharganj, New Delhi, Delhi 110055', latitude: 28.6419, longitude: 77.2194),
  ];
}

/// Full-screen location search overlay widget (PRD §FR-LOC-001/FR-LOC-002)
class LocationSearchOverlay extends StatefulWidget {
  final String title;
  final List<Place> recentPlaces;
  final List<Place> favouritePlaces;
  final void Function(Place) onPlaceSelected;

  const LocationSearchOverlay({
    super.key,
    required this.title,
    required this.recentPlaces,
    required this.favouritePlaces,
    required this.onPlaceSelected,
  });

  @override
  State<LocationSearchOverlay> createState() => _LocationSearchOverlayState();
}

class _LocationSearchOverlayState extends State<LocationSearchOverlay>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  List<Place> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchResults = SimulatedLocations.presets
            .where((p) =>
                p.name.toLowerCase().contains(query) ||
                p.address.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space4,
                    vertical: AppSpacing.space3),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.space2),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceVariantDark
                              : AppColors.surfaceVariantLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space4),
                    Text(
                      widget.title,
                      style: AppTypography.title.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Search Input ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space4),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceVariantDark
                        : AppColors.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Semantics(
                    label: 'Search Location',
                    hint: 'Type to search for a place or address',
                    textField: true,
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search for a location...',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textDisabledDark
                              : AppColors.textDisabledLight,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear_rounded,
                                    size: 18,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space4,
                            vertical: AppSpacing.space4),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.space4),

              // ─── Results ───────────────────────────────────────────────
              Expanded(
                child: _isSearching
                    ? _buildSearchResults(isDark)
                    : _buildDefaultSections(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(bool isDark) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_rounded,
                size: 48,
                color: isDark
                    ? AppColors.textDisabledDark
                    : AppColors.textDisabledLight),
            const SizedBox(height: AppSpacing.space3),
            Text(
              'No places found',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: _searchResults.length,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      itemBuilder: (context, index) {
        return _PlaceTile(
          place: _searchResults[index],
          isDark: isDark,
          leadingIcon: Icons.location_on_rounded,
          leadingColor: AppColors.primary,
          onTap: () => widget.onPlaceSelected(_searchResults[index]),
        );
      },
    );
  }

  Widget _buildDefaultSections(bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      children: [
        // ── Favourites ─────────────────────────────────────────────────
        if (widget.favouritePlaces.isNotEmpty) ...[
          _SectionHeader(
            label: 'Saved Places',
            icon: Icons.star_rounded,
            isDark: isDark,
          ),
          ...widget.favouritePlaces.map((place) => _PlaceTile(
                place: place,
                isDark: isDark,
                leadingIcon: Icons.star_rounded,
                leadingColor: AppColors.primary,
                onTap: () => widget.onPlaceSelected(place),
              )),
          const SizedBox(height: AppSpacing.space4),
        ],

        // ── Recents ────────────────────────────────────────────────────
        if (widget.recentPlaces.isNotEmpty) ...[
          _SectionHeader(
            label: 'Recent Places',
            icon: Icons.history_rounded,
            isDark: isDark,
          ),
          ...widget.recentPlaces.map((place) => _PlaceTile(
                place: place,
                isDark: isDark,
                leadingIcon: Icons.history_rounded,
                leadingColor: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                onTap: () => widget.onPlaceSelected(place),
              )),
          const SizedBox(height: AppSpacing.space4),
        ],

        // ── Suggestions ────────────────────────────────────────────────
        _SectionHeader(
          label: 'Suggestions',
          icon: Icons.explore_rounded,
          isDark: isDark,
        ),
        ...SimulatedLocations.presets.take(6).map((place) => _PlaceTile(
              place: place,
              isDark: isDark,
              leadingIcon: Icons.place_rounded,
              leadingColor: AppColors.accent,
              onTap: () => widget.onPlaceSelected(place),
            )),
      ],
    );
  }
}

// ── Internal widgets ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;

  const _SectionHeader({
    required this.label,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight),
          const SizedBox(width: AppSpacing.space2),
          Text(
            label,
            style: AppTypography.label.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceTile extends StatelessWidget {
  final Place place;
  final bool isDark;
  final IconData leadingIcon;
  final Color leadingColor;
  final VoidCallback onTap;

  const _PlaceTile({
    required this.place,
    required this.isDark,
    required this.leadingIcon,
    required this.leadingColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.space3, horizontal: AppSpacing.space2),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: leadingColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(leadingIcon, color: leadingColor, size: 18),
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        place.address,
                        style: AppTypography.caption.copyWith(
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
                Icon(
                  Icons.north_west_rounded,
                  size: 16,
                  color: isDark
                      ? AppColors.textDisabledDark
                      : AppColors.textDisabledLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
