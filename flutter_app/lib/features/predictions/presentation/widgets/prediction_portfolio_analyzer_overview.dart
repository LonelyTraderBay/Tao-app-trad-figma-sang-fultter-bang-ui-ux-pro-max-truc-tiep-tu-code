part of '../pages/prediction_portfolio_analyzer_page.dart';

class _AnalyzerTabBar extends StatelessWidget {
  const _AnalyzerTabBar({required this.activeTab, required this.onChanged});

  final _AnalyzerTab activeTab;
  final ValueChanged<_AnalyzerTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionPortfolioAnalyzerPage.overviewTabKey,
        tab: _AnalyzerTab.overview,
        label: 'Tong quan',
      ),
      (
        key: PredictionPortfolioAnalyzerPage.performanceTabKey,
        tab: _AnalyzerTab.performance,
        label: 'Hieu suat',
      ),
      (
        key: PredictionPortfolioAnalyzerPage.riskTabKey,
        tab: _AnalyzerTab.risk,
        label: 'Rui ro',
      ),
    ];

    return Material(
      color: AppColors.surface,
      shape: const Border(bottom: BorderSide(color: AppColors.border)),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_AnalyzerTab.values.byName(key)),
        tabs: [
          for (final item in tabs)
            VitTabItem(
              key: item.tab.name,
              label: item.label,
              widgetKey: item.key,
            ),
        ],
      ),
    );
  }
}

class _PortfolioSummaryCard extends StatelessWidget {
  const _PortfolioSummaryCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pnlColor = snapshot.totalPnl >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.badge.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatMoney(snapshot.totalPortfolioValue),
                style: AppTextStyles.amountMd.copyWith(color: AppColors.text1),
              ),
              const SizedBox(width: AppSpacing.predictionAnalyzerPnlGap),
              Padding(
                padding: AppSpacing.predictionAnalyzerPnlPadding,
                child: Row(
                  children: [
                    Icon(
                      snapshot.totalPnl >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: pnlColor,
                      size: AppSpacing.predictionAnalyzerPnlIcon,
                    ),
                    const SizedBox(
                      width: AppSpacing.predictionAnalyzerPnlIconGap,
                    ),
                    Text(
                      '${snapshot.totalPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.totalPnl)}',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: pnlColor,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Invested',
                  value: _formatMoney(snapshot.totalInvested),
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Return %',
                  value:
                      '${snapshot.totalPnlPercent >= 0 ? '+' : ''}${snapshot.totalPnlPercent.toStringAsFixed(2)}%',
                  valueColor: pnlColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Realized P/L',
                  value:
                      '${snapshot.realizedPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.realizedPnl)}',
                  valueColor: snapshot.realizedPnl >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  small: true,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Unrealized P/L',
                  value:
                      '${snapshot.unrealizedPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.unrealizedPnl)}',
                  valueColor: snapshot.unrealizedPnl >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        icon: Icons.show_chart_rounded,
        label: 'Open Positions',
        value: '${snapshot.openPositions.length}',
        color: _predictionPrimary,
      ),
      (
        icon: Icons.adjust_rounded,
        label: 'Win Rate',
        value: '${snapshot.winRate.toStringAsFixed(1)}%',
        color: AppColors.buy,
      ),
      (
        icon: Icons.workspace_premium_outlined,
        label: 'Total Trades',
        value: '${snapshot.totalTrades}',
        color: _purple,
      ),
      (
        icon: Icons.bar_chart_rounded,
        label: 'Avg Trade',
        value: _formatMoneyCompact(snapshot.averageTrade),
        color: AppColors.warn,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppSpacing.predictionAnalyzerGridColumns,
        mainAxisExtent: AppSpacing.x7 * 3,
        crossAxisSpacing: AppSpacing.predictionAnalyzerGridGap,
        mainAxisSpacing: AppSpacing.predictionAnalyzerGridGap,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return VitCard(
          density: VitDensity.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    stat.icon,
                    color: stat.color,
                    size: AppSpacing.predictionAnalyzerStatIcon,
                  ),
                  const SizedBox(
                    width: AppSpacing.predictionAnalyzerStatIconGap,
                  ),
                  Expanded(
                    child: Text(
                      stat.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                stat.value,
                style: AppTextStyles.amountSm.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final categories = snapshot.categories;
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio by Category',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x2),
          Center(
            child: SizedBox(
              height: AppSpacing.x7 * 4,
              width: AppSpacing.x7 * 4,
              child: CustomPaint(
                painter: _DonutChartPainter(categories: categories),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppSpacing.predictionAnalyzerLegendColumns,
              mainAxisExtent: AppSpacing.x7,
              crossAxisSpacing: AppSpacing.predictionAnalyzerLegendCrossGap,
              mainAxisSpacing: AppSpacing.predictionAnalyzerLegendMainGap,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryLegendItem(
                category: category,
                color: _categoryColor(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
