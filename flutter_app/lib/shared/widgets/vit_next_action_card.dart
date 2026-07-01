import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_accent_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

class VitNextActionCard extends StatelessWidget {
  const VitNextActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.ctaLabel,
    required this.accentColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String statusLabel;
  final String ctaLabel;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsetsDirectional.all(
        AppSpacing.homeNextActionCardPadding,
      ),
      borderColor: accentColor.withValues(alpha: .28),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.homeNextActionIconContainer,
            height: AppSpacing.homeNextActionIconContainer,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: accentColor.withValues(alpha: .14),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: accentColor,
                  size: AppSpacing.homeNextActionIconSize,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.homeCommandRowSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitAccentPill(label: statusLabel, accentColor: accentColor),
                  ],
                ),
                const SizedBox(height: AppSpacing.homeSectionInnerGap),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            ctaLabel,
            style: AppTextStyles.caption.copyWith(
              color: accentColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.homeChevronGap),
          Icon(
            Icons.chevron_right_rounded,
            color: accentColor,
            size: AppSpacing.homeActionChevronSize,
          ),
        ],
      ),
    );
  }
}
