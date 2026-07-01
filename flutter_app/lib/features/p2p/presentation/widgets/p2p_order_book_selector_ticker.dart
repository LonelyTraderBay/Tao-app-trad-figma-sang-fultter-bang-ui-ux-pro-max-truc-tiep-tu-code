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
    return VitCard(
      key: P2POrderBookPage.assetKey(market.asset),
      variant: VitCardVariant.ghost,
      borderColor: selected ? AppModuleAccents.p2p : AppColors.borderSolid,
      background: ColoredBox(
        color: selected ? AppColors.warn10 : AppColors.surface2,
      ),
      constraints: const BoxConstraints(
        minWidth: _p2pOrderBookAssetChipMinWidth,
        minHeight: _p2pOrderBookAssetChipMinExtent,
      ),
      padding: AppSpacing.p2pOrderBookSelectorPadding,
      onTap: onTap,
      clip: true,
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
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pOrderBookCardPadding,
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
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: VitCard(
                    key: P2POrderBookPage.refreshKey,
                    variant: VitCardVariant.inner,
                    radius: VitCardRadius.standard,
                    width: _p2pOrderBookRefreshExtent,
                    height: _p2pOrderBookRefreshExtent,
                    onTap: onRefresh,
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
          const SizedBox(height: _p2pOrderBookSectionGap),
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
          const SizedBox(height: _p2pOrderBookSectionGap),
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
    return VitMetricDeltaPill(
      label: _formatChange(value),
      tone: value >= 0
          ? VitMetricDeltaTone.positive
          : VitMetricDeltaTone.negative,
      icon: value >= 0 ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
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
