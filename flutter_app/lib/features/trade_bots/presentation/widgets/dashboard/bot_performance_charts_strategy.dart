part of '../../pages/dashboard/bot_performance_analytics_page.dart';

class _KeyMetricsCard extends StatelessWidget {
  const _KeyMetricsCard({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingTall,
      density: VitDensity.tool,
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
          const SizedBox(height: _analyticsSpace),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            width: double.infinity,
            padding: TradeSpacingTokens.tradeBotControlPadding,
            borderColor: _analyticsGreen.withValues(alpha: .22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: _analyticsGreen,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: _analyticsSpace),
                Flexible(
                  child: Text(
                    'Excellent performance - Sharpe > 1.5 indicates strong risk-adjusted returns',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: _analyticsGreen,
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
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: _analyticsTinySpace),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
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

    return VitSegmentedTabBar(
      activeKey: active.name,
      onChanged: (key) =>
          onChanged(tabs.firstWhere((tab) => tab.$1.name == key).$1),
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.$1.name,
            label: tab.$3,
            widgetKey: BotPerformanceAnalyticsPage.timeframeKey(tab.$2),
          ),
      ],
    );
  }
}

class _PnlChartCard extends StatelessWidget {
  const _PnlChartCard({required this.points});

  final List<TradeBotPnlPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: BotPerformanceAnalyticsPage.pnlChartKey,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingTall,
      density: VitDensity.tool,
      child: SizedBox(
        height: _analyticsChartExtent,
        // PERF-HN5: isolate the heavy chart painter into its own compositor
        // layer.
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _PnlChartPainter(points),
            size: Size.infinite,
          ),
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
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingTall,
      density: VitDensity.tool,
      child: SizedBox(
        height: _analyticsDistributionExtent,
        // PERF-HN5: isolate the heavy chart painter into its own compositor
        // layer.
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _WinLossChartPainter(points),
            size: Size.infinite,
          ),
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

    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingLoose,
      density: VitDensity.tool,
      child: Column(
        children: [
          for (final strategy in strategies) ...[
            _StrategyRow(strategy: strategy, maxPnl: maxPnl),
            if (strategy != strategies.last)
              const SizedBox(height: _analyticsSpace),
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
            Icon(
              Icons.circle,
              color: color,
              size: TradeSpacingTokens.tradeBotCardGap,
            ),
            const SizedBox(width: _analyticsSpace),
            Expanded(
              child: Text(
                '${strategy.strategy} Bot',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              '${isPositive ? '+' : ''}${strategy.pnl.toStringAsFixed(2)} USDT',
              style: AppTextStyles.caption.copyWith(
                color: isPositive ? _analyticsGreen : _analyticsRed,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: _analyticsTinySpace),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: SizedBox(
            height: _analyticsProgressExtent,
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
