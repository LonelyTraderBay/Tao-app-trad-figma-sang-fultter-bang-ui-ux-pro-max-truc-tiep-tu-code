part of 'live_market_interest_cards.dart';

class _TopTradersCard extends StatelessWidget {
  const _TopTradersCard({required this.data});

  final TradeTopTraderPositions data;

  @override
  Widget build(BuildContext context) {
    final shortShift = data.change24h < 0;
    return LiveMarketCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LiveMarketCardHeader(
            icon: Icons.visibility_rounded,
            color: liveMarketAmber,
            title: 'Top Traders',
            badge: 'Long',
          ),
          const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
          LiveMarketCard(
            variant: VitCardVariant.ghost,
            borderColor: liveMarketGreen.withValues(alpha: .2),
            height: MarketsSpacingTokens.liveMarketTopTraderHighlightHeight,
            padding: AppSpacing.cardPadding,
            background: ColoredBox(
              color: liveMarketGreen.withValues(alpha: .09),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LiveMarketMutedLabel(
                  'Top traders dang Long',
                  align: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.rowGap),
                Text(
                  '${data.longPct.toStringAsFixed(1)}%',
                  style: AppTextStyles.amountLg.copyWith(
                    color: liveMarketGreen,
                  ),
                ),
                const SizedBox(height: AppSpacing.rowGapRegular),
                const LiveMarketMutedLabel(
                  'of top traders are long',
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
          LiveMarketRatioBar(longPct: data.longPct),
          const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
          LiveMarketCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.transparent,
            padding: MarketsSpacingTokens.liveMarketRowPadding,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LiveMarketMutedLabel('24h Change'),
                      const SizedBox(height: AppSpacing.rowGapCompact),
                      Text(
                        'Shifted ${data.change24h.abs().toStringAsFixed(1)}% to ${shortShift ? 'Short' : 'Long'}',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipOval(
                  child: ColoredBox(
                    color: (shortShift ? liveMarketRed : liveMarketGreen)
                        .withValues(alpha: .12),
                    child: SizedBox.square(
                      dimension: MarketsSpacingTokens.liveMarketTrendActionBox,
                      child: Icon(
                        shortShift
                            ? Icons.trending_down_rounded
                            : Icons.trending_up_rounded,
                        color: shortShift ? liveMarketRed : liveMarketGreen,
                        size: MarketsSpacingTokens.liveMarketTrendActionIcon,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
          LiveMarketInfoStrip(
            bg: liveMarketAmber.withValues(alpha: .06),
            color: liveMarketAmber,
          ),
        ],
      ),
    );
  }
}
