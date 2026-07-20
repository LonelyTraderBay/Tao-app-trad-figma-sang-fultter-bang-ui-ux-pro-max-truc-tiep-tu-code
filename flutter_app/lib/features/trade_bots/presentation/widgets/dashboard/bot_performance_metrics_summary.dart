part of '../../pages/dashboard/bot_performance_analytics_page.dart';

class _AdvancedMetricsGrid extends StatelessWidget {
  const _AdvancedMetricsGrid({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final items = [
      _AdvancedMetricData(
        icon: Icons.adjust_rounded,
        label: 'Hệ số lợi nhuận',
        value: metrics.profitFactor.toStringAsFixed(2),
        helper: 'Lãi gộp / Lỗ gộp',
        color: _analyticsPrimary,
      ),
      _AdvancedMetricData(
        icon: Icons.workspace_premium_outlined,
        label: 'Lãi TB',
        value: '+\$${metrics.avgWin.toStringAsFixed(1)}',
        helper: 'Mỗi lệnh thắng',
        color: _analyticsAmber,
        valueColor: _analyticsGreen,
      ),
      _AdvancedMetricData(
        icon: Icons.trending_up_rounded,
        label: 'Lệnh tốt nhất',
        value: '+\$${metrics.bestTrade.toStringAsFixed(1)}',
        helper: 'Lệnh thắng lớn nhất',
        color: _analyticsGreen,
        valueColor: _analyticsGreen,
      ),
      _AdvancedMetricData(
        icon: Icons.show_chart_rounded,
        label: 'Lỗ TB',
        value: metrics.avgLoss.toStringAsFixed(1),
        helper: 'Mỗi lệnh thua',
        color: _analyticsRed,
        valueColor: _analyticsRed,
      ),
    ];

    return GridView.count(
      crossAxisCount: TradeSpacingTokens.tradeBotGridColumns,
      crossAxisSpacing: _analyticsSpace,
      mainAxisSpacing: _analyticsSpace,
      childAspectRatio: TradeSpacingTokens.tradeBotAnalyticsMetricAspectRatio,
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
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPadding,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: item.color, size: 22),
          const SizedBox(height: _analyticsTinySpace),
          Text(
            item.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _analyticsTinySpace),
          Text(
            item.value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: item.valueColor ?? AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: _analyticsTinySpace),
          Text(
            item.helper,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingTall,
      density: VitDensity.tool,
      child: SizedBox(
        height: _analyticsDonutExtent,
        // PERF-HN5: isolate the heavy chart painter into its own compositor
        // layer.
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _DurationDonutPainter(distribution),
            size: Size.infinite,
          ),
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
    final wins = (metrics.totalTrades * metrics.winRate / 100).round();
    final losses = metrics.totalTrades - wins;
    final rows = [
      ('Tổng số lệnh', '${metrics.totalTrades}', 'lệnh'),
      (
        'Tỷ lệ thắng',
        '${metrics.winRate.toStringAsFixed(1)}%',
        '($wins thắng / $losses thua)',
      ),
      ('Tỷ lệ Sharpe', metrics.sharpeRatio.toStringAsFixed(2), '(Xuất sắc)'),
      ('Hệ số lợi nhuận', metrics.profitFactor.toStringAsFixed(2), '(Tốt)'),
      ('Lệnh tốt nhất', '+\$${metrics.bestTrade.toStringAsFixed(1)}', ''),
      ('Lệnh tệ nhất', '\$${metrics.worstTrade.toStringAsFixed(1)}', ''),
    ];

    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingTall,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tổng quan hiệu suất',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _analyticsSpace),
          for (final row in rows) ...[
            _SummaryRow(label: row.$1, value: row.$2, suffix: row.$3),
            if (row != rows.last) const SizedBox(height: _analyticsTinySpace),
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
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      constraints: const BoxConstraints(minHeight: _analyticsMetricMinExtent),
      padding: TradeSpacingTokens.tradeBotControlPadding,
      density: VitDensity.tool,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              if (suffix.isNotEmpty) ...[
                const SizedBox(height: _analyticsTinySpace),
                Text(
                  suffix,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPadding,
      density: VitDensity.tool,
      borderColor: _analyticsGreen.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            color: _analyticsGreen,
            size: 22,
          ),
          const SizedBox(width: _analyticsSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hiệu suất xuất sắc (A+)',
                  style: AppTextStyles.caption.copyWith(
                    color: _analyticsGreen,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _analyticsTinySpace),
                Text(
                  'Các bot giao dịch của bạn đang hoạt động trên mức trung bình. Tỷ lệ Sharpe > 1.5, tỷ lệ thắng > 65% và hệ số lợi nhuận > 2 cho thấy lợi nhuận đã điều chỉnh theo rủi ro ở mức mạnh. Tiếp tục theo dõi và điều chỉnh khi điều kiện thị trường thay đổi.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
