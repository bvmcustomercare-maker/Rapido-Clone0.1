import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/logger.dart';
import 'features/auth/data/models/user_dto.dart';
import 'features/home/data/models/place_dto.dart';
import 'features/ride/data/models/driver_dto.dart';
import 'features/ride/data/models/ride_dto.dart';
import 'infrastructure/storage/shared_prefs_provider.dart';

/// Class containing bootstrap results to inject into the App root (teck-stack.md §4)
class BootstrapResult {
  final List<Override> overrides;
  BootstrapResult({required this.overrides});
}

/// Global Application Bootstrap Orchestrator (teck-stack.md §4)
Future<BootstrapResult> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.i('Starting RideFlow bootstrap flow...');

  // 1. Initialize SharedPreferences
  AppLogger.i('Initializing SharedPreferences...');
  final sharedPrefs = await SharedPreferences.getInstance();
  AppLogger.i('SharedPreferences initialized.');

  // 2. Initialize Hive
  AppLogger.i('Initializing Hive...');
  await Hive.initFlutter();
  Hive.registerAdapter(UserDtoAdapter());
  Hive.registerAdapter(PlaceDtoAdapter());
  Hive.registerAdapter(DriverDtoAdapter());
  Hive.registerAdapter(RideDtoAdapter());
  await Hive.openBox('settings');
  await Hive.openBox('sessions');
  await Hive.openBox<UserDto>('users');
  await Hive.openBox<PlaceDto>('places');
  await Hive.openBox<RideDto>('rides');
  AppLogger.i('Hive database initialized.');

  // 3. Define Dependency Injection Overrides
  final overrides = [
    sharedPreferencesProvider.overrideWithValue(sharedPrefs),
  ];

  // Set up Global Flutter Error catchers
  FlutterError.onError = (details) {
    AppLogger.e('Unhandled Flutter Error caught by bootstrap: ${details.exceptionAsString()}', details.exception, details.stack);
  };

  AppLogger.i('RideFlow bootstrap flow completed successfully.');
  return BootstrapResult(overrides: overrides);
}
