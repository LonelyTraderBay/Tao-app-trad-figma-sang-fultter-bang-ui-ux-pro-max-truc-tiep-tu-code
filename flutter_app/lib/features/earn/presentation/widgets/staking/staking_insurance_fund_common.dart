import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

enum StakingInsuranceFundTab { overview, claims, history }

final class StakingInsuranceFundKeys {
  const StakingInsuranceFundKeys._();

  static const info = Key('sc377_info');
  static const tabs = Key('sc377_tabs');
  static const fundStatus = Key('sc377_fund_status');
  static const assetBreakdown = Key('sc377_asset_breakdown');
  static const contribution = Key('sc377_contribution');
  static const claims = Key('sc377_claims');
  static const history = Key('sc377_history');
  static const audits = Key('sc377_audits');
  static const footer = Key('sc377_footer');

  static Key tab(String id) => Key('sc377_tab_$id');

  static Key claim(String id) => Key('sc377_claim_$id');
}

class StakingInsuranceFundStatusPill extends StatelessWidget {
  const StakingInsuranceFundStatusPill({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class StakingInsuranceFundFooterNote extends StatelessWidget {
  const StakingInsuranceFundFooterNote({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsuranceFundKeys.footer,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: EarnSpacingTokens.stakingProductBodyLineHeight,
        ),
      ),
    );
  }
}

class StakingInsuranceFundProgressRingPainter extends CustomPainter {
  const StakingInsuranceFundProgressRingPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = AppSpacing.x4.toDouble();
    final rect = Offset.zero & size;
    final ringRect = rect.deflate(stroke / 2);
    final track = Paint()
      ..color = AppColors.surface3
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final active = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(ringRect, 0, math.pi * 2, false, track);
    canvas.drawArc(
      ringRect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(
    covariant StakingInsuranceFundProgressRingPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class StakingInsuranceFundPiePainter extends CustomPainter {
  const StakingInsuranceFundPiePainter({required this.assets});

  final List<StakingInsuranceFundAssetDraft> assets;

  @override
  void paint(Canvas canvas, Size size) {
    final total = assets.fold<double>(0, (sum, asset) => sum + asset.value);
    if (total <= 0) return;
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;
    for (final asset in assets) {
      final sweep = math.pi * 2 * (asset.value / total);
      paint.color = stakingInsuranceFundAssetColor(asset.colorKey);
      canvas.drawArc(rect.deflate(AppSpacing.x2), start, sweep, true, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant StakingInsuranceFundPiePainter oldDelegate) {
    return oldDelegate.assets != assets;
  }
}

class StakingInsuranceFundHistoryPainter extends CustomPainter {
  const StakingInsuranceFundHistoryPainter({required this.history});

  final List<StakingInsuranceFundHistoryDraft> history;

  @override
  void paint(Canvas canvas, Size size) {
    if (history.length < 2) return;
    final area = Rect.fromLTWH(
      AppSpacing.x4,
      AppSpacing.x4,
      size.width - AppSpacing.x6,
      size.height - AppSpacing.x6,
    );
    final gridPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = area.top + area.height * i / 3;
      canvas.drawLine(Offset(area.left, y), Offset(area.right, y), gridPaint);
    }
    _drawLine(
      canvas,
      area,
      history.map((item) => item.balance).toList(),
      AppColors.primarySoft,
    );
    _drawLine(
      canvas,
      area,
      history.map((item) => item.ratio.toDouble()).toList(),
      AppColors.buy,
    );
  }

  void _drawLine(Canvas canvas, Rect area, List<double> values, Color color) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(maxValue - minValue, 1);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = area.left + area.width * i / (values.length - 1);
      final normalized = (values[i] - minValue) / range;
      final y = area.bottom - area.height * normalized;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant StakingInsuranceFundHistoryPainter oldDelegate) {
    return oldDelegate.history != history;
  }
}

String stakingInsuranceFundTabLabel(StakingInsuranceFundTab tab) {
  return switch (tab) {
    StakingInsuranceFundTab.overview => 'Overview',
    StakingInsuranceFundTab.claims => 'Claims',
    StakingInsuranceFundTab.history => 'History',
  };
}

Color stakingInsuranceFundAssetColor(String colorKey) {
  return switch (colorKey) {
    'primary' => AppColors.primarySoft,
    'warning' => AppColors.warn,
    'success' => AppColors.buy,
    _ => AppColors.text3,
  };
}

String stakingInsuranceFundFormatUsd(double value) {
  if (value >= 1000000) {
    final formatted = value.toStringAsFixed(2);
    return '\$${stakingInsuranceFundCommaWhole(formatted)}';
  }
  final formatted = value.toStringAsFixed(2);
  return '\$${stakingInsuranceFundCommaWhole(formatted)}';
}

String stakingInsuranceFundCommaWhole(String fixedValue) {
  final parts = fixedValue.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[i]);
  }
  return '${buffer.toString()}.${parts.last}';
}
