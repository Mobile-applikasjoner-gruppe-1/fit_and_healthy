import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:fit_and_healthy/src/features/auth/auth_providers/buttons/provider_button_data.dart';
import 'package:fit_and_healthy/src/features/auth/auth_providers/buttons/provider_button_view.dart';
import 'package:fit_and_healthy/src/features/auth/login/login_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerWidget {
  static const route = '/login';
  static const routeName = 'login';

  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), centerTitle: true),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(Sizes.s200),
          children: [
            LoginFormView(),
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.s200),
                  child: Text('Or'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            ...providerButtons
                .map(
                  (providerButton) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.s50),
                    child: ProviderButtonView(
                      onPressed: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .signInWithProvider(providerButton.provider);
                      },
                      buttonData: providerButton,
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
