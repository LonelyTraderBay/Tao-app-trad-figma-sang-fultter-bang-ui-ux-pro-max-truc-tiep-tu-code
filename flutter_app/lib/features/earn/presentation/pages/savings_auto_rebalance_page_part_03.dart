part of 'savings_auto_rebalance_page.dart';

class _CompareRow extends StatelessWidget {
  const _CompareRow({required this.label, required this.values});

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          SizedBox(
            width: _savingsRebalanceCompareLabelWidth,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          for (final value in values)
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: _captionMedium.copyWith(color: AppColors.text1),
              ),
            ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: _savingsRebalanceInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(value, style: _captionMedium.copyWith(color: AppColors.text1)),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(value, style: _captionMedium.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _RebalanceActionDraft {
  const _RebalanceActionDraft({
    required this.asset,
    required this.increase,
    required this.amount,
  });

  final String asset;
  final bool increase;
  final double amount;
}

class _AllocationRingPainter extends CustomPainter {
  const _AllocationRingPainter({
    required this.allocations,
    required this.positions,
  });

  final Map<String, double> allocations;
  final List<SavingsRebalancePositionDraft> positions;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = math.min(size.width, size.height) * .2;
    final rect = Offset.zero & size;
    final ringRect = rect.deflate(stroke / 2);
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    for (final entry in allocations.entries) {
      final sweep = math.pi * 2 * (entry.value / 100);
      paint.color = _assetColorName(entry.key);
      canvas.drawArc(ringRect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_AllocationRingPainter oldDelegate) {
    return oldDelegate.allocations != allocations ||
        oldDelegate.positions != positions;
  }
}

class _DriftTrackPainter extends CustomPainter {
  const _DriftTrackPainter({
    required this.color,
    required this.driftColor,
    required this.current,
    required this.target,
  });

  final Color color;
  final Color driftColor;
  final double current;
  final double target;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.elliptical(size.height / 2, size.height / 2);
    final track = RRect.fromRectAndRadius(Offset.zero & size, radius);
    canvas.drawRRect(track, Paint()..color = AppColors.surface2);
    final left = size.width * (math.min(current, target) / 100);
    final right = size.width * (math.max(current, target) / 100);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, 0, right, size.height),
        radius,
      ),
      Paint()..color = driftColor.withValues(alpha: .72),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * (current / 100), 0, 2, size.height),
      Paint()..color = color,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * (target / 100), 0, 2, size.height),
      Paint()..color = AppColors.text2.withValues(alpha: .62),
    );
  }

  @override
  bool shouldRepaint(_DriftTrackPainter oldDelegate) {
    return oldDelegate.current != current ||
        oldDelegate.target != target ||
        oldDelegate.color != color ||
        oldDelegate.driftColor != driftColor;
  }
}

class _DriftBarPainter extends CustomPainter {
  const _DriftBarPainter({required this.points});

  final List<SavingsRebalanceDriftPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(34, 8, size.width - 42, size.height - 28);
    final grid = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    for (final value in [0, 2, 4, 6, 8]) {
      final y = chart.bottom - chart.height * (value / 8);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), grid);
    }

    final step = chart.width / points.length;
    final barWidth = step * .64;
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final height = chart.height * (point.drift / 8).clamp(0, 1);
      final x = chart.left + step * i + (step - barWidth) / 2;
      final color = _driftColor(point.drift).withValues(alpha: .86);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, chart.bottom - height, barWidth, height),
          const Radius.elliptical(AppRadii.xs, AppRadii.xs),
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_DriftBarPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

double _totalDrift(
  List<SavingsRebalancePositionDraft> positions,
  SavingsRebalanceStrategyDraft strategy,
) {
  final total = positions.fold<double>(0, (sum, position) {
    final target = strategy.allocations[position.asset] ?? position.targetPct;
    return sum + (position.currentPct - target).abs();
  });
  return total / 2;
}

List<_RebalanceActionDraft> _rebalanceActions(
  SavingsAutoRebalanceSnapshot snapshot,
  SavingsRebalanceStrategyDraft strategy,
) {
  return [
    for (final position in snapshot.positions)
      if (position.rebalanceable)
        (() {
          final target =
              strategy.allocations[position.asset] ?? position.targetPct;
          final diff = target - position.currentPct;
          final amount = (diff.abs() / 100) * snapshot.totalPortfolio;
          if (diff.abs() < .5 || amount < snapshot.settings.minTradeSize) {
            return null;
          }
          return _RebalanceActionDraft(
            asset: position.asset,
            increase: diff > 0,
            amount: amount,
          );
        })(),
  ].whereType<_RebalanceActionDraft>().toList();
}

Color _assetColor(SavingsRebalancePositionDraft position) {
  return _assetColorName(position.asset);
}

Color _assetColorName(String asset) {
  switch (asset) {
    case 'USDT':
      return AppColors.buy;
    case 'BTC':
      return AppColors.primary;
    case 'SOL':
      return AppColors.accent;
    case 'ETH':
      return AppColors.text2;
    default:
      return AppColors.text3;
  }
}

Color _driftColor(double drift) {
  if (drift < 2.5) return AppColors.buy;
  if (drift < 8) return AppColors.primary;
  return AppColors.sell;
}

Color _riskColor(SavingsRebalanceRiskLevel risk) {
  switch (risk) {
    case SavingsRebalanceRiskLevel.low:
      return AppColors.buy;
    case SavingsRebalanceRiskLevel.medium:
      return AppColors.primary;
    case SavingsRebalanceRiskLevel.high:
      return AppColors.sell;
  }
}

String _riskLabel(SavingsRebalanceRiskLevel risk) {
  switch (risk) {
    case SavingsRebalanceRiskLevel.low:
      return 'Thấp';
    case SavingsRebalanceRiskLevel.medium:
      return 'Trung bình';
    case SavingsRebalanceRiskLevel.high:
      return 'Cao';
  }
}

IconData _riskIcon(SavingsRebalanceRiskLevel risk) {
  switch (risk) {
    case SavingsRebalanceRiskLevel.low:
      return Icons.shield_outlined;
    case SavingsRebalanceRiskLevel.medium:
      return Icons.adjust_rounded;
    case SavingsRebalanceRiskLevel.high:
      return Icons.trending_up_rounded;
  }
}

Color _historyColor(SavingsRebalanceHistoryStatus status) {
  switch (status) {
    case SavingsRebalanceHistoryStatus.completed:
      return AppColors.buy;
    case SavingsRebalanceHistoryStatus.partial:
      return AppColors.primary;
    case SavingsRebalanceHistoryStatus.failed:
      return AppColors.sell;
  }
}

String _historyLabel(SavingsRebalanceHistoryStatus status) {
  switch (status) {
    case SavingsRebalanceHistoryStatus.completed:
      return 'Hoàn tất';
    case SavingsRebalanceHistoryStatus.partial:
      return 'Một phần';
    case SavingsRebalanceHistoryStatus.failed:
      return 'Thất bại';
  }
}

IconData _historyIcon(SavingsRebalanceHistoryStatus status) {
  switch (status) {
    case SavingsRebalanceHistoryStatus.completed:
      return Icons.check_circle_outline_rounded;
    case SavingsRebalanceHistoryStatus.partial:
      return Icons.warning_amber_rounded;
    case SavingsRebalanceHistoryStatus.failed:
      return Icons.error_outline_rounded;
  }
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(value >= 1000 ? 2 : 0);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) return '\$$buffer.${parts.last}';
  return '\$$buffer';
}
