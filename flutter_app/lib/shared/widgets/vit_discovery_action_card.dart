import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';

enum VitDiscoveryActionCardVariant { standard, compact }

class VitDiscoveryActionCard extends StatelessWidget {
  const VitDiscoveryActionCard({
    super.key,
    required this.title,
    required this.badgeLabel,
    required this.subtitle,
    required this.actionLabel,
    required this.icon,
    required this.accentColor,
    required this.borderColor,
    required this.background,
    required this.onTap,
    this.badgeStatus = VitStatusPillStatus.purple,
    this.variant = VitDiscoveryActionCardVariant.standard,
  });

  final String title;
  final String badgeLabel;
  final String subtitle;
  final String actionLabel;
  final IconData icon;
  final Color accentColor;
  final Color borderColor;
  final Gradient background;
  final VoidCallback onTap;
  final VitStatusPillStatus badgeStatus;
  final VitDiscoveryActionCardVariant variant;

  _DiscoveryCardMetrics get _metrics {
    return switch (variant) {
      VitDiscoveryActionCardVariant.standard => const _DiscoveryCardMetrics(
        padding: AppSpacing.cardPadding,
        iconContainerSize: AppSpacing.homeDiscoveryIconContainer,
        iconSize: AppSpacing.homeDiscoveryIconSize,
        titleStyle: AppTextStyles.body,
        showActionLabel: true,
      ),
      VitDiscoveryActionCardVariant.compact => const _DiscoveryCardMetrics(
        padding: AppSpacing.homeDiscoveryCompactPadding,
        iconContainerSize: AppSpacing.homeDiscoveryCompactIconContainer,
        iconSize: AppSpacing.homeDiscoveryCompactIconSize,
        titleStyle: AppTextStyles.caption,
        showActionLabel: true,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics;
    return VitCard(
      onTap: onTap,
      borderColor: borderColor,
      padding: metrics.padding,
      child: Row(
        children: [
          SizedBox(
            width: metrics.iconContainerSize,
            height: metrics.iconContainerSize,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                gradient: background,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
              ),
              child: Center(
                child: Icon(icon, color: accentColor, size: metrics.iconSize),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.homeMarketIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: metrics.titleStyle.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    VitStatusPill(
                      label: badgeLabel,
                      status: badgeStatus,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                if (metrics.showActionLabel) ...[
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    actionLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: accentColor,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: accentColor,
            size: AppSpacing.homeSectionActionChevronSize,
          ),
        ],
      ),
    );
  }
}

class _DiscoveryCardMetrics {
  const _DiscoveryCardMetrics({
    required this.padding,
    required this.iconContainerSize,
    required this.iconSize,
    required this.titleStyle,
    required this.showActionLabel,
  });

  final EdgeInsetsGeometry padding;
  final double iconContainerSize;
  final double iconSize;
  final TextStyle titleStyle;
  final bool showActionLabel;
}
