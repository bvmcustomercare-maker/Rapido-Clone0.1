import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/storage/hive_provider.dart';
import '../../infrastructure/storage/shared_prefs_provider.dart';
import '../utils/logger.dart';

/// Abstract storage service defining baseline read/write actions (teck-stack.md §2.5)
abstract class StorageService {
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<void> setBool(String key, bool value);
  bool? getBool(String key);
  Future<void> remove(String key);
  Future<void> clearAll();
}

/// SharedPreferences implementation of StorageService (mainly for raw key-value prefs)
class SharedPreferencesServiceImpl implements StorageService {
  final SharedPreferences _prefs;

  SharedPreferencesServiceImpl(this._prefs);

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

/// Hive implementation of StorageService (mainly for structured settings)
class HiveStorageServiceImpl implements StorageService {
  final Box _box;

  HiveStorageServiceImpl(this._box);

  @override
  Future<void> setString(String key, String value) async {
    await _box.put(key, value);
  }

  @override
  String? getString(String key) {
    final val = _box.get(key);
    return val is String ? val : null;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _box.put(key, value);
  }

  @override
  bool? getBool(String key) {
    final val = _box.get(key);
    return val is bool ? val : null;
  }

  @override
  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
}

/// Provider exposing SharedPreferences-based storage service
final sharedPrefsStorageProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesServiceImpl(prefs);
});

/// Provider exposing Hive-based settings storage service
final hiveStorageProvider = Provider<StorageService>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return HiveStorageServiceImpl(box);
});
