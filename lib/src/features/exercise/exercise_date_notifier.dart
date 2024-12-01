import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_date_notifier.g.dart';

@Riverpod(keepAlive: true)
class ExerciseDateNotifier extends _$ExerciseDateNotifier {
  @override
  Future<DateTime> build() async {
    return DateTime.now();
  }

  void changeDate(DateTime newDate) {
    state = AsyncValue.data(newDate);
  }
}
