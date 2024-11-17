import 'package:fit_and_healthy/src/features/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_service.dart';

part 'settings_controller.g.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
///
@riverpod
class SettingsController extends _$SettingsController {
  SettingsController();

  // Make SettingsService a private variable so it is not used directly.
  late SettingsService _settingsService;

  @override
  FutureOr<SettingsState> build() async {
    _settingsService = SettingsService();
    return await loadSettings();
  }

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<SettingsState> loadSettings() async {
    final _themeMode = await _settingsService.themeMode();

    final temp = SettingsState(themeMode: _themeMode);
    return temp;
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    final previousState = await future;
    final _themeMode = previousState.themeMode;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    state = AsyncData(previousState.copyWith(themeMode: newThemeMode));

    // Persist the changes to a local database or the internet using the
    // SettingService.
    // TODO: Consider updating the service and returning the new state first. And then using that returned state to update the UI.
    await _settingsService.updateThemeMode(newThemeMode);
  }
}
