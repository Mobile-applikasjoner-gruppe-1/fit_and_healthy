import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';

class GdprSettingsPage extends StatelessWidget {
  const GdprSettingsPage({super.key});

  static const route = '/gdpr';
  static const routeName = 'GDPR Settings';

  @override
  Widget build(BuildContext context) {
    return NestedScaffold(
      appBar: AppBar(
        title: Text("GDPR"),
      ),
      body: ListView(children: [
        Text(
            'User can update their information -> profile. Access all their data, and delete their user'),
      ]),
    );
  }
}
