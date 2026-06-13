import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_depth_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketDepthOrderBookView extends StatelessWidget {
  const MarketDepthOrderBookView({required this.snapshot, super.key});

  final MarketDepthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OrderBookHeader(pair: snapshot.pair),
        const SizedBox(height: 16),
        const MarketDepthSectionHeader(
          label: 'Lệnh bán (Ask)',
          accentColor: AppColors.sell,
        ),
        const SizedBox(height: 16),
        _OrderBookRows(
          levels: snapshot.depth.asks.take(15).toList().reversed,
          side: MarketOrderSide.sell,
        ),
        const SizedBox(height: 16),
        _MidPriceStrip(depth: snapshot.depth),
        const SizedBox(height: 16),
        const MarketDepthSectionHeader(
          label: 'Lệnh mua (Bid)',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: 16),
        _OrderBookRows(
          levels: snapshot.depth.bids.take(15).toList(),
          side: MarketOrderSide.buy,
        ),
      ],
    );
  }
}

class _OrderBookHeader extends StatelessWidget {
  const _OrderBookHeader({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          _HeaderCell('Giá (${pair.quoteAsset})'),
          _HeaderCell('Số lượng (${pair.baseAsset})', alignRight: true),
          const _HeaderCell('Tích lũy', alignRight: true),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {this.alignRight = false});

  final String text;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _OrderBookRows extends StatelessWidget {
  const _OrderBookRows({required this.levels, required this.side});

  final Iterable<MarketDepthLevel> levels;
  final MarketOrderSide side;

  @override
  Widget build(BuildContext context) {
    final list = levels.toList();
    final maxCumulative = list.fold<double>(
      0,
      (maxValue, level) => math.max(maxValue, level.cumulative),
    );
    final color = side == MarketOrderSide.buy ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          for (final level in list)
            _OrderBookRow(
              level: level,
              maxCumulative: maxCumulative,
              color: color,
            ),
        ],
      ),
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  const _OrderBookRow({
    required this.level,
    required this.maxCumulative,
    required this.color,
  });

  final MarketDepthLevel level;
  final double maxCumulative;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final barPct = maxCumulative == 0 ? 0.0 : level.cumulative / maxCumulative;
    return SizedBox(
      height: 28,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: barPct.clamp(0.0, 1.0),
              heightFactor: 1,
              child: ColoredBox(color: color.withValues(alpha: .08)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _BookCell(formatMarketDepthPrice(level.price), color: color),
                _BookCell(
                  formatMarketDepthQuantity(level.quantity),
                  alignRight: true,
                ),
                _BookCell(
                  formatMarketDepthQuantity(level.cumulative),
                  alignRight: true,
                  color: AppColors.text3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookCell extends StatelessWidget {
  const _BookCell(this.text, {this.color, this.alignRight = false});

  final String text;
  final Color? color;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.captionSm.copyWith(
          color: color ?? AppColors.text1,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _MidPriceStrip extends StatelessWidget {
  const _MidPriceStrip({required this.depth});

  final MarketDepthData depth;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.caption,
          children: [
            TextSpan(
              text: '\$${formatMarketDepthPrice(depth.midPrice)}',
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            TextSpan(
              text: '   Spread: ${depth.spreadPct.toStringAsFixed(4)}%',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}
