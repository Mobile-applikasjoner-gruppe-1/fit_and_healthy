import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/gdpr_policy/privacy_gdpr_policy_settings_page.dart';
import 'package:fit_and_healthy/src/features/profile/profile_settings_page.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// This page provides users with GDPR-related settings, including:
/// - Updating personal information
/// - Downloading user data
/// - Deleting the user account
/// - Viewing GDPR policies
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
      body: Padding(
        padding: const EdgeInsets.all(Sizes.s200),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.s200),
          ),
          elevation: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildListTile(
                context,
                icon: Icons.person,
                title: 'Update Information',
                onTap: () {
                  context.pushNamed(ProfileSettingsPage.routeName);
                },
              ),
              const Divider(height: 1, thickness: 1),
              _buildListTile(
                context,
                icon: Icons.download,
                title: 'Download Your Data',
                onTap: () {
                  _showConfirmationDialog(
                    context,
                    title: 'Download Data',
                    content: 'Are you sure you want to download your data?',
                    onConfirm: _downloadData,
                  );
                },
              ),
              const Divider(height: 1, thickness: 1),
              _buildDeleteAccountTile(context),
              const Divider(height: 1, thickness: 1),
              _buildListTile(
                context,
                icon: Icons.info_outline,
                title: 'Our GDPR Policies',
                onTap: () {
                  context.pushNamed(PrivacyGdprPolicySettingsPage.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a common ListTile widget for GDPR options.
  ///
  /// Parameters:
  /// - [context]: Build context.
  /// - [icon]: Icon to display in the leading position.
  /// - [title]: Title of the option.
  /// - [subtitle]: Optional subtitle for additional context.
  /// - [onTap]: Action to perform when the tile is tapped.
  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: subtitle != null
          ? Text(subtitle, style: theme.textTheme.bodyMedium)
          : null,
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface),
      onTap: onTap,
    );
  }

  /// Builds the delete account tile with a confirmation dialog.
  Widget _buildDeleteAccountTile(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.delete, color: theme.colorScheme.error),
      title: Text(
        'Delete Your Account',
        style: TextStyle(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.error),
      onTap: () {
        _showConfirmationDialog(
          context,
          title: 'Delete Account',
          content:
              'Are you sure you want to delete your account? This action cannot be undone.',
          onConfirm: _deleteAccount,
        );
      },
    );
  }

  /// Displays a confirmation dialog for sensitive actions.
  ///
  /// Parameters:
  /// - [context]: Build context.
  /// - [title]: Title of the dialog.
  /// - [content]: Content of the dialog explaining the action.
  /// - [onConfirm]: Action to perform when the user confirms.
  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              isDestructiveAction: true,
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  /// Placeholder for the download data action.
  void _downloadData() {
    debugPrint("User data download initiated.");
  }

  /// Placeholder for the delete account action.
  void _deleteAccount() {
    debugPrint("User account deletion initiated.");
  }
}
