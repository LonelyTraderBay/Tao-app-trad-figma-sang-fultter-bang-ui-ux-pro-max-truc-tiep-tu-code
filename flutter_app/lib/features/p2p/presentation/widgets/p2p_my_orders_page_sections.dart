part of '../pages/p2p_my_orders_page.dart';

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot});

  final P2PMyOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatMeta('Tổng đơn', '${snapshot.orders.length}', AppColors.text1),
      _StatMeta('Hoàn thành', '${snapshot.completedCount}', AppColors.buy),
      _StatMeta(
        'Tổng KL',
        _formatCompactVnd(snapshot.completedVolume),
        AppModuleAccents.p2p,
      ),
    ];
    return Row(
      key: P2PMyOrdersPage.statsKey,
      children: [
        for (var index = 0; index < stats.length; index++) ...[
          Expanded(child: _StatCard(meta: stats[index])),
          if (index != stats.length - 1) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.meta});

  final _StatMeta meta;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: AppSpacing.p2pMyOrdersStatPadding,
      child: Column(
        children: [
          Text(
            meta.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(color: meta.color),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            meta.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _OrderTabs extends StatelessWidget {
  const _OrderTabs({
    required this.snapshot,
    required this.active,
    required this.onChanged,
  });

  final P2PMyOrdersSnapshot snapshot;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in snapshot.tabs)
          VitTabItem(key: tab.id, label: tab.label),
      ],
    );
  }
}

class _SearchSortRow extends StatelessWidget {
  const _SearchSortRow({
    required this.hint,
    required this.controller,
    required this.sort,
    required this.onQueryChanged,
    required this.onSort,
  });

  final String hint;
  final TextEditingController controller;
  final _OrdersSort sort;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSearchBar(
            key: P2PMyOrdersPage.searchKey,
            controller: controller,
            placeholder: hint,
            variant: VitSearchBarVariant.compact,
            onChanged: onQueryChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Material(
          key: P2PMyOrdersPage.sortKey,
          color: AppColors.surface2,
          borderRadius: AppRadii.inputRadius,
          child: VitCard(
            onTap: onSort,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: AppSpacing.zeroInsets,
            child: VitCard(
              height: _p2pMyOrdersSortHeight,
              variant: VitCardVariant.ghost,
              radius: VitCardRadius.standard,
              borderColor: AppColors.borderSolid,
              padding: AppSpacing.p2pMyOrdersChipPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sort_rounded,
                    color: AppColors.text2,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    sort == _OrdersSort.date ? 'Ngày' : 'Số tiền',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final P2PMyOrderDraft order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = _statusMeta(order.status);
    final isBuy = order.type == 'buy';
    final typeColor = isBuy ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: P2PMyOrdersPage.orderKey(order.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pMyOrdersCardPadding,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitAccentPill(
                label: isBuy ? 'MUA' : 'BÁN',
                accentColor: typeColor,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '#${order.id.toUpperCase()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Icon(status.icon, color: status.color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x1),
              Text(
                status.label,
                style: AppTextStyles.micro.copyWith(
                  color: status.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pMyOrdersSectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _OrderMetric(
                  label: 'Số lượng',
                  value: '${_formatCrypto(order.amount)} ${order.asset}',
                ),
              ),
              Expanded(
                child: _OrderMetric(
                  label: 'Giá',
                  value: _formatVnd(order.price),
                ),
              ),
              Expanded(
                child: _OrderMetric(
                  label: 'Tổng tiền',
                  value: _formatVnd(order.total),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pMyOrdersSectionGap),
          const Divider(
            color: AppColors.divider,
            height: _p2pMyOrdersDividerHeight,
          ),
          const SizedBox(height: _p2pMyOrdersTightGap),
          Row(
            children: [
              CircleAvatar(
                radius: AppSpacing.x4,
                backgroundColor: AppModuleAccents.p2p,
                child: Text(
                  order.merchant.characters.first.toUpperCase(),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  order.merchant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Text(
                _formatDateTime(order.createdAt),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: AppSpacing.x1),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderMetric extends StatelessWidget {
  const _OrderMetric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.snapshot, required this.activeTab});

  final P2PMyOrdersSnapshot snapshot;
  final String activeTab;

  @override
  Widget build(BuildContext context) {
    final message = switch (activeTab) {
      'disputed' => 'Không có đơn tranh chấp',
      'completed' => 'Chưa có đơn hoàn tất',
      _ => 'Bạn không có đơn đang xử lý',
    };
    return VitCard(
      key: P2PMyOrdersPage.emptyKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pMyOrdersLargePadding,
      child: Column(
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(snapshot.emptyTitle, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x1),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _p2pMyOrdersSectionGap),
          VitCtaButton(
            variant: VitCtaButtonVariant.primary,
            onPressed: () => context.go(snapshot.parentRoute),
            child: const Text('Tạo giao dịch P2P'),
          ),
        ],
      ),
    );
  }
}
