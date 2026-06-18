part of '../pages/staking_earn_page.dart';

class _EarnHero extends StatelessWidget {
  const _EarnHero({required this.snapshot});

  final StakingEarnSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tong thu nhap (USD)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.totalEarnedUsd,
                      style: AppTextStyles.amountMd.copyWith(
                        color: AppColors.buy,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      'Tich luy tu truoc den nay',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              VitCard(
                variant: VitCardVariant.inner,
                padding: AppSpacing.earnCardPaddingX4X3,
                child: Column(
                  children: [
                    Text(
                      '${snapshot.activePositions}',
                      style: AppTextStyles.amountSm.copyWith(
                        color: AppColors.buy,
                      ),
                    ),
                    Text(
                      'Vi the hoat dong',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _HeroPill(
                  icon: Icons.bolt_rounded,
                  label: snapshot.maxApyLabel,
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroPill(
                  icon: Icons.shield_outlined,
                  label: snapshot.fundProtectionLabel,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroPill(
                  key: StakingEarnPage.savingsButtonKey,
                  icon: Icons.savings_outlined,
                  label: 'Tiet kiem',
                  color: AppColors.text2,
                  onTap: () => context.go(snapshot.savingsRoute),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: AppSpacing.earnCardPaddingX3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.stakingEarnHeroTabLabelLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainTabs extends StatelessWidget {
  const _MainTabs({
    required this.activeTab,
    required this.positionCount,
    required this.onChanged,
  });

  final _EarnTab activeTab;
  final int positionCount;
  final ValueChanged<_EarnTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeTab.name,
      onChanged: (key) => onChanged(_EarnTab.values.byName(key)),
      tabs: [
        VitTabItem(
          key: _EarnTab.products.name,
          label: 'San pham',
          icon: Icons.inventory_2_outlined,
        ),
        VitTabItem(
          key: _EarnTab.positions.name,
          label: 'Cua toi ($positionCount)',
          icon: Icons.business_center_outlined,
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.activeFilter, required this.onChanged});

  final _EarnFilter activeFilter;
  final ValueChanged<_EarnFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in _EarnFilter.values) ...[
            _FilterChip(
              key: StakingEarnPage.filterKey(filter.name),
              filter: filter,
              selected: filter == activeFilter,
              onTap: () => onChanged(filter),
            ),
            if (filter != _EarnFilter.values.last)
              const SizedBox(width: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final _EarnFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Padding(
          padding: AppSpacing.earnSmallPillPadding,
          child: Row(
            children: [
              if (_filterIcon(filter) != null) ...[
                Icon(
                  _filterIcon(filter),
                  color: selected ? AppColors.primary : AppColors.text2,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x1),
              ],
              Text(
                _filterLabel(filter),
                style: AppTextStyles.micro.copyWith(
                  color: selected ? AppColors.primary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
