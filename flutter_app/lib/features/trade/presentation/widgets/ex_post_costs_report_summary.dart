part of '../pages/ex_post_costs_report_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.text1,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Annual Cost Report Available',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This report shows the actual costs you paid in $year. '
                  'Required by PRIIPs regulation.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.muted = false,
  });

  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 13),
      child: SizedBox(
        height: 46,
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
              style: AppTextStyles.heroNumber.copyWith(
                color: muted ? AppColors.text3 : AppColors.text1,
                fontSize: 20,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearTabs extends StatelessWidget {
  const _YearTabs({
    required this.reports,
    required this.activeYear,
    required this.onChanged,
  });

  final List<TradeExPostCostReport> reports;
  final int activeYear;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      color: _reportPanel,
      child: Row(
        children: [
          for (final report in reports)
            Expanded(
              child: InkWell(
                key: ExPostCostsReportPage.tabKey(report.year),
                onTap: () => onChanged(report.year),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          '${report.year}',
                          style: AppTextStyles.caption.copyWith(
                            color: activeYear == report.year
                                ? _reportPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeYear == report.year ? 100 : 0,
                      height: 2,
                      color: _reportPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CostBreakdownCard extends StatelessWidget {
  const _CostBreakdownCard({
    required this.title,
    required this.actual,
    required this.estimate,
    this.note,
  });

  final String title;
  final double actual;
  final double estimate;
  final _VarianceNote? note;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatEur(actual),
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontSize: 16,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Est: ${_formatEur(estimate)}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 22),
            _VarianceNoteView(note: note!),
          ],
        ],
      ),
    );
  }
}
