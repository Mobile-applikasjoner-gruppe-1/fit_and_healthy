import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_verification_controller.g.dart';

@riverpod
class EmailVerificationController extends _$EmailVerificationController {
  EmailVerificationController();

  @override
  FutureOr<EmailVerificationState> build() async {
    bool isEmailVerified = ref
        .watch(firebaseAuthRepositoryProvider)
        .currentUser!
        .firebaseUser
        .emailVerified;
    if (isEmailVerified) {
      return EmailVerificationState(
        isEmailVerified: true,
        lastEmailSent: DateTime.fromMillisecondsSinceEpoch(0),
      );
    } else {
      await _verifyEmail();
      return EmailVerificationState(
        isEmailVerified: false,
        lastEmailSent: DateTime.now(),
      );
    }
  }

  Future<void> _verifyEmail() async {
    await ref.read(firebaseAuthRepositoryProvider).sendEmailVerification();
  }

  Future<void> verifyEmail() async {
    EmailVerificationState previousState = await future;
    if (previousState.nextEmailSend != null &&
        previousState.nextEmailSend!.isAfter(DateTime.now())) {
      return;
    }

    await _verifyEmail();

    state =
        AsyncValue.data(previousState.copyWith(lastEmailSent: DateTime.now()));
  }

  Future<void> confirmVerification() async {
    await ref.read(firebaseAuthRepositoryProvider).verifyEmail();
  }
}

class EmailVerificationState {
  DateTime? lastEmailSent;
  bool isEmailVerified = false;
  bool error = false;

  DateTime? get nextEmailSend => lastEmailSent?.add(Duration(seconds: 60));

  EmailVerificationState({
    required this.lastEmailSent,
    this.isEmailVerified = false,
    this.error = false,
  });

  EmailVerificationState copyWith({
    DateTime? lastEmailSent,
    bool? isEmailVerified,
    bool? error,
  }) {
    return EmailVerificationState(
      lastEmailSent: lastEmailSent ?? this.lastEmailSent,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      error: error ?? this.error,
    );
  }
}
