import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _scenarioBg = Color(0xFF080C14);
const _scenarioSurface = Color(0xFF151A23);
const _scenarioSurface2 = Color(0xFF1E2535);
const _scenarioBorder = Color(0xFF273142);
const _scenarioBlue = Color(0xFF3B82F6);
const _scenarioRed = Color(0xFFEF4444);
const _scenarioAmber = Color(0xFFF59E0B);
const _scenarioGreen = Color(0xFF10B981);

class PerformanceScenariosPage extends ConsumerStatefulWidget {
  const PerformanceScenariosPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc109_performance_scenarios_content');
  static Key periodKey(int years) => Key('sc109_period_$years');
  static Key scenarioKey(String label) =>
      Key('sc109_scenario_${label.toLowerCase()}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PerformanceScenariosPage> createState() =>
      _PerformanceScenariosPageState();
}

class _PerformanceScenariosPageState
    extends ConsumerState<PerformanceScenariosPage> {
  int? _holdingPeriod;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getPerformanceScenarios();
    final selectedPeriod = _holdingPeriod ?? snapshot.defaultHoldingPeriod;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-109 PerformanceScenariosPage',
      child: Material(
        color: _scenarioBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Performance Scenarios',
              subtitle: 'Potential Outcomes',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: PerformanceScenariosPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _WarningNotice(),
                    const SizedBox(height: 25),
                    _InvestmentCard(investment: snapshot.investment),
                    const SizedBox(height: 26),
                    _HoldingPeriodSelector(
                      periods: snapshot.holdingPeriods,
                      selectedPeriod: selectedPeriod,
                      onChanged: (value) =>
                          setState(() => _holdingPeriod = value),
                    ),
                    const SizedBox(height: 25),
                    const _SectionLabel('Potential Outcomes'),
                    const SizedBox(height: 10),
                    for (final scenario in snapshot.scenarios) ...[
                      _ScenarioCard(
                        scenario: scenario,
                        investment: snapshot.investment,
                        holdingPeriod: selectedPeriod,
                      ),
                      if (scenario != snapshot.scenarios.last)
                        const SizedBox(height: 13),
                    ],
                    const SizedBox(height: 36),
                    const _InfoNote(),
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

class _WarningNotice extends StatelessWidget {
  const _WarningNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        color: _scenarioAmber.withValues(alpha: .09),
        border: Border.all(color: _scenarioAmber.withValues(alpha: .38)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _scenarioAmber,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not a Guarantee',
                  style: AppTextStyles.caption.copyWith(
                    color: _scenarioAmber,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'These scenarios are illustrations based on past '
                  'performance and statistical models. Actual results may '
                  'differ significantly.',
                  style: AppTextStyles.micro.copyWith(
                    color: _scenarioAmber,
                    fontSize: 10,
                    fontWeight: AppTextStyles.medium,
                    height: 1.35,
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

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.investment});

  final double investment;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Example Investment',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _formatEur(investment),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.text1,
              fontSize: 28,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoldingPeriodSelector extends StatelessWidget {
  const _HoldingPeriodSelector({
    required this.periods,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final List<int> periods;
  final int selectedPeriod;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final period in periods) ...[
          Expanded(
            child: SizedBox(
              height: 32,
              child: TextButton(
                key: PerformanceScenariosPage.periodKey(period),
                onPressed: () => onChanged(period),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: selectedPeriod == period
                      ? _scenarioBlue
                      : _scenarioSurface2,
                  foregroundColor: selectedPeriod == period
                      ? Colors.white
                      : AppColors.text2,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  '$period ${period == 1 ? 'Year' : 'Years'}',
                  style: AppTextStyles.caption.copyWith(
                    color: selectedPeriod == period
                        ? Colors.white
                        : AppColors.text2,
                    fontSize: 12,
                    fontWeight: selectedPeriod == period
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          if (period != periods.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _scenarioBlue,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

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
              borderRadius: BorderRadius.circular(24),
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
                          fontSize: 15,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatReturn(scenario.annualReturnPct),
                      style: AppTextStyles.baseMedium.copyWith(
                        color: color,
                        fontSize: 16,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
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
        color: _scenarioSurface2,
        borderRadius: BorderRadius.circular(14),
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
              fontSize: 9,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 13,
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
                fontSize: 10,
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
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _scenarioSurface,
        border: Border.all(color: _scenarioBorder.withValues(alpha: .76)),
        borderRadius: BorderRadius.circular(16),
      ),
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
    TradePerformanceScenarioType.moderate => _scenarioBlue,
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
