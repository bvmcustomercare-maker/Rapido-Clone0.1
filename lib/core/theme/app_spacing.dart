import 'package:flutter/material.dart';

/// Global 8-point grid spacing and radius tokens (design.md §5/§6)
abstract class AppSpacing {
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
}

abstract class AppRadius {
  static const double button = 16.0;
  static const double buttonPill = 28.0;
  static const double card = 20.0;
  static const double vehicleCard = 24.0;
  static const double sheet = 28.0;
  static const double dialog = 24.0;
  static const double input = 14.0;
  static const double avatar = 9999.0;
  static const double chip = 9999.0;
}
