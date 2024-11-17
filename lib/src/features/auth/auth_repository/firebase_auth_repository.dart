import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_and_healthy/src/features/auth/app_user_model.dart';
import 'package:fit_and_healthy/src/features/auth/auth_providers/auth_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithProvider(SupportedAuthProvider provider) async {
    // TODO: Check if signInWithPopup is good for our use-case
    switch (provider) {
      case SupportedAuthProvider.google:
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        break;
      case SupportedAuthProvider.facebook: // Trigger the sign-in flow
        final LoginResult loginResult = await FacebookAuth.instance.login();
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        break;
      case SupportedAuthProvider.apple:
        final appleProvider = AppleAuthProvider();
        if (kIsWeb) {
          await _firebaseAuth.signInWithPopup(appleProvider);
        } else {
          await _firebaseAuth.signInWithProvider(appleProvider);
        }
        break;
      default:
        throw UnimplementedError(
            'Provider ${provider.providerId} is not implemented');
    }
  }

  // TODO: Add methods for sending and verifying email verification, reset password-link and/or OTP (one-time password)
}
