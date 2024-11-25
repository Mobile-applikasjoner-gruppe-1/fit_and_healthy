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
  final String id;
  final String name;
  final ExerciseCategory exerciseCategory;
  final String info;
  const ExerciseInfoList({
    required this.id,
    required this.name,
    required this.exerciseCategory,
    required this.info,
  });

  factory ExerciseInfoList.fromFirebase(Map<String, dynamic> json) {
    if (json['id'] is! String) {
      throw TypeError();
    }
    if (json['name'] is! String) {
      throw TypeError();
    }
    if (json['exerciseCategory'] is! ExerciseCategory) {
      throw TypeError();
    }
    if (json['info'] is! String) {
      throw TypeError();
    }

    return ExerciseInfoList(
      id: json['id'],
      name: json['name'],
      exerciseCategory: json['exerciseCategory'],
      info: json['info'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'name': name,
      'exerciseCategory': exerciseCategory,
      'info': info,
    };
  }
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
  final String id;
  final ExerciseInfoList exerciseInfoList;
  final List<ExerciseSet> sets;
  final String? note;

  const Exercise({
    required this.id,
    required this.exerciseInfoList,
    required this.sets,
    this.note,
  });

  factory Exercise.fromFirebase(Map<String, dynamic> json) {
    if (json['id'] is! int) {
      throw TypeError();
    }
    if (json['exerciseInfoList'] is! ExerciseInfoList) {
      throw TypeError();
    }
    if (json['sets'] is! List) {
      throw TypeError();
    }

    return Exercise(
      id: json['id'],
      exerciseInfoList: json['exerciseInfoList'],
      sets: json['sets'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'name': exerciseInfoList.name,
      'exerciseCategory': exerciseInfoList.exerciseCategory,
      'info': exerciseInfoList.info,
      'note': note,
    };
    // TODO: Add sets as a subcollection
  }
}

class ExerciseOther {
  final String id;
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
  final String id;
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

  factory Workout.fromFirebase(Map<String, dynamic> json) {
    if (json['id'] is! String) {
      throw TypeError();
    }
    if (json['title'] is! String) {
      throw TypeError();
    }
    if (json['time'] is! String) {
      throw TypeError();
    }
    if (json['dateTime'] is! DateTime) {
      throw TypeError();
    }
    if (json['exercises'] is! List) {
      throw TypeError();
    }

    return Workout(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      dateTime: json['dateTime'],
      exercises: json['exercises'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'dateTime': dateTime,
      'exercises': exercises.map((e) => e.toFirebase()).toList(),
    };
  }
}
