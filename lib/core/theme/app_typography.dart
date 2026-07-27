import 'package:flutter/material.dart';

/// Global typography system scale (design.md §3)
abstract class AppTypography {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.w700,
    height: 48 / 40,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
    letterSpacing: 0,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: 0,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    letterSpacing: 0,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.1,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    height: 14 / 11,
    letterSpacing: 0.2,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    height: 20 / 15,
    letterSpacing: 0.1,
  );
}
