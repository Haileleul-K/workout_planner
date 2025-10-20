import 'package:equatable/equatable.dart';
import 'exercise_model.dart';

/// Workout model representing a complete workout session
class WorkoutModel extends Equatable {
  final String workoutName;
  final List<ExerciseModel> exercises;

  const WorkoutModel({
    required this.workoutName,
    required this.exercises,
  });

  /// Create from JSON
  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    final exercisesList = json['exercises'] as List<dynamic>? ?? [];
    final exercises = exercisesList
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final exerciseJson = entry.value as Map<String, dynamic>;
          // Add unique ID based on index if not present
          if (!exerciseJson.containsKey('id')) {
            exerciseJson['id'] = 'exercise_$index';
          }
          return ExerciseModel.fromJson(exerciseJson);
        })
        .toList();

    return WorkoutModel(
      workoutName: json['workout_name'] ?? 'Untitled Workout',
      exercises: exercises,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'workout_name': workoutName,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  /// Copy with method for immutability
  WorkoutModel copyWith({
    String? workoutName,
    List<ExerciseModel>? exercises,
  }) {
    return WorkoutModel(
      workoutName: workoutName ?? this.workoutName,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object?> get props => [workoutName, exercises];
}

