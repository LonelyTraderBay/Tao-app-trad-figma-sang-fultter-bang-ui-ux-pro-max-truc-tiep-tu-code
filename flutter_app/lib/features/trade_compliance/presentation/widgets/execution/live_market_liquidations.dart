import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/execution/live_market_common_widgets.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

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
              const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
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
        const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
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
              const SizedBox(height: MarketsSpacingTokens.liveMarketCardGap),
              for (final liquidation in snapshot.recentLiquidations) ...[
                _LiquidationRow(liquidation: liquidation),
                if (liquidation != snapshot.recentLiquidations.last)
                  const SizedBox(height: AppSpacing.rowGap),
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
    return LiveMarketCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: AppColors.transparent,
      padding: MarketsSpacingTokens.liveMarketRowPadding,
      child: Row(
        children: [
          LiveMarketChip(label: liquidation.side.toUpperCase(), color: color),
          const SizedBox(width: AppSpacing.statusPillHorizontalPaddingMd),
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
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
