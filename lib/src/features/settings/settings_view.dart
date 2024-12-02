import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:fit_and_healthy/src/features/gdpr_policy/gdpr_settings_page.dart';
import 'package:fit_and_healthy/src/features/goals/goals_settings_page.dart';
import 'package:fit_and_healthy/src/features/measurement/measurement_settings_page.dart';
import 'package:fit_and_healthy/src/features/profile/profile_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/settings_appbar.dart';
import 'package:fit_and_healthy/src/features/settings/settings_widget_page.dart';
import 'package:fit_and_healthy/src/features/theme/theme_settings_view.dart';
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
                  context.pushNamed(WidgetSettingsPage.routeName);
                },
              ),
              ListTile(
                title: Text('Measurment'),
                leading: Icon(Icons.monitor_weight_rounded),
                onTap: () {
                  context.pushNamed(MeasurementSettingsPage.routeName);
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
                title: Text('Theme'),
                leading: Icon(Icons.color_lens),
                onTap: () {
                  context.pushNamed(ThemeSettingsPage.routeName);
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
        ],
      ),
    );
  }
}
