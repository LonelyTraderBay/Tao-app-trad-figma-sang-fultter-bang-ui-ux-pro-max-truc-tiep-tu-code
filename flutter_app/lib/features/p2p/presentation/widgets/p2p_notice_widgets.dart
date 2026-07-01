import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class P2PNoticeCard extends StatelessWidget {
  const P2PNoticeCard({
    super.key,
    required this.icon,
    required this.message,
    this.title,
    this.iconColor = AppModuleAccents.p2p,
    this.titleColor,
    this.messageColor = AppColors.text2,
    this.borderColor,
    this.variant = VitCardVariant.inner,
    this.radius = VitCardRadius.standard,
    this.padding = AppSpacing.p2pDisputeCardPadding,
    this.iconSize = AppSpacing.iconSm,
    this.titleStyle,
    this.messageStyle,
  });

  final IconData icon;
  final String? title;
  final String message;
  final Color iconColor;
  final Color? titleColor;
  final Color messageColor;
  final Color? borderColor;
  final VitCardVariant variant;
  final VitCardRadius radius;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  @override
  Widget build(BuildContext context) {
    final titleText = title;

    return VitCard(
      variant: variant,
      radius: radius,
      borderColor: borderColor,
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: iconSize),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (titleText != null) ...[
                  Text(
                    titleText,
                    style:
                        titleStyle ??
                        AppTextStyles.caption.copyWith(
                          color: titleColor ?? iconColor,
                          fontWeight: AppTextStyles.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                ],
                Text(
                  message,
                  style:
                      messageStyle ??
                      AppTextStyles.micro.copyWith(
                        color: messageColor,
                        height: AppSpacing.p2pDisputeReadableLineHeight,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class P2PHelpBullet extends StatelessWidget {
  const P2PHelpBullet({
    super.key,
    required this.text,
    this.iconColor = AppModuleAccents.p2p,
    this.textStyle,
  });

  final String text;
  final Color iconColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.p2pDisputeNoticeIconPadding,
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: iconColor,
            size: AppSpacing.p2pDisputeNoticeBulletIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style:
                textStyle ??
                AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}
