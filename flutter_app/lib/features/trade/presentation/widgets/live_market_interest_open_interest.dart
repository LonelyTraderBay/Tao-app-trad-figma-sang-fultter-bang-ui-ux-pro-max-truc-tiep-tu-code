part of 'live_market_interest_cards.dart';

class _OpenInterestCard extends StatelessWidget {
  const _OpenInterestCard({required this.data});

  final TradeMarketOpenInterest data;

  @override
  Widget build(BuildContext context) {
    final positive = data.change24hPct >= 0;
    final tone = positive ? liveMarketGreen : liveMarketRed;
    return LiveMarketCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LiveMarketCardHeader(
            icon: Icons.show_chart_rounded,
            color: liveMarketPrimary,
            title: 'Open Interest',
            trailing: 'BTC/USDT >',
          ),
          const SizedBox(height: AppSpacing.sectionGapCompact),
          const LiveMarketMutedLabel('Total Open Interest'),
          const SizedBox(height: AppSpacing.liveMarketCardGap),
          Row(
            children: [
              Text(
                formatLiveMarketMillions(data.current),
                style: AppTextStyles.numericDisplayMd.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              LiveMarketChip(
                label:
                    '${positive ? '+' : ''}${data.change24hPct.toStringAsFixed(2)}%',
                color: tone,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGapCompact),
          Row(
            children: [
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Change 24h',
                  value:
                      '${positive ? '+' : ''}${formatLiveMarketMillions(data.change24h)}',
                  color: tone,
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'High 24h',
                  value: formatLiveMarketMillions(data.high24h),
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Low 24h',
                  value: formatLiveMarketMillions(data.low24h),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.liveMarketCardGap),
          const LiveMarketInfoStrip(),
        ],
      ),
    );
  }
}
