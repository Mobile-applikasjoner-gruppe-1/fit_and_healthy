import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_and_healthy/src/features/auth/app_user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // TODO: Add methods for sending and verifying email verification and/or OTP (one-time password)
}
