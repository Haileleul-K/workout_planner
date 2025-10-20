import 'package:equatable/equatable.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../models/exercise_state_model.dart';

/// Workout screen state
class WorkoutState extends Equatable {
  final WorkoutModel? workout;
  final List<ExerciseModel> exercises;
  final List<ExerciseModel> originalExercises;
  final int? selectedExerciseIndex;
  final bool isEditMode;
  final bool hasChanges;
  final bool isLoading;
  final String? error;

  const WorkoutState({
    this.workout,
    this.exercises = const [],
    this.originalExercises = const [],
    this.selectedExerciseIndex,
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

  /// Get state for a specific exercise by index
  ExerciseStateModel getExerciseState(int index) {
    if (index < 0 || index >= exercises.length) {
      return ExerciseStateModel(exerciseIndex: index);
    }
    return exercises[index].exerciseState;
  }

  /// Get selected exercise
  ExerciseModel? get selectedExercise {
    if (selectedExerciseIndex == null) return null;
    final i = selectedExerciseIndex!;
    if (i < 0 || i >= exercises.length) return null;
    return exercises[i];
  }

  /// Check if exercise is completed
  bool isExerciseCompleted(int index) {
    return getExerciseState(index).isCompleted;
  }

  /// Copy with method
  WorkoutState copyWith({
    WorkoutModel? workout,
    List<ExerciseModel>? exercises,
    List<ExerciseModel>? originalExercises,
    int? selectedExerciseIndex,
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
      selectedExerciseIndex: clearSelectedExercise
          ? null
          : (selectedExerciseIndex ?? this.selectedExerciseIndex),
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
        selectedExerciseIndex,
        isEditMode,
        hasChanges,
        isLoading,
        error,
      ];
}

