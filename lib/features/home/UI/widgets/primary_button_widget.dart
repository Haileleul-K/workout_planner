import 'package:flutter/material.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';

/// Primary button widget for main actions
class PrimaryButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final IconData? icon;
  final bool isEnabled;

  const PrimaryButtonWidget({
    Key? key,
    required this.label,
    this.onPressed,
    this.isSecondary = false,
    this.icon,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isEnabled
        ? (isSecondary ? AppColors.surface : AppColors.buttonPrimary)
        : AppColors.buttonDisabled;
    
    final textColor = isEnabled
        ? AppColors.buttonTextPrimary
        : AppColors.buttonTextSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          height: AppSizes.buttonHeightSmall,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: isSecondary
                ? Border.all(color: AppColors.border, width: 1)
                : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppSizes.iconSizeSmall,
                  color: textColor,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: AppTextStyles.buttonMedium.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

