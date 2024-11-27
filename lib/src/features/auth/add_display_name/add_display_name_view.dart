import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDisplayNameView extends ConsumerStatefulWidget {
  static const route = '/add-display-name';
  static const routeName = 'Add Display Name';

  const AddDisplayNameView({super.key});

  @override
  _AddDisplayNameViewState createState() => _AddDisplayNameViewState();
}

class _AddDisplayNameViewState extends ConsumerState<AddDisplayNameView> {
  final double gapSize = Sizes.s200;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AddDisplayNameView.routeName), centerTitle: true),
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
              'Please enter your first and last name to complete your registration.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: gapSize),
            Text(
              'First Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Sizes.s100),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              keyboardType: TextInputType.name,
              autofillHints: [AutofillHints.givenName],
            ),
            SizedBox(height: gapSize),
            Text(
              'Last Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Sizes.s100),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              keyboardType: TextInputType.name,
              autofillHints: [AutofillHints.familyName],
            ),
            SizedBox(height: gapSize),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).updateDisplayName(
                        _firstNameController.text,
                        _lastNameController.text,
                      );
                },
                child: Text('Save Display Name'),
              ),
            ),
            SizedBox(height: gapSize),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref.read(authControllerProvider.notifier).signOut();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.s50),
                child: Text(
                  'Sign in with a different account',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                    decoration: TextDecoration.underline,
                    decorationColor:
                        Theme.of(context).primaryTextTheme.bodySmall!.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
