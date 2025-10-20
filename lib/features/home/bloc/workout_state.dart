import 'package:equatable/equatable.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../models/exercise_state_model.dart';

/// Workout screen state
class WorkoutState extends Equatable {
  final WorkoutModel? workout;
  final List<ExerciseModel> exercises;
  final List<ExerciseModel> originalExercises;
  final Map<String, ExerciseStateModel> exerciseStates;
  final String? selectedExerciseId;
  final bool isEditMode;
  final bool hasChanges;
  final bool isLoading;
  final String? error;

  const WorkoutState({
    this.workout,
    this.exercises = const [],
    this.originalExercises = const [],
    this.exerciseStates = const {},
    this.selectedExerciseId,
    this.isEditMode = false,
    this.hasChanges = false,
    this.isLoading = false,
    this.error,
  });

  /// Initial state
  factory WorkoutState.initial() {
    return const WorkoutState(
      isLoading: true,
    );
  }

  /// Get state for a specific exercise
  ExerciseStateModel getExerciseState(String exerciseId) {
    return exerciseStates[exerciseId] ??
        ExerciseStateModel(exerciseId: exerciseId);
  }

  /// Get selected exercise
  ExerciseModel? get selectedExercise {
    if (selectedExerciseId == null) return null;
    try {
      return exercises.firstWhere((e) => e.id == selectedExerciseId);
    } catch (_) {
      return null;
    }
  }

  /// Check if exercise is completed
  bool isExerciseCompleted(String exerciseId) {
    return exerciseStates[exerciseId]?.isCompleted ?? false;
  }

  /// Copy with method
  WorkoutState copyWith({
    WorkoutModel? workout,
    List<ExerciseModel>? exercises,
    List<ExerciseModel>? originalExercises,
    Map<String, ExerciseStateModel>? exerciseStates,
    String? selectedExerciseId,
    bool? isEditMode,
    bool? hasChanges,
    bool? isLoading,
    String? error,
    bool clearSelectedExercise = false,
    bool clearError = false,
  }) {
    return WorkoutState(
      workout: workout ?? this.workout,
      exercises: exercises ?? this.exercises,
      originalExercises: originalExercises ?? this.originalExercises,
      exerciseStates: exerciseStates ?? this.exerciseStates,
      selectedExerciseId: clearSelectedExercise
          ? null
          : (selectedExerciseId ?? this.selectedExerciseId),
      isEditMode: isEditMode ?? this.isEditMode,
      hasChanges: hasChanges ?? this.hasChanges,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        workout,
        exercises,
        originalExercises,
        exerciseStates,
        selectedExerciseId,
        isEditMode,
        hasChanges,
        isLoading,
        error,
      ];
}

