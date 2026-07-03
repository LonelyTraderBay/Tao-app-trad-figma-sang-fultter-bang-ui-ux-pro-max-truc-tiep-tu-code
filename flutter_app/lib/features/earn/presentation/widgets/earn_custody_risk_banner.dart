import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Shared info banner for earn/savings flows (icon + body in inner VitCard).
class EarnInfoBanner extends StatelessWidget {
  const EarnInfoBanner({
    super.key,
    required this.text,
    this.icon = Icons.info_outline_rounded,
    this.color = AppColors.primary,
    this.lineHeight,
  });

  final String text;
  final IconData icon;
  final Color color;
  final double? lineHeight;

  @override
  Widget build(BuildContext context) {
    return EarnToneBanner(
      text: text,
      icon: icon,
      color: color,
      lineHeight: lineHeight,
    );
  }
}

/// Warning-tone variant for risk and maturity disclosures.
class EarnWarningBanner extends StatelessWidget {
  const EarnWarningBanner({
    super.key,
    required this.text,
    this.lineHeight,
  });

  final String text;
  final double? lineHeight;

  @override
  Widget build(BuildContext context) {
    return EarnToneBanner(
      text: text,
      icon: Icons.warning_amber_rounded,
      color: AppColors.warn,
      lineHeight: lineHeight,
    );
  }
}

/// Ghost disclaimer card used at the bottom of earn mega-flows.
class EarnDisclaimerBanner extends StatelessWidget {
  const EarnDisclaimerBanner({
    super.key,
    required this.text,
    this.lineHeight,
    this.icon = Icons.info_outline_rounded,
    this.iconColor = AppColors.warn,
    this.borderColor = AppColors.warningBorder,
  });

  final String text;
  final double? lineHeight;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: borderColor,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: lineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custody / risk inner-card banner (title optional).
class EarnCustodyRiskBanner extends StatelessWidget {
  const EarnCustodyRiskBanner({
    super.key,
    required this.body,
    this.title,
    this.icon = Icons.shield_outlined,
    this.color = AppColors.buy,
    this.borderColor,
  });

  final String body;
  final String? title;
  final IconData icon;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor ?? color.withValues(alpha: 0.2),
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(title!, style: AppTextStyles.baseMedium),
                  const SizedBox(height: AppSpacing.x2),
                ],
                Text(
                  body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingCustodyBodyLineHeight,
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

class EarnToneBanner extends StatelessWidget {
  const EarnToneBanner({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    this.lineHeight,
  });

  final String text;
  final IconData icon;
  final Color color;
  final double? lineHeight;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: color.withValues(alpha: 0.2),
      padding: AppSpacing.earnPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: lineHeight == null ? color : AppColors.text2,
                height: lineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
