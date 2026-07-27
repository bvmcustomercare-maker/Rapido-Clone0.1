import 'package:flutter/material.dart';

/// ThemeExtension to support custom semantic color tokens and shadows (design.md §7/§18.9)
class RideFlowTokens extends ThemeExtension<RideFlowTokens> {
  final Color success;
  final Color warning;
  final Color info;
  final Color routePolyline;
  final Color pickupPin;
  final Color dropPin;

  // Custom Elevation Shadows
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> vehicleCardSelectedShadow;
  final List<BoxShadow> dialogShadow;
  final List<BoxShadow> bottomSheetShadow;
  final List<BoxShadow> fabShadow;
  final List<BoxShadow> snackbarShadow;
  final List<BoxShadow> liveRideCardShadow;
  final List<BoxShadow> bottomNavBarShadow;

  const RideFlowTokens({
    required this.success,
    required this.warning,
    required this.info,
    required this.routePolyline,
    required this.pickupPin,
    required this.dropPin,
    required this.cardShadow,
    required this.vehicleCardSelectedShadow,
    required this.dialogShadow,
    required this.bottomSheetShadow,
    required this.fabShadow,
    required this.snackbarShadow,
    required this.liveRideCardShadow,
    required this.bottomNavBarShadow,
  });

  @override
  RideFlowTokens copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? routePolyline,
    Color? pickupPin,
    Color? dropPin,
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? vehicleCardSelectedShadow,
    List<BoxShadow>? dialogShadow,
    List<BoxShadow>? bottomSheetShadow,
    List<BoxShadow>? fabShadow,
    List<BoxShadow>? snackbarShadow,
    List<BoxShadow>? liveRideCardShadow,
    List<BoxShadow>? bottomNavBarShadow,
  }) {
    return RideFlowTokens(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      routePolyline: routePolyline ?? this.routePolyline,
      pickupPin: pickupPin ?? this.pickupPin,
      dropPin: dropPin ?? this.dropPin,
      cardShadow: cardShadow ?? this.cardShadow,
      vehicleCardSelectedShadow: vehicleCardSelectedShadow ?? this.vehicleCardSelectedShadow,
      dialogShadow: dialogShadow ?? this.dialogShadow,
      bottomSheetShadow: bottomSheetShadow ?? this.bottomSheetShadow,
      fabShadow: fabShadow ?? this.fabShadow,
      snackbarShadow: snackbarShadow ?? this.snackbarShadow,
      liveRideCardShadow: liveRideCardShadow ?? this.liveRideCardShadow,
      bottomNavBarShadow: bottomNavBarShadow ?? this.bottomNavBarShadow,
    );
  }

  @override
  RideFlowTokens lerp(ThemeExtension<RideFlowTokens>? other, double t) {
    if (other is! RideFlowTokens) return this;
    return RideFlowTokens(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      routePolyline: Color.lerp(routePolyline, other.routePolyline, t)!,
      pickupPin: Color.lerp(pickupPin, other.pickupPin, t)!,
      dropPin: Color.lerp(dropPin, other.dropPin, t)!,
      // Linear interpolation of lists of box shadows is complex, so we fallback on t thresholding
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
      vehicleCardSelectedShadow: t < 0.5 ? vehicleCardSelectedShadow : other.vehicleCardSelectedShadow,
      dialogShadow: t < 0.5 ? dialogShadow : other.dialogShadow,
      bottomSheetShadow: t < 0.5 ? bottomSheetShadow : other.bottomSheetShadow,
      fabShadow: t < 0.5 ? fabShadow : other.fabShadow,
      snackbarShadow: t < 0.5 ? snackbarShadow : other.snackbarShadow,
      liveRideCardShadow: t < 0.5 ? liveRideCardShadow : other.liveRideCardShadow,
      bottomNavBarShadow: t < 0.5 ? bottomNavBarShadow : other.bottomNavBarShadow,
    );
  }
}
