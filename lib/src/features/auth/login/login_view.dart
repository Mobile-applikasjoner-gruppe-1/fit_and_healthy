import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  static const route = '/login';
  static const routeName = 'login';

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.s100),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Sizes.s100),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle login logic here
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
