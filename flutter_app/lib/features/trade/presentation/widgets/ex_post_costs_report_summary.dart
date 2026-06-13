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
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This report shows the actual costs you paid in $year. '
                  'Required by PRIIPs regulation.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.amountSm.copyWith(
                color: muted ? AppColors.text3 : AppColors.text1,
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
    return VitCard(
      height: 53,
      padding: EdgeInsets.zero,
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
                            fontWeight: AppTextStyles.bold,
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
                      fontWeight: AppTextStyles.bold,
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
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Est: ${_formatEur(estimate)}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
