import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

class VitAccentPill extends StatelessWidget {
  const VitAccentPill({
    super.key,
    required this.label,
    required this.accentColor,
    this.size = VitStatusPillSize.sm,
    this.semanticStatus,
  });

  final String label;
  final Color accentColor;
  final VitStatusPillSize size;
  final VitStatusPillStatus? semanticStatus;

  _AccentPillMetrics get _metrics {
    return switch (size) {
      VitStatusPillSize.sm => const _AccentPillMetrics(
        minHeight: SharedSpacingTokens.homeChipMinHeight,
        paddingX: SharedSpacingTokens.homeChipHorizontalPadding,
        paddingY: SharedSpacingTokens.homeChipVerticalPadding,
        style: AppTextStyles.micro,
      ),
      VitStatusPillSize.md => const _AccentPillMetrics(
        minHeight: AppSpacing.statusPillHeightMd,
        paddingX: AppSpacing.statusPillHorizontalPaddingMd,
        paddingY: AppSpacing.x1,
        style: AppTextStyles.navLabel,
      ),
      VitStatusPillSize.lg => const _AccentPillMetrics(
        minHeight: AppSpacing.statusPillHeightLg,
        paddingX: AppSpacing.statusPillHorizontalPaddingLg,
        paddingY: AppSpacing.x2,
        style: AppTextStyles.navLabel,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics;
    return Semantics(
      label: semanticStatus == null ? label : '$label ${semanticStatus!.name}',
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: metrics.minHeight),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: accentColor.withValues(alpha: .14),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: accentColor.withValues(alpha: .26)),
              borderRadius: AppRadii.pillRadius,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: metrics.paddingX,
              vertical: metrics.paddingY,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: metrics.style.copyWith(
                color: accentColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccentPillMetrics {
  const _AccentPillMetrics({
    required this.minHeight,
    required this.paddingX,
    required this.paddingY,
    required this.style,
  });

  final double minHeight;
  final double paddingX;
  final double paddingY;
  final TextStyle style;
}
