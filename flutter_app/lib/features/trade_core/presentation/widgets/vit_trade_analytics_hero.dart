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
      density: VitDensity.compact,
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
                Expanded(child: _AnalyticsHeroStat(stat: stat)),
                if (stat != stats.last) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalyticsHeroStat extends StatelessWidget {
  const _AnalyticsHeroStat({required this.stat});

  final VitTradeAnalyticsStat stat;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: stat.color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent.withValues(alpha: .62),
            ),
          ),
        ],
      ),
    );
  }
}
