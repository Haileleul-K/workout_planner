import 'package:flutter/material.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../models/exercise_model.dart';
import '../../models/exercise_state_model.dart';

/// Circular exercise item widget for the horizontal list
class ExerciseItemWidget extends StatelessWidget {
  final ExerciseModel exercise;
  final ExerciseStateModel exerciseState;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isEditMode;
  final VoidCallback? onRemove;

  const ExerciseItemWidget({
    Key? key,
    required this.exercise,
    required this.exerciseState,
    required this.onTap,
    this.onLongPress,
    this.isEditMode = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = exerciseState.isSelected;
    final isCompleted = exerciseState.isCompleted;
    final isPlaying =
        exerciseState.playbackState == ExercisePlaybackState.playing;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: SizedBox(
        width: AppSizes.exerciseItemSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Exercise Image Container
                Container(
                  padding: EdgeInsets.all(3),

                  decoration: BoxDecoration(
                    color: AppColors.border,
                    shape: BoxShape.circle,
                    border: Border.all(width: 2,  color: isSelected?AppColors.buttonPrimary: AppColors.surface),
                  ),
                  child: Container(
                    width: AppSizes.exerciseItemSize,
                    height: AppSizes.exerciseItemSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: AppColors.surface,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipOval(
                        child: Image.network(
                          isPlaying ? exercise.gifAssetUrl : exercise.assetUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.surfaceVariant,
                              child: const Icon(
                                Icons.fitness_center,
                                color: AppColors.textTertiary,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: AppColors.surfaceVariant,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Small badge at bottom-right: play when selected, check when completed
                Positioned(
                  bottom: 10,
                  right: 6,
                  child: () {
                    if (isCompleted) {
                      return Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.textPrimary,
                        ),
                      );
                    }
                    if (isSelected) {
                      return Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 14,
                          color: AppColors.textPrimary,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }(),
                ),

                // Remove button (edit mode)
                if (isEditMode && onRemove != null)
                  Positioned(
                    top: -2,
                    left: -2,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD32F2F),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
