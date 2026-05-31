part of '../pages/prediction_risk_calculator_page.dart';

class _RiskAnalysis extends StatelessWidget {
  const _RiskAnalysis({required this.metrics});

  final _RiskMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Risk Analysis',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _RiskMetricRow(
                icon: Icons.trending_down_rounded,
                iconColor: AppColors.sell,
                label: 'Max Loss',
                value: _formatMoney(metrics.maxLoss),
                valueColor: AppColors.sell,
              ),
              _RiskMetricRow(
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.buy,
                label: 'Max Gain',
                value: _formatMoney(metrics.maxGain),
                valueColor: AppColors.buy,
              ),
              _RiskMetricRow(
                icon: Icons.track_changes_rounded,
                iconColor: AppColors.text3,
                label: 'Break-even Price',
                value: _formatPrice(metrics.breakEvenPrice),
              ),
              _RiskMetricRow(
                icon: Icons.percent_rounded,
                iconColor: _predictionPrimary,
                label: 'Implied Probability',
                value: '${metrics.probabilityOfProfit.toStringAsFixed(1)}%',
                valueColor: _predictionPrimary,
              ),
              _RiskMetricRow(
                icon: Icons.attach_money_rounded,
                iconColor: AppColors.text3,
                label: 'Expected Value',
                value:
                    '${metrics.expectedValue >= 0 ? '+' : ''}${_formatMoney(metrics.expectedValue)}',
                valueColor: metrics.expectedValue >= 0
                    ? AppColors.buy
                    : AppColors.sell,
              ),
              _RiskMetricRow(
                icon: Icons.bar_chart_rounded,
                iconColor: AppColors.text3,
                label: 'Risk/Reward Ratio',
                value: '1:${metrics.riskRewardRatio.toStringAsFixed(2)}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KellyRecommendation extends StatelessWidget {
  const _KellyRecommendation({required this.metrics, required this.riskBudget});

  final _RiskMetrics metrics;
  final double riskBudget;

  @override
  Widget build(BuildContext context) {
    final pct = riskBudget > 0
        ? (metrics.suggestedExposure / riskBudget) * 100
        : 0;

    return VitCard(
      borderColor: AppColors.primary15,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _predictionPrimary,
                size: 17,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelly Criterion Position Sizing',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Suggested exposure based on risk budget and edge',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                _formatMoney(metrics.suggestedExposure),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: _predictionPrimary,
                  fontSize: 20,
                ),
              ),
              Text(
                '(${pct.toStringAsFixed(1)}% of risk budget)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Phan tich rui ro chi mang tinh tham khao. Ket qua thuc te co the khac. Luon quan ly von than trong.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
