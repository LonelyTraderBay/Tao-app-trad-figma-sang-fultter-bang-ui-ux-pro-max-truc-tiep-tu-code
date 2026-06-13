import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_derivatives_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketDerivativesLiquidationSummary extends StatelessWidget {
  const MarketDerivativesLiquidationSummary({super.key, required this.stats});

  final DerivativesGlobalStats stats;

  @override
  Widget build(BuildContext context) {
    final longPercent =
        stats.longLiquidations24h / stats.totalLiquidations24h * 100;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.sell10],
        ),
        border: Border.all(color: AppColors.sell20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng thanh lý 24h',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 8),
          Text(
            marketDerivativesFormatCompact(
              stats.totalLiquidations24h,
              prefix: r'$',
            ),
            style: AppTextStyles.amountMd,
          ),
          const SizedBox(height: 14),
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
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          MarketDerivativesPairLogo(pair: pair, size: 30),
          const SizedBox(width: 12),
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
                const SizedBox(height: 7),
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
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: 10),
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
                const SizedBox(height: 4),
                Text(
                  'Giao dịch phái sinh có rủi ro cao. Đòn bẩy khuếch đại cả lãi lẫn lỗ.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.45,
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
