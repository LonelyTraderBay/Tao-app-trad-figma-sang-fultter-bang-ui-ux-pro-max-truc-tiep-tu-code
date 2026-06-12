part of '../pages/launchpad_limit_orders_page.dart';

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeTab, required this.onChanged});

  final _LimitOrderTab activeTab;
  final ValueChanged<_LimitOrderTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadLimitOrdersPage.tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: VitTabBar(
        tabs: const [
          VitTabItem(key: 'active', label: 'Hoat dong'),
          VitTabItem(key: 'history', label: 'Lich su'),
          VitTabItem(key: 'create', label: 'Tao lenh'),
        ],
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_LimitOrderTab.values.byName(key)),
        variant: VitTabBarVariant.underline,
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final LaunchpadLimitOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadLimitOrdersPage.statsKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _StatCell(
            label: 'Active',
            value: '${snapshot.activeOrders.length}',
            color: AppColors.primary,
          ),
          _StatCell(
            label: 'Filled 24h',
            value: '${snapshot.filled24h}',
            color: AppColors.buy,
          ),
          _StatCell(
            label: 'Value',
            value: snapshot.totalValueLabel,
            color: AppColors.text1,
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: color,
              fontSize: AppSpacing.launchpadFont2xl,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
