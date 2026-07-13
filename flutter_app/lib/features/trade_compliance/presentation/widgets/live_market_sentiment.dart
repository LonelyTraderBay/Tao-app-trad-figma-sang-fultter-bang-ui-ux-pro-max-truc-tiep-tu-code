import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/live_market_common_widgets.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

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
              const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
              Text(
                '${snapshot.sentiment.score}',
                textAlign: TextAlign.center,
                style: AppTextStyles.numericDisplayHero.copyWith(
                  color: liveMarketAmber,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
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
              const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
              for (final indexed in const [
                'Open Interest',
                'Long/Short Ratio',
                'Top Traders',
                'Funding Rate',
                'Liquidations',
              ].indexed) ...[
                _SourceRow(label: indexed.$2),
                if (indexed.$1 < 4) const SizedBox(height: AppSpacing.rowGap),
              ],
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
    return LiveMarketCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: AppColors.transparent,
      padding: MarketsSpacingTokens.liveMarketRowPadding,
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
