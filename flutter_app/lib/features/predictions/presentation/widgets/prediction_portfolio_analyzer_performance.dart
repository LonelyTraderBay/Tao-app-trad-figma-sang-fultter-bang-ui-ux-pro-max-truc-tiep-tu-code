part of '../pages/prediction_portfolio_analyzer_page.dart';

class _PerformanceChartCard extends StatelessWidget {
  const _PerformanceChartCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.predictionAnalyzerCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'P/L Over Time',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(
            height: AppSpacing.predictionAnalyzerPerformanceChartGap,
          ),
          SizedBox(
            height: AppSpacing.predictionAnalyzerPerformanceChartHeight,
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
          padding: AppSpacing.predictionAnalyzerCardPadding,
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
              const SizedBox(
                height: AppSpacing.predictionAnalyzerTradeStatsGap,
              ),
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
              const SizedBox(
                height: AppSpacing.predictionAnalyzerTradeProgressGap,
              ),
              ClipRRect(
                borderRadius: AppRadii.pillRadius,
                child: LinearProgressIndicator(
                  minHeight: AppSpacing.predictionAnalyzerTradeProgressHeight,
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
            padding: AppSpacing.predictionAnalyzerAttributionPadding,
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
                      const SizedBox(
                        height:
                            AppSpacing.predictionAnalyzerAttributionLabelGap,
                      ),
                      Text(
                        position.category,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.predictionAnalyzerAttributionTrailingGap,
                ),
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
