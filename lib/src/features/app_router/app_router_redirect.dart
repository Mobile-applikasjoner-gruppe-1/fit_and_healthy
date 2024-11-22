import 'dart:async';

import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/forgot_password/forgot_password_view.dart';
import 'package:fit_and_healthy/src/features/auth/login/login_view.dart';
import 'package:fit_and_healthy/src/features/auth/register/register_view.dart';
import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

FutureOr<String?> appRouterRedirectHandler(
  BuildContext context,
  GoRouterState state,
  FirebaseAuthRepository auth,
) {
  final bool isLoggedIn = auth.currentUser != null;
  final bool isLoggingIn = state.matchedLocation == LoginView.route ||
      state.matchedLocation == RegisterView.route ||
      state.matchedLocation == ForgotPasswordView.route;

  // Redirect to the dashboard (main page) if the user is already logged in.
  if (isLoggedIn && isLoggingIn) {
    return DashboardView.route;
  }

  // Redirect to the login page if the user is not logged in.
  if (!isLoggedIn && !isLoggingIn) {
    return LoginView.route;
  }

  return null;
}
