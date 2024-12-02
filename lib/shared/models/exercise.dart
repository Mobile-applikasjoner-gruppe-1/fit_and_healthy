import 'package:cloud_firestore/cloud_firestore.dart';

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

extension ExerciseCategoryExtension on ExerciseCategory {
  String toShortString() {
    return this.toString().split('.').last;
  }

  static ExerciseCategory fromShortString(String shortString) {
    return ExerciseCategory.values.firstWhere(
      (element) => element.toShortString() == shortString,
    );
  }
}

enum ExerciseSetType {
  warmup,
  dropset,
  tofailure,
}

extension ExerciseSetTypeExtension on ExerciseSetType {
  String toShortString() {
    return this.toString().split('.').last;
  }

  static ExerciseSetType fromShortString(String shortString) {
    return ExerciseSetType.values.firstWhere(
      (element) => element.toShortString() == shortString,
    );
  }
}

// Keep the information about predefined exercises, like bench press or squat.
class ExerciseInfoList {
  final String name;
  final ExerciseCategory exerciseCategory;
  final String info;
  const ExerciseInfoList({
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

  factory ExerciseSet.fromFirestore(Map<String, dynamic> json) {
    final repititions = json['repititions'];
    final weight = json['weight'];
    final exerciseSetType = json['exerciseSetType'] ?? null;

    if (repititions is! int) {
      throw Exception('Exercise set repititions is not an integer');
    }

    if (weight is! double) {
      throw Exception('Exercise set weight is not a double');
    }

    if (exerciseSetType != null && exerciseSetType is! String) {
      throw Exception('Exercise set type is not a string');
    }

    return ExerciseSet(
      repititions: repititions,
      weight: weight,
      exerciseSetType: exerciseSetType == null
          ? null
          : ExerciseSetTypeExtension.fromShortString(exerciseSetType),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'repititions': repititions,
      'weight': weight,
      'exerciseSetType': exerciseSetType?.toShortString(),
    };
  }
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

  factory Exercise.fromFirebase(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data();

    if (json == null) {
      throw Exception('Document data is null');
    }

    final id = doc.id;
    final name = json['name'];
    final exerciseCategory = json['exerciseCategory'];
    final info = json['info'];
    final note = json['note'];
    final sets = json['sets'];

    if (name is! String) {
      throw Exception('Exercise name is not a string');
    }

    if (exerciseCategory is! String) {
      throw Exception('Exercise category is not a string');
    }

    if (info is! String) {
      throw Exception('Exercise info is not a string');
    }

    if (note is! String) {
      throw Exception('Exercise note is not a string');
    }

    if (sets is! List) {
      throw Exception('Exercise sets is not a list');
    }

    final exerciseInfoList = ExerciseInfoList(
      name: name,
      exerciseCategory:
          ExerciseCategoryExtension.fromShortString(exerciseCategory),
      info: info,
    );

    final parsedSets = sets.map((e) => ExerciseSet.fromFirestore(e)).toList();

    return Exercise(
      id: id,
      exerciseInfoList: exerciseInfoList,
      sets: parsedSets,
      note: note,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'name': exerciseInfoList.name,
      'exerciseCategory': exerciseInfoList.exerciseCategory.toShortString(),
      'info': exerciseInfoList.info,
      'note': note,
      'sets': sets.map((e) => e.toFirestore()).toList(),
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
  final DateTime dateTime;
  List<Exercise> exercises;
  Workout({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.exercises,
  });

  factory Workout.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    if (data == null) {
      throw Exception('Document data is null');
    }

    final title = data['title'];
    final dateTime = data['dateTime'];

    if (title is! String) {
      throw Exception('Workout title is not a string');
    }
    if (dateTime is! Timestamp) {
      throw Exception('Workout dateTime is not a Timestamp');
    }

    return Workout(
        id: doc.id, title: title, dateTime: dateTime.toDate(), exercises: []);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'dateTime': dateTime,
    };
  }

  Workout copyOf({
    String? title,
    DateTime? dateTime,
    List<Exercise>? exercises,
  }) {
    return Workout(
      id: id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      exercises: exercises ?? this.exercises,
    );
  }
}
