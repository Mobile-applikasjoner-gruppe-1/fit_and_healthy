import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  static const route = '/login';
  static const routeName = 'login';

  const LoginView({super.key, this.rd});

  final String? rd;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (rd != null) {
            // URL decode rd and redirect to it
            context.go(Uri.decodeFull(rd!));
          } else {
            context.go(DashboardView.route);
          }

          // TODO: return a loading spinner or similar?
        }

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
      },
    );
  }
}
