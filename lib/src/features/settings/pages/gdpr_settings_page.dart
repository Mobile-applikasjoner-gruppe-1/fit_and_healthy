import 'package:fit_and_healthy/src/features/settings/pages/privacy_gdpr_policy_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/pages/profile_settings_page.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GdprSettingsPage extends StatelessWidget {
  const GdprSettingsPage({super.key});

  static const route = '/gdpr';
  static const routeName = 'GDPR Settings';

  @override
  Widget build(BuildContext context) {
    return NestedScaffold(
      appBar: AppBar(
        title: const Text("GDPR"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Update Information'),
            subtitle: const Text('Edit your personal details.'),
            onTap: () {
              context.pushNamed(ProfileSettingsPage.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download Your Data'),
            subtitle: const Text('Get a copy of all your personal data.'),
            onTap: () {
              _showConfirmationDialog(
                context,
                title: 'Download Data',
                content: 'Are you sure you want to download your data?',
                onConfirm: _downloadData,
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                _showConfirmationDialog(
                  context,
                  title: 'Delete Account',
                  content:
                      'Are you sure you want to delete your account? This action cannot be undone.',
                  onConfirm: _deleteAccount,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delete Your Account',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Our GDPR Policies'),
            subtitle:
                const Text('Learn more about our data handling practices.'),
            onTap: () {
              context.pushNamed(PrivacyGdprPolicySettingsPage.routeName);
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.background,
          title: Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            content,
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Placeholder: Download Data Action
  void _downloadData() {
    debugPrint("User data download initiated.");
  }

  // Placeholder: Delete Account Action
  void _deleteAccount() {
    debugPrint("User account deletion initiated.");
  }
}
