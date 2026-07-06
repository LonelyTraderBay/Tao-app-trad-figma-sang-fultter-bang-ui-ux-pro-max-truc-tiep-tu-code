import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

class PredictionSocialShareButton extends StatelessWidget {
  const PredictionSocialShareButton({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: AppRadii.cardRadius,
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Padding(
          padding: AppSpacing.predictionSocialShareButtonPadding,
          child: Row(
            children: [
              const Icon(
                Icons.share_rounded,
                color: AppColors.onAccent,
                size: AppSpacing.predictionSocialShareIcon,
              ),
              const SizedBox(width: AppSpacing.predictionSocialShareIconGap),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PredictionSocialMetric extends StatelessWidget {
  const PredictionSocialMetric({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class PredictionSocialSentimentLegend extends StatelessWidget {
  const PredictionSocialSentimentLegend({super.key, required this.item});

  final PredictionSentimentDraft item;

  @override
  Widget build(BuildContext context) {
    final color = item.tone.resolve();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: color,
              borderRadius: AppRadii.hairlineRadius,
              child: const SizedBox.square(
                dimension: AppSpacing.predictionSocialLegendSwatch,
              ),
            ),
            const SizedBox(width: AppSpacing.predictionSocialLegendGap),
            Text(
              item.name,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${item.value}%',
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class PredictionSocialSentimentPiePainter extends CustomPainter {
  const PredictionSocialSentimentPiePainter(this.data);

  final List<PredictionSentimentDraft> data;

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<int>(0, (sum, item) => sum + item.value);
    if (total == 0) return;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: math.min(size.width, size.height) / 2 - 14,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;
    var start = 0.0;
    for (final item in data) {
      final sweep = -(item.value / total) * math.pi * 2;
      paint.color = item.tone.resolve();
      canvas.drawArc(rect, start, sweep + .025, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(
    covariant PredictionSocialSentimentPiePainter oldDelegate,
  ) {
    return oldDelegate.data != data;
  }
}
