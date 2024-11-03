import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_controller.dart';
import 'settings_service.dart';

/// A provider that supplies an instance of SettingsController
final settingsControllerProvider =
    ChangeNotifierProvider<SettingsController>((ref) {
  final settingsService = SettingsService();
  final settingsController = SettingsController(settingsService);
  settingsController.loadSettings();
  return settingsController;
});
