import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  static const route = '/register';
  static const routeName = 'register';

  const RegisterView({super.key, this.rd});

  final String? rd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'), centerTitle: true),
      body: Center(),
    );
  }
}
