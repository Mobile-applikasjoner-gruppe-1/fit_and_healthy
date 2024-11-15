import 'package:flutter/material.dart';

class GdprSettingsPage extends StatelessWidget {
  const GdprSettingsPage({super.key});

  static const routeName = '/gdpr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
