import 'package:flutter/material.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../models/exercise_model.dart';
// Removed direct state import; state is embedded in ExerciseModel
import 'exercise_item_widget.dart';
import 'edit_button_widget.dart';

/// Horizontal scrollable exercise list widget
class ExerciseListWidget extends StatelessWidget {
  final List<ExerciseModel> exercises;
  final Function(int) onExerciseTap;
  final Function(int)? onExerciseLongPress;
  final VoidCallback onEditTap;
  final Function(int)? onRemoveExercise;
  final bool isEditMode;
  final Function(int, int)? onReorder;

  const ExerciseListWidget({
    Key? key,
    required this.exercises,
    required this.onExerciseTap,
    this.onExerciseLongPress,
    required this.onEditTap,
    this.onRemoveExercise,
    this.isEditMode = false,
    this.onReorder,
  }) : super(key: key);


  //we will have two build methods, one for the scrollable list and one for the reorderable list
  //the scrollable list will be used to show the exercises in a horizontal scrollable list
  //the reorderable list will be used to show the exercises in a horizontal scrollable list with drag and drop functionality

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
          final exerciseState = exercise.exerciseState;

          return ExerciseItemWidget(
            exercise: exercise,
            exerciseState: exerciseState,
            onTap: () => onExerciseTap(index),
            onLongPress: onExerciseLongPress != null
                ? () => onExerciseLongPress!(index)
                : null,
            isEditMode: isEditMode,
            onRemove: onRemoveExercise != null
                ? () => onRemoveExercise!(index)
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
        physics: const AlwaysScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
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
              final t = Curves.easeInOut.transform(animation.value);
              final scale = 1.0 + (t * 0.1);
              return Transform.scale(
                scale: scale,
                child: Material(
                  elevation: 4 * t,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.exerciseItemSize / 2),
                  child: Opacity(
                    opacity: 0.85 + (0.15 * (1 - t)),
                    child: child,
                  ),
                ),
              );
            },
            child: child,
          );
        },
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          final exerciseState = exercise.exerciseState;

          return ReorderableDragStartListener(
            key: ValueKey('exercise_$index'),
            index: index,
            child: Padding(
              padding: EdgeInsets.only(
                right: index < exercises.length - 1
                    ? AppSpacing.exerciseItemSpacing
                    : 0,
              ),
              child: ExerciseItemWidget(
                exercise: exercise,
                exerciseState: exerciseState,
                onTap: () => onExerciseTap(index),
                isEditMode: isEditMode,
                onRemove: onRemoveExercise != null
                    ? () => onRemoveExercise!(index)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}

