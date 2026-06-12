part of 'p2p_ad_analytics_page.dart';

class _VolumeCard extends StatelessWidget {
  const _VolumeCard({required this.points});

  final List<P2PAdDailyPerformanceDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Volume giao dịch',
            color: AppColors.primary,
          ),
          Text(
            'Tổng giá trị giao dịch theo ngày (VND)',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.x7 * 3,
            child: CustomPaint(
              painter: _VolumeBarPainter(points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.points});

  final List<P2PAdHourlyHeatmapDraft> points;

  @override
  Widget build(BuildContext context) {
    final maxOrders = points.fold<int>(
      0,
      (max, point) => math.max(max, point.orders),
    );

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.monitor_heart_outlined,
            title: 'Heatmap theo giờ',
            color: AppColors.buy,
          ),
          Text(
            'Số đơn hàng phân bổ theo giờ trong ngày (0-23h)',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          LayoutBuilder(
            builder: (context, constraints) {
              final gap = AppSpacing.x2;
              final side = (constraints.maxWidth - gap * 11) / 12;
              return Wrap(
                spacing: gap,
                runSpacing: AppSpacing.x3,
                children: [
                  for (final point in points)
                    SizedBox(
                      width: side,
                      child: Column(
                        children: [
                          Container(
                            width: side,
                            height: side,
                            decoration: BoxDecoration(
                              color: _heatColor(point.orders, maxOrders),
                              borderRadius: AppRadii.smRadius,
                            ),
                          ),
                          if (point.hour % 3 == 0) ...[
                            const SizedBox(height: AppSpacing.x1),
                            Text(
                              '${point.hour}h',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                height: 1,
                              ),
                            ),
                          ] else
                            const SizedBox(height: AppSpacing.x3),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _LegendDot(color: AppColors.buy10, label: 'Ít'),
              Row(
                children: const [
                  _HeatLegendCell(alpha: .22),
                  SizedBox(width: AppSpacing.x1),
                  _HeatLegendCell(alpha: .38),
                  SizedBox(width: AppSpacing.x1),
                  _HeatLegendCell(alpha: .54),
                  SizedBox(width: AppSpacing.x1),
                  _HeatLegendCell(alpha: .70),
                ],
              ),
              const _LegendDot(color: AppColors.buy, label: 'Nhiều'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentBreakdownCard extends StatelessWidget {
  const _PaymentBreakdownCard({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final total = snapshot.paymentBreakdown.fold<int>(
      0,
      (sum, item) => sum + item.volume,
    );

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.credit_card_rounded,
            title: 'Thanh toán phân bổ',
            color: AppColors.warn,
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < snapshot.paymentBreakdown.length; i++) ...[
            _PaymentRow(
              item: snapshot.paymentBreakdown[i],
              totalVolume: total,
              color: i.isEven ? AppColors.accent : AppColors.primary,
            ),
            if (i < snapshot.paymentBreakdown.length - 1)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.item,
    required this.totalVolume,
    required this.color,
  });

  final P2PAdPaymentBreakdownDraft item;
  final int totalVolume;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = totalVolume == 0 ? 0.0 : item.volume / totalVolume;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.method,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              '${item.count} đơn',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(width: AppSpacing.x4),
            Text(
              _formatCompactVnd(item.volume),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.smRadius,
          child: LinearProgressIndicator(
            value: pct,
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _CompetitorCard extends StatelessWidget {
  const _CompetitorCard({required this.rows});

  final List<P2PAdCompetitorComparisonDraft> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.emoji_events_outlined,
            title: 'So sánh đối thủ',
            color: AppColors.warn,
          ),
          Text(
            'So với trung bình thị trường & top merchant',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          SizedBox(
            height: AppSpacing.buttonHero * 2 + AppSpacing.x6,
            child: CustomPaint(
              painter: _RadarComparisonPainter(rows),
              child: const SizedBox.expand(),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: AppColors.accent, label: 'Bạn'),
              SizedBox(width: AppSpacing.x4),
              _LegendDot(color: AppColors.text3, label: 'TB thị trường'),
              SizedBox(width: AppSpacing.x4),
              _LegendDot(color: AppColors.buy, label: 'Top'),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          ClipRRect(
            borderRadius: AppRadii.cardRadius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Column(
                children: [
                  const _ComparisonTableRow(
                    metric: 'Chỉ số',
                    yours: 'Bạn',
                    average: 'TB',
                    top: 'Top',
                    header: true,
                  ),
                  for (final row in rows)
                    _ComparisonTableRow(
                      metric: row.metric,
                      yours: _formatComparison(row.metric, row.yours),
                      average: _formatComparison(row.metric, row.average),
                      top: _formatComparison(row.metric, row.top),
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

class _ComparisonTableRow extends StatelessWidget {
  const _ComparisonTableRow({
    required this.metric,
    required this.yours,
    required this.average,
    required this.top,
    this.header = false,
  });

  final String metric;
  final String yours;
  final String average;
  final String top;
  final bool header;

  @override
  Widget build(BuildContext context) {
    final bg = header ? AppColors.surface2 : AppColors.transparent;
    final weight = header ? AppTextStyles.bold : AppTextStyles.normal;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        border: header
            ? null
            : const Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                metric,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: header ? AppColors.text3 : AppColors.text2,
                  fontWeight: weight,
                ),
              ),
            ),
            Expanded(
              child: _TableCell(
                text: yours,
                color: header ? AppColors.accent : AppColors.text1,
                bold: header,
              ),
            ),
            Expanded(
              child: _TableCell(
                text: average,
                color: AppColors.text3,
                bold: header,
              ),
            ),
            Expanded(
              child: _TableCell(text: top, color: AppColors.buy, bold: header),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.text,
    required this.color,
    required this.bold,
  });

  final String text;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontWeight: bold ? AppTextStyles.bold : AppTextStyles.medium,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.tips});

  final List<P2PAdOptimizationTipDraft> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.bolt_rounded,
            title: 'Gợi ý tối ưu',
            color: AppColors.warn,
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < tips.length; i++) ...[
            _TipRow(tip: tips[i]),
            if (i < tips.length - 1) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.tip});

  final P2PAdOptimizationTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tip.tone);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .06),
        border: Border.all(color: color.withValues(alpha: .14)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_tipIcon(tip.iconKey), color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                tip.text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallInlineStat extends StatelessWidget {
  const _SmallInlineStat({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}
