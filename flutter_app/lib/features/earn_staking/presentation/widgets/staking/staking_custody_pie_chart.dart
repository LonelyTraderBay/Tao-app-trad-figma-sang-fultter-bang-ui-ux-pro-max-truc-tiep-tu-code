part of 'staking_custody_common.dart';

class StakingCustodyPieChart extends StatelessWidget {
  const StakingCustodyPieChart({
    super.key,
    required this.allocations,
    required this.size,
    required this.donut,
  });

  final List<StakingCustodyAllocationDraft> allocations;
  final double size;
  final bool donut;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: StakingCustodyPieChartPainter(
          allocations: allocations,
          donut: donut,
        ),
        child: Center(
          child: donut
              ? DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: AppColors.cardBg,
                    shape: CircleBorder(),
                  ),
                  child: SizedBox(width: size * 0.48, height: size * 0.48),
                )
              : null,
        ),
      ),
    );
  }
}

class StakingCustodyPieChartPainter extends CustomPainter {
  const StakingCustodyPieChartPainter({
    required this.allocations,
    required this.donut,
  });

  final List<StakingCustodyAllocationDraft> allocations;
  final bool donut;

  @override
  void paint(Canvas canvas, Size size) {
    final total = allocations.fold<int>(0, (sum, item) => sum + item.value);
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final allocation in allocations) {
      final sweep = (allocation.value / total) * math.pi * 2;
      paint.color = stakingCustodyToneColor(allocation.tone);
      canvas.drawArc(rect.deflate(8), start, sweep, true, paint);
      start += sweep;
    }

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.borderSolid;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide / 2 - 8,
      stroke,
    );

    if (donut) {
      final holePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = AppColors.cardBg;
      canvas.drawCircle(
        size.center(Offset.zero),
        size.shortestSide * 0.24,
        holePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StakingCustodyPieChartPainter oldDelegate) {
    return oldDelegate.allocations != allocations || oldDelegate.donut != donut;
  }
}

IconData stakingCustodyIconFor(String iconKey) {
  return switch (iconKey) {
    'building' => Icons.account_balance_outlined,
    'lock' => Icons.lock_outline_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.circle_outlined,
  };
}

Color stakingCustodyToneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.accent,
  };
}

String stakingCustodyFormatUsd(double amount) {
  if (amount >= 1000000000) {
    return '\$${(amount / 1000000000).toStringAsFixed(2)}B';
  }
  if (amount >= 1000000) {
    return '\$${(amount / 1000000).toStringAsFixed(2)}M';
  }
  if (amount == 0) return '\$0.00';
  return '\$${amount.toStringAsFixed(2)}';
}
