import 'package:fit_and_healthy/src/common/styles/sizes.dart';
import 'package:fit_and_healthy/src/features/auth/auth_controller/auth_controller.dart';
import 'package:fit_and_healthy/src/features/auth/email_verification/email_verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailVerificationView extends ConsumerStatefulWidget {
  static const route = '/verify-email';
  static const routeName = 'Verify Email';

  const EmailVerificationView({super.key});

  @override
  _EmailVerificationViewState createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends ConsumerState<EmailVerificationView> {
  final double gapSize = Sizes.s200;

  @override
  Widget build(BuildContext context) {
    final emailVerificationControllerFuture =
        ref.watch(emailVerificationControllerProvider.future);

    return FutureBuilder(
      future: emailVerificationControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('An error occurred. Please try again later.'),
          );
        }

        DateTime nextEmailSend = snapshot.data!.nextEmailSend;

        return Scaffold(
          appBar: AppBar(
            title: Text(EmailVerificationView.routeName),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.s200,
              right: Sizes.s200,
              bottom: Sizes.s200,
            ),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Text(
                  'We have sent a verification email to your email address. Please check your email and click the link to verify your email address.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: gapSize),
                Text(
                  'Already verified your email?',
                ),
                SizedBox(height: gapSize / 2),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(emailVerificationControllerProvider.notifier)
                        .confirmVerification();
                  },
                  child: Text('I have verified my email'),
                ),
                SizedBox(height: gapSize),
                StreamBuilder<int>(
                  stream: Stream.periodic(Duration(seconds: 1), (x) {
                    final secondsUntilNextEmailSend =
                        nextEmailSend.difference(DateTime.now()).inSeconds;
                    return secondsUntilNextEmailSend;
                  }).takeWhile((secondsUntilNextEmailSend) =>
                      secondsUntilNextEmailSend >= 0),
                  builder: (context, snapshot) {
                    final secondsUntilNextEmailSend = snapshot.data ?? 0;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: secondsUntilNextEmailSend > 0
                            ? null
                            : () {
                                ref
                                    .read(emailVerificationControllerProvider
                                        .notifier)
                                    .verifyEmail();
                              },
                        child: Text(secondsUntilNextEmailSend > 0
                            ? 'Resend Email in $secondsUntilNextEmailSend seconds'
                            : 'Resend Verification Email'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.disabled)
                                ? Theme.of(context).disabledColor
                                : null,
                          ),
                          foregroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.disabled)
                                ? Theme.of(context).disabledColor
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: gapSize),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    ref.read(authControllerProvider.notifier).signOut();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.s50),
                    child: Text(
                      'Sign in with a different account',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.bodySmall!.color,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            Theme.of(context).primaryTextTheme.bodySmall!.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
