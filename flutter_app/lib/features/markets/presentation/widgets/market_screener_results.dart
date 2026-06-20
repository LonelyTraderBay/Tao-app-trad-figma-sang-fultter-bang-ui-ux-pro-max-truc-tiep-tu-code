part of '../pages/market_screener_page.dart';

class _ScreenerResults extends StatelessWidget {
  const _ScreenerResults({required this.pairs, required this.onPairTap});

  final List<MarketPair> pairs;
  final ValueChanged<MarketPair> onPairTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < pairs.length; index++) ...[
          _ScreenerRow(
            pair: pairs[index],
            rank: index + 1,
            onTap: () => onPairTap(pairs[index]),
          ),
          if (index != pairs.length - 1) const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}

class _ScreenerRow extends StatelessWidget {
  const _ScreenerRow({
    required this.pair,
    required this.rank,
    required this.onTap,
  });

  final MarketPair pair;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final up = pair.change24h >= 0;
    final color = up ? AppColors.buy : AppColors.sell;

    return InkWell(
      key: MarketScreenerPage.rowKey(pair.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadii.cardRadius,
        child: SizedBox(
          height: _rowHeight,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
            child: Row(
              children: [
                SizedBox(
                  width: _rowRankWidth,
                  child: Text(
                    '$rank',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                _ScreenerAvatar(pair: pair),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pair.baseAsset,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                          height: 1.06,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        _formatCompactUsd(pair.marketCap),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1.18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: _sparklineWidth,
                  height: _sparklineHeight,
                  child: VitSparkline(
                    values: pair.sparklineData,
                    color: color,
                    showFill: false,
                    strokeWidth: _sparklineStroke,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                SizedBox(
                  width: _valueWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${_formatPrice(pair.price)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                          height: 1.06,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                up
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                color: color,
                                size: _trendIconSize,
                              ),
                              const SizedBox(width: AppSpacing.x1),
                              Text(
                                '${up ? '+' : ''}${pair.change24h.toStringAsFixed(2)}%',
                                style: AppTextStyles.caption.copyWith(
                                  color: color,
                                  fontWeight: AppTextStyles.medium,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                  height: 1.12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScreenerAvatar extends StatelessWidget {
  const _ScreenerAvatar({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: pair.baseAsset,
      accentColor: pair.logoColor,
      size: _rowAvatarSize,
    );
  }
}
