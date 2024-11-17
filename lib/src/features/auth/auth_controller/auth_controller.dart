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
}
