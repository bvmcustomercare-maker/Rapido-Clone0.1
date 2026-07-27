import 'package:flutter/material.dart';

/// Global color constants for RideFlow (design.md §2/§17)
abstract class AppColors {
  // Brand Palette (Mobility Yellow / Near Black / White)
  static const Color primary = Color(0xFFFFD400); // Mobility Yellow
  static const Color primaryDark = Color(0xFFD4A800);
  static const Color primaryLight = Color(0xFFFFF3B0);
  static const Color onPrimary = Color(0xFF1A1A1A); // Near-black text on yellow

  static const Color secondary = Color(0xFF1A1A1A);
  static const Color secondaryContainerLight = Color(0xFFEDEDED);
  static const Color secondaryContainerDark = Color(0xFF2C2C2C);

  static const Color accent = Color(0xFF2F6FED);
  static const Color success = Color(0xFF1AE86F);
  static const Color warning = Color(0xFFF2A900);
  static const Color error = Color(0xFFE5484D);
  static const Color info = Color(0xFF2F6FED);

  // Surfaces - Light Mode
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF7F7F7);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color dividerLight = Color(0xFFE3E3E3);
  static const Color borderLight = Color(0xFFDDDDDD);

  // Surfaces - Dark Mode
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);
  static const Color backgroundDark = Color(0xFF0B0B0B);
  static const Color dividerDark = Color(0xFF2A2A2A);
  static const Color borderDark = Color(0xFF333333);

  // Text Hierarchy - Light Mode
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF707070);
  static const Color textDisabledLight = Color(0xFF8A8A8A);

  // Text Hierarchy - Dark Mode
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFA0A0A0);
  static const Color textDisabledDark = Color(0xFF6B6B6B);

  // Map Markers & Polylines
  static const Color routePolyline = Color(0xFFFFD400);
  static const Color pickupPin = Color(0xFF1AE86F);
  static const Color dropPin = Color(0xFFE5484D);
  static const Color driverPin = Color(0xFFFFD400);
}
