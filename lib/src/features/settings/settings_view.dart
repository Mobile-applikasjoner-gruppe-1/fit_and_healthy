import 'package:fit_and_healthy/src/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  //final SettingsController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider).value;

    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  context.push('/settings/profile');
                },
              ),
              ListTile(
                title: Text('Widgets'),
                leading: Icon(Icons.widgets),
                onTap: () {
                  context.push('/settings/widget');
                },
              ),
              ListTile(
                title: Text('Goals'),
                leading: Icon(Icons.star),
                onTap: () {
                  context.push('/settings/goals');
                },
              ),
              ListTile(
                title: Text('GDPR'),
                leading: Icon(Icons.document_scanner),
                onTap: () {
                  context.push('/settings/gdpr');
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            child: DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: settingsState!.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged:
                  ref.read(settingsControllerProvider.notifier).updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
