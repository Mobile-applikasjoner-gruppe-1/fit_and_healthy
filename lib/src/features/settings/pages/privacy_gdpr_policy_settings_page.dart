import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';

class PrivacyGdprPolicySettingsPage extends StatelessWidget {
  const PrivacyGdprPolicySettingsPage({super.key});

  static const route = '/privacypolicy';
  static const routeName = 'Privacy Policy';

  @override
  Widget build(BuildContext context) {
    return NestedScaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy & GDPR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We are committed to protecting your privacy. This application collects only the '
              'necessary data to ensure functionality. Here are the key points of our policy:\n\n'
              '- Your personal data is stored securely and used solely for app purposes.\n'
              '- You can request a copy of your data at any time.\n'
              '- You can delete your account, which will remove all stored data permanently.\n'
              '- We do not share your data with third parties without your consent.\n\n'
              'For further details, please contact uss.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'GDPR Compliance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our application is fully compliant with GDPR standards. Here’s how we ensure compliance:\n\n'
              '- You have the right to access your data and know how it is used.\n'
              '- You have the right to delete your data permanently.\n'
              '- Data processing is limited to what is necessary for app functionality.\n'
              '- We implement robust security measures to safeguard your information.\n\n'
              'For more information on your rights under GDPR, please refer to '
              '[https://gdpr-info.eu](https://gdpr-info.eu).',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
