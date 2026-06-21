part of '../pages/staking_risk_dashboard_page.dart';

class _MiniRiskMetric extends StatelessWidget {
  const _MiniRiskMetric({
    required this.label,
    required this.value,
    this.color,
    this.borderColor,
  });

  final String label;
  final String value;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      padding: AppSpacing.earnCardPaddingX3,
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color ?? AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.15),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.pillRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnPillPaddingLarge,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.15),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          '$score/100',
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRiskDashboardPage.footerKey,
      variant: VitCardVariant.inner,
      padding: AppSpacing.earnCardPaddingX3,
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: AppSpacing.stakingEarnHeroTabLabelLineHeight,
        ),
      ),
    );
  }
}

class _ExposurePiePainter extends CustomPainter {
  const _ExposurePiePainter(this.items);

  final List<StakingRiskExposureDraft> items;

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;
    for (final item in items) {
      final sweep = math.pi * 2 * item.percentage / 100;
      paint.color = _exposureColor(item.risk);
      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }
    final border = Paint()
      ..color = AppColors.borderSolid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, border);
  }

  @override
  bool shouldRepaint(covariant _ExposurePiePainter oldDelegate) {
    return oldDelegate.items != items;
  }
}

Color _riskColor(int score) {
  if (score < 25) return AppColors.buy;
  if (score < 50) return AppColors.warn;
  if (score < 75) return AppColors.riskHigh;
  return AppColors.sell;
}

String _riskLabel(int score) {
  if (score < 25) return 'Low Risk';
  if (score < 50) return 'Moderate Risk';
  if (score < 75) return 'High Risk';
  return 'Critical Risk';
}

IconData _riskIcon(String status) {
  return switch (status) {
    'low' => Icons.shield_outlined,
    'critical' => Icons.warning_amber_rounded,
    _ => Icons.error_outline_rounded,
  };
}

Color _exposureColor(String risk) {
  return risk == 'low' ? AppColors.buy : AppColors.warn;
}

Color _eventColor(String type) {
  return switch (type) {
    'warning' => AppColors.warn,
    'resolved' => AppColors.buy,
    _ => AppColors.primarySoft,
  };
}

IconData _eventIcon(String type) {
  return switch (type) {
    'warning' => Icons.warning_amber_rounded,
    'resolved' => Icons.shield_outlined,
    _ => Icons.monitor_heart_outlined,
  };
}

Color _toneColor(String tone) {
  return switch (tone) {
    'sell' => AppColors.sell,
    'buy' => AppColors.buy,
    'accent' => AppColors.accent,
    _ => AppColors.primarySoft,
  };
}

IconData _actionIcon(String tone) {
  return switch (tone) {
    'sell' => Icons.warning_amber_rounded,
    'buy' => Icons.shield_outlined,
    'accent' => Icons.verified_user_outlined,
    _ => Icons.monitor_heart_outlined,
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
