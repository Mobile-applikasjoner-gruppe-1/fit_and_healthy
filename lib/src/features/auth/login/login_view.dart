import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_view.dart';
import 'package:fit_and_healthy/src/features/auth/login/login_form_view.dart';
import 'package:fit_and_healthy/src/features/auth/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerWidget {
  static const route = '/login';
  static const routeName = 'login';

  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(title: Text('Login'), centerTitle: true),
      body: AuthView(
        title: Text('Login', style: Theme.of(context).textTheme.headlineSmall),
        form: LoginFormView(),
        navigationLink: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Don\'t have an account? '),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.replaceNamed(RegisterView.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.s50),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                ),
              ),
              Text('.'),
            ],
          ),
        ),
      ),
    );
  }
}
