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
          const SizedBox(height: 18),
          const LiveMarketMutedLabel('Total Open Interest'),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                formatLiveMarketMillions(data.current),
                style: AppTextStyles.numericDisplayMd.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              LiveMarketChip(
                label:
                    '${positive ? '+' : ''}${data.change24hPct.toStringAsFixed(2)}%',
                color: tone,
              ),
            ],
          ),
          const SizedBox(height: 18),
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
              const SizedBox(width: 8),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'High 24h',
                  value: formatLiveMarketMillions(data.high24h),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Low 24h',
                  value: formatLiveMarketMillions(data.low24h),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const LiveMarketInfoStrip(),
        ],
      ),
    );
  }
}
