import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class AuthUser {
  const AuthUser({
    required this.firebaseUser,
    // this.user,
  });

  final FirebaseAuth.User firebaseUser;
  // final User? user;

  AuthUser copyOf({
    FirebaseAuth.User? firebaseUser,
    // User? user,
  }) {
    return AuthUser(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      // user: user ?? this.user,
    );
  }
}
