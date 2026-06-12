part of '../pages/savings_page.dart';

class _SavingsTabs extends StatelessWidget {
  const _SavingsTabs({
    required this.activeTab,
    required this.positionCount,
    required this.onChanged,
  });

  final _SavingsTab activeTab;
  final int positionCount;
  final ValueChanged<_SavingsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeTab.name,
      onChanged: (key) => onChanged(_SavingsTab.values.byName(key)),
      tabs: [
        VitTabItem(
          key: _SavingsTab.products.name,
          label: 'Sản phẩm',
          icon: Icons.inventory_2_outlined,
        ),
        VitTabItem(
          key: _SavingsTab.my.name,
          label: 'Đăng ký ($positionCount)',
          icon: Icons.business_center_outlined,
        ),
      ],
    );
  }
}

class _SavingsFilters extends StatelessWidget {
  const _SavingsFilters({required this.activeFilter, required this.onChanged});

  final _SavingsFilter activeFilter;
  final ValueChanged<_SavingsFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final filter in _SavingsFilter.values) ...[
          _SavingsFilterChip(
            key: SavingsPage.filterKey(filter.name),
            filter: filter,
            selected: filter == activeFilter,
            onTap: () => onChanged(filter),
          ),
          if (filter != _SavingsFilter.values.last)
            const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _SavingsFilterChip extends StatelessWidget {
  const _SavingsFilterChip({
    super.key,
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final _SavingsFilter filter;
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _filterIcon(filter),
                color: selected ? AppColors.primary : AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                _filterLabel(filter),
                style: AppTextStyles.caption.copyWith(
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

class _SavingsProductList extends StatelessWidget {
  const _SavingsProductList({
    required this.products,
    required this.detailRoute,
  });

  final List<SavingsProductDraft> products;
  final String detailRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final product in products) ...[
          _SavingsProductCard(product: product, detailRoute: detailRoute),
          if (product != products.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _SavingsProductCard extends StatelessWidget {
  const _SavingsProductCard({required this.product, required this.detailRoute});

  final SavingsProductDraft product;
  final String detailRoute;

  @override
  Widget build(BuildContext context) {
    final accent = _productAccent(product);

    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AssetBadge(asset: product.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        if (product.isHot)
                          const _StatusBadge(
                            label: 'HOT',
                            color: AppColors.sell,
                            background: AppColors.sell10,
                          ),
                        if (product.isNew)
                          const _StatusBadge(
                            label: 'MỚI',
                            color: AppColors.primary,
                            background: AppColors.primary12,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Icon(
                          product.type == SavingsProductType.flexible
                              ? Icons.lock_open_rounded
                              : Icons.lock_outline_rounded,
                          color: product.type == SavingsProductType.flexible
                              ? AppColors.buy
                              : AppColors.warn,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Expanded(
                          child: Text(
                            _productSubtitle(product),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontSize:
                                  AppSpacing.savingsConsumerCaptionFontSize,
                            ),
                          ),
                        ),
                        _RiskPill(label: _riskLabel(product.riskLevel)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.apy,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontSize: AppSpacing.savingsConsumerProductRateFontSize,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  if (product.maxApy != null)
                    Text(
                      product.maxApy!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.warn,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đã ký: ${product.totalSubscribed}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                'Còn: ${product.remainingQuota}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressBar(
            progress: product.progress,
            color: product.progress > 0.85 ? AppColors.sell : accent,
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              TextButton.icon(
                key: product.id == 'sav001'
                    ? SavingsPage.productDetailButtonKey
                    : null,
                onPressed: () => context.go(detailRoute),
                icon: const Icon(Icons.chevron_right_rounded),
                label: const Text('Chi tiết'),
              ),
              const Spacer(),
              VitCtaButton(
                fullWidth: false,
                height: AppSpacing.savingsConsumerActionHeight,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                onPressed: () => HapticFeedback.selectionClick(),
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
