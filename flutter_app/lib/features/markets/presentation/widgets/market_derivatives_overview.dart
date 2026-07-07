import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_derivatives_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketDerivativesOpenInterestHero extends StatelessWidget {
  const MarketDerivativesOpenInterestHero({super.key, required this.stats});

  final DerivativesGlobalStats stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: double.infinity,
      padding: AppSpacing.marketDerivativesHeroPadding,
      borderColor: marketDerivativesPrimary.withValues(alpha: .2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng Open Interest',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.marketDerivativesHeroLabelGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                marketDerivativesFormatCompact(
                  stats.totalOpenInterest,
                  prefix: r'$',
                ),
                style: AppTextStyles.amountMd,
              ),
              const SizedBox(width: AppSpacing.marketDerivativesHeroValueGap),
              Padding(
                padding: AppSpacing.marketDerivativesHeroDeltaPadding,
                child: Text(
                  marketDerivativesFormatSignedPercent(stats.oiChange24h),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MarketDerivativesOverviewStatGrid extends StatelessWidget {
  const MarketDerivativesOverviewStatGrid({super.key, required this.stats});

  final DerivativesGlobalStats stats;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: AppSpacing.marketDerivativesStatGridColumns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.marketDerivativesStatGridGap,
      mainAxisSpacing: AppSpacing.marketDerivativesStatGridGap,
      childAspectRatio: AppSpacing.marketDerivativesStatGridAspectRatio,
      children: [
        _StatCard(
          icon: Icons.bar_chart_rounded,
          iconColor: marketDerivativesPrimary,
          label: 'KL giao dịch 24h',
          value: marketDerivativesFormatCompact(
            stats.totalVolume24h,
            prefix: r'$',
          ),
          change: marketDerivativesFormatSignedPercent(stats.volumeChange24h),
        ),
        _StatCard(
          icon: Icons.bolt_rounded,
          iconColor: AppColors.sell,
          label: 'Thanh lý 24h',
          value: marketDerivativesFormatCompact(
            stats.totalLiquidations24h,
            prefix: r'$',
          ),
          subtitle:
              'L: ${marketDerivativesFormatCompact(stats.longLiquidations24h, prefix: r'$')} / S: ${marketDerivativesFormatCompact(stats.shortLiquidations24h, prefix: r'$')}',
        ),
        _StatCard(
          icon: Icons.show_chart_rounded,
          iconColor: AppColors.accent,
          label: 'Funding TB',
          value: '${(stats.avgFundingRate * 100).toStringAsFixed(4)}%',
          valueColor: AppColors.buy,
          subtitle: '8h rate',
        ),
        _StatCard(
          icon: Icons.balance_rounded,
          iconColor: AppColors.warn,
          label: 'BTC Long/Short',
          value: stats.btcLongShortRatio.toStringAsFixed(2),
          valueColor: AppColors.buy,
          subtitle: 'Long thiên hướng',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
    this.change,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
  final String? change;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.marketDerivativesStatCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.marketDerivativesStatIconBox,
                height: AppSpacing.marketDerivativesStatIconBox,
                child: Material(
                  color: AppColors.surface2,
                  borderRadius: AppRadii.smRadius,
                  child: Center(
                    child: Icon(
                      icon,
                      size: AppSpacing.marketDerivativesStatIcon,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.amountSm.copyWith(
              color: valueColor ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          if (change != null)
            Text(
              '↗ $change',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.medium,
              ),
            )
          else if (subtitle != null)
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
        ],
      ),
    );
  }
}

class MarketDerivativesSectionHeader extends StatelessWidget {
  const MarketDerivativesSectionHeader({
    super.key,
    required this.label,
    required this.accentColor,
  });

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      bottomGap: AppSpacing.pageRhythmStandardInnerGap,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: accentColor,
    );
  }
}

class MarketDerivativesLiquidationTimeline extends StatelessWidget {
  const MarketDerivativesLiquidationTimeline({
    super.key,
    required this.history,
    required this.pairs,
  });

  final List<LiquidationPoint> history;
  final List<DerivativePair> pairs;

  @override
  Widget build(BuildContext context) {
    final maxValue = history.fold<double>(
      0,
      (max, point) => math.max(max, math.max(point.long, point.short)),
    );
    final totalLong = pairs.fold<double>(
      0,
      (sum, pair) => sum + pair.longLiquidations24h,
    );
    final totalShort = pairs.fold<double>(
      0,
      (sum, pair) => sum + pair.shortLiquidations24h,
    );

    return VitCard(
      padding: AppSpacing.marketDerivativesTimelinePadding,
      child: Column(
        children: [
          for (final point in history) ...[
            Row(
              children: [
                SizedBox(
                  width: AppSpacing.marketDerivativesTimelineTimeWidth,
                  child: Text(
                    point.time,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.marketDerivativesTimelineTimeGap,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        flex: (point.long / maxValue * 1000).round(),
                        child: const _BarSegment(
                          color: AppColors.buy,
                          leftRadius: true,
                        ),
                      ),
                      Flexible(
                        flex: (point.short / maxValue * 1000).round(),
                        child: const _BarSegment(
                          color: AppColors.sell,
                          rightRadius: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.marketDerivativesTimelineItemGap),
          ],
          const Divider(
            height: AppSpacing.marketDerivativesTimelineDividerHeight,
            color: AppColors.borderSolid,
          ),
          Row(
            children: [
              _Legend(
                label:
                    'Long (${marketDerivativesFormatCompact(totalLong, prefix: r'$')})',
                color: AppColors.buy,
              ),
              const SizedBox(width: AppSpacing.marketDerivativesLegendItemGap),
              _Legend(
                label:
                    'Short (${marketDerivativesFormatCompact(totalShort, prefix: r'$')})',
                color: AppColors.sell,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarSegment extends StatelessWidget {
  const _BarSegment({
    required this.color,
    this.leftRadius = false,
    this.rightRadius = false,
  });

  final Color color;
  final bool leftRadius;
  final bool rightRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.marketDerivativesTimelineBarHeight,
      child: Material(
        color: color.withValues(alpha: .78),
        borderRadius: BorderRadius.horizontal(
          left: leftRadius ? AppRadii.chartBarCorner : Radius.zero,
          right: rightRadius ? AppRadii.chartBarCorner : Radius.zero,
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          color: color,
          size: AppSpacing.marketDerivativesLegendDot,
        ),
        const SizedBox(width: AppSpacing.marketDerivativesLegendGap),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class MarketDerivativesTopOpenInterestList extends StatelessWidget {
  const MarketDerivativesTopOpenInterestList({super.key, required this.pairs});

  final List<DerivativePair> pairs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final pair in pairs) ...[
          _OIPairRow(pair: pair),
          const SizedBox(height: AppSpacing.marketDerivativesOiRowGap),
        ],
      ],
    );
  }
}

class _OIPairRow extends StatelessWidget {
  const _OIPairRow({required this.pair});

  final DerivativePair pair;

  @override
  Widget build(BuildContext context) {
    final up = pair.openInterestChange24h >= 0;
    return VitCard(
      padding: AppSpacing.marketDerivativesOiRowPadding,
      child: Row(
        children: [
          MarketDerivativesPairLogo(
            pair: pair,
            size: AppSpacing.marketDerivativesPairAvatarMd,
          ),
          const SizedBox(width: AppSpacing.marketDerivativesPairGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pair.symbol,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'OI: ${marketDerivativesFormatCompact(pair.openInterest, prefix: r'$')}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                marketDerivativesFormatSignedPercent(
                  pair.openInterestChange24h,
                ),
                style: AppTextStyles.caption.copyWith(
                  color: up ? AppColors.buy : AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '24h',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
