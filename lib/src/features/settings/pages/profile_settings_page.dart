import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  static const route = '/profile';
  static const routeName = 'Profile Settings';

  @override
  Widget build(BuildContext context) {
    return NestedScaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(children: [
        Text('Profile options like change values, name and theme?'),
      ]),
    );
  }
}
