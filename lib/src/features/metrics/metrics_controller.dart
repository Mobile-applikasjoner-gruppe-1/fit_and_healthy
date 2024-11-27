import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/src/features/user/user_repository.dart';
import 'package:fit_and_healthy/src/features/user/weight_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metrics_controller.g.dart';

@riverpod
class MetricsController extends _$MetricsController {
  late final UserRepository _userRepository;
  late final WeightRepository _weightRepository;

  @override
  Future<Map<String, dynamic>> build() async {
    final authRepository = ref.read(firebaseAuthRepositoryProvider);
    _userRepository = UserRepository(authRepository);
    _weightRepository = WeightRepository(authRepository);

    final userData = await _userRepository.getUser();
    final weightHistory = await _weightRepository.getWeightHistory();

    if (userData == null) throw Exception('UserModel not found');

    return {
      'weightHistory': weightHistory,
      'height': userData.height,
      'gender': userData.gender,
      'birthday': userData.birthday,
      'weeklyWorkoutGoal': userData.weeklyWorkoutGoal,
      'weightGoal': userData.weightGoal,
      'intensityLevel': userData.activityLevel,
    };
  }

  Future<void> addWeightEntry(double weight, DateTime date) async {
    final entry = WeightEntry(timestamp: date, weight: weight);
    await _weightRepository.addWeightEntry(entry);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'weightHistory': [...currentState['weightHistory'], entry]
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp)),
      });
    }
  }

  // Handle the weight
  Future<void> addWeight(double weight) async {
    final entry = WeightEntry(timestamp: DateTime.now(), weight: weight);
    await _weightRepository.addWeightEntry(entry);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'weightHistory': [...currentState['weightHistory'], entry]
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp)),
      });
    }
  }

  Future<double?> getLatestWeight() async {
    final weigthHistory = await _weightRepository.getWeightHistory();

    if (weigthHistory.isNotEmpty) {
      final latestEntry = weigthHistory
          .reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);
      return latestEntry.weight;
    }
    return null;
  }

  //Handle the height
  Future<double> getHeight() async {
    final userData = await _userRepository.getUser();

    if (userData != null) {
      print('Height: ' + userData.height.toString());
      return userData.height;
    }

    throw Exception('Height not found for the user');
  }

  Future<void> updateHeight(double height) async {
    print('Updating height');

    final userData = await _userRepository.getUser();
    if (userData != null) {
      final updatedUser = userData.copyWith(height: height);
      await _userRepository.updateUser(updatedUser);
    }

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'height': height,
      });
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
      state = AsyncValue.data({
        ...currentState,
        'gender': gender,
      });
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
      state = AsyncValue.data({
        ...currentState,
        'birthday': birthday,
      });
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
      state = AsyncValue.data({
        ...currentState,
        'weeklyWorkoutGoal': goal,
      });
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
      state = AsyncValue.data({
        ...currentState,
        'weightGoal': goal,
      });
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
      state = AsyncValue.data({
        ...currentState,
        'activityLevel': level,
      });
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
