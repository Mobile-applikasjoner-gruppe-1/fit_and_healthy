import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginFormView extends ConsumerStatefulWidget {
  const LoginFormView({super.key});

  @override
  _LoginFormViewState createState() => _LoginFormViewState();
}

class _LoginFormViewState extends ConsumerState<LoginFormView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Form(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: Sizes.s100),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        SizedBox(height: Sizes.s100),
        Container(
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
        )
      ],
    );
  }
}
