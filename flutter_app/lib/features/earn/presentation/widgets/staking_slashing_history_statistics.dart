import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_slashing_history_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingSlashingStatisticsTab extends StatelessWidget {
  const StakingSlashingStatisticsTab({super.key, required this.snapshot});

  final StakingSlashingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingSlashingHistoryKeys.statistics,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingSlashingHistoryKeys.trend,
          label: '12-Month Trend',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX4,
              child: Column(
                children: [
                  SizedBox(
                    height: EarnSpacingTokens.stakingSlashingStatsChartHeight,
                    child: CustomPaint(
                      painter: _TrendPainter(snapshot.trend),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      const Icon(
                        Icons.trending_down_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
                      Text(
                        '-40% vs 12 months ago',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                      const CircleAvatar(
                        radius: 2,
                        backgroundColor: AppColors.borderSolid,
                      ),
                      Text(
                        'Avg: 0.25 events/month',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Breakdown by Network',
          accentColor: AppColors.primarySoft,
          children: [
            for (final item in snapshot.networkBreakdown)
              _NetworkBreakdownCard(item: item),
          ],
        ),
        VitPageSection(
          label: 'Breakdown by Reason',
          accentColor: AppColors.primarySoft,
          children: [
            for (final item in snapshot.reasonBreakdown)
              _ReasonBreakdownCard(item: item),
          ],
        ),
      ],
    );
  }
}

class _NetworkBreakdownCard extends StatelessWidget {
  const _NetworkBreakdownCard({required this.item});

  final StakingSlashingNetworkDraft item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.network, style: AppTextStyles.baseMedium),
              ),
              Text(
                '${item.events} events',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _BreakdownTile(
                  label: 'Total Slashed',
                  value:
                      '${stakingSlashingFormatEth(item.amount)} ${item.unit}',
                  color: AppColors.sell,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _BreakdownTile(
                  label: 'Coverage',
                  value: '${item.coverage}%',
                  color: AppColors.buy,
                  borderColor: AppColors.buy20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.label,
    required this.value,
    required this.color,
    this.borderColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonBreakdownCard extends StatelessWidget {
  const _ReasonBreakdownCard({required this.item});

  final StakingSlashingReasonDraft item;

  @override
  Widget build(BuildContext context) {
    final color = stakingSlashingSeverityColor(item.severity);
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.reason, style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${stakingSlashingCapitalize(item.severity)} severity',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            item.events.toString(),
            style: AppTextStyles.baseMedium.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter(this.points);

  final List<StakingSlashingTrendPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    if (points.isEmpty) return;
    final maxAmount = points.map((p) => p.amountEth).reduce(math.max);
    final scale = maxAmount <= 0 ? 1 : maxAmount;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = points.length == 1 ? 0.0 : size.width * i / (points.length - 1);
      final y = size.height - (points[i].amountEth / scale) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = AppColors.sell
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = AppColors.sell
      ..style = PaintingStyle.fill;
    for (var i = 0; i < points.length; i++) {
      final x = points.length == 1 ? 0.0 : size.width * i / (points.length - 1);
      final y = size.height - (points[i].amountEth / scale) * size.height;
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
