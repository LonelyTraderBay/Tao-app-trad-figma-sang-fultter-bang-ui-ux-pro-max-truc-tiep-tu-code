part of 'home_page.dart';

class _RankedRow extends StatelessWidget {
  const _RankedRow({
    required this.rank,
    required this.pair,
    required this.positive,
    required this.onTap,
  });

  final int rank;
  final HomeCryptoPair pair;
  final bool positive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.buy : AppColors.sell;
    final bg = positive ? AppColors.buy10 : AppColors.sell10;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.homeSectionHorizontalPadding,
          vertical: AppSpacing.homeSectionVerticalPadding,
        ),
        child: Row(
          children: [
            SizedBox(
              width: AppSpacing.homeRankedRowRankChipWidth,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: rank == 1 && positive
                      ? AppColors.warn
                      : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.homeMarketIconGap),
            const SizedBox(width: AppSpacing.homeMarketIconGap),
            _CoinAvatar(pair: pair),
            const SizedBox(width: AppSpacing.homeMarketIconGap),
            Expanded(
              child: Text(
                pair.symbol,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.homeRankedRowBadgePaddingHorizontal,
                vertical: AppSpacing.homeRankedRowBadgePaddingVertical,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: AppRadii.xsRadius,
              ),
              child: Text(
                _formatPct(pair.change24h),
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({
    required this.pair,
    this.size = AppSpacing.homeCoinAvatarSize,
    this.radius = AppRadii.smRadius,
  });

  final HomeCryptoPair pair;
  final double size;
  final BorderRadiusGeometry radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: 0.16),
        borderRadius: radius,
      ),
      child: Text(
        pair.baseAsset.characters.first,
        style: AppTextStyles.caption.copyWith(
          color: pair.logoColor,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: active
          ? AppSpacing.homeAnnouncementDotActiveWidth
          : AppSpacing.homeAnnouncementDotInactiveWidth,
      height: AppSpacing.homeAnnouncementDotHeight,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary
            : AppColors.text3.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(
          AppSpacing.homeAnnouncementDotRadius,
        ),
      ),
    );
  }
}

class _PortfolioGlow extends StatelessWidget {
  const _PortfolioGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.58, -0.68),
          radius: 0.82,
          colors: [
            AppColors.primary12,
            AppColors.primary08.withValues(alpha: 0.08),
            AppColors.transparent,
          ],
          stops: const [0, 0.36, 1],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y =
          size.height -
          ((values[i] - minValue) / range * (size.height - 6)) -
          3;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

String _formatUsd(double value, {bool forceTwoDecimals = false}) {
  final decimals = forceTwoDecimals || value >= 1 ? 2 : 4;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final buffer = StringBuffer();
  final whole = parts.first;
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatBillions(double value) {
  return (value / 1000000000).toStringAsFixed(2);
}
