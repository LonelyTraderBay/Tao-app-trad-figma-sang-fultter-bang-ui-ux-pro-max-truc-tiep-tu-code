part of '../pages/bot_performance_analytics_page.dart';

class _AdvancedMetricsGrid extends StatelessWidget {
  const _AdvancedMetricsGrid({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final items = [
      _AdvancedMetricData(
        icon: Icons.adjust_rounded,
        label: 'Profit Factor',
        value: metrics.profitFactor.toStringAsFixed(2),
        helper: 'Gross profit / Gross loss',
        color: _analyticsPrimary,
      ),
      _AdvancedMetricData(
        icon: Icons.workspace_premium_outlined,
        label: 'Avg Win',
        value: '+\$${metrics.avgWin.toStringAsFixed(1)}',
        helper: 'Per winning trade',
        color: _analyticsAmber,
        valueColor: _analyticsGreen,
      ),
      _AdvancedMetricData(
        icon: Icons.trending_up_rounded,
        label: 'Best Trade',
        value: '+\$${metrics.bestTrade.toStringAsFixed(1)}',
        helper: 'Largest single win',
        color: _analyticsGreen,
        valueColor: _analyticsGreen,
      ),
      _AdvancedMetricData(
        icon: Icons.show_chart_rounded,
        label: 'Avg Loss',
        value: metrics.avgLoss.toStringAsFixed(1),
        helper: 'Per losing trade',
        color: _analyticsRed,
        valueColor: _analyticsRed,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.22,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [for (final item in items) _AdvancedMetricCard(item: item)],
    );
  }
}

class _AdvancedMetricData {
  const _AdvancedMetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String helper;
  final Color color;
  final Color? valueColor;
}

class _AdvancedMetricCard extends StatelessWidget {
  const _AdvancedMetricCard({required this.item});

  final _AdvancedMetricData item;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: item.color, size: 22),
          const Spacer(),
          Text(
            item.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            item.value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: item.valueColor ?? AppColors.text1,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.helper,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  const _DurationCard({required this.distribution});

  final List<TradeBotDurationDistribution> distribution;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: SizedBox(
        height: 180,
        child: CustomPaint(
          painter: _DurationDonutPainter(distribution),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _PerformanceSummaryCard extends StatelessWidget {
  const _PerformanceSummaryCard({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Total Trades', '${metrics.totalTrades}', 'trades'),
      ('Win Rate', '${metrics.winRate.toStringAsFixed(1)}%', '(45W / 21L)'),
      ('Sharpe Ratio', metrics.sharpeRatio.toStringAsFixed(2), '(Excellent)'),
      ('Profit Factor', metrics.profitFactor.toStringAsFixed(2), '(Good)'),
      ('Best Trade', '+\$${metrics.bestTrade.toStringAsFixed(1)}', ''),
      ('Worst Trade', '\$${metrics.worstTrade.toStringAsFixed(1)}', ''),
    ];

    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Performance Summary',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          for (final row in rows) ...[
            _SummaryRow(label: row.$1, value: row.$2, suffix: row.$3),
            if (row != rows.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.suffix,
  });

  final String label;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              if (suffix.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  suffix,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      borderColor: _analyticsGreen.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            color: _analyticsGreen,
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Excellent Performance (A+)',
                  style: AppTextStyles.caption.copyWith(
                    color: _analyticsGreen,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Your bots are performing above average. Sharpe ratio > 1.5, win rate > 65%, and profit factor > 2 indicate strong risk-adjusted returns. Keep monitoring and adjusting as market conditions change.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(padding: padding, child: child);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 4,
          height: 15,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _analyticsPrimary,
              borderRadius: AppRadii.smRadius,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
