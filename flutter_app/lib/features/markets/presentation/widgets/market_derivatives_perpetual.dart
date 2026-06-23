import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_derivatives_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketDerivativesSortChips extends StatelessWidget {
  const MarketDerivativesSortChips({
    super.key,
    required this.active,
    required this.onSelected,
  });

  final MarketDerivativesSort active;
  final ValueChanged<MarketDerivativesSort> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final sort in MarketDerivativesSort.values) ...[
            _SortChip(
              key: MarketDerivativesKeys.sort(sort),
              sort: sort,
              active: active == sort,
              onTap: () => onSelected(sort),
            ),
            const SizedBox(width: AppSpacing.marketDerivativesSortGap),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    super.key,
    required this.sort,
    required this.active,
    required this.onTap,
  });

  final MarketDerivativesSort sort;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: marketDerivativesSortLabel(sort),
      selected: active,
      onTap: onTap,
      accentColor: marketDerivativesPrimary,
    );
  }
}

class MarketDerivativesPerpetualPairCard extends StatelessWidget {
  const MarketDerivativesPerpetualPairCard({super.key, required this.pair});

  final DerivativePair pair;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.marketDerivativesPairCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              MarketDerivativesPairLogo(
                pair: pair,
                size: AppSpacing.marketDerivativesPairAvatarMd,
              ),
              const SizedBox(width: AppSpacing.marketDerivativesPairGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pair.symbol,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(
                          width: AppSpacing.marketDerivativesLeverageGap,
                        ),
                        MarketDerivativesTinyPill('${pair.maxLeverage}x'),
                      ],
                    ),
                    Text(
                      'Perpetual',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${marketDerivativesFormatPrice(pair.price)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    marketDerivativesFormatSignedPercent(pair.change24h),
                    style: AppTextStyles.micro.copyWith(
                      color: pair.change24h >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.marketDerivativesPerpetualMetaGap),
          Row(
            children: [
              Expanded(
                child: MarketDerivativesMetric(
                  label: 'OI',
                  value: marketDerivativesFormatCompact(
                    pair.openInterest,
                    prefix: r'$',
                  ),
                ),
              ),
              Expanded(
                child: MarketDerivativesMetric(
                  label: 'Volume 24h',
                  value: marketDerivativesFormatCompact(
                    pair.volume24h,
                    prefix: r'$',
                  ),
                ),
              ),
              Expanded(
                child: MarketDerivativesMetric(
                  label: 'Funding',
                  value: '${(pair.fundingRate * 100).toStringAsFixed(4)}%',
                  color: pair.fundingRate >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.marketDerivativesPerpetualSplitGap),
          MarketDerivativesSplitBar(
            leftPercent: pair.longRatio,
            leftLabel: 'Long ${pair.longRatio.toStringAsFixed(1)}%',
            rightLabel: 'Short ${pair.shortRatio.toStringAsFixed(1)}%',
          ),
        ],
      ),
    );
  }
}
