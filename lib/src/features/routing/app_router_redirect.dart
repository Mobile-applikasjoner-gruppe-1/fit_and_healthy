import 'dart:async';

import 'package:fit_and_healthy/src/features/auth/add_display_name/add_display_name_view.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
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
  final AuthUser? currentUser = auth.currentUser;

  final bool isLoggedIn = currentUser != null;
  final bool isLoggingIn = state.matchedLocation == LoginView.route ||
      state.matchedLocation == RegisterView.route ||
      state.matchedLocation == ForgotPasswordView.route;

  final bool isUnverfiedEmail = currentUser != null &&
      currentUser.firebaseUser.email != null &&
      !currentUser.firebaseUser.emailVerified;
  final bool isVerifiedEmail = currentUser != null &&
      currentUser.firebaseUser.email != null &&
      currentUser.firebaseUser.emailVerified;

  final bool isVerifyingEmail =
      state.matchedLocation == EmailVerificationView.route;

  final bool loggedInWithoutDisplayName =
      currentUser != null && currentUser.firebaseUser.displayName == null;

  if (loggedInWithoutDisplayName) {
    return AddDisplayNameView.route;
  }

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
