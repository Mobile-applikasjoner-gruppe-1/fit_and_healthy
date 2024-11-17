import 'package:fit_and_healthy/src/features/auth/auth_providers/auth_providers.dart';
import 'package:fit_and_healthy/src/features/auth/auth_providers/buttons/provider_button_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<ProviderButtonData> providerButtons = [
  ProviderButtonData(
      label: 'Continue with Apple',
      image: SvgPicture.asset(
        'assets/images/Apple logo Black.svg',
        fit: BoxFit.contain,
      ),
      provider: SupportedAuthProvider.apple),
  ProviderButtonData(
      label: 'Continue with Google',
      image: SvgPicture.asset(
        'assets/images/Google_logo.svg',
        fit: BoxFit.contain,
      ),
      provider: SupportedAuthProvider.google),
  ProviderButtonData(
      label: 'Continue with Facebook',
      image: Image.asset(
        'assets/images/Facebook_Logo_Primary.png',
        fit: BoxFit.contain,
      ),
      textColor: Color(0xFF5890FF),
      provider: SupportedAuthProvider.facebook),
];
