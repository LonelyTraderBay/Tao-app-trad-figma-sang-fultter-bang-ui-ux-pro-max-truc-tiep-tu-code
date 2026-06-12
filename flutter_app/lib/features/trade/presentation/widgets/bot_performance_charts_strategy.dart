part of '../pages/bot_performance_analytics_page.dart';

class _KeyMetricsCard extends StatelessWidget {
  const _KeyMetricsCard({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricColumn(
                  label: 'Total PnL',
                  value: '+\$${metrics.totalPnl.toStringAsFixed(2)}',
                  color: _analyticsGreen,
                ),
              ),
              Expanded(
                child: _MetricColumn(
                  label: 'Win Rate',
                  value: '${metrics.winRate.toStringAsFixed(1)}%',
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _MetricColumn(
                  label: 'Sharpe Ratio',
                  value: metrics.sharpeRatio.toStringAsFixed(2),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: _analyticsGreen.withValues(alpha: .08),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 13,
                  height: 13,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: _analyticsGreen.withValues(alpha: .9),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.onAccent,
                    size: 11,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Excellent performance - Sharpe > 1.5 indicates strong risk-adjusted returns',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: _analyticsGreen,
                      height: 1.45,
                    ),
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

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(color: color, height: 1),
        ),
      ],
    );
  }
}

class _TimeframeTabs extends StatelessWidget {
  const _TimeframeTabs({required this.active, required this.onChanged});

  final _AnalyticsTimeframe active;
  final ValueChanged<_AnalyticsTimeframe> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      (_AnalyticsTimeframe.sevenDays, '7d', '7 Days'),
      (_AnalyticsTimeframe.thirtyDays, '30d', '30 Days'),
      (_AnalyticsTimeframe.allTime, 'all', 'All Time'),
    ];

    return Row(
      children: [
        for (final tab in tabs) ...[
          _TimeframePill(
            key: BotPerformanceAnalyticsPage.timeframeKey(tab.$2),
            label: tab.$3,
            active: active == tab.$1,
            onTap: () => onChanged(tab.$1),
          ),
          if (tab != tabs.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _TimeframePill extends StatelessWidget {
  const _TimeframePill({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _analyticsPrimary.withValues(alpha: .12)
              : _analyticsPanel2,
          border: active
              ? Border.all(color: _analyticsPrimary.withValues(alpha: .55))
              : null,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _analyticsPrimary : AppColors.text3,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PnlChartCard extends StatelessWidget {
  const _PnlChartCard({required this.points});

  final List<TradeBotPnlPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: SizedBox(
        height: 220,
        child: CustomPaint(
          painter: _PnlChartPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _WinLossChartCard extends StatelessWidget {
  const _WinLossChartCard({required this.points});

  final List<TradeBotWinLossPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: SizedBox(
        height: 200,
        child: CustomPaint(
          painter: _WinLossChartPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _StrategyPerformanceCard extends StatelessWidget {
  const _StrategyPerformanceCard({required this.strategies});

  final List<TradeBotStrategyPerformance> strategies;

  @override
  Widget build(BuildContext context) {
    final maxPnl = strategies
        .map((strategy) => strategy.pnl.abs())
        .fold<double>(0, math.max);

    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        children: [
          for (final strategy in strategies) ...[
            _StrategyRow(strategy: strategy, maxPnl: maxPnl),
            if (strategy != strategies.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _StrategyRow extends StatelessWidget {
  const _StrategyRow({required this.strategy, required this.maxPnl});

  final TradeBotStrategyPerformance strategy;
  final double maxPnl;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    final isPositive = strategy.pnl >= 0;
    final widthFactor = maxPnl == 0 ? 0.0 : strategy.pnl.abs() / maxPnl;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${strategy.strategy} Bot',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            Text(
              '${isPositive ? '+' : ''}${strategy.pnl.toStringAsFixed(2)} USDT',
              style: AppTextStyles.caption.copyWith(
                color: isPositive ? _analyticsGreen : _analyticsRed,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: widthFactor.clamp(0, 1),
              backgroundColor: _chartTrack,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
