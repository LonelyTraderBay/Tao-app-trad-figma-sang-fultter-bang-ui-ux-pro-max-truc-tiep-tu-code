import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_dashboard_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingPerformanceCard extends StatelessWidget {
  const StakingPerformanceCard({super.key, required this.points});

  final List<StakingPerformancePointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
            child: Stack(
              children: [
                const Positioned(
                  left: 0,
                  top: AppSpacing.x3,
                  bottom: AppSpacing.x7,
                  child: _AxisLabels(),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PerformancePainter(points: points),
                    child: const SizedBox.expand(),
                  ),
                ),
                Positioned(
                  left: AppSpacing.x7,
                  right: AppSpacing.x3,
                  bottom: AppSpacing.x3,
                  child: _DateLabels(points: points),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const StakingLegendDot(
                color: AppColors.primary,
                label: 'Tổng giá trị',
              ),
              const SizedBox(width: AppSpacing.x6),
              const StakingLegendDot(color: AppColors.buy, label: 'Lợi nhuận'),
            ],
          ),
        ],
      ),
    );
  }
}

class StakingAllocationCard extends StatelessWidget {
  const StakingAllocationCard({
    super.key,
    required this.allocations,
    required this.total,
  });

  final List<StakingAllocationDraft> allocations;
  final double total;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.buttonHero + AppSpacing.x7,
            height: AppSpacing.buttonHero + AppSpacing.x6,
            child: CustomPaint(
              painter: _AllocationPainter(
                allocations: allocations,
                total: total,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Wrap(
              runSpacing: AppSpacing.x3,
              spacing: AppSpacing.x5,
              children: [
                for (final item in allocations)
                  _AllocationLegend(item: item, total: total),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AxisLabels extends StatelessWidget {
  const _AxisLabels();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final label in const ['\$16k', '\$12k', '\$8k', '\$4k', '\$0k'])
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}

class _DateLabels extends StatelessWidget {
  const _DateLabels({required this.points});

  final List<StakingPerformancePointDraft> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final index in stakingDateIndexes(points.length))
          Text(
            points[index].date,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}

class _AllocationLegend extends StatelessWidget {
  const _AllocationLegend({required this.item, required this.total});

  final StakingAllocationDraft item;
  final double total;

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : item.valueUsd / total * 100;
    return SizedBox(
      width: AppSpacing.buttonHero,
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.x3,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: stakingAssetColor(item.colorIndex),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.asset,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformancePainter extends CustomPainter {
  const _PerformancePainter({required this.points});

  final List<StakingPerformancePointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final left = AppSpacing.x7;
    final right = size.width - AppSpacing.x3;
    final top = AppSpacing.x4;
    final bottom = size.height - AppSpacing.x7;
    final chart = Rect.fromLTRB(left, top, right, bottom);

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    void drawLine(
      double Function(StakingPerformancePointDraft p) valueOf,
      Color color,
    ) {
      const minValue = 0.0;
      final maxValue = points
          .map((point) => math.max(point.valueUsd, point.earnedUsd))
          .reduce(math.max);
      final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x = chart.left + chart.width * i / (points.length - 1);
        final normalized = (valueOf(points[i]) - minValue) / range;
        final y = chart.bottom - normalized * chart.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = color;
      canvas.drawPath(path, paint);
    }

    drawLine((point) => point.valueUsd, AppColors.primary);
    drawLine((point) => point.earnedUsd, AppColors.buy);
  }

  @override
  bool shouldRepaint(covariant _PerformancePainter oldDelegate) =>
      oldDelegate.points != points;
}

class _AllocationPainter extends CustomPainter {
  const _AllocationPainter({required this.allocations, required this.total});

  final List<StakingAllocationDraft> allocations;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .34;
    final stroke = AppSpacing.x6;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = AppColors.surface3,
    );

    for (final item in allocations) {
      final sweep = total == 0 ? 0.0 : item.valueUsd / total * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt
        ..color = stakingAssetColor(item.colorIndex);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _AllocationPainter oldDelegate) =>
      oldDelegate.allocations != allocations || oldDelegate.total != total;
}
