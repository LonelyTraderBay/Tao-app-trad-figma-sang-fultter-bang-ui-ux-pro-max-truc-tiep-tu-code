import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

class LaunchpadRebalanceAllocationCard extends StatelessWidget {
  const LaunchpadRebalanceAllocationCard({super.key, required this.assets});

  final List<LaunchpadRebalanceAssetDraft> assets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hien tai vs Muc tieu',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _DonutBlock(
                  label: 'Hien tai',
                  values: [for (final asset in assets) asset.currentPercent],
                  colors: [for (final asset in assets) asset.accent.resolve()],
                ),
              ),
              const Icon(
                Icons.sync_rounded,
                color: AppColors.text3,
                size: LaunchpadSpacingTokens.launchpadIcon2xl,
              ),
              Expanded(
                child: _DonutBlock(
                  label: 'Muc tieu',
                  values: [for (final asset in assets) asset.targetPercent],
                  colors: [for (final asset in assets) asset.accent.resolve()],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x2,
            children: [
              for (final asset in assets)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: LaunchpadSpacingTokens.launchpadDotMd,
                      height: LaunchpadSpacingTokens.launchpadDotMd,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: asset.accent.resolve(),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      asset.symbol,
                      style: AppTextStyles.chartLabelXs.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutBlock extends StatelessWidget {
  const _DonutBlock({
    required this.label,
    required this.values,
    required this.colors,
  });

  final String label;
  final List<double> values;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.chartLabelXs.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        SizedBox(
          width: LaunchpadSpacingTokens.launchpadBox104,
          height: LaunchpadSpacingTokens.launchpadBox104,
          child: CustomPaint(
            painter: _DonutPainter(values: values, colors: colors),
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.values, required this.colors});

  final List<double> values;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.butt;
    final total = values.fold<double>(0, (sum, value) => sum + value);
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = total == 0 ? 0.0 : values[i] / total * math.pi * 2;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 13),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}
