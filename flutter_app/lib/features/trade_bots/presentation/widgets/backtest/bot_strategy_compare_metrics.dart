part of '../../pages/backtest/bot_strategy_compare_page.dart';

class _EquityChartCard extends StatelessWidget {
  const _EquityChartCard({required this.points, required this.strategies});

  final List<TradeBotCompareEquityPoint> points;
  final List<TradeBotCompareStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: AspectRatio(
        aspectRatio: 2.15,
        child: CustomPaint(
          painter: _EquityChartPainter(points, strategies),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _RadarCard extends StatelessWidget {
  const _RadarCard({required this.strategies});

  final List<TradeBotCompareStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: AspectRatio(
        aspectRatio: 1.85,
        child: CustomPaint(
          painter: _RadarPainter(strategies),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _MetricsTable extends StatelessWidget {
  const _MetricsTable({required this.strategies});

  final List<TradeBotCompareStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _MetricRowData('Total Return', 'totalReturn', '%', _BestMode.highest),
      _MetricRowData('Sharpe Ratio', 'sharpeRatio', '', _BestMode.highest),
      _MetricRowData('Max Drawdown', 'maxDrawdown', '%', _BestMode.lowest),
      _MetricRowData('Win Rate', 'winRate', '%', _BestMode.highest),
      _MetricRowData('Profit Factor', 'profitFactor', '', _BestMode.highest),
      _MetricRowData('Total Trades', 'totalTrades', '', _BestMode.neutral),
      _MetricRowData('Avg Duration', 'avgTradeDuration', '', _BestMode.neutral),
      _MetricRowData('Volatility', 'volatility', '%', _BestMode.lowest),
    ];

    return _Card(
      child: Column(
        children: [
          _TableHeader(strategies: strategies),
          for (final row in rows)
            _TableMetricRow(
              row: row,
              strategies: strategies,
              showDivider: row != rows.last,
            ),
        ],
      ),
    );
  }
}

enum _BestMode { highest, lowest, neutral }

class _MetricRowData {
  const _MetricRowData(this.label, this.key, this.suffix, this.bestMode);

  final String label;
  final String key;
  final String suffix;
  final _BestMode bestMode;
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.strategies});

  final List<TradeBotCompareStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Metric',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              for (final strategy in strategies)
                Expanded(
                  child: Text(
                    strategy.name,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: Color(strategy.colorHex),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.borderSolid,
          thickness: AppSpacing.hairlineStroke,
        ),
      ],
    );
  }
}

class _TableMetricRow extends StatelessWidget {
  const _TableMetricRow({
    required this.row,
    required this.strategies,
    required this.showDivider,
  });

  final _MetricRowData row;
  final List<TradeBotCompareStrategy> strategies;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final values = strategies.map(
      (strategy) => _metricValue(strategy, row.key),
    );
    final numericValues = values.whereType<double>().toList();
    final bestValue = switch (row.bestMode) {
      _BestMode.highest when numericValues.isNotEmpty => numericValues.reduce(
        math.max,
      ),
      _BestMode.lowest when numericValues.isNotEmpty => numericValues.reduce(
        math.min,
      ),
      _ => null,
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  row.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              for (final strategy in strategies)
                Expanded(
                  child: _TableValue(
                    metricKey: row.key,
                    strategy: strategy,
                    value: _metricValue(strategy, row.key),
                    suffix: row.suffix,
                    isBest:
                        bestValue != null &&
                        _metricValue(strategy, row.key) == bestValue,
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            color: AppColors.borderSolid,
            thickness: AppSpacing.hairlineStroke,
          ),
      ],
    );
  }
}

class _TableValue extends StatelessWidget {
  const _TableValue({
    required this.metricKey,
    required this.strategy,
    required this.value,
    required this.suffix,
    required this.isBest,
  });

  final String metricKey;
  final TradeBotCompareStrategy strategy;
  final Object value;
  final String suffix;
  final bool isBest;

  @override
  Widget build(BuildContext context) {
    final text = _formatMetricValue(metricKey, value, suffix);
    final color = isBest ? Color(strategy.colorHex) : AppColors.text1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        if (isBest) ...[
          const SizedBox(width: AppSpacing.x1),
          Icon(Icons.star_rounded, color: color, size: AppSpacing.x3),
        ],
      ],
    );
  }
}

String _formatMetricValue(String metricKey, Object value, String suffix) {
  if (value is! num) return '$value$suffix';
  final decimals = switch (metricKey) {
    'sharpeRatio' || 'profitFactor' => 2,
    'totalTrades' => 0,
    _ => 1,
  };
  return '${value.toStringAsFixed(decimals)}$suffix';
}

Object _metricValue(TradeBotCompareStrategy strategy, String key) {
  final metrics = strategy.metrics;
  return switch (key) {
    'totalReturn' => metrics.totalReturn,
    'sharpeRatio' => metrics.sharpeRatio,
    'maxDrawdown' => metrics.maxDrawdown,
    'winRate' => metrics.winRate,
    'profitFactor' => metrics.profitFactor,
    'totalTrades' => metrics.totalTrades,
    'avgTradeDuration' => metrics.avgTradeDuration,
    'volatility' => metrics.volatility,
    _ => '',
  };
}
