import 'dart:async';

import 'package:flutter/foundation.dart';

/// This class is used to listen to a stream and notify listeners when the stream emits a value.
///
/// Code is copied from go_router package where this class used to be provided.
class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
