part of '../pages/bot_tax_reporting_page.dart';

class _TaxNotice extends StatelessWidget {
  const _TaxNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      variant: VitCardVariant.inner,
      borderColor: _taxAmber.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _taxAmber,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax Reporting Notice',
                  style: AppTextStyles.caption.copyWith(
                    color: _taxAmber,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Cryptocurrency trading is taxable in most countries. Bot '
                  'trades are treated as individual transactions. We provide '
                  'reports for convenience, but you should consult a tax '
                  'professional for accurate filing.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedYear == years[i]
                      ? _taxPrimary
                      : _taxBackground,
                  border: Border.all(
                    color: selectedYear == years[i]
                        ? _taxPrimary
                        : _taxOptionBorder,
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Text(
                  years[i],
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          if (i != years.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
