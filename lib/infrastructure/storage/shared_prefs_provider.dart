import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/logger.dart';

/// Riverpod provider to configure and manage the lifecycle of SharedPreferences (teck-stack.md §2.5)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized in bootstrap/main.dart yet.');
});
