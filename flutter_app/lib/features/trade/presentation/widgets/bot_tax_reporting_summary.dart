part of '../pages/bot_tax_reporting_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final TradeBotTaxSummary summary;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Total Trades',
                  value: _formatInt(summary.totalTrades),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _SummaryStat(
                  label: 'Total Fees Paid',
                  value: _formatUsd(summary.totalFees),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Realized Gains',
                  value: '+${_formatUsd(summary.realizedGains)}',
                  color: _taxGreen,
                ),
              ),
              Expanded(
                child: _SummaryStat(
                  label: 'Realized Losses',
                  value: _formatSignedUsd(summary.realizedLosses),
                  color: _taxRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          const Divider(height: 1, thickness: 1, color: _taxOptionBorder),
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Net Gain/Loss:',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '+${_formatUsd(summary.netGainLoss)}',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _taxGreen,
                  fontSize: 20,
                  fontWeight: AppTextStyles.bold,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

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
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontSize: 20,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'Roboto',
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _CostBasisPicker extends StatelessWidget {
  const _CostBasisPicker({
    required this.selectedMethod,
    required this.onChanged,
  });

  final String selectedMethod;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const methods = [
      ('FIFO', 'First In, First Out (most common)'),
      ('LIFO', 'Last In, First Out'),
    ];
    return Row(
      children: [
        for (var i = 0; i < methods.length; i++) ...[
          Expanded(
            child: GestureDetector(
              key: BotTaxReportingPage.methodKey(methods[i].$1),
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(methods[i].$1),
              child: Container(
                height: 82,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                decoration: BoxDecoration(
                  color: _taxPanel,
                  border: Border.all(
                    color: selectedMethod == methods[i].$1
                        ? _taxPrimary
                        : _taxOptionBorder,
                    width: 2,
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _RadioDot(selected: selectedMethod == methods[i].$1),
                        const SizedBox(width: 8),
                        Text(
                          methods[i].$1,
                          style: AppTextStyles.caption.copyWith(
                            color: selectedMethod == methods[i].$1
                                ? _taxPrimary
                                : AppColors.text1,
                            fontSize: 13,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        methods[i].$2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (i != methods.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}
