import 'package:fit_and_healthy/src/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final settingsNotifier = ref.read(settingsControllerProvider.notifier);

    final selectedGender = ref.watch(genderProvider);
    final height = ref.watch(heightProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture Placeholder
            CircleAvatar(
              radius: 50,
              child: const Icon(
                Icons.person,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder Name
            Text(
              'User Name',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // Placeholder Email
            Text(
              'user@example.com',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(height: 32),
            // Theme Switcher
            _buildThemeSwitcher(settingsState!.themeMode, settingsNotifier),
            const Divider(height: 32),
            // Update Gender
            _buildEditableGenderField(
              context,
              ref,
              selectedGender: selectedGender,
            ),
            const Divider(height: 32),
            // Update Height
            _buildEditableHeightField(
              context,
              ref,
              height: height,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSwitcher(ThemeMode currentMode, dynamic notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Theme',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        DropdownButton<ThemeMode>(
          value: currentMode,
          onChanged: notifier.updateThemeMode,
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
      ],
    );
  }

  Widget _buildEditableGenderField(
    BuildContext context,
    WidgetRef ref, {
    required Gender selectedGender,
  }) {
    return GestureDetector(
      onTap: () {
        _showGenderEditDialog(
          context,
          ref,
          selectedGender: selectedGender,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Gender',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Text(
                selectedGender == Gender.male ? 'Male' : 'Female',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableHeightField(
    BuildContext context,
    WidgetRef ref, {
    required String height,
  }) {
    return GestureDetector(
      onTap: () {
        _showHeightEditDialog(
          context,
          ref,
          height: height,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Height',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Text(
                height,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }

  // Gender Edit Dialog
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
