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

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 11),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatMoney(snapshot.totalPortfolioValue),
                style: AppTextStyles.heroNumber.copyWith(
                  fontSize: 29,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    Icon(
                      snapshot.totalPnl >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: pnlColor,
                      size: 15,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${snapshot.totalPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.totalPnl)}',
                      style: AppTextStyles.caption.copyWith(
                        color: pnlColor,
                        fontWeight: AppTextStyles.bold,
                        fontSize: 16,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
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
          const SizedBox(height: 16),
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
        crossAxisCount: 2,
        mainAxisExtent: 84,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(stat.icon, color: stat.color, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stat.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                stat.value,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 20,
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio by Category',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              height: 190,
              width: 240,
              child: CustomPaint(
                painter: _DonutChartPainter(categories: categories),
              ),
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 42,
              crossAxisSpacing: 16,
              mainAxisSpacing: 4,
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
