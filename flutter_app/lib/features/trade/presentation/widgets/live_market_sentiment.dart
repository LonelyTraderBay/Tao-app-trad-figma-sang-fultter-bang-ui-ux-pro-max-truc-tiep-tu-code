import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_common_widgets.dart';

class LiveMarketSentimentTab extends StatelessWidget {
  const LiveMarketSentimentTab({required this.snapshot, super.key});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LiveMarketCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LiveMarketCardHeader(
                icon: Icons.psychology_outlined,
                color: liveMarketPurple,
                title: 'Market Sentiment',
              ),
              const SizedBox(height: 14),
              Text(
                '${snapshot.sentiment.score}',
                textAlign: TextAlign.center,
                style: AppTextStyles.heroNumber.copyWith(
                  color: liveMarketAmber,
                  fontSize: 42,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LiveMarketCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Live Data Sources',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: 12),
              for (final item in const [
                'Open Interest',
                'Long/Short Ratio',
                'Top Traders',
                'Funding Rate',
                'Liquidations',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _SourceRow(label: item),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: liveMarketPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const LiveMarketLiveDot(),
        ],
      ),
    );
  }
}
