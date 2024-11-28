import 'package:fit_and_healthy/src/features/auth/auth_loading_state.dart';
import 'package:fit_and_healthy/src/features/auth/auth_providers/auth_providers.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AuthLoadingState> build() async {
    return AuthLoadingState.initial();
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.data(AuthLoadingState.loading());
    try {
      final authRepository = ref.read(firebaseAuthRepositoryProvider);
      await authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(AuthLoadingState.success());
    } on Exception catch (e) {
      state = AsyncValue.data(AuthLoadingState.error(e));
    }
  }

  Future<void> signOut() async {
    state = AsyncValue.data(AuthLoadingState.loading());
    try {
      final authRepository = ref.read(firebaseAuthRepositoryProvider);
      await authRepository.signOut();
      state = AsyncValue.data(AuthLoadingState.success());
    } on Exception catch (e) {
      state = AsyncValue.data(AuthLoadingState.error(e));
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.data(AuthLoadingState.loading());
    try {
      final authRepository = ref.read(firebaseAuthRepositoryProvider);
      await authRepository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = AsyncValue.data(AuthLoadingState.success());
    } on Exception catch (e) {
      state = AsyncValue.data(AuthLoadingState.error(e));
    }
  }

  // void createUserOnAuthStateChange() {
  //   ref.listen(
  //     firebaseAuthStateChangeProvider,
  //     (previous, next) async {
  //       if (next.value != null) {
  //         final user = next.value!;
  //         final userRepository = ref.read(userRepositoryProvider);

  //         userRepository.createUser(
  //           uid: user.uid,
  //           email: user.email,
  //           firstName: user.displayName,
  //           lastName: user.displayName,
  //         );
  //       }
  //     },
  //   );
  // }

  Future<void> signInWithProvider(SupportedAuthProvider provider) async {
    state = AsyncValue.data(AuthLoadingState.loading());
    try {
      final authRepository = ref.read(firebaseAuthRepositoryProvider);
      await authRepository.signInWithProvider(provider);
      state = AsyncValue.data(AuthLoadingState.success());
    } on Exception catch (e) {
      state = AsyncValue.data(AuthLoadingState.error(e));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = AsyncValue.data(AuthLoadingState.loading());
    try {
      final authRepository = ref.read(firebaseAuthRepositoryProvider);
      await authRepository.sendPasswordResetEmail(email);
      state = AsyncValue.data(AuthLoadingState.success());
    } on Exception catch (e) {
      state = AsyncValue.data(AuthLoadingState.error(e));
    }
  }

  Future<void> updateDisplayName(String firstName, String lastName) async {
    state = AsyncValue.data(AuthLoadingState.loading());
    try {
      final authRepository = ref.read(firebaseAuthRepositoryProvider);
      await authRepository.updateDisplayName(firstName, lastName);
      state = AsyncValue.data(AuthLoadingState.success());
    } on Exception catch (e) {
      state = AsyncValue.data(AuthLoadingState.error(e));
    }
  }
}
