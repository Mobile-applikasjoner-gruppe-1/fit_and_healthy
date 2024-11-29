import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:fit_and_healthy/src/features/user/user_model.dart';

class AuthUser {
  const AuthUser({
    required this.firebaseUser,
    this.appUser,
  });

  final FirebaseAuth.User firebaseUser;
  final UserModel? appUser;

  AuthUser copyOf({
    FirebaseAuth.User? firebaseUser,
    UserModel? appUser,
  }) {
    return AuthUser(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      appUser: appUser ?? this.appUser,
    );
  }
}
