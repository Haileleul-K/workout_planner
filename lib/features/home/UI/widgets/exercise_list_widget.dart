import 'package:flutter/material.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../models/exercise_model.dart';
import '../../models/exercise_state_model.dart';
import 'exercise_item_widget.dart';
import 'edit_button_widget.dart';

/// Horizontal scrollable exercise list widget
class ExerciseListWidget extends StatelessWidget {
  final List<ExerciseModel> exercises;
  final Map<String, ExerciseStateModel> exerciseStates;
  final Function(String) onExerciseTap;
  final Function(String)? onExerciseLongPress;
  final VoidCallback onEditTap;
  final Function(String)? onRemoveExercise;
  final bool isEditMode;
  final Function(int, int)? onReorder;

  const ExerciseListWidget({
    Key? key,
    required this.exercises,
    required this.exerciseStates,
    required this.onExerciseTap,
    this.onExerciseLongPress,
    required this.onEditTap,
    this.onRemoveExercise,
    this.isEditMode = false,
    this.onReorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditMode && onReorder != null) {
      return _buildReorderableList();
    } else {
      return _buildScrollableList();
    }
  }

  Widget _buildScrollableList() {
    return SizedBox(
      height: AppSizes.exerciseItemSize + 40, // Item height + name space
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: exercises.length + 1, // +1 for edit button
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.exerciseItemSpacing),
        itemBuilder: (context, index) {
          if (index == exercises.length) {
            // Edit button at the end
            return EditButtonWidget(onTap: onEditTap);
          }

          final exercise = exercises[index];
          final exerciseState = exerciseStates[exercise.id] ??
              ExerciseStateModel(exerciseId: exercise.id);

          return ExerciseItemWidget(
            exercise: exercise,
            exerciseState: exerciseState,
            onTap: () => onExerciseTap(exercise.id),
            onLongPress: onExerciseLongPress != null
                ? () => onExerciseLongPress!(exercise.id)
                : null,
            isEditMode: isEditMode,
            onRemove: onRemoveExercise != null
                ? () => onRemoveExercise!(exercise.id)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildReorderableList() {
    return SizedBox(
      height: AppSizes.exerciseItemSize + 40,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: exercises.length,
        onReorder: (oldIndex, newIndex) {
          if (onReorder != null) {
            onReorder!(oldIndex, newIndex);
          }
        },
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return Material(
                elevation: 0,
                color: Colors.transparent,
                child: child,
              );
            },
            child: child,
          );
        },
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          final exerciseState = exerciseStates[exercise.id] ??
              ExerciseStateModel(exerciseId: exercise.id);

          return Padding(
            key: ValueKey(exercise.id),
            padding: EdgeInsets.only(
              right: index < exercises.length - 1
                  ? AppSpacing.exerciseItemSpacing
                  : 0,
            ),
            child: ExerciseItemWidget(
              exercise: exercise,
              exerciseState: exerciseState,
              onTap: () => onExerciseTap(exercise.id),
              isEditMode: isEditMode,
              onRemove: onRemoveExercise != null
                  ? () => onRemoveExercise!(exercise.id)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

