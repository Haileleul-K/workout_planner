import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'workout_state.dart';
import '../models/exercise_model.dart';
import '../models/exercise_state_model.dart';
import '../repository/workout_repo.dart';

/// Cubit for managing workout state
class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository _repository;
  Timer? _timer;

  WorkoutCubit(this._repository) : super(WorkoutState.initial());

  /// Load workout data
  Future<void> loadWorkout() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final workout = await _repository.getWorkout();
      
      // Initialize exercise states
      final exerciseStates = <String, ExerciseStateModel>{};
      for (final exercise in workout.exercises) {
        exerciseStates[exercise.id] = ExerciseStateModel(
          exerciseId: exercise.id,
        );
      }

      emit(state.copyWith(
        workout: workout,
        exercises: workout.exercises,
        originalExercises: List.from(workout.exercises),
        exerciseStates: exerciseStates,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load workout: $e',
      ));
    }
  }

  /// Select an exercise
  void selectExercise(String exerciseId) {
    final currentState = state.getExerciseState(exerciseId);
    
    // Deselect all exercises
    final updatedStates = <String, ExerciseStateModel>{};
    for (final entry in state.exerciseStates.entries) {
      updatedStates[entry.key] = entry.value.copyWith(isSelected: false);
    }
    
    // Select the target exercise
    updatedStates[exerciseId] = currentState.copyWith(isSelected: true);

    emit(state.copyWith(
      selectedExerciseId: exerciseId,
      exerciseStates: updatedStates,
    ));
  }

  /// Deselect exercise
  void deselectExercise() {
    // Stop timer if running
    _stopTimer();

    // Deselect all exercises
    final updatedStates = <String, ExerciseStateModel>{};
    for (final entry in state.exerciseStates.entries) {
      updatedStates[entry.key] = entry.value.copyWith(
        isSelected: false,
        playbackState: entry.value.playbackState == ExercisePlaybackState.playing
            ? ExercisePlaybackState.paused
            : entry.value.playbackState,
      );
    }

    emit(state.copyWith(
      exerciseStates: updatedStates,
      clearSelectedExercise: true,
    ));
  }

  /// Play exercise
  void playExercise(String exerciseId) {
    final currentState = state.getExerciseState(exerciseId);
    
    final updatedStates = Map<String, ExerciseStateModel>.from(state.exerciseStates);
    updatedStates[exerciseId] = currentState.copyWith(
      playbackState: ExercisePlaybackState.playing,
    );

    emit(state.copyWith(exerciseStates: updatedStates));
    
    // Start timer
    _startTimer(exerciseId);
  }

  /// Pause exercise
  void pauseExercise(String exerciseId) {
    _stopTimer();

    final currentState = state.getExerciseState(exerciseId);
    final updatedStates = Map<String, ExerciseStateModel>.from(state.exerciseStates);
    updatedStates[exerciseId] = currentState.copyWith(
      playbackState: ExercisePlaybackState.paused,
    );

    emit(state.copyWith(exerciseStates: updatedStates));
  }

  /// Start timer for exercise
  void _startTimer(String exerciseId) {
    _stopTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state.getExerciseState(exerciseId);
      final newElapsed = currentState.elapsedSeconds + 1;

      final updatedStates = Map<String, ExerciseStateModel>.from(state.exerciseStates);
      
      // Check if 5 seconds elapsed
      if (newElapsed >= 5) {
        updatedStates[exerciseId] = currentState.copyWith(
          elapsedSeconds: newElapsed,
          playbackState: ExercisePlaybackState.completed,
          isCompleted: true,
        );
        _stopTimer();
      } else {
        updatedStates[exerciseId] = currentState.copyWith(
          elapsedSeconds: newElapsed,
        );
      }

      emit(state.copyWith(exerciseStates: updatedStates));
    });
  }

  /// Stop timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Enter edit mode
  void enterEditMode() {
    emit(state.copyWith(
      isEditMode: true,
      hasChanges: false,
      clearSelectedExercise: true,
    ));
  }

  /// Exit edit mode
  void exitEditMode() {
    emit(state.copyWith(
      isEditMode: false,
      hasChanges: false,
    ));
  }

  /// Reorder exercises
  void reorderExercises(int oldIndex, int newIndex) {
    final exercises = List<ExerciseModel>.from(state.exercises);
    
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final item = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, item);

    emit(state.copyWith(
      exercises: exercises,
      hasChanges: true,
    ));
  }

  /// Remove exercise
  void removeExercise(String exerciseId) {
    final exercises = state.exercises.where((e) => e.id != exerciseId).toList();
    final updatedStates = Map<String, ExerciseStateModel>.from(state.exerciseStates);
    updatedStates.remove(exerciseId);

    emit(state.copyWith(
      exercises: exercises,
      exerciseStates: updatedStates,
      hasChanges: true,
    ));
  }

  /// Save changes
  void saveChanges() {
    final updatedWorkout = state.workout?.copyWith(
      exercises: state.exercises,
    );

    emit(state.copyWith(
      workout: updatedWorkout,
      originalExercises: List.from(state.exercises),
      isEditMode: false,
      hasChanges: false,
    ));
  }

  /// Discard changes
  void discardChanges() {
    // Restore exercise states for original exercises
    final exerciseStates = <String, ExerciseStateModel>{};
    for (final exercise in state.originalExercises) {
      exerciseStates[exercise.id] = state.exerciseStates[exercise.id] ??
          ExerciseStateModel(exerciseId: exercise.id);
    }

    emit(state.copyWith(
      exercises: List.from(state.originalExercises),
      exerciseStates: exerciseStates,
      isEditMode: false,
      hasChanges: false,
    ));
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}

