part of '../pages/market_correlations_page.dart';

class _CorrelationTabs extends StatelessWidget {
  const _CorrelationTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _corrTabsHeight,
            child: Row(
              children: [
                _UnderlinedTab(
                  key: MarketCorrelationsPage.matrixTabKey,
                  label: 'Ma trận',
                  value: 'matrix',
                  active: activeTab == 'matrix',
                  onChanged: onChanged,
                ),
                _UnderlinedTab(
                  key: MarketCorrelationsPage.pairsTabKey,
                  label: 'Cặp tương quan',
                  value: 'pairs',
                  active: activeTab == 'pairs',
                  onChanged: onChanged,
                ),
                _UnderlinedTab(
                  key: MarketCorrelationsPage.diversifyTabKey,
                  label: 'Đa dạng hóa',
                  value: 'diversify',
                  active: activeTab == 'diversify',
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: EdgeInsets.zero,
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _corrTabIndicatorHeight,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeframeChips extends StatelessWidget {
  const _TimeframeChips({required this.timeframe, required this.onSelected});

  final MarketCorrelationTimeframe timeframe;
  final ValueChanged<MarketCorrelationTimeframe> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TimeframeChip(
          key: MarketCorrelationsPage.timeframe7dKey,
          label: '7d',
          active: timeframe == MarketCorrelationTimeframe.d7,
          onTap: () => onSelected(MarketCorrelationTimeframe.d7),
        ),
        const SizedBox(width: _corrChipGap),
        _TimeframeChip(
          key: MarketCorrelationsPage.timeframe30dKey,
          label: '30d',
          active: timeframe == MarketCorrelationTimeframe.d30,
          onTap: () => onSelected(MarketCorrelationTimeframe.d30),
        ),
        const SizedBox(width: _corrChipGap),
        _TimeframeChip(
          key: MarketCorrelationsPage.timeframe90dKey,
          label: '90d',
          active: timeframe == MarketCorrelationTimeframe.d90,
          onTap: () => onSelected(MarketCorrelationTimeframe.d90),
        ),
      ],
    );
  }
}

class _TimeframeChip extends StatelessWidget {
  const _TimeframeChip({
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
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: _marketPrimary,
      height: _corrTimeframeChipHeight,
      padding: AppSpacing.marketCorrelationsTimeframeChipPadding,
    );
  }
}
