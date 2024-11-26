import 'package:fit_and_healthy/shared/widgets/fields/height_editor.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
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
  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsControllerProvider).value;
    final metricsState = ref.watch(metricsControllerProvider);
    final theme = Theme.of(context);

    final height = metricsState.asData?.value['height'].toInt() ?? 170;
    final gender = metricsState.asData?.value['gender'] ?? Gender.male;
    final birthday = metricsState.asData?.value['birthday'];

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
                  _buildEditableGenderField(context, ref, gender),
                  _buildDivider(),
                  _buildEditableHeightField(context, ref, height),
                  _buildDivider(),
                  _buildEditableBirthdayField(context, ref, birthday),
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
    WidgetRef ref,
    Gender gender,
  ) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.person, color: theme.colorScheme.primary),
      title: const Text('Gender'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            gender == Gender.male ? 'Male' : 'Female',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Sizes.s100),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        _showGenderEditDialog(context, ref, gender);
      },
    );
  }

  Widget _buildEditableHeightField(
    BuildContext contex,
    WidgetRef ref,
    int height,
  ) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.height, color: theme.colorScheme.primary),
      title: const Text('Height'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            height.toString(),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Sizes.s100),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () async {
        //_showHeightEditDialog(context, ref, height);
        final newHeight = await HeightEditor.showDialogForHeight(
          context,
          height.toDouble(),
        );
        if (newHeight != null) {
          await ref
              .read(metricsControllerProvider.notifier)
              .updateHeight(newHeight);
        }
      },
    );
  }

  Widget _buildEditableBirthdayField(
      BuildContext context, WidgetRef ref, DateTime? birthday) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.cake, color: theme.colorScheme.primary),
      title: const Text('Birthday'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            birthday != null
                ? '${birthday.day}/${birthday.month}/${birthday.year}'
                : 'Set Birthday',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Sizes.s100),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        _showBirthdayEditDialog(context, ref, birthday);
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1);
  }

  void _showGenderEditDialog(
    BuildContext context,
    WidgetRef ref,
    Gender currentGender,
  ) {
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
                groupValue: currentGender,
                onChanged: (newGender) async {
                  if (newGender != null) {
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

  void _showBirthdayEditDialog(
      BuildContext context, WidgetRef ref, DateTime? birthday) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Birthday'),
          content: ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: birthday ?? DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
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
