import 'package:flutter/material.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../models/exercise_model.dart';
// Removed direct state import; state is embedded in ExerciseModel
import 'exercise_item_widget.dart';
// import 'edit_button_widget.dart';

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
    return _buildReorderableList();
  }


  Widget _buildReorderableList() {
    return SizedBox(
      height: AppSizes.exerciseItemSize + 30,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: exercises.length,
        onReorderStart: (index) {
          // Enter edit mode as soon as the user long-presses to start a drag
          if (!isEditMode && onExerciseLongPress != null) {
            onExerciseLongPress!(index);
          }
        },
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
                  //elevation: 4 * t,
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

          return ReorderableDelayedDragStartListener(
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

