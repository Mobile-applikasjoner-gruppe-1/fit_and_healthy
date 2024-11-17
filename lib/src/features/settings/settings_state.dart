import 'package:flutter/material.dart';

class SettingsState {
  final ThemeMode themeMode;
  // Add other settings here

  SettingsState({
    required this.themeMode,
    // Initialize other settings here
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    // Add other settings here
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      // Update other settings here
    );
  }
}
