import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:fit_and_healthy/src/features/auth/auth_providers/buttons/provider_button_data.dart';
import 'package:fit_and_healthy/src/features/auth/auth_providers/buttons/provider_button_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthView extends ConsumerWidget {
  final Widget title;
  final Widget form;
  final Widget navigationLink;

  AuthView({
    super.key,
    required this.title,
    required this.form,
    required this.navigationLink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.s200),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              title,
              form,
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.s25, vertical: Sizes.s100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Sizes.s200),
                      child: Text('Or'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              ...providerButtons
                  .asMap()
                  .map(
                    (index, providerButton) => MapEntry(
                      index,
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: index == providerButtons.length - 1
                              ? 0
                              : Sizes.s100,
                        ),
                        child: ProviderButtonView(
                          onPressed: () {
                            ref
                                .read(authControllerProvider.notifier)
                                .signInWithProvider(providerButton.provider);
                          },
                          buttonData: providerButton,
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
              SizedBox(height: Sizes.s200),
              navigationLink,
            ],
          ),
        ),
      ),
    );
  }
}
