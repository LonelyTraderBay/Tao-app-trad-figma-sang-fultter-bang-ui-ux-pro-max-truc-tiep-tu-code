import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
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
      padding: const EdgeInsets.all(16),
      borderColor: sector.color.withValues(alpha: 0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: sector.color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(sector.icon, color: sector.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sector.nameVi,
                      style: AppTextStyles.baseMedium.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sector.coinCount} coins · ${formatMarketSectorDominance(sector.dominance)}% dominance',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              MarketSectorChangePill(value: sector.change24h),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _DetailMetric(
                  label: 'Vốn hóa',
                  value: formatMarketSectorBillions(sector.totalMarketCap),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DetailMetric(
                  label: 'KL 24h',
                  value: formatMarketSectorBillions(sector.volume24h),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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
      accentColor: sector.color,
      children: [
        VitCard(
          padding: const EdgeInsets.all(12),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: 5),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: coin.color.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Text(
                coin.symbol.characters.first,
                style: AppTextStyles.micro.copyWith(
                  color: coin.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                      height: 1.1,
                    ),
                  ),
                  Text(
                    coin.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.1,
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
            const SizedBox(width: 10),
            MarketSectorChangePill(value: coin.change24h),
          ],
        ),
      ),
    );
  }
}
