part of '../pages/bot_tax_reporting_page.dart';

class _TaxNotice extends StatelessWidget {
  const _TaxNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPaddingLoose,
      variant: VitCardVariant.inner,
      borderColor: _taxAmber.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _taxAmber,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax Reporting Notice',
                  style: AppTextStyles.caption.copyWith(
                    color: _taxAmber,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotRowGap),
                Text(
                  'Cryptocurrency trading is taxable in most countries. Bot '
                  'trades are treated as individual transactions. We provide '
                  'reports for convenience, but you should consult a tax '
                  'professional for accurate filing.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.tradeBotLineHeightRelaxed,
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
            child: GestureDetector(
              key: BotTaxReportingPage.yearKey(years[i]),
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(years[i]),
              child: VitCtaButton(
                onPressed: () => onChanged(years[i]),
                height: AppSpacing.tradeBotControlHeight,
                variant: selectedYear == years[i]
                    ? VitCtaButtonVariant.primary
                    : VitCtaButtonVariant.ghost,
                padding: AppSpacing.zeroInsets,
                child: Text(
                  years[i],
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
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
