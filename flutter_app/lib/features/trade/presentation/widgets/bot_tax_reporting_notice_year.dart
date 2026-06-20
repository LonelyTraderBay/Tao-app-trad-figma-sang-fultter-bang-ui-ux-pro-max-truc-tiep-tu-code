part of '../pages/bot_tax_reporting_page.dart';

class _TaxNotice extends StatelessWidget {
  const _TaxNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: _taxAmber.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _taxAmber,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.tradeBotNarrowIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax Reporting Notice',
                  style: AppTextStyles.caption.copyWith(
                    color: _taxAmber,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Cryptocurrency trading is taxable in most countries. Bot '
                  'trades are treated as individual transactions. We provide '
                  'reports for convenience, but you should consult a tax '
                  'professional for accurate filing.',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YearPicker extends StatelessWidget {
  const _YearPicker({
    required this.years,
    required this.selectedYear,
    required this.onChanged,
  });

  final List<String> years;
  final String selectedYear;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < years.length; i++) ...[
          Expanded(
            child: VitCtaButton(
              key: BotTaxReportingPage.yearKey(years[i]),
              onPressed: () => onChanged(years[i]),
              density: VitDensity.compact,
              variant: selectedYear == years[i]
                  ? VitCtaButtonVariant.primary
                  : VitCtaButtonVariant.ghost,
              padding: AppSpacing.zeroInsets,
              child: Text(
                years[i],
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
          if (i != years.length - 1)
            const SizedBox(width: AppSpacing.tradeBotRowGap),
        ],
      ],
    );
  }
}
