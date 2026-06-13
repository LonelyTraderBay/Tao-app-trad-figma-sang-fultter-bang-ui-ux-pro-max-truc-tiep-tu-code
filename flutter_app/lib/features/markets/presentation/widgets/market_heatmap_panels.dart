import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_data_viz_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final item in items) ...[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              item.label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1,
              ),
            ),
            if (item != items.last) const SizedBox(width: 7),
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
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: coin.color.withValues(alpha: .14),
                  shape: BoxShape.circle,
                  border: Border.all(color: coin.color.withValues(alpha: .28)),
                ),
                child: Text(
                  coin.symbol.length <= 3
                      ? coin.symbol
                      : coin.symbol.substring(0, 3),
                  style: AppTextStyles.micro.copyWith(
                    color: coin.color,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: AppTextStyles.baseMedium.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${coin.symbol}/USDT · ${coin.category}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                key: MarketHeatmapKeys.detailButton,
                onTap: onDetail,
                borderRadius: AppRadii.mdRadius,
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    color: marketHeatmapPrimary,
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    'Chi tiết',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
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
        const SizedBox(width: 12),
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
      height: 156,
      padding: const EdgeInsets.all(13),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 7),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < coins.length; i++) ...[
            _TrendRow(index: i + 1, coin: coins[i], metric: metric),
            if (i != coins.length - 1)
              const Divider(height: 1, color: AppColors.divider),
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
      height: 32,
      child: Row(
        children: [
          Text(
            '$index.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              coin.symbol,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          Text(
            marketHeatmapFormatPercent(change),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
