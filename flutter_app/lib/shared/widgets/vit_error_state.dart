import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

class VitErrorState extends StatelessWidget {
  const VitErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'Please try again or check your connection.',
    this.icon = Icons.warning_amber_rounded,
    this.iconContainerSize = 80,
    this.iconSize = 36,
    this.iconShape = BoxShape.rectangle,
    this.iconBorderRadius,
    this.verticalPadding = 64,
    this.horizontalPadding = AppSpacing.x6,
    this.titleStyle,
    this.messageStyle,
    this.actionLabel = 'Retry',
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final IconData icon;
  final double iconContainerSize;
  final double iconSize;
  final BoxShape iconShape;
  final BorderRadius? iconBorderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final String actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: BoxDecoration(
              color: AppColors.sell10,
              border: Border.all(color: AppColors.sell20),
              shape: iconShape,
              borderRadius: iconShape == BoxShape.circle
                  ? null
                  : iconBorderRadius ?? AppRadii.cardLargeRadius,
            ),
            child: Icon(icon, color: AppColors.sell, size: iconSize),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle ?? AppTextStyles.baseMedium,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            message,
            textAlign: TextAlign.center,
            style: messageStyle ?? AppTextStyles.caption,
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
