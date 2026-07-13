part of '../pages/ex_ante_costs_page.dart';

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Example Investment Amount',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: _costTinySpace),
                Text(
                  _formatEur(snapshot.investmentAmount),
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: _costTinySpace),
                Text(
                  'Illustrative estimate',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _costLineTight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: _costTinySpace),
          Expanded(
            child: _MetricBox(
              label: 'Year 1',
              value: _formatEur(snapshot.totalFirstYear),
            ),
          ),
          const SizedBox(width: _costTinySpace),
          Expanded(
            child: _MetricBox(
              label: '% Invested',
              value: '${snapshot.totalPercentage.toStringAsFixed(2)}%',
              valueColor: _costRed,
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
    const tabs = [
      ('summary', 'Summary'),
      ('breakdown', 'Breakdown'),
      ('scenarios', 'Scenarios'),
    ];
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: _costTabExtent,
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets,
      child: VitTabBar(
        activeKey: activeId,
        onChanged: onChanged,
        variant: VitTabBarVariant.underline,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: ExAnteCostsPage.tabKey(tab.$1),
            ),
        ],
      ),
    );
  }
}
