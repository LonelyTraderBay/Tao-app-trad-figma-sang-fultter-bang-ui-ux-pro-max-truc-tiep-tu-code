part of 'dca_page.dart';

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    final color = switch (symbol) {
      'BTC' => AppColors.warn,
      'ETH' => AppColors.text2,
      'SOL' => AppColors.accent,
      _ => AppColors.primary,
    };
    final icon = switch (symbol) {
      'BTC' => Icons.currency_bitcoin_rounded,
      'ETH' => Icons.diamond_outlined,
      'SOL' => Icons.blur_on_rounded,
      _ => Icons.token_rounded,
    };
    return Container(
      width: AppSpacing.dcaMainAssetIconBox,
      height: AppSpacing.dcaMainAssetIconBox,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: .24)),
      ),
      child: Icon(icon, color: color, size: AppSpacing.dcaMainAssetIcon),
    );
  }
}

class _PlanMetric extends StatelessWidget {
  const _PlanMetric({
    required this.label,
    required this.value,
    required this.unit,
    this.color = AppColors.text1,
    this.icon,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.dcaMainTightLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x1),
            ],
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  height: AppSpacing.dcaMainTightLineHeight,
                ),
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.x1),
              Text(
                unit,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.dcaMainTightLineHeight,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _PlanIconButton extends StatelessWidget {
  const _PlanIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.ctaHeight,
      height: AppSpacing.dcaMainActionHeight,
      child: VitCard(
        variant: VitCardVariant.inner,
        radius: VitCardRadius.sm,
        onTap: onTap,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({super.key, required this.snapshot});

  final DcaDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Lịch sử danh mục',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const VitStatusPill(
                label: '90 ngày',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          SizedBox(
            height: AppSpacing.dcaMainHistoryChartHeight,
            child: CustomPaint(
              painter: _HistoryChartPainter(
                values: snapshot.history,
                lineColor: AppColors.buy,
                investedColor: AppColors.primary,
                gridColor: AppColors.divider,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HistoryStat(
                  label: 'Giá trị',
                  value: _formatCompactVnd(snapshot.overview.currentValueVnd),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _HistoryStat(
                  label: 'Đã đầu tư',
                  value: _formatCompactVnd(snapshot.overview.totalInvestedVnd),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryStat extends StatelessWidget {
  const _HistoryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitMetricCard(label: label, value: value, accentColor: color);
  }
}

class _CreatePlanSheet extends StatelessWidget {
  const _CreatePlanSheet({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: AppColors.dynamicIslandBg.withValues(alpha: .54),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                child: const SizedBox.expand(),
              ),
            ),
            VitCard(
              key: DCAPage.createSheetKey,
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.contentPad),
              margin: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                0,
                AppSpacing.contentPad,
                AppSpacing.contentPad,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: AppSpacing.dcaMainToolIconBox,
                        height: AppSpacing.dcaMainToolIconBox,
                        decoration: const BoxDecoration(
                          color: AppColors.primary12,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_chart_rounded,
                          color: AppColors.primary,
                          size: AppSpacing.dcaMainToolIcon,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tạo kế hoạch DCA',
                              style: AppTextStyles.base.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            Text(
                              'Chọn coin, số tiền và lịch mua trong bước sau.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  VitCtaButton(
                    onPressed: onClose,
                    leading: const Icon(Icons.check_rounded),
                    child: const Text('Đã hiểu'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final path = _buildLinePath(values, size);
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(
      Offset(size.width, _yForValue(values.last, values, size)),
      4,
      Paint()..color = lineColor,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}
