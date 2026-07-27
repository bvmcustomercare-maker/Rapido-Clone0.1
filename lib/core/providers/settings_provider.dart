import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../utils/logger.dart';

class SettingsState {
  final ThemeMode themeMode;
  final String language;
  final bool notificationsEnabled;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.language = 'English',
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? language,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class SettingsViewModel extends StateNotifier<SettingsState> {
  final Box _settingsBox;

  SettingsViewModel(this._settingsBox) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    try {
      final themeIndex = _settingsBox.get('themeMode', defaultValue: ThemeMode.system.index) as int;
      final language = _settingsBox.get('language', defaultValue: 'English') as String;
      final notifs = _settingsBox.get('notificationsEnabled', defaultValue: true) as bool;

      state = state.copyWith(
        themeMode: ThemeMode.values[themeIndex],
        language: language,
        notificationsEnabled: notifs,
      );
    } catch (e) {
      AppLogger.e('Error loading settings', e);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _settingsBox.put('themeMode', mode.index);
  }

  Future<void> setLanguage(String lang) async {
    state = state.copyWith(language: lang);
    await _settingsBox.put('language', lang);
  }

  Future<void> toggleNotifications() async {
    final newValue = !state.notificationsEnabled;
    state = state.copyWith(notificationsEnabled: newValue);
    await _settingsBox.put('notificationsEnabled', newValue);
  }
}

final settingsProvider = StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
  final box = Hive.box('settings');
  return SettingsViewModel(box);
});
