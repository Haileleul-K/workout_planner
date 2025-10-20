import 'package:flutter/material.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../../../../core/design_system/app_assets.dart';

/// Equipment badge widget showing equipment type with icon
class EquipmentBadgeWidget extends StatelessWidget {
  final String equipment;

  const EquipmentBadgeWidget({
    Key? key,
    required this.equipment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.equipmentBadge,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssets.getEquipmentIcon(equipment),
            width: AppSizes.equipmentIconSize,
            height: AppSizes.equipmentIconSize,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.fitness_center,
                size: AppSizes.equipmentIconSize,
                color: AppColors.equipmentText,
              );
            },
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            AppAssets.getEquipmentDisplayName(equipment),
            style: AppTextStyles.equipmentLabel,
          ),
        ],
      ),
    );
  }
}

