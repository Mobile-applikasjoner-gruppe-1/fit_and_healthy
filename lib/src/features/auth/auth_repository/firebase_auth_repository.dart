import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
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
Stream<AuthUser?> firebaseAuthStateChange(Ref ref) {
  final auth = ref.watch(firebaseAuthRepositoryProvider);
  return auth.userChanges();
}

class FirebaseAuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;
  AuthUser? _authUser = null;

  Stream<AuthUser?> userChanges() {
    return _firebaseAuth.userChanges().map((user) {
      if (user == null) {
        _authUser = null;
        return null;
      }

      _authUser = AuthUser(firebaseUser: user);
      return _authUser;
    });
  }

  AuthUser? get currentUser => _authUser;

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
    // final creds =
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
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

    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  Future<void> verifyEmail() async {
    if (_firebaseAuth.currentUser == null) {
      throw Exception('No user is currently signed in');
    }

    User user = _firebaseAuth.currentUser!;

    if (user.emailVerified) {
      throw Exception('Email is already verified');
    }

    if (user.email == null || user.email!.isEmpty) {
      throw Exception('User was created without email verification');
    }

    await user.reload();

    if (user.emailVerified) {
      await user.getIdToken(true);
    }
  }

  Future<void> updateDisplayName(String firstName, String lastName) async {
    if (_firebaseAuth.currentUser == null) {
      throw Exception('No user is currently signed in');
    }

    User user = _firebaseAuth.currentUser!;
    String newDisplayName = '$firstName $lastName';

    await user.updateDisplayName(newDisplayName);

    await user.reload();

    if (user.displayName == newDisplayName) {
      await user.getIdToken(true);
    }
  }
}
