import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/src/features/metrics/metric_state.dart';
import 'package:fit_and_healthy/src/features/user/user_model.dart';
import 'package:fit_and_healthy/src/features/user/user_repository.dart';
import 'package:fit_and_healthy/src/features/user/weight_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metrics_controller.g.dart';

@Riverpod(keepAlive: true)
class MetricsController extends _$MetricsController {
  late final UserRepository _userRepository;
  late final WeightRepository _weightRepository;

  @override
  Future<MetricsState> build() async {
    final authRepository = ref.read(firebaseAuthRepositoryProvider);
    _userRepository = UserRepository(authRepository);
    _weightRepository = WeightRepository(authRepository);

    final userData = await _userRepository.getUser();
    final weightHistory = await _weightRepository.getWeightHistory();

    if (userData == null) throw Exception('UserModel not found');

    return MetricsState(
      weightHistory: weightHistory,
      height: userData.height,
      gender: userData.gender,
      birthday: userData.birthday,
      weeklyWorkoutGoal: userData.weeklyWorkoutGoal,
      weightGoal: userData.weightGoal,
      activityLevel: userData.activityLevel,
    );
  }

  Future<void> addAllMetrics(MetricsState metricstate) async {
    final authRepostiory = ref.read(firebaseAuthRepositoryProvider);

    final user = User(
      id: authRepostiory.currentUser!.firebaseUser.uid,
      height: metricstate.height,
      activityLevel: metricstate.activityLevel,
      birthday: metricstate.birthday,
      gender: metricstate.gender,
      weeklyWorkoutGoal: metricstate.weeklyWorkoutGoal,
      weightGoal: metricstate.weightGoal,
    );

    await _userRepository.createUser(user);

    final newWeightEntry = NewWeightEntry(
      timestamp: metricstate.weightHistory.first.timestamp,
      weight: metricstate.weightHistory.first.weight,
    );

    await _weightRepository.addWeightEntry(newWeightEntry);

    state = AsyncValue.data(metricstate);
  }

  Future<void> updateAllMetrics(MetricsState metricsState) async {
    final userData = await _userRepository.getUser();

    if (userData == null) {
      throw Exception('User data not found');
    }

    final updatedUser = userData.copyWith(
      height: metricsState.height,
      gender: metricsState.gender,
      birthday: metricsState.birthday,
      weeklyWorkoutGoal:
          metricsState.weeklyWorkoutGoal, // Retain existing value
      weightGoal: metricsState.weightGoal,
      activityLevel: metricsState.activityLevel,
    );

    await _userRepository.updateUser(updatedUser);

    final firstWeight = metricsState.weightHistory.first;
    final newWeightEntry = NewWeightEntry(
      timestamp: firstWeight.timestamp,
      weight: firstWeight.weight,
    );
    await _weightRepository.addWeightEntry(newWeightEntry);

    state = AsyncValue.data(metricsState);
  }

  Future<void> addWeightEntry(double weight, DateTime date) async {
    final currentState = await future;

    final entry = NewWeightEntry(timestamp: date, weight: weight);
    final weightEntry = await _weightRepository.addWeightEntry(entry);

    state = AsyncValue.data(currentState.copyWith(
      weightHistory: [...currentState.weightHistory, weightEntry]
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp)),
    ));
  }

  // Handle the weight
  Future<void> addWeight(double weight) async {
    final currentState = await future;
    final entry = NewWeightEntry(timestamp: DateTime.now(), weight: weight);
    final weightEntry = await _weightRepository.addWeightEntry(entry);

    state = AsyncValue.data(currentState.copyWith(
      weightHistory: [...currentState.weightHistory, weightEntry]
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp)),
    ));
  }

  Future<WeightEntry?> getLatestWeight() async {
    final weigthHistory = await _weightRepository.getLatestWeightEntry();

    return weigthHistory;
  }

  Future<List<WeightEntry>> getWeightEntryPastMonth() async {
    return await _weightRepository.getWeightHistoryPastMonth();
  }

  Future<List<WeightEntry>> getWeightEntryPastyear() async {
    return await _weightRepository.getWeightHistoryPastYear();
  }

  Future<void> updateHeight(double height) async {
    final currentState = await future;

    _userRepository.updateHeight(height);

    state = AsyncValue.data(currentState.copyWith(height: height));
  }

  Future<void> updateGender(Gender gender) async {
    final currentState = await future;

    await _userRepository.updateGender(gender);

    state = AsyncValue.data(currentState.copyWith(gender: gender));
  }

  Future<void> setBirthday(DateTime birthday) async {
    final currentState = await future;

    await _userRepository.updateBirthday(birthday);

    state = AsyncValue.data(currentState.copyWith(birthday: birthday));
  }

  // Handle the weekly workouts
  Future<void> updateWeeklyWorkoutGoal(int goal) async {
    final currentState = await future;

    await _userRepository.updateWeeklyWorkoutGoal(goal);

    state = AsyncValue.data(currentState.copyWith(weeklyWorkoutGoal: goal));
  }

  // Handle the weight goal
  Future<void> updateWeightGoal(WeightGoal goal) async {
    final currentState = await future;

    await _userRepository.updateWeightGoal(goal);

    state = AsyncValue.data(currentState.copyWith(weightGoal: goal));
  }

  // Handle the activity level
  Future<void> updateActivityLevel(ActivityLevel activityLevel) async {
    final currentState = await future;

    await _userRepository.updateActivityLevel(activityLevel);

    state =
        AsyncValue.data(currentState.copyWith(activityLevel: activityLevel));
  }

  Future<void> reloadAuthUserDataFromDB() async {
    await ref.read(firebaseAuthRepositoryProvider).updateAppUserFromDB();
  }
}
