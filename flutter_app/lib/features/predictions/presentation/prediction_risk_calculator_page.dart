import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/predictions_repository.dart';

const _predictionBlue = Color(0xFF3B82F6);

enum _RiskTab { calculator, scenarios, guide }

class PredictionRiskCalculatorPage extends ConsumerStatefulWidget {
  const PredictionRiskCalculatorPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc036_risk_calculator_content');
  static const calculatorTabKey = Key('sc036_tab_calculator');
  static const scenariosTabKey = Key('sc036_tab_scenarios');
  static const guideTabKey = Key('sc036_tab_guide');
  static const yesKey = Key('sc036_outcome_yes');
  static const noKey = Key('sc036_outcome_no');
  static const sharesFieldKey = Key('sc036_shares_field');
  static const entryFieldKey = Key('sc036_entry_field');
  static const currentFieldKey = Key('sc036_current_field');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionRiskCalculatorPage> createState() =>
      _PredictionRiskCalculatorPageState();
}

class _PredictionRiskCalculatorPageState
    extends ConsumerState<PredictionRiskCalculatorPage> {
  _RiskTab _activeTab = _RiskTab.calculator;
  String _outcome = 'yes';
  late final TextEditingController _eventController;
  late final TextEditingController _sharesController;
  late final TextEditingController _entryPriceController;
  late final TextEditingController _currentPriceController;
  late final TextEditingController _bankrollController;

  @override
  void initState() {
    super.initState();
    final snapshot = const MockPredictionsRepository().getRiskCalculator();
    _outcome = snapshot.defaultOutcome;
    _eventController = TextEditingController(text: snapshot.defaultEventName);
    _sharesController = TextEditingController(
      text: _formatInput(snapshot.defaultShares),
    );
    _entryPriceController = TextEditingController(
      text: snapshot.defaultEntryPrice.toStringAsFixed(2),
    );
    _currentPriceController = TextEditingController(
      text: snapshot.defaultCurrentPrice.toStringAsFixed(2),
    );
    _bankrollController = TextEditingController(
      text: _formatInput(snapshot.defaultBankroll),
    );

    for (final controller in [
      _eventController,
      _sharesController,
      _entryPriceController,
      _currentPriceController,
      _bankrollController,
    ]) {
      controller.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _eventController,
      _sharesController,
      _entryPriceController,
      _currentPriceController,
      _bankrollController,
    ]) {
      controller
        ..removeListener(_refresh)
        ..dispose();
    }
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(predictionsRepositoryProvider).getRiskCalculator();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);
    final inputs = _RiskInputs(
      shares: _parse(_sharesController.text),
      entryPrice: _parse(_entryPriceController.text),
      currentPrice: _parse(_currentPriceController.text),
      bankroll: _parse(_bankrollController.text, fallback: 1),
    );
    final metrics = _calculate(inputs);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-036 PredictionRiskCalculatorPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Risk Calculator',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            _RiskTabBar(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionRiskCalculatorPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: _activeTab == _RiskTab.calculator
                        ? [
                            _PositionInfoCard(
                              eventController: _eventController,
                              sharesController: _sharesController,
                              entryPriceController: _entryPriceController,
                              currentPriceController: _currentPriceController,
                              bankrollController: _bankrollController,
                              outcome: _outcome,
                              onOutcomeChanged: (value) =>
                                  setState(() => _outcome = value),
                            ),
                            _PositionSummary(inputs: inputs),
                            _RiskAnalysis(metrics: metrics),
                            _KellyRecommendation(
                              metrics: metrics,
                              bankroll: inputs.bankroll,
                            ),
                            const _RiskWarning(),
                          ]
                        : _activeTab == _RiskTab.scenarios
                        ? [_ScenariosTab(inputs: inputs, metrics: metrics)]
                        : const [_GuideTab()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskTabBar extends StatelessWidget {
  const _RiskTabBar({required this.activeTab, required this.onChanged});

  final _RiskTab activeTab;
  final ValueChanged<_RiskTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionRiskCalculatorPage.calculatorTabKey,
        tab: _RiskTab.calculator,
        label: 'May tinh',
      ),
      (
        key: PredictionRiskCalculatorPage.scenariosTabKey,
        tab: _RiskTab.scenarios,
        label: 'Kich ban',
      ),
      (
        key: PredictionRiskCalculatorPage.guideTabKey,
        tab: _RiskTab.guide,
        label: 'Huong dan',
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
                                  ? _predictionBlue
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
                          color: _predictionBlue,
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

class _PositionInfoCard extends StatelessWidget {
  const _PositionInfoCard({
    required this.eventController,
    required this.sharesController,
    required this.entryPriceController,
    required this.currentPriceController,
    required this.bankrollController,
    required this.outcome,
    required this.onOutcomeChanged,
  });

  final TextEditingController eventController;
  final TextEditingController sharesController;
  final TextEditingController entryPriceController;
  final TextEditingController currentPriceController;
  final TextEditingController bankrollController;
  final String outcome;
  final ValueChanged<String> onOutcomeChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Thong tin vi the',
      accentColor: _predictionBlue,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _RiskInput(label: 'Event', controller: eventController),
              const SizedBox(height: 16),
              _OutcomeToggle(value: outcome, onChanged: onOutcomeChanged),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _RiskInput(
                      label: 'Shares',
                      controller: sharesController,
                      fieldKey: PredictionRiskCalculatorPage.sharesFieldKey,
                      numeric: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RiskInput(
                      label: 'Entry Price (\$)',
                      controller: entryPriceController,
                      fieldKey: PredictionRiskCalculatorPage.entryFieldKey,
                      numeric: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _RiskInput(
                      label: 'Current Price (\$)',
                      controller: currentPriceController,
                      fieldKey: PredictionRiskCalculatorPage.currentFieldKey,
                      numeric: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RiskInput(
                      label: 'Total Bankroll (\$)',
                      controller: bankrollController,
                      numeric: true,
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

class _RiskInput extends StatelessWidget {
  const _RiskInput({
    required this.label,
    required this.controller,
    this.fieldKey,
    this.numeric = false,
  });

  final String label;
  final TextEditingController controller;
  final Key? fieldKey;
  final bool numeric;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.bg,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(21),
          ),
          alignment: Alignment.center,
          child: TextField(
            key: fieldKey,
            controller: controller,
            keyboardType: numeric
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            inputFormatters: numeric
                ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                : null,
            cursorColor: _predictionBlue,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              fontWeight: AppTextStyles.medium,
            ),
            decoration: const InputDecoration.collapsed(hintText: ''),
          ),
        ),
      ],
    );
  }
}

class _OutcomeToggle extends StatelessWidget {
  const _OutcomeToggle({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Outcome',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _OutcomeButton(
                key: PredictionRiskCalculatorPage.yesKey,
                label: 'YES',
                selected: value == 'yes',
                selectedColor: AppColors.buy,
                onTap: () => onChanged('yes'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _OutcomeButton(
                key: PredictionRiskCalculatorPage.noKey,
                label: 'NO',
                selected: value == 'no',
                selectedColor: AppColors.sell,
                onTap: () => onChanged('no'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OutcomeButton extends StatelessWidget {
  const _OutcomeButton({
    super.key,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Material(
        color: selected ? selectedColor : AppColors.bg,
        borderRadius: BorderRadius.circular(21),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(21),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PositionSummary extends StatelessWidget {
  const _PositionSummary({required this.inputs});

  final _RiskInputs inputs;

  @override
  Widget build(BuildContext context) {
    final cost = inputs.cost;
    final currentValue = inputs.currentValue;
    final pnl = currentValue - cost;
    final pnlPct = cost > 0 ? (pnl / cost) * 100 : 0;

    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Position Summary',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Total Cost',
                  value: _formatMoney(cost),
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Current Value',
                  value: _formatMoney(currentValue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Unrealized P/L',
                  value: '${pnl >= 0 ? '+' : ''}${_formatMoney(pnl)}',
                  valueColor: pnl >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'P/L %',
                  value:
                      '${pnlPct >= 0 ? '+' : ''}${pnlPct.toStringAsFixed(2)}%',
                  valueColor: pnlPct >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskAnalysis extends StatelessWidget {
  const _RiskAnalysis({required this.metrics});

  final _RiskMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Risk Analysis',
      accentColor: _predictionBlue,
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
                iconColor: _predictionBlue,
                label: 'Implied Probability',
                value: '${metrics.probabilityOfProfit.toStringAsFixed(1)}%',
                valueColor: _predictionBlue,
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
  const _KellyRecommendation({required this.metrics, required this.bankroll});

  final _RiskMetrics metrics;
  final double bankroll;

  @override
  Widget build(BuildContext context) {
    final pct = bankroll > 0 ? (metrics.kellyBetSize / bankroll) * 100 : 0;

    return VitCard(
      borderColor: const Color(0x263B82F6),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _predictionBlue,
                size: 17,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelly Criterion Recommendation',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Optimal bet size based on bankroll and edge',
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
                _formatMoney(metrics.kellyBetSize),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: _predictionBlue,
                  fontSize: 20,
                ),
              ),
              Text(
                '(${pct.toStringAsFixed(1)}% of bankroll)',
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

class _ScenariosTab extends StatelessWidget {
  const _ScenariosTab({required this.inputs, required this.metrics});

  final _RiskInputs inputs;
  final _RiskMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final scenarios = [
      (
        outcome: 'Win (YES resolves)',
        payout: inputs.shares,
        probability: inputs.currentPrice * 100,
        positive: true,
      ),
      (
        outcome: 'Loss (NO resolves)',
        payout: 0.0,
        probability: (1 - inputs.currentPrice) * 100,
        positive: false,
      ),
    ];

    return VitPageSection(
      label: 'Scenarios Analysis',
      accentColor: _predictionBlue,
      children: [
        for (final scenario in scenarios)
          VitCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.outcome,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: AppTextStyles.medium,
                            ),
                          ),
                          Text(
                            'Implied probability: ${scenario.probability.toStringAsFixed(1)}%',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      scenario.positive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: scenario.positive ? AppColors.buy : AppColors.sell,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _RiskMetricRow(
                  label: 'Payout',
                  value: _formatMoney(scenario.payout),
                  compact: true,
                ),
                _RiskMetricRow(
                  label: 'Profit/Loss',
                  value:
                      '${scenario.payout - inputs.cost >= 0 ? '+' : ''}${_formatMoney(scenario.payout - inputs.cost)}',
                  valueColor: scenario.payout - inputs.cost >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  compact: true,
                ),
              ],
            ),
          ),
        VitCard(
          padding: const EdgeInsets.all(16),
          child: _RiskMetricRow(
            label: 'Net Expected Value',
            value:
                '${metrics.expectedValue >= 0 ? '+' : ''}${_formatMoney(metrics.expectedValue)}',
            valueColor: metrics.expectedValue >= 0
                ? AppColors.buy
                : AppColors.sell,
            compact: true,
          ),
        ),
      ],
    );
  }
}

class _GuideTab extends StatelessWidget {
  const _GuideTab();

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'How to Use',
      accentColor: _predictionBlue,
      children: const [
        _GuideCard(
          title: '1. Input Position Details',
          body:
              'Nhap thong tin vi the: event, outcome, so luong shares, gia entry va current',
        ),
        _GuideCard(
          title: '2. Review Risk Metrics',
          body:
              'Xem phan tich rui ro: max loss/gain, break-even, expected value',
        ),
        _GuideCard(
          title: '3. Check Position Sizing',
          body:
              'Tham khao Kelly criterion de xac dinh kich thuoc vi the toi uu',
        ),
        _GuideCard(
          title: 'Expected Value',
          body:
              'Cong cu tinh toan chi la tham khao. Probability khong phai la certainty.',
        ),
      ],
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _RiskMetricRow extends StatelessWidget {
  const _RiskMetricRow({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor = AppColors.text3,
    this.valueColor = AppColors.text1,
    this.compact = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color iconColor;
  final Color valueColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 4 : 7),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 15,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskInputs {
  const _RiskInputs({
    required this.shares,
    required this.entryPrice,
    required this.currentPrice,
    required this.bankroll,
  });

  final double shares;
  final double entryPrice;
  final double currentPrice;
  final double bankroll;

  double get cost => shares * entryPrice;
  double get currentValue => shares * currentPrice;
}

class _RiskMetrics {
  const _RiskMetrics({
    required this.maxLoss,
    required this.maxGain,
    required this.breakEvenPrice,
    required this.probabilityOfProfit,
    required this.expectedValue,
    required this.riskRewardRatio,
    required this.kellyBetSize,
  });

  final double maxLoss;
  final double maxGain;
  final double breakEvenPrice;
  final double probabilityOfProfit;
  final double expectedValue;
  final double riskRewardRatio;
  final double kellyBetSize;
}

_RiskMetrics _calculate(_RiskInputs inputs) {
  final maxLoss = inputs.cost;
  final maxGain = inputs.shares * (1 - inputs.entryPrice);
  final ratio = maxLoss > 0 ? maxGain / maxLoss : 0.0;
  final expectedValue =
      (inputs.currentPrice * maxGain) - ((1 - inputs.currentPrice) * maxLoss);
  final kellyFraction = ratio > 0
      ? ((inputs.currentPrice * ratio) - (1 - inputs.currentPrice)) / ratio
      : 0.0;
  final safeKellyFraction = kellyFraction.clamp(0.0, 1.0).toDouble();

  return _RiskMetrics(
    maxLoss: maxLoss,
    maxGain: maxGain,
    breakEvenPrice: inputs.entryPrice,
    probabilityOfProfit: inputs.currentPrice * 100,
    expectedValue: expectedValue,
    riskRewardRatio: ratio,
    kellyBetSize: safeKellyFraction * inputs.bankroll,
  );
}

double _parse(String value, {double fallback = 0}) {
  return double.tryParse(value) ?? fallback;
}

String _formatInput(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toString();
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';
