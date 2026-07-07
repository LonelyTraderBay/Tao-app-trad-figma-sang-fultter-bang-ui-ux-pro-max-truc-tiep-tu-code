import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_derivatives_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketDerivativesLiquidationSummary extends StatelessWidget {
  const MarketDerivativesLiquidationSummary({super.key, required this.stats});

  final DerivativesGlobalStats stats;

  @override
  Widget build(BuildContext context) {
    final longPercent =
        stats.longLiquidations24h / stats.totalLiquidations24h * 100;
    return VitCard(
      width: double.infinity,
      padding: MarketsSpacingTokens.marketDerivativesLiquidationSummaryPadding,
      borderColor: AppColors.sell20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng thanh lý 24h',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(
            height: MarketsSpacingTokens.marketDerivativesSummaryLabelGap,
          ),
          Text(
            marketDerivativesFormatCompact(
              stats.totalLiquidations24h,
              prefix: r'$',
            ),
            style: AppTextStyles.amountMd,
          ),
          const SizedBox(
            height: MarketsSpacingTokens.marketDerivativesSummarySplitGap,
          ),
          MarketDerivativesSplitBar(
            leftPercent: longPercent,
            leftLabel:
                'Long ${marketDerivativesFormatCompact(stats.longLiquidations24h, prefix: r'$')}',
            rightLabel:
                'Short ${marketDerivativesFormatCompact(stats.shortLiquidations24h, prefix: r'$')}',
          ),
        ],
      ),
    );
  }
}

class MarketDerivativesLiquidationPairCard extends StatelessWidget {
  const MarketDerivativesLiquidationPairCard({super.key, required this.pair});

  final DerivativePair pair;

  @override
  Widget build(BuildContext context) {
    final longPercent =
        pair.longLiquidations24h / pair.totalLiquidations24h * 100;
    return VitCard(
      padding: MarketsSpacingTokens.marketDerivativesPairCardPadding,
      child: Row(
        children: [
          MarketDerivativesPairLogo(
            pair: pair,
            size: MarketsSpacingTokens.marketDerivativesPairAvatarSm,
          ),
          const SizedBox(width: MarketsSpacingTokens.marketDerivativesPairGap),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      pair.symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      marketDerivativesFormatCompact(
                        pair.totalLiquidations24h,
                        prefix: r'$',
                      ),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height:
                      MarketsSpacingTokens.marketDerivativesLiquidationRowGap,
                ),
                MarketDerivativesSplitBar(
                  leftPercent: longPercent,
                  leftLabel:
                      'L: ${marketDerivativesFormatCompact(pair.longLiquidations24h, prefix: r'$')}',
                  rightLabel:
                      'S: ${marketDerivativesFormatCompact(pair.shortLiquidations24h, prefix: r'$')}',
                  compact: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarketDerivativesRiskWarningCard extends StatelessWidget {
  const MarketDerivativesRiskWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: MarketsSpacingTokens.marketDerivativesRiskPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: MarketsSpacingTokens.marketDerivativesRiskIcon,
          ),
          const SizedBox(
            width: MarketsSpacingTokens.marketDerivativesRiskIconGap,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo rủi ro',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(
                  height: MarketsSpacingTokens.marketDerivativesRiskTitleGap,
                ),
                Text(
                  'Giao dịch phái sinh có rủi ro cao. Đòn bẩy khuếch đại cả lãi lẫn lỗ.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height:
                        MarketsSpacingTokens.marketDerivativesRiskLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
