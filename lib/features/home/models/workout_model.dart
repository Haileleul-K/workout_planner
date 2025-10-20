import 'package:equatable/equatable.dart';
import 'exercise_model.dart';
import 'exercise_state_model.dart';

/// Workout model representing a complete workout session
class WorkoutModel extends Equatable {
  final String workoutName;
  final List<ExerciseModel> exercises;

  const WorkoutModel({
    required this.workoutName,
    required this.exercises,
  });


  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    final exercisesList = json['exercises'] as List<dynamic>? ?? [];
    final exercises = exercisesList
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final exerciseJson = entry.value as Map<String, dynamic>;
          final base = ExerciseModel.fromJson(exerciseJson);
          return base.copyWith(
            exerciseState: ExerciseStateModel(exerciseIndex: index),
          );
        })
        .toList();

    return WorkoutModel(
      workoutName: json['workout_name'] ?? 'Untitled Workout',
      exercises: exercises,
    );
  }

 // me make this immutableee

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

