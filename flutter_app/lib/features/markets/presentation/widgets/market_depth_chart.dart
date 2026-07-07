import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_data_viz_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_depth_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketDepthChartView extends StatelessWidget {
  const MarketDepthChartView({
    required this.snapshot,
    required this.levels,
    required this.onLevelSelected,
    super.key,
  });

  final MarketDepthSnapshot snapshot;
  final int levels;
  final ValueChanged<int> onLevelSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DepthMiniStats(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        _DepthChartCard(
          snapshot: snapshot,
          levels: levels,
          onLevelSelected: onLevelSelected,
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        _DepthRatioCard(depth: snapshot.depth),
      ],
    );
  }
}

class _DepthMiniStats extends StatelessWidget {
  const _DepthMiniStats({required this.snapshot});

  final MarketDepthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final depth = snapshot.depth;
    return Row(
      children: [
        Expanded(
          child: _MiniStat(
            label: 'Spread',
            value: '\$${depth.spread.toStringAsFixed(2)}',
            sub: '${depth.spreadPct.toStringAsFixed(4)}%',
          ),
        ),
        const SizedBox(width: AppSpacing.marketAnalyticsCompactGap),
        Expanded(
          child: _MiniStat(
            label: 'Bid Wall',
            value: formatMarketDepthQuantity(depth.totalBidQuantity),
            sub: snapshot.pair.baseAsset,
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.marketAnalyticsCompactGap),
        Expanded(
          child: _MiniStat(
            label: 'Ask Wall',
            value: formatMarketDepthQuantity(depth.totalAskQuantity),
            sub: snapshot.pair.baseAsset,
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.sub,
    this.color,
  });

  final String label;
  final String value;
  final String sub;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.marketDepthMiniStatPadding,
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.marketLineHeightTight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.marketAnalyticsSmallGap),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.marketLineHeightCaption,
            ),
          ),
          const SizedBox(height: AppSpacing.marketAnalyticsTinyGap),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.marketLineHeightCaption,
            ),
          ),
        ],
      ),
    );
  }
}

class _DepthChartCard extends StatelessWidget {
  const _DepthChartCard({
    required this.snapshot,
    required this.levels,
    required this.onLevelSelected,
  });

  final MarketDepthSnapshot snapshot;
  final int levels;
  final ValueChanged<int> onLevelSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.marketDepthChartPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Biểu đồ độ sâu',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.marketLineHeightTight,
                  ),
                ),
              ),
              for (final level in snapshot.availableLevels) ...[
                _LevelChip(
                  key: marketDepthLevelKey(level),
                  level: level,
                  active: levels == level,
                  onTap: () => onLevelSelected(level),
                ),
                if (level != snapshot.availableLevels.last)
                  const SizedBox(width: AppSpacing.marketAnalyticsSmallGap),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.marketHeatmapSummaryGap),
          SizedBox(
            height: AppSpacing.marketDepthChartHeight,
            width: double.infinity,
            child: CustomPaint(
              painter: _DepthChartPainter(depth: snapshot.depth),
            ),
          ),
          const SizedBox(height: AppSpacing.marketAnalyticsCompactGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.borderSolid,
          ),
          const SizedBox(height: AppSpacing.marketAnalyticsMediumGap),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LegendItem(label: 'Mua (Bid)', color: AppColors.buy),
              _LegendItem(label: 'Bán (Ask)', color: AppColors.sell),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.level,
    required this.active,
    required this.onTap,
    super.key,
  });

  final int level;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: '${level}L',
      selected: active,
      onTap: onTap,
      accentColor: marketDepthPrimary,
      padding: AppSpacing.marketDepthLevelChipPadding,
    );
  }
}

class _DepthChartPainter extends CustomPainter {
  const _DepthChartPainter({required this.depth});

  final MarketDepthData depth;

  @override
  void paint(Canvas canvas, Size size) {
    final bids = depth.bids;
    final asks = depth.asks;
    if (bids.isEmpty || asks.isEmpty) return;

    const padding = AppSpacing.marketDepthPainterPadding;
    final chartHeight = size.height - padding * 2;
    final maxCumulative = math.max(bids.last.cumulative, asks.last.cumulative);
    final minPrice = bids.last.price;
    final maxPrice = asks.last.price;
    final priceRange = maxPrice - minPrice;
    final midX = ((depth.midPrice - minPrice) / priceRange) * size.width;

    Offset pointFor(MarketDepthLevel level) {
      final x = ((level.price - minPrice) / priceRange) * size.width;
      final y =
          size.height -
          padding -
          (level.cumulative / maxCumulative) * chartHeight;
      return Offset(x, y);
    }

    final bidPath = Path()..moveTo(midX, size.height - padding);
    for (var index = 0; index < bids.length; index += 1) {
      final point = pointFor(bids[index]);
      if (index == 0) {
        bidPath.lineTo(point.dx, point.dy);
      } else {
        final previous = pointFor(bids[index - 1]);
        bidPath
          ..lineTo(previous.dx, point.dy)
          ..lineTo(point.dx, point.dy);
      }
    }
    final lastBid = pointFor(bids.last);
    bidPath
      ..lineTo(lastBid.dx, size.height - padding)
      ..close();

    final bidFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppDataVizColors.heatmapSoftPositive,
          AppDataVizColors.heatmapFaintPositive,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(bidPath, bidFill);

    final askPath = Path()..moveTo(midX, size.height - padding);
    for (var index = 0; index < asks.length; index += 1) {
      final point = pointFor(asks[index]);
      if (index == 0) {
        askPath.lineTo(point.dx, point.dy);
      } else {
        final previous = pointFor(asks[index - 1]);
        askPath
          ..lineTo(previous.dx, point.dy)
          ..lineTo(point.dx, point.dy);
      }
    }
    final lastAsk = pointFor(asks.last);
    askPath
      ..lineTo(lastAsk.dx, size.height - padding)
      ..close();

    final askFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppDataVizColors.heatmapSoftNegative,
          AppDataVizColors.heatmapFaintNegative,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(askPath, askFill);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.marketDepthStroke
      ..strokeCap = StrokeCap.square
      ..color = AppColors.buy;
    _drawSteppedLine(canvas, bids, pointFor, linePaint, midX, size.height);

    linePaint.color = AppColors.sell;
    _drawSteppedLine(canvas, asks, pointFor, linePaint, midX, size.height);

    final dashPaint = Paint()
      ..color = AppColors.sell
      ..strokeWidth = AppSpacing.marketDepthDashedStroke
      ..style = PaintingStyle.stroke;
    var y = padding;
    while (y < size.height - padding) {
      canvas.drawLine(
        Offset(midX, y),
        Offset(midX, y + AppSpacing.marketDepthPainterDash),
        dashPaint,
      );
      y += AppSpacing.marketDepthPainterDashGap;
    }
  }

  void _drawSteppedLine(
    Canvas canvas,
    List<MarketDepthLevel> levels,
    Offset Function(MarketDepthLevel level) pointFor,
    Paint paint,
    double midX,
    double height,
  ) {
    final path = Path()
      ..moveTo(midX, height - AppSpacing.marketDepthPainterPadding);
    for (var index = 0; index < levels.length; index += 1) {
      final point = pointFor(levels[index]);
      if (index == 0) {
        path.lineTo(point.dx, point.dy);
      } else {
        final previous = pointFor(levels[index - 1]);
        path
          ..lineTo(previous.dx, point.dy)
          ..lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DepthChartPainter oldDelegate) {
    return oldDelegate.depth != depth;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: color.withValues(alpha: .35),
          shape: const CircleBorder(),
          child: const SizedBox.square(
            dimension: AppSpacing.marketDepthLegendDot,
          ),
        ),
        const SizedBox(width: AppSpacing.marketAnalyticsCompactGap),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.marketLineHeightTight,
          ),
        ),
      ],
    );
  }
}

class _DepthRatioCard extends StatelessWidget {
  const _DepthRatioCard({required this.depth});

  final MarketDepthData depth;

  @override
  Widget build(BuildContext context) {
    final bidPct = depth.bidRatioPct;
    return VitCard(
      padding: AppSpacing.marketDepthRatioPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tỷ lệ tường mua/bán',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.marketLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.marketAnalyticsMediumGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: SizedBox(
              width: double.infinity,
              height: AppSpacing.marketDepthRatioBarHeight,
              child: Row(
                children: [
                  Expanded(
                    flex: (bidPct * 10).round(),
                    child: const ColoredBox(color: AppColors.buy),
                  ),
                  Expanded(
                    flex: ((100 - bidPct) * 10).round(),
                    child: const ColoredBox(color: AppColors.sell),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.marketAnalyticsCompactGap),
          Row(
            children: [
              Text(
                'Mua ${bidPct.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  height: AppSpacing.marketLineHeightTight,
                ),
              ),
              const Spacer(),
              Text(
                'Bán ${(100 - bidPct).toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  height: AppSpacing.marketLineHeightTight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
