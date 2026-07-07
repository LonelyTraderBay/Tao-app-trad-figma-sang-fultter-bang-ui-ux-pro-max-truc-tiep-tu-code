part of '../pages/bot_tax_reporting_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final TradeBotTaxSummary summary;

  @override
  Widget build(BuildContext context) {
    return _Card(
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
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            thickness: AppSpacing.dividerHairline,
            color: _taxOptionBorder,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Net Gain/Loss:',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '+${_formatUsd(summary.netGainLoss)}',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _taxGreen,
                  fontWeight: AppTextStyles.bold,
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
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
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
            child: VitCard(
              key: BotTaxReportingPage.methodKey(methods[i].$1),
              onTap: () => onChanged(methods[i].$1),
              density: VitDensity.compact,
              borderColor: selectedMethod == methods[i].$1
                  ? _taxPrimary
                  : _taxOptionBorder,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _RadioDot(selected: selectedMethod == methods[i].$1),
                      const SizedBox(width: AppSpacing.tradeBotSmallGap),
                      Text(
                        methods[i].$1,
                        style: AppTextStyles.caption.copyWith(
                          color: selectedMethod == methods[i].$1
                              ? _taxPrimary
                              : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    children: [
                      const SizedBox(
                        width: AppSpacing.tradeBotMethodTextIndent,
                      ),
                      Expanded(
                        child: Text(
                          methods[i].$2,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (i != methods.length - 1)
            const SizedBox(width: AppSpacing.tradeBotCardIconGap),
        ],
      ],
    );
  }
}
