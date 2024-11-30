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

@riverpod
class MetricsController extends AutoDisposeAsyncNotifier<MetricsState> {
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
      id: userData.id,
      weightHistory: weightHistory,
      height: userData.height,
      gender: userData.gender,
      birthday: userData.birthday,
      weeklyWorkoutGoal: userData.weeklyWorkoutGoal,
      weightGoal: userData.weightGoal,
      activityLevel: userData.activityLevel,
    );
  }

  Future<void> updateUser({required String key, required dynamic value}) async {
    final currentState = state.asData?.value;

    print('Current user map: $currentState'); // Debugging

    if (currentState == null) return;

    try {
      UserModel updatedUser = UserModel(
        id: currentState.id,
        height: currentState.height,
        gender: currentState.gender,
        birthday: currentState.birthday!,
        weeklyWorkoutGoal: currentState.weeklyWorkoutGoal,
        weightGoal: currentState.weightGoal,
        activityLevel: currentState.activityLevel,
      );

      switch (key) {
        case 'height':
          updatedUser = updatedUser.copyWith(height: value as double);
          break;
        case 'gender':
          updatedUser = updatedUser.copyWith(gender: value as Gender);
          break;
        case 'birthday':
          updatedUser = updatedUser.copyWith(birthday: value as DateTime?);
          break;
        case 'weeklyWorkoutGoal':
          updatedUser = updatedUser.copyWith(weeklyWorkoutGoal: value as int);
          break;
        case 'weightGoal':
          updatedUser = updatedUser.copyWith(weightGoal: value as WeightGoal);
          break;
        case 'activityLevel':
          updatedUser =
              updatedUser.copyWith(activityLevel: value as ActivityLevel);
          break;
        default:
          throw Exception('Unsupported key: $key');
      }

      // Update Firebase
      await _userRepository.updateUser(updatedUser);

      state = AsyncValue.data(currentState.copyWith(
        height: key == 'height' ? value as double : currentState.height,
        gender: key == 'gender' ? value as Gender : currentState.gender,
        birthday:
            key == 'birthday' ? value as DateTime? : currentState.birthday,
        weeklyWorkoutGoal: key == 'weeklyWorkoutGoal'
            ? value as int
            : currentState.weeklyWorkoutGoal,
        weightGoal:
            key == 'weightGoal' ? value as WeightGoal : currentState.weightGoal,
        activityLevel: key == 'activityLevel'
            ? value as ActivityLevel
            : currentState.activityLevel,
      ));

      print('Firebase and local state updated successfully.');
    } catch (e, stack) {
      print('Failed to update Firebase: $e');
      print(stack);
    }
  }

  Future<void> updateAllMetrics(MetricsState metricstate) async {
    final userData = await _userRepository.getUser();

    if (userData != null) {
      final updatedUser = userData.copyWith(
        height: metricstate.height,
        gender: metricstate.gender,
        birthday: metricstate.birthday,
        weeklyWorkoutGoal:
            metricstate.weeklyWorkoutGoal, // Retain existing value
        weightGoal: metricstate.weightGoal,
        activityLevel: metricstate.activityLevel,
      );

      final firstWeight = metricstate.weightHistory.first;
      final newWeightEntry = NewWeightEntry(
        timestamp: firstWeight.timestamp,
        weight: firstWeight.weight,
      );
      await _weightRepository.addWeightEntry(newWeightEntry);

      // Update state
      final updatedState = MetricsState(
        id: updatedUser.id,
        weightHistory: await _weightRepository.getWeightHistory(),
        height: updatedUser.height,
        gender: updatedUser.gender,
        birthday: updatedUser.birthday,
        weeklyWorkoutGoal: updatedUser.weeklyWorkoutGoal,
        weightGoal: updatedUser.weightGoal,
        activityLevel: updatedUser.activityLevel,
      );

      state = AsyncValue.data(updatedState);
    }
  }

  Future<void> addWeightEntry(double weight, DateTime date) async {
    try {
      final entry = NewWeightEntry(timestamp: date, weight: weight);
      final weightEntry = await _weightRepository.addWeightEntry(entry);

      final currentState = state.asData?.value;
      if (currentState != null) {
        state = AsyncValue.data(currentState.copyWith(
          weightHistory: [...currentState.weightHistory, weightEntry]
            ..sort((a, b) => a.timestamp.compareTo(b.timestamp)),
        ));
      }
    } catch (e) {
      throw Exception("Failed to add weight entry: $e");
    }
  }

  // Handle the weight
  Future<void> addWeight(double weight) async {
    try {
      final entry = NewWeightEntry(timestamp: DateTime.now(), weight: weight);
      final weightEntry = await _weightRepository.addWeightEntry(entry);

      final currentState = state.asData?.value;
      if (currentState != null) {
        state = AsyncValue.data(currentState.copyWith(
          weightHistory: [...currentState.weightHistory, weightEntry]
            ..sort((a, b) => a.timestamp.compareTo(b.timestamp)),
        ));
      }
    } catch (e) {
      throw Exception("Failed to add weight entry: $e");
    }
  }

  Future<WeightEntry?> getLatestWeight() async {
    final weigthHistory = await _weightRepository.getLatestWeightEntry();

    if (weigthHistory == null) return null;
    return weigthHistory;
  }

  Future<List<WeightEntry>> getWeightEntryPastMonth() async {
    return await _weightRepository.getWeightHistoryPastMonth();
  }

  Future<List<WeightEntry>> getWeightEntryPastyear() async {
    return await _weightRepository.getWeightHistoryPastYear();
  }

  //Handle the height
  Future<double> getHeight() async {
    final userData = await _userRepository.getUser();

    if (userData != null) {
      return userData.height;
    }

    throw Exception('Height not found for the user');
  }

  Future<void> updateHeight(double height) async {
    try {
      if (!UserModel.isValidHeight(height)) {
        throw Exception('Height must be between 20 to 300 cm.');
      }
      final userData = await _userRepository.getUser();
      if (userData == null) throw Exception('User Data is empty');
      final updatedUser = userData.copyWith(height: height);
      await _userRepository.updateUser(updatedUser);

      final currentState = state.asData?.value;
      if (currentState != null) {
        state = AsyncValue.data(currentState.copyWith(height: height));
      }
    } catch (e) {
      throw Exception('Failed to update height.');
    }
  }

// Handle the Gender
  Future<Gender?> getGender() async {
    final userData = await _userRepository.getUser();

    if (userData != null) {
      return userData.gender;
    }

    throw Exception('Gender not found for the user');
  }

  Future<void> updateGender(Gender gender) async {
    final userData = await _userRepository.getUser();
    if (userData != null) {
      final updatedUser = userData.copyWith(gender: gender);
      await _userRepository.updateUser(updatedUser);
    }

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(gender: gender));
    }
  }

  // Handle the birthday
  Future<DateTime?> getBirthday() async {
    final userData = await _userRepository.getUser();

    if (userData != null) {
      return userData.birthday;
    }

    throw Exception('Birthday not found for the user');
  }

  Future<void> setBirthday(DateTime birthday) async {
    final userData = await _userRepository.getUser();
    if (userData != null) {
      final updatedUser = userData.copyWith(birthday: birthday);
      await _userRepository.updateUser(updatedUser);
    }

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(birthday: birthday));
    }
  }

  // Handle the weekly workouts
  Future<void> updateWeeklyWorkoutGoal(int goal) async {
    final userData = await _userRepository.getUser();
    if (userData != null) {
      final updatedUser = userData.copyWith(weeklyWorkoutGoal: goal);
      await _userRepository.updateUser(updatedUser);
    }

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(weeklyWorkoutGoal: goal));
    }
  }

  // Handle the weight goal
  Future<void> updateWeightGoal(WeightGoal? goal) async {
    final userData = await _userRepository.getUser();
    if (userData != null) {
      final updatedUser = userData.copyWith(weightGoal: goal);
      await _userRepository.updateUser(updatedUser);
    }

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(weightGoal: goal));
    }
  }

  Future<WeightGoal?> getWeightGoal() async {
    final userData = await _userRepository.getUser();

    if (userData != null) {
      return userData.weightGoal;
    }

    throw Exception('Weight goal not found for the user');
  }

  // Handle the activity level
  Future<void> updateActivityLevel(ActivityLevel? level) async {
    final userData = await _userRepository.getUser();
    if (userData != null) {
      final updatedUser = userData.copyWith(activityLevel: level);
      await _userRepository.updateUser(updatedUser);
    }

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(activityLevel: level));
    }
  }

  Future<ActivityLevel?> getActivityLevel() async {
    final userData = await _userRepository.getUser();

    if (userData != null) {
      return userData.activityLevel;
    }

    throw Exception('Activity level not found for the user');
  }
}
