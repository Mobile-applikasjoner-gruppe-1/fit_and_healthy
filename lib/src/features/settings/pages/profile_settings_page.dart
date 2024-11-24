import 'package:fit_and_healthy/src/features/settings/metrics_controller.dart';
import 'package:fit_and_healthy/src/features/settings/settings_controller.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';

class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({super.key});

  static const route = '/profile';
  static const routeName = 'Profile';

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  String _height = '170 cm'; // Default height
  Gender _gender = Gender.male; // Default gender
  DateTime? _birthday; // Null by default

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final metricsController = ref.read(metricsControllerProvider.notifier);

    final height = await metricsController.getHeight();
    final gender = await metricsController.getGender();
    final birthday = await metricsController.getBirthday();

    setState(() {
      _height = '${height.toInt()} cm'; // Ensure height is a string with "cm"
      _gender = gender ?? Gender.male; // Default to Gender.male if null
      _birthday = birthday; // Default to null
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsControllerProvider).value;
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
                  _buildEditableGenderField(context),
                  _buildDivider(),
                  _buildEditableHeightField(context),
                  _buildDivider(),
                  _buildEditableBirthdayField(context),
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

  Widget _buildEditableGenderField(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.person, color: theme.colorScheme.primary),
      title: const Text('Gender'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _gender == Gender.male ? 'Male' : 'Female',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Sizes.s100),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        _showGenderEditDialog(context);
      },
    );
  }

  Widget _buildEditableHeightField(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.height, color: theme.colorScheme.primary),
      title: const Text('Height'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _height,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Sizes.s100),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        _showHeightEditDialog(context);
      },
    );
  }

  Widget _buildEditableBirthdayField(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.cake, color: theme.colorScheme.primary),
      title: const Text('Birthday'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _birthday != null
                ? '${_birthday!.day}/${_birthday!.month}/${_birthday!.year}'
                : 'Set Birthday',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Sizes.s100),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        _showBirthdayEditDialog(context);
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1);
  }

  void _showGenderEditDialog(BuildContext context) {
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
                groupValue: _gender,
                onChanged: (newGender) async {
                  if (newGender != null) {
                    setState(() {
                      _gender = newGender;
                    });
                    await ref
                        .read(metricsControllerProvider.notifier)
                        .updateGender(newGender);
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

  void _showHeightEditDialog(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: _height.replaceAll(' cm', ''));

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
              onPressed: () async {
                final int? newHeight = int.tryParse(controller.text);
                if (newHeight != null) {
                  setState(() {
                    _height = '$newHeight cm';
                  });
                  await ref
                      .read(metricsControllerProvider.notifier)
                      .updateHeight(newHeight.toDouble());
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

  void _showBirthdayEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Birthday'),
          content: ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _birthday ?? DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  _birthday = selectedDate;
                });
                await ref
                    .read(metricsControllerProvider.notifier)
                    .setBirthday(selectedDate);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Select Birthday'),
          ),
        );
      },
    );
  }
}
