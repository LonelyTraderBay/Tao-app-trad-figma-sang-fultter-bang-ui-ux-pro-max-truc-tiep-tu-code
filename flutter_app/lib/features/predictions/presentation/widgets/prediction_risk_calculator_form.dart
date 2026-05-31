part of '../pages/prediction_risk_calculator_page.dart';

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
                child: Semantics(
                  button: true,
                  selected: activeTab == item.tab,
                  label: '${item.label} risk calculator tab',
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
    required this.riskBudgetController,
    required this.outcome,
    required this.onOutcomeChanged,
  });

  final TextEditingController eventController;
  final TextEditingController sharesController;
  final TextEditingController entryPriceController;
  final TextEditingController currentPriceController;
  final TextEditingController riskBudgetController;
  final String outcome;
  final ValueChanged<String> onOutcomeChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Thong tin vi the',
      accentColor: _predictionPrimary,
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
                      label: 'Risk Budget (\$)',
                      controller: riskBudgetController,
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
            borderRadius: AppRadii.lgRadius,
          ),
          alignment: Alignment.center,
          child: Semantics(
            textField: true,
            label: label,
            child: TextField(
              key: fieldKey,
              controller: controller,
              keyboardType: numeric
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              inputFormatters: numeric
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                  : null,
              cursorColor: _predictionPrimary,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                fontWeight: AppTextStyles.medium,
              ),
              decoration: const InputDecoration.collapsed(hintText: ''),
            ),
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
    return Semantics(
      button: true,
      selected: selected,
      label: '$label risk scenario',
      child: SizedBox(
        height: 42,
        child: Material(
          color: selected ? selectedColor : AppColors.bg,
          borderRadius: AppRadii.lgRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadii.lgRadius,
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
