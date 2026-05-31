import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_common_widgets.dart';

class LiveMarketLiquidationsTab extends StatelessWidget {
  const LiveMarketLiquidationsTab({required this.snapshot, super.key});

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
                icon: Icons.flash_on_rounded,
                color: liveMarketAmber,
                title: 'Liquidation Stats',
                badge: 'Live',
              ),
              const SizedBox(height: 12),
              LiveMarketMetricBox(
                label: '24h Total',
                value: formatLiveMarketCompactUsd(
                  snapshot.liquidationStats.total24h,
                ),
                color: AppColors.text1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LiveMarketCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LiveMarketCardHeader(
                icon: Icons.history_rounded,
                color: liveMarketPrimary,
                title: 'Recent Liquidations',
                badge: 'Real-time',
              ),
              const SizedBox(height: 12),
              for (final liquidation in snapshot.recentLiquidations) ...[
                _LiquidationRow(liquidation: liquidation),
                if (liquidation != snapshot.recentLiquidations.last)
                  const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LiquidationRow extends StatelessWidget {
  const _LiquidationRow({required this.liquidation});

  final TradeRecentLiquidation liquidation;

  @override
  Widget build(BuildContext context) {
    final color = liquidation.side == 'long' ? liveMarketGreen : liveMarketRed;
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: liveMarketPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          LiveMarketChip(label: liquidation.side.toUpperCase(), color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              liquidation.pair,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            formatLiveMarketCompactUsd(liquidation.size),
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
