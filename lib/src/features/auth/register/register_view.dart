import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:fit_and_healthy/src/features/auth/auth_view.dart';
import 'package:fit_and_healthy/src/features/auth/login/login_view.dart';
import 'package:fit_and_healthy/src/features/auth/register/register_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends ConsumerWidget {
  static const route = '/register';
  static const routeName = 'register';

  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      next.maybeWhen(
        data: (authState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (authState.isError) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('An error occurred. Please try again.'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else if (authState.isLoading) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Registering...'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            } else if (authState.isSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Registered successfully.'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).clearSnackBars();
            }
          });
        },
        orElse: () {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).clearSnackBars();
          });
        },
      );
    });

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
