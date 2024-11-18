import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:fit_and_healthy/src/features/auth/forgot_password/forgot_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginFormView extends ConsumerStatefulWidget {
  const LoginFormView({super.key});

  @override
  _LoginFormViewState createState() => _LoginFormViewState();
}

class _LoginFormViewState extends ConsumerState<LoginFormView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final double gapSize = Sizes.s200;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'Email',
              //   style: TextStyle(fontSize: 16),
              // ),
              // SizedBox(height: Sizes.s100),
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
              // Text(
              //   'Password',
              //   style: TextStyle(fontSize: 16),
              // ),
              // SizedBox(height: Sizes.s100),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                autofillHints: [AutofillHints.password],
                obscureText: true,
              ),
            ],
          ),
        ),
        SizedBox(height: gapSize),
        Container(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(authControllerProvider.notifier)
                    .signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
              },
              child: Text('Login'),
            ),
          ),
        ),
        SizedBox(height: Sizes.s25),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              context.pushNamed(ForgotPasswordView.routeName);
            },
            child: Text('Forgot Password?'),
          ),
        ),
      ],
    );
  }
}
