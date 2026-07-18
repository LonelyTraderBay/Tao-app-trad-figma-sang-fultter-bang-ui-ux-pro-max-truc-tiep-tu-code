part of '../../pages/staking/staking_earn_page.dart';

class _EarnHero extends StatelessWidget {
  const _EarnHero({required this.snapshot});

  final StakingEarnSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          Expanded(
            child: _HeroKpi(
              label: 'Tong stake',
              value: _stakedHeroValue(snapshot.positions),
              caption: snapshot.positions.isEmpty
                  ? 'Chua co vi the'
                  : '${snapshot.activePositions} vi the dang hoat dong',
              valueColor: AppColors.text1,
            ),
          ),
          const SizedBox(
            width: 1,
            height: AppSpacing.x6,
            child: ColoredBox(color: AppColors.border),
          ),
          Expanded(
            child: Padding(
              padding: EarnSpacingTokens.earnHeroSecondaryPadding,
              child: _HeroKpi(
                label: 'APY uoc tinh',
                value: _apyEstimateRange(snapshot.products),
                caption: 'Tham khao, co the thay doi',
                valueColor: AppModuleAccents.earn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroKpi extends StatelessWidget {
  const _HeroKpi({
    required this.label,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.heroNumber.copyWith(
            color: valueColor,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
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
          widgetKey: StakingEarnPage.productsTabKey,
        ),
        VitTabItem(
          key: _EarnTab.positions.name,
          label: 'Cua toi ($positionCount)',
          icon: Icons.business_center_outlined,
          widgetKey: StakingEarnPage.positionsTabKey,
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
    return VitPresetChipRow<_EarnFilter>(
      accentColor: AppModuleAccents.earn,
      selectedValue: activeFilter,
      onTap: onChanged,
      items: [
        for (final filter in _EarnFilter.values)
          VitPresetChipItem(
            value: filter,
            label: _filterLabel(filter),
            key: StakingEarnPage.filterKey(filter.name),
            semanticLabel: 'Lọc sản phẩm ${_filterLabel(filter)}',
          ),
      ],
    );
  }
}

class _YieldDisclaimer extends StatelessWidget {
  const _YieldDisclaimer();

  @override
  Widget build(BuildContext context) {
    return const VitRiskDisclaimerNote(
      message:
          'APY la uoc tinh tham khao va co the thay doi. Gia tai san va APY co the bien dong; DeFi co rui ro smart contract.',
    );
  }
}

String _stakedHeroValue(List<EarnPositionDraft> positions) {
  if (positions.isEmpty) {
    return 'Chua stake';
  }
  if (positions.length == 1) {
    return positions.first.amount;
  }
  return '${positions.length} vi the';
}

String _apyEstimateRange(List<EarnProductDraft> products) {
  if (products.isEmpty) {
    return '--';
  }

  final values = products
      .map((product) => _parseApyPercent(product.apy))
      .whereType<double>()
      .toList();
  if (values.isEmpty) {
    return '--';
  }

  final minApy = values.reduce((a, b) => a < b ? a : b);
  final maxApy = values.reduce((a, b) => a > b ? a : b);
  if ((maxApy - minApy).abs() < 0.05) {
    return '${minApy.toStringAsFixed(1)}%';
  }
  return '${minApy.toStringAsFixed(1)}–${maxApy.toStringAsFixed(1)}%';
}

double? _parseApyPercent(String apy) {
  final normalized = apy.replaceAll('%', '').trim();
  return double.tryParse(normalized);
}
