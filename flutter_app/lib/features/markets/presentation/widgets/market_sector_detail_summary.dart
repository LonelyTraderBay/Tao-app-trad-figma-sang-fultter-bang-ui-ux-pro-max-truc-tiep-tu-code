import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/market_icon_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_sector_card.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_sector_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_sector_comparison_table.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketSectorDetailSummary extends StatelessWidget {
  const MarketSectorDetailSummary({required this.sector, super.key});

  final MarketSector sector;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.marketSectorCardPadding,
      borderColor: sector.color.resolve().withValues(alpha: 0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Material(
                color: sector.color.resolve().withValues(alpha: 0.16),
                shape: const CircleBorder(),
                child: SizedBox.square(
                  dimension: AppSpacing.marketSectorDetailIcon,
                  child: Icon(
                    MarketIconTokens.icon(sector.icon),
                    color: sector.color.resolve(),
                    size: AppSpacing.marketSectorDetailIconGlyph,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.marketSectorCardHeaderGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sector.nameVi,
                      style: AppTextStyles.baseMedium.copyWith(
                        height: AppSpacing.marketSectorLineHeightTitle,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.marketSectorTitleGap),
                    Text(
                      '${sector.coinCount} coins · ${formatMarketSectorDominance(sector.dominance)}% dominance',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: AppSpacing.marketSectorLineHeightTight,
                      ),
                    ),
                  ],
                ),
              ),
              MarketSectorChangePill(value: sector.change24h),
            ],
          ),
          const SizedBox(height: AppSpacing.marketSectorCardSectionGap),
          Row(
            children: [
              Expanded(
                child: _DetailMetric(
                  label: 'Vốn hóa',
                  value: formatMarketSectorBillions(sector.totalMarketCap),
                ),
              ),
              const SizedBox(width: AppSpacing.marketSectorControlGroupGap),
              Expanded(
                child: _DetailMetric(
                  label: 'KL 24h',
                  value: formatMarketSectorBillions(sector.volume24h),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.marketSectorMetricGap),
          MarketSectorDominanceBar(sector: sector),
        ],
      ),
    );
  }
}

class MarketSectorTopCoinsSection extends StatelessWidget {
  const MarketSectorTopCoinsSection({
    required this.sector,
    required this.coins,
    required this.onTap,
    super.key,
  });

  final MarketSector sector;
  final List<MarketSectorCoin> coins;
  final ValueChanged<MarketSectorCoin> onTap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Coin nổi bật',
      accentColor: sector.color.resolve(),
      children: [
        VitCard(
          padding: AppSpacing.marketSectorTopCoinsPadding,
          child: Column(
            children: [
              for (final coin in coins) ...[
                _TopCoinRow(coin: coin, onTap: () => onTap(coin)),
                if (coin != coins.last) const TableDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.marketSectorDetailMetricPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.marketSectorLegendGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopCoinRow extends StatelessWidget {
  const _TopCoinRow({required this.coin, required this.onTap});

  final MarketSectorCoin coin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: SizedBox(
        height: AppSpacing.marketSectorTopCoinRowHeight,
        child: Row(
          children: [
            VitAssetAvatar(
              label: coin.symbol,
              accentColor: coin.color,
              size: AppSpacing.marketSectorTopCoinAvatar,
              radius: AppRadii.avatarRadius,
            ),
            const SizedBox(width: AppSpacing.marketSectorControlGroupGap),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: AppSpacing.marketSectorLineHeightCompact,
                    ),
                  ),
                  Text(
                    coin.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppSpacing.marketSectorLineHeightCompact,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              coin.priceLabel,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(width: AppSpacing.marketSectorTopCoinPriceGap),
            MarketSectorChangePill(value: coin.change24h),
          ],
        ),
      ),
    );
  }
}
