enum ExerciseCategory {
  back,
  chest,
  shoulders,
  triceps,
  biceps,
  forearm,
  core,
  legs,
}

enum ExerciseSetType {
  warmup,
  dropset,
  tofailure,
}

// Keep the information about predefined exercises, like bench press or squat.
class ExerciseInfoList {
  final int id;
  final String name;
  final ExerciseCategory exerciseCategory;
  final String info;
  const ExerciseInfoList({
    required this.id,
    required this.name,
    required this.exerciseCategory,
    required this.info,
  });
}

// Keep information about the sets repitition, weigth, and if it is a special set
class ExerciseSet {
  final int repititions;
  final double weight;
  final ExerciseSetType? exerciseSetType;
  const ExerciseSet({
    required this.repititions,
    required this.weight,
    this.exerciseSetType,
  });
}

// The main Exercise
class Exercise {
  final int id;
  final ExerciseInfoList exerciseInfoList;
  final List<ExerciseSet> sets;
  final String? note;

  const Exercise({
    required this.id,
    required this.exerciseInfoList,
    required this.sets,
    this.note,
  });
}

class ExerciseOther {
  final int id;
  final int length;
  final String time;
  final int intensity;
  const ExerciseOther({
    required this.id,
    required this.length,
    required this.time,
    required this.intensity,
  });
}

// A single workout keeping track of a whole strength workout.
class Workout {
  final int id;
  final String title;
  final String time;
  final DateTime dateTime;
  final List<Exercise> exercises;
  const Workout({
    required this.id,
    required this.title,
    required this.time,
    required this.dateTime,
    required this.exercises,
  });
}
