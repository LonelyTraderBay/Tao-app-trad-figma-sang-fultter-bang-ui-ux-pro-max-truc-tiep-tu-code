part of '../pages/ex_post_costs_report_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.exPostCostsReportNoticePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.text1,
            size: AppSpacing.exPostCostsReportNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.exPostCostsReportNoticeIconGap),
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
                const SizedBox(height: AppSpacing.exPostCostsReportNoticeBodyGap),
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
      padding: AppSpacing.exPostCostsReportSummaryPadding,
      child: SizedBox(
        height: AppSpacing.exPostCostsReportSummaryHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppSpacing.exPostCostsReportSummaryLineHeight,
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
      height: AppSpacing.x7,
      padding: AppSpacing.zeroInsets,
      child: VitTabBar(
        activeKey: '$activeYear',
        onChanged: (year) => onChanged(int.parse(year)),
        variant: VitTabBarVariant.underline,
        tabs: [
          for (final report in reports)
            VitTabItem(
              key: '${report.year}',
              label: '${report.year}',
              widgetKey: ExPostCostsReportPage.tabKey(report.year),
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
      padding: AppSpacing.exPostCostsReportBreakdownPadding,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: AppSpacing.exPostCostsReportBreakdownTitlePadding,
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
                  const SizedBox(
                    height: AppSpacing.exPostCostsReportBreakdownEstimateGap,
                  ),
                  Text(
                    'Est: ${_formatEur(estimate)}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(
              height: AppSpacing.exPostCostsReportBreakdownNoteGap,
            ),
            _VarianceNoteView(note: note!),
          ],
        ],
      ),
    );
  }
}
