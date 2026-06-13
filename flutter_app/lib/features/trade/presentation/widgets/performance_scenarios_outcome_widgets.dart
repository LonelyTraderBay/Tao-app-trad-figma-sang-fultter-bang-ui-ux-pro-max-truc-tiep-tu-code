part of '../pages/performance_scenarios_page.dart';

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({
    required this.scenario,
    required this.investment,
    required this.holdingPeriod,
  });

  final TradePerformanceScenario scenario;
  final double investment;
  final int holdingPeriod;

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(scenario.type);
    final outcome = scenario.outcomeFor(investment, holdingPeriod);
    final profit = scenario.profitFor(investment, holdingPeriod);

    return _Card(
      key: PerformanceScenariosPage.scenarioKey(scenario.label),
      padding: const EdgeInsets.fromLTRB(16, 16, 17, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .11),
              borderRadius: AppRadii.cardLargeRadius,
            ),
            child: Icon(_iconForType(scenario.type), color: color, size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${scenario.label} Scenario',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatReturn(scenario.annualReturnPct),
                      style: AppTextStyles.baseMedium.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _MetricBox(
                        label: 'Value After ${holdingPeriod}Y',
                        value: _formatEur(outcome),
                        valueColor: AppColors.text1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricBox(
                        label: 'Profit/Loss',
                        value: _formatSignedEur(profit),
                        valueColor: profit >= 0 ? _scenarioGreen : _scenarioRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
      decoration: BoxDecoration(
        color: _scenarioPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.numericCode.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              color: AppColors.text1,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Scenarios calculated using statistical models based on '
              'historical volatility and returns. The stress scenario shows '
              'what you might get back in extreme market conditions.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _scenarioBorder.withValues(alpha: .76),
      child: child,
    );
  }
}

IconData _iconForType(TradePerformanceScenarioType type) {
  return switch (type) {
    TradePerformanceScenarioType.stress => Icons.trending_down_rounded,
    TradePerformanceScenarioType.unfavorable => Icons.trending_down_rounded,
    TradePerformanceScenarioType.moderate => Icons.remove_rounded,
    TradePerformanceScenarioType.favorable => Icons.trending_up_rounded,
  };
}

Color _colorForType(TradePerformanceScenarioType type) {
  return switch (type) {
    TradePerformanceScenarioType.stress => _scenarioRed,
    TradePerformanceScenarioType.unfavorable => _scenarioAmber,
    TradePerformanceScenarioType.moderate => _scenarioPrimary,
    TradePerformanceScenarioType.favorable => _scenarioGreen,
  };
}

String _formatReturn(double value) {
  final rounded = value.round();
  final sign = rounded > 0 ? '+' : '';
  return '$sign$rounded% p.a.';
}

String _formatSignedEur(double value) {
  final rounded = value.round();
  final sign = rounded >= 0 ? '+' : '-';
  return '$sign\u20AC${_groupThousands(rounded.abs())}';
}

String _formatEur(double value) {
  final rounded = value.round();
  final sign = rounded < 0 ? '-' : '';
  return '$sign\u20AC${_groupThousands(rounded.abs())}';
}

String _groupThousands(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < raw.length; index += 1) {
    if (index > 0 && (raw.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(raw[index]);
  }
  return buffer.toString();
}
