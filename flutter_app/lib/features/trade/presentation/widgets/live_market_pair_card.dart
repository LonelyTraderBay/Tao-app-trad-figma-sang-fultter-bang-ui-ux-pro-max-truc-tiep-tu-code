import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_common_widgets.dart';

class LiveMarketPairCard extends StatelessWidget {
  const LiveMarketPairCard({super.key, required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 119,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            liveMarketGreen.withValues(alpha: .08),
            liveMarketPrimary.withValues(alpha: .08),
          ],
        ),
        border: Border.all(
          color: liveMarketGreen.withValues(alpha: .22),
          width: 1.5,
        ),
        borderRadius: AppRadii.cardRadius,
      ),
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
                monospace: true,
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
    this.monospace = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool alignRight;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
            height: 1,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontSize: 20,
            fontWeight: AppTextStyles.bold,
            fontFamily: monospace ? 'monospace' : null,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}
