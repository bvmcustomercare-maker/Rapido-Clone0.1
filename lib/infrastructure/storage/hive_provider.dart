import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/utils/logger.dart';

/// Riverpod provider to configure and manage the lifecycle of Hive (teck-stack.md §2.5)
final hiveInitProvider = FutureProvider<void>((ref) async {
  AppLogger.i('Initializing Hive database storage engine...');
  await Hive.initFlutter();
  
  // Open baseline Hive boxes for settings & local sessions
  await Hive.openBox('settings');
  await Hive.openBox('sessions');
  AppLogger.i('Hive database storage engine initialized successfully.');
});

/// Riverpod provider wrapper to retrieve settings Hive box instance
final settingsBoxProvider = Provider<Box>((ref) {
  return Hive.box('settings');
});

/// Riverpod provider wrapper to retrieve sessions Hive box instance
final sessionsBoxProvider = Provider<Box>((ref) {
  return Hive.box('sessions');
});
