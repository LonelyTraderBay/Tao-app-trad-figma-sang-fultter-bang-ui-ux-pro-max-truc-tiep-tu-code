part of '../pages/ex_post_costs_report_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: VitDensity.compact.cardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.text1,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
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
                const SizedBox(height: AppSpacing.x1),
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
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.amountSm.copyWith(
              color: muted ? AppColors.text3 : AppColors.text1,
            ),
          ),
        ],
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
      padding: AppSpacing.zeroInsets,
      constraints: BoxConstraints(minHeight: VitDensity.compact.controlHeight),
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
      padding: VitDensity.compact.cardPadding,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Est: ${_formatEur(estimate)}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: AppSpacing.x2),
            _VarianceNoteView(note: note!),
          ],
        ],
      ),
    );
  }
}
