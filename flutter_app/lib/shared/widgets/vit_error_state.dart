import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import 'vit_cta_button.dart';

class VitErrorState extends StatelessWidget {
  const VitErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'Please try again or check your connection.',
    this.icon = Icons.warning_amber_rounded,
    this.actionLabel = 'Retry',
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final IconData icon;
  final String actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x6,
        vertical: 64,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.sell10,
              border: Border.all(color: AppColors.sell20),
              borderRadius: AppRadii.cardLargeRadius,
            ),
            child: Icon(icon, color: AppColors.sell, size: 36),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
          if (onAction != null) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCtaButton(
              onPressed: onAction,
              variant: VitCtaButtonVariant.danger,
              fullWidth: false,
              height: 44,
              leading: const Icon(Icons.refresh_rounded),
              child: Text(actionLabel),
            ),
          ],
          if (secondaryLabel != null && onSecondary != null) ...[
            const SizedBox(height: AppSpacing.x3),
            VitCtaButton(
              onPressed: onSecondary,
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: 44,
              child: Text(secondaryLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
