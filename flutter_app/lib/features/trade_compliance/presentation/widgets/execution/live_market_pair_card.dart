import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/execution/live_market_common_widgets.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

class LiveMarketPairCard extends StatelessWidget {
  const LiveMarketPairCard({super.key, required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    // Page-hero outer (Trade Redesign V2 §2 radius tier): this is the
    // page's primary pair/price surface (like VitTradeInstrumentHero
    // elsewhere), so it keeps the larger `.standard` radius while every
    // other regular card on this page normalizes to `.tight`.
    return LiveMarketCard(
      radius: VitCardRadius.standard,
      height: MarketsSpacingTokens.liveMarketPairCardHeight,
      padding: MarketsSpacingTokens.liveMarketPairCardPadding,
      borderColor: liveMarketGreen.withValues(alpha: .22),
      background: ColoredBox(color: liveMarketGreen.withValues(alpha: .08)),
      child: Column(
        children: [
          const Row(
            children: [
              LiveMarketLiveDot(),
              Spacer(),
              LiveMarketChip(label: 'WebSocket Active', color: liveMarketGreen),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _PairValue(
                  label: 'Analyzing',
                  value: snapshot.selectedPair,
                ),
              ),
              _PairValue(
                label: 'Mark Price',
                value: '\$${formatLiveMarketMoney(snapshot.markPrice)}',
                color: liveMarketGreen,
                alignRight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PairValue extends StatelessWidget {
  const _PairValue({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.alignRight = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: MarketsSpacingTokens.liveMarketPairValueGap),
        Text(
          value,
          style: AppTextStyles.sectionTitleSm.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
