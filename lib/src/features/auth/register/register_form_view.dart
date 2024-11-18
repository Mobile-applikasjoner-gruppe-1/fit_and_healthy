import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterFormView extends ConsumerStatefulWidget {
  const RegisterFormView({super.key});

  @override
  _RegisterFormViewState createState() => _RegisterFormViewState();
}

class _RegisterFormViewState extends ConsumerState<RegisterFormView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final double gapSize = Sizes.s200;

  // TODO: Split the different form fields into separate pages to not have too many fields on one page

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Sizes.s100),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                autofillHints: [AutofillHints.givenName],
              ),
              SizedBox(height: gapSize),
              Text(
                'Last Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Sizes.s100),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                autofillHints: [AutofillHints.familyName],
              ),
              SizedBox(height: gapSize),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Sizes.s100),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.visiblePassword,
                autofillHints: [AutofillHints.newPassword],
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
                    .createUserWithEmailAndPassword(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
              },
              child: Text('Register'),
            ),
          ),
        ),
      ],
    );
  }
}
