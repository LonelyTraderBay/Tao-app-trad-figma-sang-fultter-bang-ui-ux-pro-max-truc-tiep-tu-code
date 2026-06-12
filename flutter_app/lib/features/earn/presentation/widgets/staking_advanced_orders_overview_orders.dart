part of '../pages/staking_advanced_orders_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAdvancedOrdersPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.track_changes_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAdvancedOrdersPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          for (var i = 0; i < snapshot.statCards.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.x3),
            Expanded(child: _StatTile(stat: snapshot.statCards[i])),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingAdvancedOrderStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final isSuccess = stat.tone == 'success';
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      borderColor: isSuccess ? AppColors.buy20 : null,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: isSuccess ? AppColors.buy : AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
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
  const _OrderTabs({required this.active, required this.onChanged});

  final _AdvancedOrderTab active;
  final ValueChanged<_AdvancedOrderTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingAdvancedOrdersPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _AdvancedOrderTab.values)
            Expanded(
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  key: StakingAdvancedOrdersPage.tabKey(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.x4),
                    child: Column(
                      children: [
                        Text(
                          _tabLabel(tab),
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: active == tab ? AppSpacing.buttonHero : 0,
                          height: AppSpacing.stakingProductTabIndicatorHeight,
                          decoration: BoxDecoration(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.transparent,
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final StakingAdvancedOrderDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAdvancedOrdersPage.orderKey(order.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _orderIcon(order.type),
                color: _orderTone(order.type),
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _orderTypeLabel(order.type),
                      style: AppTextStyles.baseMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${order.asset} · Trigger: ${order.trigger.toStringAsFixed(order.trigger == 0.90 ? 1 : 2)} ETH',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatAmount(order.amount)} ${order.asset}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  _StatusPill(status: order.status),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(
            height: AppSpacing.stakingProductDividerHeight,
            color: AppColors.borderSolid,
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Created: ${_formatDate(order.created)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (order.status == StakingAdvancedOrderStatus.active)
                Text(
                  'Cancel',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final StakingAdvancedOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      StakingAdvancedOrderStatus.active => AppColors.buy,
      StakingAdvancedOrderStatus.triggered => AppColors.primarySoft,
      StakingAdvancedOrderStatus.cancelled => AppColors.text3,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: switch (status) {
          StakingAdvancedOrderStatus.active => AppColors.buy15,
          StakingAdvancedOrderStatus.triggered => AppColors.primary15,
          StakingAdvancedOrderStatus.cancelled => AppColors.surface3,
        },
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        _statusLabel(status),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
