import 'package:flutter/material.dart';
import '../theme/ride_flow_tokens.dart';

/// Convenient BuildContext extensions to read themes and dimensions quickly
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  /// Quick accessor to customized RideFlow custom tokens (design.md §18.9)
  RideFlowTokens get tokens => theme.extension<RideFlowTokens>()!;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
