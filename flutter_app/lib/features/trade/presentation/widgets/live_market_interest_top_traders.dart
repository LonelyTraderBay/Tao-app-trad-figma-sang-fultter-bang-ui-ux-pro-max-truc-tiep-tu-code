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
          const SizedBox(height: 16),
          Container(
            height: 113,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: liveMarketGreen.withValues(alpha: .09),
              border: Border.all(color: liveMarketGreen.withValues(alpha: .2)),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LiveMarketMutedLabel(
                  'Top traders dang Long',
                  align: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.longPct.toStringAsFixed(1)}%',
                  style: AppTextStyles.amountLg.copyWith(
                    color: liveMarketGreen,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 9),
                const LiveMarketMutedLabel(
                  'of top traders are long',
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          LiveMarketRatioBar(longPct: data.longPct),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
            decoration: BoxDecoration(
              color: liveMarketPanel2,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LiveMarketMutedLabel('24h Change'),
                      const SizedBox(height: 7),
                      Text(
                        'Shifted ${data.change24h.abs().toStringAsFixed(1)}% to ${shortShift ? 'Short' : 'Long'}',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: (shortShift ? liveMarketRed : liveMarketGreen)
                        .withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    shortShift
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                    color: shortShift ? liveMarketRed : liveMarketGreen,
                    size: 23,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          LiveMarketInfoStrip(
            bg: liveMarketAmber.withValues(alpha: .06),
            color: liveMarketAmber,
          ),
        ],
      ),
    );
  }
}
