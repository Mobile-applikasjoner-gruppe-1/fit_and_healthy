import 'dart:async';

import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/email_verification/email_verification_view.dart';
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

  final bool isUnverfiedEmail = auth.currentUser != null &&
      auth.currentUser!.firebaseUser.email != null &&
      !auth.currentUser!.firebaseUser.emailVerified;
  final bool isVerifiedEmail = auth.currentUser != null &&
      auth.currentUser!.firebaseUser.email != null &&
      auth.currentUser!.firebaseUser.emailVerified;

  final bool isVerifyingEmail =
      state.matchedLocation == EmailVerificationView.route;

  // Redirect to the email verification page if the user is logged in but the email is not verified.
  if (isUnverfiedEmail && !isVerifyingEmail) {
    return EmailVerificationView.route;
  }

  // Redirect to the dashboard (main page) if the user is already logged in.
  if ((isLoggedIn && isLoggingIn) || (isVerifiedEmail && isVerifyingEmail)) {
    return DashboardView.route;
  }

  // Redirect to the login page if the user is not logged in.
  if (!isLoggedIn && !isLoggingIn) {
    return LoginView.route;
  }

  return null;
}
