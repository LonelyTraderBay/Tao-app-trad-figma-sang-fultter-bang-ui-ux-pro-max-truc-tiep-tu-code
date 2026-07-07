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
          const SizedBox(height: AppSpacing.liveMarketCardGap),
          LiveMarketCard(
            variant: VitCardVariant.ghost,
            borderColor: AppColors.transparent,
            height: AppSpacing.liveMarketFundingCountdownHeight,
            padding: AppSpacing.liveMarketFundingCountdownPadding,
            background: const ColoredBox(color: liveMarketSurface3),
            child: Row(
              children: [
                Text(
                  'Next funding in',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                  ),
                ),
                const Spacer(),
                Text(
                  data.nextFundingLabel,
                  style: AppTextStyles.amountSm.copyWith(
                    color: liveMarketPrimary,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.liveMarketCardGap),
          Row(
            children: [
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Current',
                  value: '+${data.currentRatePct.toStringAsFixed(3)}%',
                  color: liveMarketRed,
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              Expanded(
                child: LiveMarketMetricBox(
                  label: '24h Avg',
                  value: '${data.avgRatePct.toStringAsFixed(3)}%',
                  color: liveMarketGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Range',
                  value: '${data.rangePct.toStringAsFixed(3)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.liveMarketCardGap),
          LiveMarketCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.transparent,
            height: AppSpacing.liveMarketFundingChartHeight,
            padding: AppSpacing.liveMarketFundingChartPadding,
            child: CustomPaint(
              painter: LiveMarketLinePainter(values: data.historyPct),
            ),
          ),
          const SizedBox(height: AppSpacing.liveMarketCardGap),
          const LiveMarketInfoStrip(),
        ],
      ),
    );
  }
}
