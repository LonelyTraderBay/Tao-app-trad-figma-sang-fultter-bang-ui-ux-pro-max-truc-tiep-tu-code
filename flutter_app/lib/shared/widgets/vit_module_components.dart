import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

enum VitServiceTileDensity { compact, standard }

extension VitServiceTileDensitySpacing on VitServiceTileDensity {
  double get iconContainer {
    return switch (this) {
      VitServiceTileDensity.compact =>
        AppSpacing.serviceTileIconContainerCompact,
      VitServiceTileDensity.standard => AppSpacing.serviceTileIconContainer,
    };
  }

  double get iconSize {
    return switch (this) {
      VitServiceTileDensity.compact => AppSpacing.serviceTileIconSizeCompact,
      VitServiceTileDensity.standard => AppSpacing.serviceTileIconSize,
    };
  }

  double get padding {
    return switch (this) {
      VitServiceTileDensity.compact =>
        AppSpacing.serviceTileContentPaddingCompact,
      VitServiceTileDensity.standard => AppSpacing.serviceTileContentPadding,
    };
  }

  double get labelGap {
    return switch (this) {
      VitServiceTileDensity.compact => AppSpacing.serviceTileLabelGapCompact,
      VitServiceTileDensity.standard => AppSpacing.serviceTileLabelGap,
    };
  }

  TextStyle get labelStyle {
    return switch (this) {
      VitServiceTileDensity.compact => AppTextStyles.micro,
      VitServiceTileDensity.standard => AppTextStyles.caption,
    };
  }
}

class VitServiceTile extends StatelessWidget {
  const VitServiceTile({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    this.density = VitServiceTileDensity.standard,
    this.badgeLabel,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accentColor;
  final VitServiceTileDensity density;
  final String? badgeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: label,
      child: VitCard(
        radius: VitCardRadius.sm,
        borderColor: accentColor.withValues(alpha: .18),
        clip: true,
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: AppSpacing.serviceTileTopStripeHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: .56),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: density.padding,
                horizontal: density.padding,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (badgeLabel != null)
                    Positioned(
                      top: -AppSpacing.serviceTileBadgeOffset,
                      right: -AppSpacing.serviceTileBadgeOffset,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppSpacing.serviceTileBadgeMaxWidth,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: .14),
                            borderRadius: AppRadii.xsRadius,
                            border: Border.all(
                              color: accentColor.withValues(alpha: .28),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal:
                                  AppSpacing.serviceTileBadgePaddingHorizontal,
                              vertical:
                                  AppSpacing.serviceTileBadgePaddingVertical,
                            ),
                            child: Text(
                              badgeLabel!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.micro.copyWith(
                                color: accentColor,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: density.iconContainer,
                          height: density.iconContainer,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: .16),
                            borderRadius: AppRadii.mdRadius,
                            border: Border.all(
                              color: accentColor.withValues(alpha: .28),
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: accentColor,
                            size: density.iconSize,
                          ),
                        ),
                        SizedBox(height: density.labelGap),
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: density.labelStyle.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VitModuleHeroCard extends StatelessWidget {
  const VitModuleHeroCard({
    super.key,
    required this.child,
    required this.accentColor,
    this.padding = const EdgeInsets.all(AppSpacing.x5),
    this.onTap,
  });

  final Widget child;
  final Color accentColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: accentColor.withValues(alpha: .22),
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}

class VitMetricCard extends StatelessWidget {
  const VitMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.accentColor = AppColors.primary,
    this.trailing,
  });

  final String label;
  final String value;
  final Color accentColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.serviceTileAccentBarThickness,
            height: AppSpacing.serviceTileAccentBarHeight,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: AppRadii.xsRadius,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.x3),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class VitModuleSectionHeader extends StatelessWidget {
  const VitModuleSectionHeader({
    super.key,
    required this.title,
    this.accentColor = AppColors.primary,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final Color accentColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.serviceTileAccentBarThickness,
          height: AppSpacing.serviceTileSectionBarHeight,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
