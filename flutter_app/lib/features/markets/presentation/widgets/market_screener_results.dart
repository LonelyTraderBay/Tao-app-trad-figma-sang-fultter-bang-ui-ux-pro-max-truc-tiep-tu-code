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
          if (index != pairs.length - 1) const SizedBox(height: 4),
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
      child: Container(
        height: 62,
        padding: const EdgeInsets.fromLTRB(14, 9, 14, 9),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _ScreenerAvatar(pair: pair),
            const SizedBox(width: 10),
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
                      fontSize: 15,
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatCompactUsd(pair.marketCap),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 58,
              height: 24,
              child: CustomPaint(
                painter: _ScreenerSparklinePainter(
                  values: pair.sparklineData,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 82,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${_formatPrice(pair.price)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 5),
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
                            size: 12,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${up ? '+' : ''}${pair.change24h.toStringAsFixed(2)}%',
                            style: AppTextStyles.caption.copyWith(
                              color: color,
                              fontSize: 12,
                              fontWeight: AppTextStyles.medium,
                              fontFeatures: AppTextStyles.tabularFigures,
                              height: 1,
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
    );
  }
}

class _ScreenerAvatar extends StatelessWidget {
  const _ScreenerAvatar({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Text(
        pair.baseAsset.substring(0, pair.baseAsset.length < 2 ? 1 : 2),
        style: AppTextStyles.caption.copyWith(
          color: pair.logoColor,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}
