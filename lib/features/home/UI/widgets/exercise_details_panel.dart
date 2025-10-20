import 'package:flutter/material.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../../models/exercise_model.dart';
import '../../models/exercise_state_model.dart';
import 'equipment_badge_widget.dart';
import 'action_button_widget.dart';

/// Exercise details panel showing selected exercise information
class ExerciseDetailsPanel extends StatelessWidget {
  final ExerciseModel exercise;
  final ExerciseStateModel exerciseState;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final bool showReplace;

  const ExerciseDetailsPanel({
    Key? key,
    required this.exercise,
    required this.exerciseState,
    required this.onPlay,
    required this.onPause,
    this.showReplace = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPlaying = exerciseState.playbackState == ExercisePlaybackState.playing;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Name with Edit/Replace button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  exercise.name,
                  style: AppTextStyles.exerciseTitle,
                ),
              ),
              if (showReplace)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.swap_horiz,
                        size: AppSizes.iconSizeSmall,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Replace',
                        style: AppTextStyles.buttonSmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Exercise Image in card
          Container(
            width: double.infinity,
            height: AppSizes.exerciseImageSize,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              isPlaying ? exercise.gifAssetUrl : exercise.assetUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.surfaceVariant,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Equipment Badge
          EquipmentBadgeWidget(equipment: exercise.equipment),
          const SizedBox(height: AppSpacing.md),

          // Action Buttons
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              ActionButtonWidget(
                icon: Icons.description_outlined,
                label: 'Instructions',
              ),
              ActionButtonWidget(
                icon: Icons.whatshot_outlined,
                label: 'Warm Up',
              ),
              ActionButtonWidget(
                icon: Icons.help_outline,
                label: 'FAQ',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

