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
        const SizedBox(width: AppSpacing.tradeBotCardGap),
        Expanded(
          child: _SummaryCard(
            label: 'Resolved',
            value: '${snapshot.resolvedCount}',
            caption: 'Discrepancies',
            captionColor: AppColors.text3,
          ),
        ),
        const SizedBox(width: AppSpacing.tradeBotCardGap),
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
      height: AppSpacing.tradeBotCassSummaryHeight,
      padding: AppSpacing.tradeBotStrategyCardPadding,
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
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotRowGap),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const Spacer(),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: captionColor,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
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
    return VitCard(
      height: AppSpacing.tradeBotCassTabsHeight,
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotCompactPanelPadding,
      child: VitTabBar(
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: CassReconciliationPage.tabKey(tab.$1),
            ),
        ],
        activeKey: activeId,
        onChanged: onChanged,
        variant: VitTabBarVariant.segment,
      ),
    );
  }
}
