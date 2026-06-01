part of 'live_market_interest_cards.dart';

class _FundingCard extends StatelessWidget {
  const _FundingCard({required this.data});

  final TradeFundingRateHistory data;

  @override
  Widget build(BuildContext context) {
    return LiveMarketCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LiveMarketCardHeader(
            icon: Icons.attach_money_rounded,
            color: liveMarketPrimary,
            title: 'Funding Rate',
            badge: '+${data.currentRatePct.toStringAsFixed(4)}%',
            badgeColor: liveMarketRed,
          ),
          const SizedBox(height: 16),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: liveMarketSurface3,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Text(
                  'Next funding in',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  data.nextFundingLabel,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: liveMarketPrimary,
                    fontSize: 18,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'monospace',
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Current',
                  value: '+${data.currentRatePct.toStringAsFixed(3)}%',
                  color: liveMarketRed,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LiveMarketMetricBox(
                  label: '24h Avg',
                  value: '${data.avgRatePct.toStringAsFixed(3)}%',
                  color: liveMarketGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Range',
                  value: '${data.rangePct.toStringAsFixed(3)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Container(
            height: 67,
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
            decoration: BoxDecoration(
              color: liveMarketPanel2,
              borderRadius: AppRadii.cardRadius,
            ),
            child: CustomPaint(
              painter: LiveMarketLinePainter(values: data.historyPct),
            ),
          ),
          const SizedBox(height: 12),
          const LiveMarketInfoStrip(),
        ],
      ),
    );
  }
}
