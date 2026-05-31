import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_data_viz_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
        const SizedBox(height: 16),
        _DepthChartCard(
          snapshot: snapshot,
          levels: levels,
          onLevelSelected: onLevelSelected,
        ),
        const SizedBox(height: 16),
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
        const SizedBox(width: 8),
        Expanded(
          child: _MiniStat(
            label: 'Bid Wall',
            value: formatMarketDepthQuantity(depth.totalBidQuantity),
            sub: snapshot.pair.baseAsset,
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.2,
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                  const SizedBox(width: 6),
              ],
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(
              painter: _DepthChartPainter(depth: snapshot.depth),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.borderSolid),
          const SizedBox(height: 10),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? marketDepthPrimary.withValues(alpha: .16)
              : AppColors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          '${level}L',
          style: AppTextStyles.micro.copyWith(
            color: active ? marketDepthPrimary : AppColors.text3,
            fontWeight: AppTextStyles.medium,
            height: 1,
          ),
        ),
      ),
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

    const padding = 8.0;
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
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.square
      ..color = AppColors.buy;
    _drawSteppedLine(canvas, bids, pointFor, linePaint, midX, size.height);

    linePaint.color = AppColors.sell;
    _drawSteppedLine(canvas, asks, pointFor, linePaint, midX, size.height);

    final dashPaint = Paint()
      ..color = AppColors.sell
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    var y = padding;
    while (y < size.height - padding) {
      canvas.drawLine(Offset(midX, y), Offset(midX, y + 4), dashPaint);
      y += 8;
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
    final path = Path()..moveTo(midX, height - 8);
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
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .35),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tỷ lệ tường mua/bán',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              width: double.infinity,
              height: 21,
              child: Row(
                children: [
                  Expanded(
                    flex: (bidPct * 10).round(),
                    child: Container(color: AppColors.buy),
                  ),
                  Expanded(
                    flex: ((100 - bidPct) * 10).round(),
                    child: Container(color: AppColors.sell),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Mua ${bidPct.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Bán ${(100 - bidPct).toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
