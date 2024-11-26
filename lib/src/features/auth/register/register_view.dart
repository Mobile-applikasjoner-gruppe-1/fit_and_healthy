import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_view.dart';
import 'package:fit_and_healthy/src/features/auth/login/login_view.dart';
import 'package:fit_and_healthy/src/features/auth/register/register_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends ConsumerWidget {
  static const route = '/register';
  static const routeName = 'register';

  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(title: Text('Register'), centerTitle: true),
      body: AuthView(
        title:
            Text('Register', style: Theme.of(context).textTheme.headlineSmall),
        form: RegisterFormView(),
        navigationLink: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Already have an account? '),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.replaceNamed(LoginView.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.s50),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.bodySmall!.color,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          Theme.of(context).primaryTextTheme.bodySmall!.color,
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
