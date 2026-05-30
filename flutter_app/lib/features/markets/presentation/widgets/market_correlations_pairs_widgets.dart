part of '../pages/market_correlations_page.dart';

class _SortChips extends StatelessWidget {
  const _SortChips({required this.sortOrder, required this.onSelected});

  final CorrelationSortOrder sortOrder;
  final ValueChanged<CorrelationSortOrder> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _SortChip(
            key: MarketCorrelationsPage.sortHighKey,
            label: 'Tương quan cao',
            active: sortOrder == CorrelationSortOrder.high,
            color: AppColors.sell,
            onTap: () => onSelected(CorrelationSortOrder.high),
          ),
          const SizedBox(width: 8),
          _SortChip(
            key: MarketCorrelationsPage.sortLowKey,
            label: 'Tương quan thấp',
            active: sortOrder == CorrelationSortOrder.low,
            color: AppColors.buy,
            onTap: () => onSelected(CorrelationSortOrder.low),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .10) : AppColors.surface2,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? color : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _PairCorrelationRow extends StatelessWidget {
  const _PairCorrelationRow({
    super.key,
    required this.rank,
    required this.pair,
    required this.timeframe,
    required this.maxValue,
  });

  final int rank;
  final CorrelationPairDraft pair;
  final MarketCorrelationTimeframe timeframe;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final value = _correlationValueFor(pair, timeframe);
    final color = _correlationColor(value);
    return Stack(
      children: [
        Positioned.fill(
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: maxValue == 0 ? 0 : value / maxValue,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: .06),
                borderRadius: AppRadii.mdRadius,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: .92),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                child: Text(
                  '$rank',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: 10),
              _AssetDot(symbol: pair.assetA, color: pair.colorA),
              const SizedBox(width: 5),
              Text(
                '↔',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: 5),
              _AssetDot(symbol: pair.assetB, color: pair.colorB),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${pair.assetA}/${pair.assetB}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value.toStringAsFixed(2),
                    style: AppTextStyles.body.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    _correlationLabel(value),
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AssetDot extends StatelessWidget {
  const _AssetDot({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        shape: BoxShape.circle,
      ),
      child: Text(
        symbol.substring(0, 2),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 7,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
