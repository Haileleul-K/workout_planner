import 'package:equatable/equatable.dart';

/// Represents the playback state of an exercise
enum ExercisePlaybackState {
  idle,
  playing,
  paused,
  completed,
}

// Model to track individual exercise state during workout
class ExerciseStateModel extends Equatable {
  final int exerciseIndex;
  final bool isSelected;
  final ExercisePlaybackState playbackState;
  final int elapsedSeconds;
  final bool isCompleted;

  const ExerciseStateModel({
    required this.exerciseIndex,
    this.isSelected = false,
    this.playbackState = ExercisePlaybackState.idle,
    this.elapsedSeconds = 0,
    this.isCompleted = false,
  });

  /// Copy with method for state updates
  ExerciseStateModel copyWith({
    int? exerciseIndex,
    bool? isSelected,
    ExercisePlaybackState? playbackState,
    int? elapsedSeconds,
    bool? isCompleted,
  }) {
    return ExerciseStateModel(
      exerciseIndex: exerciseIndex ?? this.exerciseIndex,
      isSelected: isSelected ?? this.isSelected,
      playbackState: playbackState ?? this.playbackState,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        exerciseIndex,
        isSelected,
        playbackState,
        elapsedSeconds,
        isCompleted,
      ];
}

