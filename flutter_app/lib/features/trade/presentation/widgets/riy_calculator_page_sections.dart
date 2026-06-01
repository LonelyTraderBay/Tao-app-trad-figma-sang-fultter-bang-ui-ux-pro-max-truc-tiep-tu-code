part of '../pages/riy_calculator_page.dart';

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.investment,
    required this.expectedReturn,
    required this.totalCosts,
    required this.years,
    required this.onInvestmentChanged,
    required this.onExpectedReturnChanged,
    required this.onTotalCostsChanged,
    required this.onYearsChanged,
  });

  final double investment;
  final double expectedReturn;
  final double totalCosts;
  final int years;
  final ValueChanged<double> onInvestmentChanged;
  final ValueChanged<double> onExpectedReturnChanged;
  final ValueChanged<double> onTotalCostsChanged;
  final ValueChanged<int> onYearsChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        children: [
          _NumberField(
            key: RIYCalculatorPage.investmentKey,
            label: 'Initial Investment (€)',
            initialValue: _formatInput(investment),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null && parsed >= 0) onInvestmentChanged(parsed);
            },
          ),
          const SizedBox(height: 17),
          _NumberField(
            key: RIYCalculatorPage.expectedReturnKey,
            label: 'Expected Annual Return (%)',
            initialValue: _formatInput(expectedReturn),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null) onExpectedReturnChanged(parsed);
            },
          ),
          const SizedBox(height: 17),
          _NumberField(
            key: RIYCalculatorPage.totalCostsKey,
            label: 'Total Annual Costs (%)',
            initialValue: _formatInput(totalCosts),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null && parsed >= 0) onTotalCostsChanged(parsed);
            },
          ),
          const SizedBox(height: 17),
          _NumberField(
            key: RIYCalculatorPage.yearsKey,
            label: 'Holding Period (Years)',
            initialValue: '$years',
            decimals: false,
            onChanged: (value) {
              final parsed = int.tryParse(value);
              if (parsed != null && parsed > 0) {
                onYearsChanged(parsed.clamp(1, 20).toInt());
              }
            },
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.decimals = true,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool decimals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: AppSpacing.inputHeight,
          child: TextFormField(
            initialValue: initialValue,
            keyboardType: TextInputType.numberWithOptions(decimal: decimals),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                decimals ? RegExp(r'[0-9.]') : RegExp(r'[0-9]'),
              ),
            ],
            onChanged: onChanged,
            cursorColor: _riyPrimary,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontSize: 16,
              height: 1,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: _riyPanel2,
              contentPadding: const EdgeInsets.fromLTRB(13, 14, 13, 12),
              border: _fieldBorder(_riyBorder),
              enabledBorder: _fieldBorder(_riyBorder),
              focusedBorder: _fieldBorder(_riyPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 13),
      child: SizedBox(
        height: 42,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontSize: 18,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CostImpactCard extends StatelessWidget {
  const _CostImpactCard({
    required this.years,
    required this.difference,
    required this.lossPct,
  });

  final int years;
  final double difference;
  final double lossPct;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 21, 16, 18),
      child: SizedBox(
        height: 74,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cost Impact',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                Text(
                  '-${_formatEur(difference)}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _riyRed,
                    fontSize: 20,
                    height: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
              decoration: BoxDecoration(
                color: _riyPrimary.withValues(alpha: .04),
                borderRadius: AppRadii.smRadius,
              ),
              child: Text(
                'Over $years years, costs reduce your investment by '
                '${_formatEur(difference)} (${lossPct.toStringAsFixed(1)}% loss).',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.projections});

  final List<TradeRiyProjection> projections;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
      child: SizedBox(
        height: 200,
        child: CustomPaint(painter: _RiyChartPainter(projections)),
      ),
    );
  }
}
