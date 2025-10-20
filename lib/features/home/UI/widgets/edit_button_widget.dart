import 'package:flutter/material.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';

/// Edit button widget for the exercise list
class EditButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const EditButtonWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.exerciseItemSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.exerciseItemSize,
              height: AppSizes.exerciseItemSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                  width: 1.5,
                ),
                color: AppColors.surface,
              ),
              child: const Icon(
                Icons.edit,
                color: AppColors.textSecondary,
                size: AppSizes.iconSizeLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Edit',
              style: AppTextStyles.exerciseName,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

