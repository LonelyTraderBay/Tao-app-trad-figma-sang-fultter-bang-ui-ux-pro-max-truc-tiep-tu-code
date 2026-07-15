import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings/savings_portfolio_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings/savings_portfolio_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class MaturitySummary extends StatelessWidget {
  const MaturitySummary({super.key, required this.events});

  final List<SavingsMaturityEventDraft> events;

  @override
  Widget build(BuildContext context) {
    final total = events.length;
    return VitCard(
      radius: VitCardRadius.large,
      padding: savingsPortfolioCardPadding,
      child: Row(
        children: [
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.warn10,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
            ),
            child: const SizedBox(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              child: Icon(
                Icons.calendar_month_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sắp đáo hạn',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  '$total khoản',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tổng giá trị',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                '\$6,000.86',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
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

class MaturityCard extends StatelessWidget {
  const MaturityCard({super.key, required this.event});

  final SavingsMaturityEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = riskColor(event.tone);
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: color.withValues(alpha: 0.45),
      padding: savingsPortfolioCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AssetBadge(asset: event.asset, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.product,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: StatusPill(
                            label: statusLabel(event.tone),
                            color: color,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          event.apy,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              DaysPill(days: event.daysLeft, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface3,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
            ),
            child: Padding(
              padding: savingsPortfolioCardPadding,
              child: Row(
                children: [
                  Expanded(
                    child: MiniMetric(label: 'Số lượng', value: event.amount),
                  ),
                  Expanded(
                    child: MiniMetric(
                      label: 'Giá trị',
                      value: event.usdValue,
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Text(
                'Hoàn thành ${(event.progress * 100).round()}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Expanded(
                child: Text(
                  event.elapsedLabel,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitProgressBar(
            progress: event.progress,
            color: color,
            trackColor: AppColors.surface3,
            height: AppSpacing.pageRhythmCompactInnerGap,
            borderRadius: AppRadii.xlRadius,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Đáo hạn: ${event.date}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Gia hạn',
                  icon: Icons.refresh_rounded,
                  onTap: () => HapticFeedback.selectionClick(),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: SecondaryButton(
                  label: 'Rút khi đáo hạn',
                  icon: Icons.arrow_upward_rounded,
                  color: color,
                  onTap: () => HapticFeedback.selectionClick(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class DonutSegment {
  const DonutSegment({required this.value, required this.color});

  final double value;
  final Color color;
}

class DonutPainter extends CustomPainter {
  const DonutPainter({required this.segments});

  final List<DonutSegment> segments;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = EarnSpacingTokens.savingsPortfolioDonutStrokeWidth;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: EarnSpacingTokens.savingsPortfolioDonutDiameter,
      height: EarnSpacingTokens.savingsPortfolioDonutDiameter,
    );
    var start = -math.pi / 2;
    for (final segment in segments) {
      final sweep = math.pi * 2 * segment.value;
      paint.color = segment.color;
      canvas.drawArc(rect, start, sweep - 0.035, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}
