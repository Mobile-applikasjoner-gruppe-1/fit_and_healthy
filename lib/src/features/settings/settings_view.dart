import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:fit_and_healthy/src/features/settings/pages/gdpr_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/pages/goals_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/pages/profile_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/settings_appbar.dart';
import 'package:fit_and_healthy/src/features/settings/settings_controller.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  static const route = '/settings';
  static const routeName = 'Settings';

  //final SettingsController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider).value;

    return NestedScaffold(
      appBar: SettingsAppBar,
      body: Column(
        children: [
          Column(
            children: [
              ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  context.pushNamed(ProfileSettingsPage.routeName);
                },
              ),
              ListTile(
                title: Text('Widgets'),
                leading: Icon(Icons.widgets),
                onTap: () {
                  context.pushNamed(ProfileSettingsPage.routeName);
                },
              ),
              ListTile(
                title: Text('Goals'),
                leading: Icon(Icons.star),
                onTap: () {
                  context.pushNamed(GoalsSettingsPage.routeName);
                },
              ),
              ListTile(
                title: Text('GDPR'),
                leading: Icon(Icons.document_scanner),
                onTap: () {
                  context.pushNamed(GdprSettingsPage.routeName);
                },
              ),
              ListTile(
                title: Text('Sign Out'),
                leading: Icon(Icons.logout),
                onTap: () {
                  ref.read(authControllerProvider.notifier).signOut();
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
