import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_and_healthy/src/features/auth/app_user_model.dart';
import 'package:fit_and_healthy/src/features/auth/auth_providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_repository.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
FirebaseAuthRepository firebaseAuthRepository(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthRepository(auth);
}

@Riverpod(keepAlive: true)
Stream<AppUser?> firebaseAuthStateChange(Ref ref) {
  final auth = ref.watch(firebaseAuthRepositoryProvider);
  return auth.authStateChanges();
}

class FirebaseAuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  DateTime? emailVerificationLastSent;

  AppUser? _convertUser(User? user) {
    return user == null ? null : AppUser.fromFirebaseUser(user);
  }

  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_convertUser);
  }

  AppUser? get currentUser => _convertUser(_firebaseAuth.currentUser);

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> createUserWithEmailAndPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final creds = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await creds.user?.updateDisplayName('$firstName $lastName');
    await creds.user?.sendEmailVerification();
  }

  Future<void> signInWithProvider(SupportedAuthProvider provider) async {
    switch (provider) {
      case SupportedAuthProvider.google:
        final GoogleSignInAccount? googleUser = await GoogleSignIn(
                clientId:
                    '726238086088-jipbremhtmsjbnji99k8f3d5j77jjks8.apps.googleusercontent.com')
            .signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        break;
      default:
        throw UnimplementedError(
            'Provider ${provider.providerId} is not implemented');
    }
  }

  // TODO: Check if we need other methods for reset password-link and/or OTP (one-time password)
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    await _firebaseAuth.confirmPasswordReset(
        code: code, newPassword: newPassword);
  }

  Future<void> sendEmailVerification() async {
    if (_firebaseAuth.currentUser == null) {
      throw Exception('No user is currently signed in');
    }

    if (_firebaseAuth.currentUser!.emailVerified) {
      throw Exception('Email is already verified');
    }

    if (_firebaseAuth.currentUser!.email == null ||
        _firebaseAuth.currentUser!.email!.isEmpty) {
      throw Exception('User was created without email verification');
    }

    if (emailVerificationLastSent != null &&
        DateTime.now().difference(emailVerificationLastSent!) <
            Duration(seconds: 30)) {
      throw Exception('Email verification already sent');
    }

    await _firebaseAuth.currentUser?.sendEmailVerification();
    emailVerificationLastSent = DateTime.now();
  }
}
