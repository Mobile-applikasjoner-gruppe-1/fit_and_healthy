import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  static const route = '/forgot-password';
  static const routeName = 'Forgot Password';

  const ForgotPasswordView({super.key});

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  final double gapSize = Sizes.s200;

  @override
  Widget build(BuildContext context) {
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
                  content: Text('Sending reset email...'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            } else if (authState.isSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reset email sent successfully.'),
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
      appBar: AppBar(
        title: Text(ForgotPasswordView.routeName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Sizes.s200,
          right: Sizes.s200,
          bottom: Sizes.s200,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Text(
              'Enter the email address associated with your account and we will send you an email with instructions to reset your password.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: gapSize),
            Text(
              'Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Sizes.s100),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              keyboardType: TextInputType.emailAddress,
              autofillHints: [AutofillHints.email],
            ),
            SizedBox(height: gapSize),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(authControllerProvider.notifier)
                      .sendPasswordResetEmail(_emailController.text);
                },
                child: Text('Send Reset Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
