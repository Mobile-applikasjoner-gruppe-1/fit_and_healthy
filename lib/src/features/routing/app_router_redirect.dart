import 'dart:async';

import 'package:fit_and_healthy/src/features/auth/add_display_name/add_display_name_view.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
import 'package:fit_and_healthy/src/features/auth/email_verification/email_verification_view.dart';
import 'package:fit_and_healthy/src/features/auth/forgot_password/forgot_password_view.dart';
import 'package:fit_and_healthy/src/features/auth/login/login_view.dart';
import 'package:fit_and_healthy/src/features/auth/register/register_view.dart';
import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_setup_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Redirects the user to the appropriate page based on the user's login status, email verification status and required data.
/// Runs on every route change.
FutureOr<String?> appRouterRedirectHandler(
  BuildContext context,
  GoRouterState state,
  FirebaseAuthRepository auth,
) {
  final AuthUser? currentUser = auth.currentUser;

  // Checks for login status.
  final bool isLoggedIn = currentUser != null;
  final bool isLoggingIn = state.matchedLocation == LoginView.route ||
      state.matchedLocation == RegisterView.route ||
      state.matchedLocation == ForgotPasswordView.route;

  // Checks for email verification.
  final bool isUnverfiedEmail = isLoggedIn &&
      currentUser.firebaseUser.email != null &&
      !currentUser.firebaseUser.emailVerified;
  final bool isVerifiedEmail = isLoggedIn &&
      currentUser.firebaseUser.email != null &&
      currentUser.firebaseUser.emailVerified;
  final bool isVerifyingEmail =
      state.matchedLocation == EmailVerificationView.route;

  // Checks for display name.
  final bool isLoggedInWithoutDisplayName =
      isLoggedIn && currentUser.firebaseUser.displayName == null;
  final bool isLoggedInWithDisplayName =
      isLoggedIn && currentUser.firebaseUser.displayName != null;
  final bool isAddingDisplayName =
      state.matchedLocation == AddDisplayNameView.route;

  // Checks for user data.
  final bool isLoggedInWithoutData =
      isLoggedIn && !currentUser.userLoading && currentUser.appUser == null;
  final bool isLoggedInWithData =
      isLoggedIn && !currentUser.userLoading && currentUser.appUser != null;
  final bool isAddingData = state.matchedLocation == MetricsSetupPage.route;

  // Redirect to the add display name page if the user is logged in but the display name is not set.
  if (isLoggedInWithoutDisplayName) {
    return AddDisplayNameView.route;
  }

  // Redirect to the email verification page if the user is logged in but the email is not verified.
  if (isLoggedInWithDisplayName && isUnverfiedEmail && !isVerifyingEmail) {
    return EmailVerificationView.route;
  }

  // Redirect to the page where the user is supposed to add data if the user is logged in but required data is not added.
  if (isLoggedInWithDisplayName &&
      isVerifiedEmail &&
      isLoggedInWithoutData &&
      !isAddingData) {
    return MetricsSetupPage.route;
  }

  // Redirect to the dashboard (main page) if the user is already logged in, email is verified, display name is set and required data is added.
  if ((isLoggedIn && isLoggingIn) ||
      (isVerifiedEmail && isVerifyingEmail) ||
      (isLoggedInWithDisplayName && isAddingDisplayName) ||
      (isLoggedInWithData && isAddingData)) {
    return DashboardView.route;
  }

  // Redirect to the login page if the user is not logged in.
  if (!isLoggedIn && !isLoggingIn) {
    return LoginView.route;
  }

  return null;
}
