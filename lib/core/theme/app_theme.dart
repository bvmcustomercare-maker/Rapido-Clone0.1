import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'ride_flow_tokens.dart';

/// AppTheme configuration for Material 3 Light/Dark modes (ENGINEERING_GUIDE.md Task 1.1)
abstract class AppTheme {
  static final ColorScheme lightColorScheme = const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondary,
    onSecondary: AppColors.surfaceLight,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerHighest: AppColors.surfaceVariantLight,
    error: AppColors.error,
    onError: AppColors.surfaceLight,
    outline: AppColors.borderLight,
  );

  static final ColorScheme darkColorScheme = const ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryDark,
    secondary: AppColors.textPrimaryDark,
    onSecondary: AppColors.secondary,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerHighest: AppColors.surfaceVariantDark,
    error: AppColors.error,
    onError: AppColors.surfaceLight,
    outline: AppColors.borderDark,
  );

  // Spacial Elevation Shadows per design.md §7
  static const List<BoxShadow> _cardShadowLight = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, 1), blurRadius: 3),
  ];
  static const List<BoxShadow> _vehicleCardSelectedShadowLight = [
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 12),
  ];
  static const List<BoxShadow> _dialogShadowLight = [
    BoxShadow(color: Color(0x29000000), offset: Offset(0, 8), blurRadius: 24),
  ];
  static const List<BoxShadow> _bottomSheetShadowLight = [
    BoxShadow(color: Color(0x1F000000), offset: Offset(0, -4), blurRadius: 20),
  ];
  static const List<BoxShadow> _fabShadowLight = [
    BoxShadow(color: Color(0x24000000), offset: Offset(0, 4), blurRadius: 10),
  ];
  static const List<BoxShadow> _snackbarShadowLight = [
    BoxShadow(color: Color(0x2E000000), offset: Offset(0, 6), blurRadius: 16),
  ];
  static const List<BoxShadow> _liveRideCardShadowLight = [
    BoxShadow(color: Color(0x1F000000), offset: Offset(0, 4), blurRadius: 14),
  ];
  static const List<BoxShadow> _bottomNavBarShadowLight = [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, -1), blurRadius: 6),
  ];

  // Dark Mode Shadows (Reduced opacity, overlay preferred)
  static const List<BoxShadow> _cardShadowDark = [
    BoxShadow(color: Color(0x1F000000), offset: Offset(0, 1), blurRadius: 3),
  ];
  static const List<BoxShadow> _vehicleCardSelectedShadowDark = [
    BoxShadow(color: Color(0x33000000), offset: Offset(0, 4), blurRadius: 12),
  ];
  static const List<BoxShadow> _dialogShadowDark = [
    BoxShadow(color: Color(0x40000000), offset: Offset(0, 8), blurRadius: 24),
  ];
  static const List<BoxShadow> _bottomSheetShadowDark = [
    BoxShadow(color: Color(0x33000000), offset: Offset(0, -4), blurRadius: 20),
  ];
  static const List<BoxShadow> _fabShadowDark = [
    BoxShadow(color: Color(0x3B000000), offset: Offset(0, 4), blurRadius: 10),
  ];
  static const List<BoxShadow> _snackbarShadowDark = [
    BoxShadow(color: Color(0x47000000), offset: Offset(0, 6), blurRadius: 16),
  ];
  static const List<BoxShadow> _liveRideCardShadowDark = [
    BoxShadow(color: Color(0x33000000), offset: Offset(0, 4), blurRadius: 14),
  ];
  static const List<BoxShadow> _bottomNavBarShadowDark = [
    BoxShadow(color: Color(0x24000000), offset: Offset(0, -1), blurRadius: 6),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      extensions: const [
        RideFlowTokens(
          success: AppColors.success,
          warning: AppColors.warning,
          info: AppColors.info,
          routePolyline: AppColors.routePolyline,
          pickupPin: AppColors.pickupPin,
          dropPin: AppColors.dropPin,
          cardShadow: _cardShadowLight,
          vehicleCardSelectedShadow: _vehicleCardSelectedShadowLight,
          dialogShadow: _dialogShadowLight,
          bottomSheetShadow: _bottomSheetShadowLight,
          fabShadow: _fabShadowLight,
          snackbarShadow: _snackbarShadowLight,
          liveRideCardShadow: _liveRideCardShadowLight,
          bottomNavBarShadow: _bottomNavBarShadowLight,
        ),
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
        titleTextStyle: AppTypography.title,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      extensions: const [
        RideFlowTokens(
          success: AppColors.success,
          warning: AppColors.warning,
          info: AppColors.info,
          routePolyline: AppColors.routePolyline,
          pickupPin: AppColors.pickupPin,
          dropPin: AppColors.dropPin,
          cardShadow: _cardShadowDark,
          vehicleCardSelectedShadow: _vehicleCardSelectedShadowDark,
          dialogShadow: _dialogShadowDark,
          bottomSheetShadow: _bottomSheetShadowDark,
          fabShadow: _fabShadowDark,
          snackbarShadow: _snackbarShadowDark,
          liveRideCardShadow: _liveRideCardShadowDark,
          bottomNavBarShadow: _bottomNavBarShadowDark,
        ),
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: AppTypography.title,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
