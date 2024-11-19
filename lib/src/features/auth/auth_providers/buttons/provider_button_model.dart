import 'package:fit_and_healthy/src/features/auth/auth_providers/auth_providers.dart';
import 'package:flutter/material.dart';

class ProviderButtonData {
  final String label;
  final Widget image;
  final Color? backgroundColor;
  final SupportedAuthProvider provider;
  final Color? textColor;

  ProviderButtonData({
    required this.label,
    required this.image,
    required this.provider,
    this.backgroundColor,
    this.textColor,
  });
}
