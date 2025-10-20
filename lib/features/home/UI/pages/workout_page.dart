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
import '../widgets/timer_widget.dart';
import '../widgets/primary_button_widget.dart';

/// Main workout page
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
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

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
                      onPressed: () => context.read<WorkoutCubit>().loadWorkout(),
                    ),
                  ],
                ),
              );
            }

            if (state.workout == null) {
              return const Center(
                child: Text('No workout data available'),
              );
            }

            return Column(
              children: [
                // Header
                _buildHeader(context, state),

                const SizedBox(height: AppSpacing.md),

                // Exercise List
                ExerciseListWidget(
                  exercises: state.exercises,
                  exerciseStates: state.exerciseStates,
                  onExerciseTap: (exerciseId) {
                    if (!state.isEditMode) {
                      context.read<WorkoutCubit>().selectExercise(exerciseId);
                    }
                  },
                  onExerciseLongPress: (exerciseId) {
                    if (!state.isEditMode) {
                      context.read<WorkoutCubit>().enterEditMode();
                    }
                  },
                  onEditTap: () {
                    context.read<WorkoutCubit>().enterEditMode();
                  },
                  isEditMode: state.isEditMode,
                  onRemoveExercise: state.isEditMode
                      ? (exerciseId) {
                          context.read<WorkoutCubit>().removeExercise(exerciseId);
                        }
                      : null,
                  onReorder: state.isEditMode
                      ? (oldIndex, newIndex) {
                          context
                              .read<WorkoutCubit>()
                              .reorderExercises(oldIndex, newIndex);
                        }
                      : null,
                ),

                const SizedBox(height: AppSpacing.md),

                // Exercise Details Panel or Edit Mode Actions
                Expanded(
                  child: state.isEditMode
                      ? _buildEditModeActions(context, state)
                      : (state.selectedExercise != null
                          ? _buildExerciseDetails(context, state)
                          : _buildEmptyState()),
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
              if (state.selectedExerciseId != null) {
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

          // Timer
          if (state.selectedExerciseId != null)
            TimerWidget(
              elapsedSeconds: state
                  .getExerciseState(state.selectedExerciseId!)
                  .elapsedSeconds,
            ),

          const SizedBox(width: AppSpacing.sm),

          // Stop button (when timer is running)
          if (state.selectedExerciseId != null)
            GestureDetector(
              onTap: () {
                // Add stop icon - pause/stop functionality
                context.read<WorkoutCubit>().deselectExercise();
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stop,
                  color: AppColors.surface,
                  size: AppSizes.iconSizeSmall,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseDetails(BuildContext context, WorkoutState state) {
    final exercise = state.selectedExercise!;
    final exerciseState = state.getExerciseState(exercise.id);

    return SingleChildScrollView(
      child: ExerciseDetailsPanel(
        exercise: exercise,
        exerciseState: exerciseState,
        onPlay: () {
          context.read<WorkoutCubit>().playExercise(exercise.id);
        },
        onPause: () {
          context.read<WorkoutCubit>().pauseExercise(exercise.id);
        },
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          
          // Edit mode instructions
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.editModeBackground,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: AppSizes.iconSizeLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Edit Mode',
                  style: AppTextStyles.headingMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Drag exercises to reorder or tap the minus button to remove',
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: PrimaryButtonWidget(
                  label: 'Discard',
                  isSecondary: true,
                  onPressed: () {
                    context.read<WorkoutCubit>().discardChanges();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PrimaryButtonWidget(
                  label: 'Save Changes',
                  isEnabled: state.hasChanges,
                  onPressed: state.hasChanges
                      ? () {
                          context.read<WorkoutCubit>().saveChanges();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

