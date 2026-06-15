import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_accent_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

class VitCompactProductCard extends StatelessWidget {
  const VitCompactProductCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.badgeLabel,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String? badgeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.homeMarketSectionGap,
        vertical: AppSpacing.x2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.homeRecentProductIcon,
                height: AppSpacing.homeRecentProductIcon,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: .14),
                  borderRadius: AppRadii.smRadius,
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: AppSpacing.homeRecentProductIconText,
                ),
              ),
              const Spacer(),
              if (badgeLabel != null)
                VitAccentPill(label: badgeLabel!, accentColor: accentColor),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.homeSectionInnerGap),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
