part of '../pages/p2p_order_book_page.dart';

class _AssetSelector extends StatelessWidget {
  const _AssetSelector({
    required this.snapshot,
    required this.selectedAsset,
    required this.onChanged,
  });

  final P2POrderBookSnapshot snapshot;
  final String selectedAsset;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: P2POrderBookPage.assetRailKey,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final market in snapshot.markets) ...[
            _AssetChip(
              market: market,
              selected: market.asset == selectedAsset,
              onTap: () => onChanged(market.asset),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _AssetChip extends StatelessWidget {
  const _AssetChip({
    required this.market,
    required this.selected,
    required this.onTap,
  });

  final P2POrderBookMarketDraft market;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = market.changePct >= 0 ? AppColors.buy : AppColors.sell;
    return Material(
      key: P2POrderBookPage.assetKey(market.asset),
      color: selected ? AppColors.warn10 : AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          constraints: const BoxConstraints(minWidth: 110, minHeight: 64),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadii.cardRadius,
            border: Border.all(
              width: selected ? 1.5 : 1,
              color: selected ? AppModuleAccents.p2p : AppColors.borderSolid,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${market.asset}/VND',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                _formatChange(market.changePct),
                style: AppTextStyles.micro.copyWith(
                  color: tone,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketTicker extends StatelessWidget {
  const _MarketTicker({
    required this.snapshot,
    required this.isRefreshing,
    required this.onRefresh,
  });

  final P2POrderBookSnapshot snapshot;
  final bool isRefreshing;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final market = snapshot.selectedAsset;
    final tone = market.changePct >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: P2POrderBookPage.tickerKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '${market.asset}/VND',
                style: AppTextStyles.numericDisplaySm,
              ),
              const SizedBox(width: AppSpacing.x2),
              _ChangePill(value: market.changePct),
              const Spacer(),
              Material(
                key: P2POrderBookPage.refreshKey,
                color: AppColors.surface2,
                borderRadius: AppRadii.inputRadius,
                child: InkWell(
                  onTap: onRefresh,
                  borderRadius: AppRadii.inputRadius,
                  child: SizedBox(
                    width: AppSpacing.buttonCompact,
                    height: AppSpacing.buttonCompact,
                    child: AnimatedRotation(
                      turns: isRefreshing ? 1 : 0,
                      duration: const Duration(milliseconds: 600),
                      child: const Icon(
                        Icons.refresh_rounded,
                        color: AppColors.text2,
                        size: AppSpacing.iconSm,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _TickerMetric(
                  label: 'Giá hiện tại',
                  value: _formatVnd(market.lastPriceVnd),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: '24h High',
                  value: _formatVnd(market.high24hVnd),
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: '24h Low',
                  value: _formatVnd(market.low24hVnd),
                  color: AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _TickerMetric(
                  label: 'Volume 24h',
                  value: market.volume24hLabel,
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: 'Lệnh 24h',
                  value: _formatWhole(market.trades24h),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: 'Spread',
                  value: '${snapshot.spreadPercent.toStringAsFixed(3)}%',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              market.changePct >= 0
                  ? 'Thanh khoản đang tăng nhẹ'
                  : 'Biến động cần theo dõi',
              style: AppTextStyles.micro.copyWith(color: tone),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePill extends StatelessWidget {
  const _ChangePill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final tone = value >= 0 ? AppColors.buy : AppColors.sell;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.withValues(alpha: .12),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          children: [
            Icon(
              value >= 0
                  ? Icons.arrow_outward_rounded
                  : Icons.south_east_rounded,
              color: tone,
              size: 11,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              _formatChange(value),
              style: AppTextStyles.micro.copyWith(
                color: tone,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TickerMetric extends StatelessWidget {
  const _TickerMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

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
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
