import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/src/features/settings/settings_controller.dart';
import 'package:fit_and_healthy/src/common/styles/sizes.dart';

/// This page allows users to customize the theme of the app. Users can select
/// between system, light, and dark theme modes. The settings are managed using
/// the `SettingsController`.
class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({Key? key}) : super(key: key);

  static const route = '/theme-settings';
  static const routeName = 'Theme Settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider).value;
    final theme = Theme.of(context);

    if (settingsState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.s200, vertical: Sizes.s300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.s200),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(Sizes.s200),
                child: ListTile(
                  leading: Icon(
                    Icons.color_lens,
                    color: theme.colorScheme.primary,
                    size: Sizes.s300,
                  ),
                  title: const Text(
                    'App Theme',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.s200,
                    ),
                  ),
                  subtitle: const Text(
                    'Choose your preferred theme',
                    style: TextStyle(fontSize: Sizes.s200),
                  ),
                  trailing: DropdownButton<ThemeMode>(
                    value: settingsState.themeMode,
                    onChanged: ref
                        .read(settingsControllerProvider.notifier)
                        .updateThemeMode,
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
