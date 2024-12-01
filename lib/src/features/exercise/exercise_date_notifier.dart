import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_date_notifier.g.dart';

@Riverpod(keepAlive: true)
class ExerciseDateNotifier extends _$ExerciseDateNotifier {
  @override
  Future<DateTime> build() async {
    return _dateTimeToDate(DateTime.now());
  }

  _dateTimeToDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  void changeDate(DateTime newDate) {
    DateTime normalizedDate = _dateTimeToDate(newDate);
    state = AsyncValue.data(normalizedDate);
  }
}
