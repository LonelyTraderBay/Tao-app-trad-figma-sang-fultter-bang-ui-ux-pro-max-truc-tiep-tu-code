import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_data_viz_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_heatmap_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketHeatmapLegend extends StatelessWidget {
  const MarketHeatmapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      MarketHeatmapLegendSpec(
        label: '<-5%',
        color: AppDataVizColors.heatmapStrongNegative,
      ),
      MarketHeatmapLegendSpec(
        label: '-2~0%',
        color: AppDataVizColors.heatmapNeutralNegative,
      ),
      MarketHeatmapLegendSpec(
        label: '0~2%',
        color: AppDataVizColors.heatmapNeutralPositive,
      ),
      MarketHeatmapLegendSpec(
        label: '2~5%',
        color: AppDataVizColors.heatmapLegendPositive,
      ),
      MarketHeatmapLegendSpec(
        label: '>5%',
        color: AppDataVizColors.heatmapStrongPositive,
      ),
    ];
    return Padding(
      padding: AppSpacing.marketHeatmapLegendPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final item in items) ...[
            Material(
              color: item.color,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.badgeRadius,
              ),
              child: const SizedBox.square(
                dimension: AppSpacing.marketHeatmapLegendDot,
              ),
            ),
            const SizedBox(width: AppSpacing.marketAnalyticsMicroGap),
            Text(
              item.label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppSpacing.marketLineHeightTight,
              ),
            ),
            if (item != items.last)
              const SizedBox(width: AppSpacing.marketOverviewMiniHeaderGap),
          ],
        ],
      ),
    );
  }
}

class MarketHeatmapSelectedCoinCard extends StatelessWidget {
  const MarketHeatmapSelectedCoinCard({
    super.key,
    required this.coin,
    required this.onDetail,
  });

  final HeatmapCoin coin;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.marketHeatmapSelectedCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: coin.color.withValues(alpha: .14),
                shape: CircleBorder(
                  side: BorderSide(color: coin.color.withValues(alpha: .28)),
                ),
                child: SizedBox.square(
                  dimension: AppSpacing.marketHeatmapAvatar,
                  child: Center(
                    child: Text(
                      coin.symbol.length <= 3
                          ? coin.symbol
                          : coin.symbol.substring(0, 3),
                      style: AppTextStyles.micro.copyWith(
                        color: coin.color,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.marketLineHeightTight,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.marketHeatmapSummaryGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        height: AppSpacing.marketLineHeightCaption,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.marketAnalyticsTinyGap),
                    Text(
                      '${coin.symbol}/USDT · ${coin.category}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: AppSpacing.marketLineHeightTight,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                key: MarketHeatmapKeys.detailButton,
                onTap: onDetail,
                borderRadius: AppRadii.mdRadius,
                child: Material(
                  color: marketHeatmapPrimary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: SizedBox(
                    height: AppSpacing.marketHeatmapDetailButtonHeight,
                    child: Padding(
                      padding: AppSpacing.marketHeatmapDetailButtonPadding,
                      child: Center(
                        child: Text(
                          'Chi tiết',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.onAccent,
                            fontWeight: AppTextStyles.bold,
                            height: AppSpacing.marketLineHeightTight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.marketAnalyticsStatIcon),
          Row(
            children: [
              _CoinMetric(
                label: 'Giá',
                value: marketHeatmapFormatPrice(coin.price),
              ),
              _CoinMetric(
                label: '24h',
                value: marketHeatmapFormatPercent(coin.change24h),
                color: coin.change24h >= 0 ? AppColors.buy : AppColors.sell,
              ),
              _CoinMetric(
                label: '7d',
                value: marketHeatmapFormatPercent(coin.change7d),
                color: coin.change7d >= 0 ? AppColors.buy : AppColors.sell,
              ),
              _CoinMetric(
                label: 'MCap',
                value: marketHeatmapFormatCompact(coin.marketCap),
                color: AppColors.text2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoinMetric extends StatelessWidget {
  const _CoinMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.marketLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.marketAnalyticsSmallGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.marketLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class MarketHeatmapTrendPanels extends StatelessWidget {
  const MarketHeatmapTrendPanels({
    super.key,
    required this.coins,
    required this.metric,
  });

  final List<HeatmapCoin> coins;
  final String metric;

  @override
  Widget build(BuildContext context) {
    final sorted = [...coins]
      ..sort((a, b) => _changeFor(b).compareTo(_changeFor(a)));
    final gainers = sorted.where((coin) => _changeFor(coin) > 0).take(3);
    final losers = sorted
        .where((coin) => _changeFor(coin) < 0)
        .take(3)
        .toList()
        .reversed;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _TrendCard(
            title: 'Top tăng',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            coins: gainers.toList(),
            metric: metric,
          ),
        ),
        const SizedBox(width: AppSpacing.marketHeatmapSummaryGap),
        Expanded(
          child: _TrendCard(
            title: 'Top giảm',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            coins: losers.toList(),
            metric: metric,
          ),
        ),
      ],
    );
  }

  double _changeFor(HeatmapCoin coin) {
    return metric == '7d' ? coin.change7d : coin.change24h;
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.coins,
    required this.metric,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<HeatmapCoin> coins;
  final String metric;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.marketHeatmapTrendCardHeight,
      padding: AppSpacing.marketHeatmapTrendCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: AppSpacing.marketHeatmapTrendIcon, color: color),
              const SizedBox(width: AppSpacing.marketOverviewMiniHeaderGap),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.marketLineHeightTight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.marketHeatmapSummaryGap),
          for (var i = 0; i < coins.length; i++) ...[
            _TrendRow(index: i + 1, coin: coins[i], metric: metric),
            if (i != coins.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _TrendRow extends StatelessWidget {
  const _TrendRow({
    required this.index,
    required this.coin,
    required this.metric,
  });

  final int index;
  final HeatmapCoin coin;
  final String metric;

  @override
  Widget build(BuildContext context) {
    final change = metric == '7d' ? coin.change7d : coin.change24h;
    final color = change >= 0 ? AppColors.buy : AppColors.sell;

    return SizedBox(
      height: AppSpacing.marketHeatmapTrendRowHeight,
      child: Row(
        children: [
          Text(
            '$index.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.marketLineHeightTight,
            ),
          ),
          const SizedBox(width: AppSpacing.marketHeatmapSummaryGap),
          Expanded(
            child: Text(
              coin.symbol,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.marketLineHeightTight,
              ),
            ),
          ),
          Text(
            marketHeatmapFormatPercent(change),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.marketLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}
