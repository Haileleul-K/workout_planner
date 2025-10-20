import 'package:equatable/equatable.dart';

/// Represents the playback state of an exercise
enum ExercisePlaybackState {
  idle,
  playing,
  paused,
  completed,
}

/// Model to track individual exercise state during workout
class ExerciseStateModel extends Equatable {
  final String exerciseId;
  final bool isSelected;
  final ExercisePlaybackState playbackState;
  final int elapsedSeconds;
  final bool isCompleted;

  const ExerciseStateModel({
    required this.exerciseId,
    this.isSelected = false,
    this.playbackState = ExercisePlaybackState.idle,
    this.elapsedSeconds = 0,
    this.isCompleted = false,
  });

  /// Copy with method for state updates
  ExerciseStateModel copyWith({
    String? exerciseId,
    bool? isSelected,
    ExercisePlaybackState? playbackState,
    int? elapsedSeconds,
    bool? isCompleted,
  }) {
    return ExerciseStateModel(
      exerciseId: exerciseId ?? this.exerciseId,
      isSelected: isSelected ?? this.isSelected,
      playbackState: playbackState ?? this.playbackState,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        exerciseId,
        isSelected,
        playbackState,
        elapsedSeconds,
        isCompleted,
      ];
}

