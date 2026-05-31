import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_sector_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketSectorDistributionCard extends StatelessWidget {
  const MarketSectorDistributionCard({required this.sectors, super.key});

  final List<MarketSector> sectors;

  @override
  Widget build(BuildContext context) {
    final total = sectors.fold<double>(
      0,
      (sum, sector) => sum + sector.totalMarketCap,
    );
    final visible = sectors
        .where((sector) => _allocation(sector, total) >= 1)
        .toList();

    return VitCard(
      height: 132,
      padding: const EdgeInsets.all(16),
      borderColor: marketSectorAccent.withValues(alpha: 0.20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: marketSectorAccent.withValues(alpha: 0.16),
                  borderRadius: AppRadii.smRadius,
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  color: marketSectorAccent,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Phân bổ vốn hóa theo ngành',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 12,
              color: AppColors.surface3,
              child: Row(
                children: [
                  for (final sector in visible)
                    Expanded(
                      flex: math.max(
                        1,
                        (_allocation(sector, total) * 10).round(),
                      ),
                      child: Container(color: sector.color),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                for (final sector in visible)
                  _LegendItem(
                    color: sector.color,
                    label:
                        '${sector.nameVi} ${_allocation(sector, total).toStringAsFixed(1)}%',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _allocation(MarketSector sector, double total) {
    if (total <= 0) return 0;
    return sector.totalMarketCap / total * 100;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}
