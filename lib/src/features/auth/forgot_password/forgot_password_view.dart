import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(ForgotPasswordView.routeName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.s200),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Text(
              'Email',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: Sizes.s100),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
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
