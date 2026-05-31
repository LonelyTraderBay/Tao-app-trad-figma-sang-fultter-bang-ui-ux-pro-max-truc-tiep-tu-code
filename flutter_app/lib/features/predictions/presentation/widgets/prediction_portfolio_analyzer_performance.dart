part of '../pages/prediction_portfolio_analyzer_page.dart';

class _PerformanceChartCard extends StatelessWidget {
  const _PerformanceChartCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'P/L Over Time',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _PnlLinePainter(points: snapshot.pnlHistory),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeStatsSection extends StatelessWidget {
  const _TradeStatsSection({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Trade Statistics',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Win Rate',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${snapshot.winRate.toStringAsFixed(1)}%',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Winning',
                      value: '${snapshot.winningTrades}',
                      valueColor: AppColors.buy,
                    ),
                  ),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Losing',
                      value: '${snapshot.losingTrades}',
                      valueColor: AppColors.sell,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: snapshot.winRate / 100,
                  color: AppColors.buy,
                  backgroundColor: AppColors.bg,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttributionSection extends StatelessWidget {
  const _AttributionSection({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final closed = snapshot.closedPositions.toList()
      ..sort((a, b) => b.pnl.compareTo(a.pnl));
    return VitPageSection(
      label: 'Performance Attribution',
      accentColor: _predictionPrimary,
      children: [
        for (final position in closed)
          VitCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position.eventName,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        position.category,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${position.pnl >= 0 ? '+' : ''}${_formatMoney(position.pnl)}',
                      style: AppTextStyles.caption.copyWith(
                        color: position.pnl >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      position.resolvedAtLabel ?? '',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
