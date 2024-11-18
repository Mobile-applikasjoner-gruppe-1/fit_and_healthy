import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_providers/buttons/provider_button_model.dart';
import 'package:flutter/material.dart';

class ProviderButtonView extends StatelessWidget {
  const ProviderButtonView({
    super.key,
    required this.onPressed,
    required this.buttonData,
  });

  final VoidCallback onPressed;
  final ProviderButtonData buttonData;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(buttonData.backgroundColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.s50),
            child: SizedBox(
              width: 30,
              height: 30,
              child: buttonData.image,
            ),
          ),
          Text(
            buttonData.label,
            style: TextStyle(
                color: buttonData.textColor ??
                    Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ],
      ),
    );
  }
}
