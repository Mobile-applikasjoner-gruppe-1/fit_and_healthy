import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
    this.firebaseUser,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final User? firebaseUser;

  static AppUser fromFirebaseUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      firebaseUser: user,
    );
  }
}
