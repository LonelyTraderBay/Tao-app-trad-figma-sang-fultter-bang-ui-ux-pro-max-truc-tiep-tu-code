part of 'launchpad_gas_tracker_page.dart';

const double _gasChartExtent =
    AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x4;

class _FeaturedGasCard extends StatelessWidget {
  const _FeaturedGasCard({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: AppSpacing.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_gas_station_outlined,
                color: AppModuleAccents.launchpad,
                size: AppSpacing.launchpadIconLg,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Gas ${price.chain}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              _TrendPill(price: price),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _TierValue(
                label: 'Slow',
                value: price.slow,
                color: AppColors.buy,
              ),
              _TierValue(
                label: 'Standard',
                value: price.standard,
                color: AppColors.primary,
              ),
              _TierValue(
                label: 'Fast',
                value: price.fast,
                color: AppColors.warn,
              ),
              _TierValue(
                label: 'Instant',
                value: price.instant,
                color: AppColors.sell,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${price.unit} · Cập nhật ${price.lastUpdated}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierValue extends StatelessWidget {
  const _TierValue({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            _formatGasValue(value),
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.launchpadLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.launchpadLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _GasTabs extends StatelessWidget {
  const _GasTabs({required this.activeTab, required this.onChanged});

  final _GasTab activeTab;
  final ValueChanged<_GasTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabButton(
          key: LaunchpadGasTrackerPage.pricesTabKey,
          label: 'prices',
          active: activeTab == _GasTab.prices,
          onTap: () => onChanged(_GasTab.prices),
        ),
        _TabButton(
          key: LaunchpadGasTrackerPage.estimatorTabKey,
          label: 'estimator',
          active: activeTab == _GasTab.estimator,
          onTap: () => onChanged(_GasTab.estimator),
        ),
        _TabButton(
          key: LaunchpadGasTrackerPage.alertsTabKey,
          label: 'alerts',
          active: activeTab == _GasTab.alerts,
          onTap: () => onChanged(_GasTab.alerts),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitChoicePill(
        label: label,
        selected: active,
        onTap: onTap,
        fullWidth: true,
        accentColor: AppColors.primary,
        semanticLabel: 'Gas tracker tab $label',
      ),
    );
  }
}

class _PricesTab extends StatelessWidget {
  const _PricesTab({
    required this.prices,
    required this.selectedGas,
    required this.selectedChain,
    required this.onSelected,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final LaunchpadGasPriceDraft selectedGas;
  final String selectedChain;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChainSelector(
          prices: prices,
          selectedChain: selectedChain,
          onSelected: onSelected,
        ),
        const SizedBox(height: AppSpacing.x4),
        _GasChartCard(price: selectedGas),
        if (selectedGas.baseFee != null && selectedGas.priorityFee != null) ...[
          const SizedBox(height: AppSpacing.x4),
          _Eip1559Card(price: selectedGas),
        ],
        const SizedBox(height: AppSpacing.x4),
        _AllChainsSection(
          prices: prices,
          selectedChain: selectedChain,
          onSelected: onSelected,
        ),
      ],
    );
  }
}

class _ChainSelector extends StatelessWidget {
  const _ChainSelector({
    required this.prices,
    required this.selectedChain,
    required this.onSelected,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final String selectedChain;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: LaunchpadGasTrackerPage.chainSelectorKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final price in prices) ...[
            _SelectablePill(
              key: LaunchpadGasTrackerPage.chainKey(price.chain),
              label: price.chain,
              color: price.accent.resolve(),
              active: selectedChain == price.chain,
              onTap: () => onSelected(price.chain),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _GasChartCard extends StatelessWidget {
  const _GasChartCard({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.chartKey,
      padding: AppSpacing.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gas 24h - ${price.chain}',
            style: AppTextStyles.captionSm.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          SizedBox(
            height: _gasChartExtent,
            child: CustomPaint(
              painter: _GasChartPainter(price),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Eip1559Card extends StatelessWidget {
  const _Eip1559Card({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.eipKey,
      padding: AppSpacing.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EIP-1559',
            style: AppTextStyles.captionSm.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _FeeBox(
                  label: 'Base Fee',
                  value: _formatGasValue(price.baseFee ?? 0),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FeeBox(
                  label: 'Priority Fee',
                  value: _formatGasValue(price.priorityFee ?? 0),
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeeBox extends StatelessWidget {
  const _FeeBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .08),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPaddingX3,
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.base.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllChainsSection extends StatelessWidget {
  const _AllChainsSection({
    required this.prices,
    required this.selectedChain,
    required this.onSelected,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final String selectedChain;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadGasTrackerPage.allChainsKey,
      child: VitPageSection(
        label: 'Tat ca chains',
        accentColor: AppColors.accent,
        children: [
          for (final price in prices)
            _ChainComparisonCard(
              price: price,
              selected: selectedChain == price.chain,
              onTap: () => onSelected(price.chain),
            ),
        ],
      ),
    );
  }
}

class _ChainComparisonCard extends StatelessWidget {
  const _ChainComparisonCard({
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final LaunchpadGasPriceDraft price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: selected
          ? price.accent.resolve().withValues(alpha: .35)
          : AppColors.cardBorder,
      padding: AppSpacing.launchpadPaddingX3,
      onTap: onTap,
      child: Row(
        children: [
          _ChainBadge(price: price),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.chain,
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_formatGasValue(price.slow)} / ${_formatGasValue(price.standard)} / ${_formatGasValue(price.fast)} ${price.unit}',
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          _TrendInline(price: price),
        ],
      ),
    );
  }
}

class _EstimatorTab extends StatelessWidget {
  const _EstimatorTab({required this.estimates});

  final List<LaunchpadGasEstimateDraft> estimates;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadGasTrackerPage.estimatesKey,
      child: VitPageSection(
        label: 'Chi phi uoc tinh',
        accentColor: AppColors.warn,
        children: [
          for (final estimate in estimates) _EstimateCard(estimate: estimate),
        ],
      ),
    );
  }
}
