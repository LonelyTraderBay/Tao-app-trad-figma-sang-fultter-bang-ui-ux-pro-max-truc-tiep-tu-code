import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

/// Shared discovery-module card tiles used by both `TopicHubPage` and
/// `UnifiedSearchPage` card families.
///
/// Consolidated from byte-for-byte (or near-identical) duplicated
/// per-page-family private widgets — see
/// run-artifacts/ponytail-audit-discovery-2026-07-11.md findings #2-#5.

/// Small tinted module label chip (e.g. "Prediction Market", "Arena Points
/// only") shown on discovery cards.
class DiscoveryModuleBadge extends StatelessWidget {
  const DiscoveryModuleBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: .24)),
          borderRadius: AppRadii.smRadius,
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.discoveryBadgePadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 10),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Trailing "label + arrow" call-to-action used on discovery card footers.
class DiscoveryInlineCta extends StatelessWidget {
  const DiscoveryInlineCta({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Icon(Icons.arrow_forward_rounded, color: color, size: 11),
      ],
    );
  }
}

/// Neutral count chip (e.g. section item counts, result counts).
///
/// [padding] defaults to the standard badge padding used by the unified
/// search result sections; pass
/// `LaunchpadSpacingTokens.discoveryMiniBadgePadding` for the tighter
/// topic-hub section-header variant.
class DiscoveryCountChip extends StatelessWidget {
  const DiscoveryCountChip({
    super.key,
    required this.count,
    this.padding = LaunchpadSpacingTokens.discoveryBadgePadding,
  });

  final int count;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          '$count',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

/// Tinted rounded box with centered initials, used for creator avatars.
class DiscoveryInitialsAvatar extends StatelessWidget {
  const DiscoveryInitialsAvatar({
    super.key,
    required this.initials,
    required this.size,
    required this.fillAlpha,
    required this.radius,
    required this.textStyle,
    this.color = AppModuleAccents.arena,
  });

  final String initials;
  final double size;
  final double fillAlpha;
  final BorderRadius radius;
  final TextStyle textStyle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: fillAlpha),
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
        child: Center(
          child: Text(
            initials,
            style: textStyle.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}
