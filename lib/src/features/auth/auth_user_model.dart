import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:fit_and_healthy/src/features/user/user_model.dart';

class AuthUser {
  const AuthUser({
    required this.firebaseUser,
    this.appUser,
    this.userLoading = true,
  });

  final FirebaseAuth.User firebaseUser;
  final User? appUser;
  final bool userLoading;

  AuthUser copyOf({
    FirebaseAuth.User? firebaseUser,
    User? appUser,
    bool? userLoading,
  }) {
    return AuthUser(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      appUser: appUser ?? this.appUser,
      userLoading: userLoading ?? this.userLoading,
    );
  }
}
