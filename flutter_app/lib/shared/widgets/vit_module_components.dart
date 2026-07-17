import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Sizing density for [VitServiceTile] and related module tile components.
enum VitServiceTileDensity { compact, standard }

/// Icon/padding/label metrics for a [VitServiceTileDensity].
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

/// Square module/service entry tile: accent icon, label, and optional
/// corner badge/risk-disclosure badge.
class VitServiceTile extends StatelessWidget {
  const VitServiceTile({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    this.density = VitServiceTileDensity.standard,
    this.badgeLabel,
    this.riskBadgeLabel,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accentColor;
  final VitServiceTileDensity density;
  final String? badgeLabel;

  /// Risk disclosure label (e.g. 'Rủi ro cao') rendered as a second badge
  /// in the corner opposite [badgeLabel], so leveraged/speculative products
  /// keep their existing state label (New/Hot/Pro) while still surfacing a
  /// distinct risk signal. Folded into the tile's Semantics label below so
  /// assistive tech announces it even if nested Semantics get merged.
  final String? riskBadgeLabel;
  final VoidCallback? onTap;

  /// Alias constructor for call sites that already have the tile's primitive
  /// fields (icon/label/accentColor/badges) resolved, so they don't need to
  /// depend on a feature's own domain entity to build a tile.
  const factory VitServiceTile.fromAction({
    required IconData icon,
    required String label,
    required Color accentColor,
    VitServiceTileDensity density,
    String? badgeLabel,
    String? riskBadgeLabel,
    VoidCallback? onTap,
  }) = VitServiceTile;

  EdgeInsetsDirectional get _contentSafeInsets {
    return EdgeInsetsDirectional.only(
      top: badgeLabel != null ? AppSpacing.x2 : 0,
      end: badgeLabel != null ? AppSpacing.x2 : 0,
      bottom: riskBadgeLabel != null
          ? AppSpacing.serviceTileBadgeReserveVertical
          : 0,
      start: riskBadgeLabel != null
          ? AppSpacing.serviceTileBadgeReserveHorizontal
          : 0,
    );
  }

  bool get _useCompactedBody => riskBadgeLabel != null;

  double get _bodyIconContainer => _useCompactedBody
      ? AppSpacing.serviceTileIconContainerCompact
      : density.iconContainer;

  double get _bodyIconSize => _useCompactedBody
      ? AppSpacing.serviceTileIconSizeCompact
      : density.iconSize;

  double get _bodyLabelGap => _useCompactedBody
      ? AppSpacing.serviceTileLabelGapCompact
      : density.labelGap;

  TextStyle get _bodyLabelStyle =>
      _useCompactedBody ? AppTextStyles.micro : density.labelStyle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: riskBadgeLabel == null ? label : '$label, $riskBadgeLabel',
      child: VitCard(
        radius: VitCardRadius.standard,
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
                decoration: ShapeDecoration(
                  color: accentColor.withValues(alpha: .56),
                  shape: const RoundedRectangleBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(density.padding),
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
                          decoration: ShapeDecoration(
                            color: accentColor.withValues(alpha: .14),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xsRadius,
                              side: BorderSide(
                                color: accentColor.withValues(alpha: .28),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
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
                  if (riskBadgeLabel != null)
                    Positioned(
                      bottom: -AppSpacing.serviceTileBadgeOffset,
                      left: -AppSpacing.serviceTileBadgeOffset,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppSpacing.serviceTileRiskBadgeMaxWidth,
                        ),
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: AppColors.riskWarning.withValues(alpha: .14),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xsRadius,
                              side: BorderSide(
                                color: AppColors.riskWarning.withValues(
                                  alpha: .28,
                                ),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal:
                                  AppSpacing.serviceTileBadgePaddingHorizontal,
                              vertical:
                                  AppSpacing.serviceTileBadgePaddingVertical,
                            ),
                            child: Text(
                              riskBadgeLabel!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.riskWarning,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: _contentSafeInsets,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: _bodyIconContainer,
                              height: _bodyIconContainer,
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: accentColor.withValues(alpha: .16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadii.mdRadius,
                                    side: BorderSide(
                                      color: accentColor.withValues(alpha: .28),
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  icon,
                                  color: accentColor,
                                  size: _bodyIconSize,
                                ),
                              ),
                            ),
                            SizedBox(height: _bodyLabelGap),
                            Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: _bodyLabelStyle.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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

/// Large hero surface (rounded, accent-tinted border) for a module's
/// top-of-page highlight card.
class VitModuleHeroCard extends StatelessWidget {
  const VitModuleHeroCard({
    super.key,
    required this.child,
    required this.accentColor,
    this.padding,
    this.density,
    this.onTap,
  });

  final Widget child;
  final Color accentColor;
  final EdgeInsetsGeometry? padding;
  final VitDensity? density;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: accentColor.withValues(alpha: .22),
      padding:
          padding ??
          (density == null
              ? const EdgeInsetsDirectional.all(AppSpacing.x5)
              : density!.cardPadding),
      onTap: onTap,
      child: child,
    );
  }
}

/// Inner card showing one label/value metric with an accent-colored bar and
/// optional trailing widget.
class VitMetricCard extends StatelessWidget {
  const VitMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.accentColor = AppColors.primary,
    this.density = VitDensity.standard,
    this.trailing,
  });

  final String label;
  final String value;
  final Color accentColor;
  final VitDensity density;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: density == VitDensity.standard
          ? const EdgeInsetsDirectional.all(AppSpacing.x4)
          : density.cardPadding,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.serviceTileAccentBarThickness,
            height: AppSpacing.serviceTileAccentBarHeight,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: accentColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
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
                  style:
                      (density == VitDensity.compact ||
                                  density == VitDensity.tool
                              ? AppTextStyles.caption
                              : AppTextStyles.base)
                          .copyWith(
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

/// Module page section header: accent bar, bold title, and an optional
/// trailing text action.
class VitModuleSectionHeader extends StatelessWidget {
  const VitModuleSectionHeader({
    super.key,
    required this.title,
    this.accentColor = AppColors.primary,
    this.density = VitDensity.standard,
    this.actionLabel,
    this.onAction,
    this.bottomGap,
  });

  final String title;
  final Color accentColor;
  final VitDensity density;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double? bottomGap;

  bool get _isCompact =>
      density == VitDensity.compact || density == VitDensity.tool;

  double get _resolvedBottomGap =>
      bottomGap ??
      (_isCompact
          ? AppSpacing.pageRhythmCompactInnerGap
          : AppSpacing.pageRhythmStandardInnerGap);

  @override
  Widget build(BuildContext context) {
    final header = Row(
      children: [
        SizedBox(
          width: AppSpacing.serviceTileAccentBarThickness,
          height: _isCompact
              ? AppSpacing.pageSectionAccentHeight
              : AppSpacing.serviceTileSectionBarHeight,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: accentColor,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.xsRadius,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                (_isCompact
                        ? AppTextStyles.caption
                        : AppTextStyles.sectionTitle)
                    .copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: _isCompact
                ? TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.x2,
                      vertical: AppSpacing.x1,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )
                : null,
            child: Text(actionLabel!),
          ),
      ],
    );
    final gap = _resolvedBottomGap;
    if (gap <= 0) return header;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        SizedBox(height: gap),
      ],
    );
  }
}
