import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'workout_state.dart';
import '../models/exercise_model.dart';
import '../models/exercise_state_model.dart';
import '../repository/workout_repo.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository _repository;
  Timer? _timer;

  WorkoutCubit(this._repository) : super(WorkoutState.initial());

  /// Load workout data
  Future<void> loadWorkout() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final workout = await _repository.getWorkout();

      emit(state.copyWith(
        workout: workout,
        exercises: workout.exercises,
        originalExercises: List.from(workout.exercises),
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
  void selectExercise(int index) {
    // Deselect all
    final updated = <ExerciseModel>[];
    for (var i = 0; i < state.exercises.length; i++) {
      final ex = state.exercises[i];
      updated.add(
        ex.copyWith(
          exerciseState: ex.exerciseState.copyWith(
            exerciseIndex: i,
            isSelected: i == index,
          ),
        ),
      );
    }

    emit(state.copyWith(
      exercises: updated,
      selectedExerciseIndex: index,
    ));

    // Auto start playing when selected
    playExercise(index);
  }

  /// Deselect exercise
  void deselectExercise() {
    // Stop timer if running
    _stopTimer();

    // Deselect all and pause any playing
    final updated = state.exercises
        .asMap()
        .entries
        .map((e) => e.value.copyWith(
              exerciseState: e.value.exerciseState.copyWith(
                exerciseIndex: e.key,
                isSelected: false,
                playbackState: e.value.exerciseState.playbackState ==
                        ExercisePlaybackState.playing
                    ? ExercisePlaybackState.paused
                    : e.value.exerciseState.playbackState,
              ),
            ))
        .toList();

    emit(state.copyWith(exercises: updated, clearSelectedExercise: true));
  }

  /// Play exercise
  void playExercise(int index) {
    final exercises = List<ExerciseModel>.from(state.exercises);
    final ex = exercises[index];
    exercises[index] = ex.copyWith(
      exerciseState: ex.exerciseState.copyWith(
        playbackState: ExercisePlaybackState.playing,
      ),
    );
    emit(state.copyWith(exercises: exercises));
    _startTimer(index);
  }

  /// Pause exercise
  void pauseExercise(int index) {
    _stopTimer();

    final exercises = List<ExerciseModel>.from(state.exercises);
    final ex = exercises[index];
    exercises[index] = ex.copyWith(
      exerciseState: ex.exerciseState.copyWith(
        playbackState: ExercisePlaybackState.paused,
      ),
    );
    emit(state.copyWith(exercises: exercises));
  }

  /// Start timer for exercise
  void _startTimer(int index) {
    _stopTimer();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final exercises = List<ExerciseModel>.from(state.exercises);
      final ex = exercises[index];
      final currentState = ex.exerciseState;
      final newElapsed = currentState.elapsedSeconds + 1;

      if (newElapsed >= 5) {
        exercises[index] = ex.copyWith(
          exerciseState: currentState.copyWith(
            elapsedSeconds: newElapsed,
            playbackState: ExercisePlaybackState.completed,
            isCompleted: true,
          ),
        );
        _stopTimer();
      } else {
        exercises[index] = ex.copyWith(
          exerciseState: currentState.copyWith(
            elapsedSeconds: newElapsed,
          ),
        );
      }

      emit(state.copyWith(exercises: exercises));
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
  void removeExercise(int index) {
    final exercises = List<ExerciseModel>.from(state.exercises)..removeAt(index);
    emit(state.copyWith(
      exercises: exercises,
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
    emit(state.copyWith(
      exercises: List.from(state.originalExercises),
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

