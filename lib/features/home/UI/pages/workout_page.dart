import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../../bloc/workout_cubit.dart';
import '../../bloc/workout_state.dart';
import '../../repository/workout_repo.dart';
import '../widgets/exercise_list_widget.dart';
import '../widgets/exercise_details_panel.dart';
import '../widgets/primary_button_widget.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutCubit(WorkoutRepository())..loadWorkout(),
      child: const _WorkoutPageContent(),
    );
  }
}

class _WorkoutPageContent extends StatelessWidget {
  const _WorkoutPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            ////If we get an error, we show a error message and a retry button
            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      state.error!,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButtonWidget(
                      label: 'Retry',
                      onPressed: () =>
                          context.read<WorkoutCubit>().loadWorkout(),
                    ),
                  ],
                ),
              );
            }

            ////If we don't have a workout, we show a message
            if (state.workout == null) {
              return const Center(child: Text('No workout data available'));
            }

            ////If we have a workout, we show the workout page
            return Column(
              children: [
                // Header
                _buildHeader(context, state),

                const SizedBox(height: AppSpacing.md),

                // Exercise List which is a horizontal scrollable list of exercises
                ExerciseListWidget(
                  exercises: state.exercises,
                  onExerciseTap: (index) {
                    if (!state.isEditMode) {
                      context.read<WorkoutCubit>().selectExercise(index);
                    }
                  },
                  onExerciseLongPress: (index) {
                    if (!state.isEditMode) {
                      context.read<WorkoutCubit>().enterEditMode();
                    }
                  },
                  onEditTap: () {
                    context.read<WorkoutCubit>().enterEditMode();
                  },
                  isEditMode: state.isEditMode,
                  onRemoveExercise: state.isEditMode
                      ? (index) {
                          context.read<WorkoutCubit>().removeExercise(index);
                        }
                      : null,
                  onReorder: state.isEditMode
                      ? (oldIndex, newIndex) {
                          context.read<WorkoutCubit>().reorderExercises(
                            oldIndex,
                            newIndex,
                          );
                        }
                      : null,
                ),

                const SizedBox(height: AppSpacing.md),

                // Exercise Details Panel or Edit Mode Actions
                Expanded(
                  child: Stack(
                    children: [
                      state.selectedExercise != null
                          ? _buildExerciseDetails(
                              context,
                              state,
                              showReplace: !state.isEditMode,
                            )
                          : _buildEmptyState(),
                      if (state.isEditMode)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: _buildEditModeActions(context, state),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WorkoutState state) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.surface,
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () {
              if (state.selectedExerciseIndex != null) {
                context.read<WorkoutCubit>().deselectExercise();
              } else {
                Navigator.of(context).maybePop();
              }
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: AppSizes.iconSizeMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Workout name
          Expanded(
            child: Text(
              state.workout?.workoutName ?? 'Workout',
              style: AppTextStyles.headingLarge,
            ),
          ),

          // Timer with Stop button in one black container
          if (state.selectedExerciseIndex != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(
                      state
                          .getExerciseState(state.selectedExerciseIndex!)
                          .elapsedSeconds,
                    ),
                    style: AppTextStyles.timer.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      context.read<WorkoutCubit>().deselectExercise();
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.stop_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseDetails(
    BuildContext context,
    WorkoutState state, {
    bool showReplace = true,
  }) {
    final exercise = state.selectedExercise!;
    final exerciseState = exercise.exerciseState;

    return SingleChildScrollView(
      child: ExerciseDetailsPanel(
        exercise: exercise,
        exerciseState: exerciseState,
        onPlay: () {
          context.read<WorkoutCubit>().playExercise(
            state.selectedExerciseIndex!,
          );
        },
        onPause: () {
          context.read<WorkoutCubit>().pauseExercise(
            state.selectedExerciseIndex!,
          );
        },
        showReplace: showReplace,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Select an exercise to begin',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditModeActions(BuildContext context, WorkoutState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 16,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: _pillButton(
                label: 'Discard',
                background: AppColors.surface,
                textColor: AppColors.textPrimary,
                onTap: () {
                  context.read<WorkoutCubit>().discardChanges();
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _pillButton(
                label: 'Save Changes',
                background: state.hasChanges
                    ? AppColors.primary
                    : AppColors.buttonDisabled,
                textColor: AppColors.buttonTextPrimary,
                onTap: state.hasChanges
                    ? () {
                        context.read<WorkoutCubit>().saveChanges();
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pillButton({
    required String label,
    required Color background,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
          border: background == AppColors.surface
              ? Border.all(color: AppColors.border)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.buttonLarge.copyWith(color: textColor),
        ),
      ),
    );
  }

  ///Need to check GPT done for this function

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }
}
