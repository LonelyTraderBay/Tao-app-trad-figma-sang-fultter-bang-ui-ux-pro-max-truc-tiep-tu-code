part of '../pages/cass_reconciliation_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final TradeCassReconciliationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Reconciled',
            value: '${snapshot.reconciledCount}',
            caption: 'Last 7 days',
            captionColor: _cassGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Resolved',
            value: '${snapshot.resolvedCount}',
            caption: 'Discrepancies',
            captionColor: AppColors.text3,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Outstanding',
            value: '${snapshot.outstandingCount}',
            caption: 'None',
            captionColor: _cassGreen,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.captionColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color captionColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 89,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 13),
      borderColor: _cassBorder.withValues(alpha: .72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: captionColor, height: 1),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [('recent', 'Recent (7 Days)'), ('history', 'History')];
    return Container(
      height: 53,
      color: _cassPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: CassReconciliationPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _cassPrimary
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 161 : 0,
                      height: 2,
                      color: _cassPrimary,
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
