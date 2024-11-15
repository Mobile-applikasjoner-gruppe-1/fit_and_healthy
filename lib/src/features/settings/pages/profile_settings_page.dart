import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hie"),
      ),
      body: ListView(children: [
        Text('Here will the user have settings options :)'),
      ]),
    );
  }
}
