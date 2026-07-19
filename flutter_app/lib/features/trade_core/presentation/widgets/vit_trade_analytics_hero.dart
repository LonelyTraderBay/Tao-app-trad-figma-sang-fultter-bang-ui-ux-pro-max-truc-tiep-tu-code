import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// One labeled numeric stat rendered inside [VitTradeAnalyticsHero]'s metric
/// row.
class VitTradeAnalyticsStat {
  const VitTradeAnalyticsStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;
}

/// Icon + title/subtitle banner with an inline metric-grid row for the
/// analytics archetype — pairs with [VitTradeDetailScaffold] or
/// [VitTradeHubScaffold].
class VitTradeAnalyticsHero extends StatelessWidget {
  const VitTradeAnalyticsHero({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.stats,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<VitTradeAnalyticsStat> stats;

  @override
  Widget build(BuildContext context) {
    assert(stats.isNotEmpty, 'Analytics hero requires at least one stat.');
    return VitCard(
      variant: VitCardVariant.hero,
      borderColor: AppColors.onAccent.withValues(alpha: .10),
      density: VitDensity.tool,
      child: Column(
        spacing: AppSpacing.pageRhythmCompactInnerGap,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppSpacing.x4,
                backgroundColor: AppColors.onAccent.withValues(alpha: .10),
                child: Icon(
                  icon,
                  color: AppColors.onAccent,
                  size: AppSpacing.iconLg,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      subtitle,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              for (final stat in stats) ...[
                Expanded(child: VitTradeAnalyticsStatChip(stat: stat)),
                if (stat != stats.last) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Alignment variant for [VitTradeAnalyticsStatChip].
enum VitTradeAnalyticsStatChipAlignment {
  /// Value stacked above label, both centered — used by
  /// [VitTradeAnalyticsHero]'s metric row.
  center,

  /// Label stacked above value, both left-aligned — used by
  /// [VitTradeDetailHero]'s stats grid.
  start,
}

/// Shared metric chip for [VitTradeAnalyticsHero] and [VitTradeDetailHero]:
/// an inner [VitCard] rendering one [VitTradeAnalyticsStat], with
/// stack order/alignment/text style tuned per [alignment].
class VitTradeAnalyticsStatChip extends StatelessWidget {
  const VitTradeAnalyticsStatChip({
    super.key,
    required this.stat,
    this.alignment = VitTradeAnalyticsStatChipAlignment.center,
  });

  final VitTradeAnalyticsStat stat;
  final VitTradeAnalyticsStatChipAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final isCenter = alignment == VitTradeAnalyticsStatChipAlignment.center;

    final valueText = Text(
      stat.value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: (isCenter ? AppTextStyles.baseMedium : AppTextStyles.caption)
          .copyWith(
            color: stat.color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
    );

    final labelText = Text(
      stat.label,
      maxLines: isCenter ? 2 : 1,
      textAlign: isCenter ? TextAlign.center : TextAlign.start,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.micro.copyWith(
        color: isCenter
            ? AppColors.onAccent.withValues(alpha: .62)
            : AppColors.text3,
      ),
    );

    return VitCard(
      density: VitDensity.tool,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      child: Column(
        mainAxisAlignment: isCenter
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: isCenter
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: isCenter
            ? [valueText, const SizedBox(height: AppSpacing.x1), labelText]
            : [labelText, const SizedBox(height: AppSpacing.x1), valueText],
      ),
    );
  }
}
