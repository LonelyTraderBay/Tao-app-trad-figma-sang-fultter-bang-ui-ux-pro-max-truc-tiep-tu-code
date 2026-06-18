part of '../pages/wallet_gas_optimizer_page.dart';

class _TipsTab extends StatelessWidget {
  const _TipsTab({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.walletGasSecondaryContentGap,
      children: [
        const _SectionLabel(label: 'Gas Optimization Tips'),
        for (var i = 0; i < snapshot.tips.length; i++) ...[
          _TipCard(tip: snapshot.tips[i]),
        ],
        const _QuickActionsCard(),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final WalletGasTip tip;

  @override
  Widget build(BuildContext context) {
    final color = switch (tip.difficulty) {
      'easy' => _gasGreen,
      'medium' => _gasAmber,
      'advanced' => _gasRed,
      _ => AppColors.text3,
    };
    return VitCard(
      padding: AppSpacing.walletGasTipPadding,
      borderColor: _gasBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            width: AppSpacing.walletGasTipIconBox,
            height: AppSpacing.walletGasTipIconBox,
            alignment: Alignment.center,
            radius: VitCardRadius.sm,
            borderColor: _gasAmber.withValues(alpha: .20),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: _gasAmber,
              size: AppSpacing.walletGasTipIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.walletGasTipIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tip.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    _SmallBadge(
                      label: tip.difficulty.toUpperCase(),
                      color: color,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.walletGasTipTitleGap),
                Text(
                  tip.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.walletGasTipFooterGap),
                Row(
                  children: [
                    _CategoryPill(label: tip.category),
                    const Spacer(),
                    const Icon(
                      Icons.attach_money_rounded,
                      color: _gasGreen,
                      size: AppSpacing.walletGasSavingIcon,
                    ),
                    Text(
                      tip.potentialSaving,
                      style: AppTextStyles.caption.copyWith(
                        color: _gasGreen,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: AppColors.textSoftBlue);
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.walletGasTipPadding,
      borderColor: _gasBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.walletGasQuickActionsTitleGap),
          for (final label in const [
            'Set Gas Price Alert',
            'Schedule Transaction',
            'View L2 Options',
          ])
            Padding(
              padding: AppSpacing.zeroInsets.copyWith(
                bottom: AppSpacing.walletGasQuickActionBottomGap,
              ),
              child: VitCard(
                height: AppSpacing.walletGasQuickActionHeight,
                padding: AppSpacing.walletGasQuickActionPadding,
                radius: VitCardRadius.sm,
                borderColor: _gasBorder,
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(
                      Icons.bolt_outlined,
                      color: AppColors.text3,
                      size: AppSpacing.walletGasQuickActionIcon,
                    ),
                    const SizedBox(
                      width: AppSpacing.walletGasQuickActionIconGap,
                    ),
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.walletGasQuickActionArrow,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GasLineChartPainter extends CustomPainter {
  const _GasLineChartPainter({required this.points});

  final List<WalletGasHistoryPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final chart = Rect.fromLTWH(
      AppSpacing.walletGasLineChartInsetX,
      AppSpacing.walletGasLineChartInsetTop,
      size.width - AppSpacing.walletGasLineChartInsetX * 2,
      size.height - AppSpacing.walletGasLineChartInsetBottom,
    );
    _drawGasLine(canvas, chart, points.map((p) => p.slow).toList(), _gasGreen);
    _drawGasLine(
      canvas,
      chart,
      points.map((p) => p.standard).toList(),
      _gasAmber,
    );
    _drawGasLine(canvas, chart, points.map((p) => p.fast).toList(), _gasRed);
  }

  void _drawGasLine(Canvas canvas, Rect chart, List<int> values, Color color) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(1, maxValue - minValue);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chart.left + chart.width * i / (values.length - 1);
      final y = chart.bottom - ((values[i] - minValue) / range) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppSpacing.walletGasChartStroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GasLineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _NetworkBarChartPainter extends CustomPainter {
  const _NetworkBarChartPainter({required this.points});

  final List<WalletNetworkActivityPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxTx = points.map((point) => point.txCount).reduce(math.max);
    final barWidth =
        size.width /
        (points.length * AppSpacing.walletGasNetworkBarWidthDivisor);
    final gap = barWidth * AppSpacing.walletGasNetworkBarGapMultiplier;
    final paint = Paint()..color = _gasPrimary;
    for (var i = 0; i < points.length; i++) {
      final barHeight =
          (points[i].txCount / maxTx) *
          (size.height - AppSpacing.walletGasNetworkBarHeightInset);
      final left =
          i * (barWidth + gap) + AppSpacing.walletGasNetworkBarLeftPadding;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
        AppRadii.statusBarCorner,
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NetworkBarChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _withCommas(String value) {
  final buffer = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    final remaining = value.length - i;
    buffer.write(value[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
