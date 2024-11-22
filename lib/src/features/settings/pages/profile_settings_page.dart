import 'package:fit_and_healthy/src/features/settings/settings_controller.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/src/common/styles/sizes.dart';

final genderProvider = StateProvider<Gender>((ref) => Gender.male);
final heightProvider = StateProvider<String>((ref) => '170 cm');

enum Gender { male, female }

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  static const route = '/profile';
  static const routeName = 'Profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider).value;

    final selectedGender = ref.watch(genderProvider);
    final height = ref.watch(heightProvider);

    final theme = Theme.of(context);

    return NestedScaffold(
      appBar: AppBar(
        title: const Text("Profile"),
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
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(Sizes.s200),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: const Icon(
                        Icons.person,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: Sizes.s200),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          'user@example.com',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Sizes.s300),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.s200),
              ),
              elevation: Sizes.s25,
              child: Column(
                children: [
                  _buildThemeSwitcher(
                    context,
                    themeMode: settingsState!.themeMode,
                    ref: ref,
                  ),
                  _buildDivider(),
                  _buildEditableGenderField(
                    context,
                    ref,
                    selectedGender: selectedGender,
                  ),
                  _buildDivider(),
                  _buildEditableHeightField(
                    context,
                    ref,
                    height: height,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSwitcher(
    BuildContext context, {
    required ThemeMode themeMode,
    required WidgetRef ref,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.color_lens, color: theme.colorScheme.primary),
      title: const Text('Theme'),
      trailing: DropdownButton<ThemeMode>(
        value: themeMode,
        onChanged:
            ref.read(settingsControllerProvider.notifier).updateThemeMode,
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
    );
  }

  Widget _buildEditableGenderField(
    BuildContext context,
    WidgetRef ref, {
    required Gender selectedGender,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.person, color: theme.colorScheme.primary),
      title: const Text('Gender'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedGender == Gender.male ? 'Male' : 'Female',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Sizes.s100),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        _showGenderEditDialog(
          context,
          ref,
          selectedGender: selectedGender,
        );
      },
    );
  }

  Widget _buildEditableHeightField(
    BuildContext context,
    WidgetRef ref, {
    required String height,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.height, color: theme.colorScheme.primary),
      title: const Text('Height'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            height,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Sizes.s100),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        _showHeightEditDialog(
          context,
          ref,
          height: height,
        );
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1);
  }

  void _showGenderEditDialog(
    BuildContext context,
    WidgetRef ref, {
    required Gender selectedGender,
  }) {
    final genderNotifier = ref.read(genderProvider.notifier);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: Gender.values.map((gender) {
              return RadioListTile<Gender>(
                title: Text(gender == Gender.male ? 'Male' : 'Female'),
                value: gender,
                groupValue: selectedGender,
                onChanged: (newGender) {
                  if (newGender != null) {
                    genderNotifier.state = newGender;
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showHeightEditDialog(
    BuildContext context,
    WidgetRef ref, {
    required String height,
  }) {
    final heightNotifier = ref.read(heightProvider.notifier);
    final TextEditingController controller =
        TextEditingController(text: height.replaceAll(' cm', ''));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Height'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              border: OutlineInputBorder(),
            ),
            // TODO: Add input validation
            // TODO: Add save on keyboard done(?)
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final int? newHeight = int.tryParse(controller.text);
                if (newHeight != null) {
                  heightNotifier.state = '$newHeight cm';
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
