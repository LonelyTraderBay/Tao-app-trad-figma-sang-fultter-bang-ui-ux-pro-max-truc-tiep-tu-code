import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_sector_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketSectorCard extends StatelessWidget {
  const MarketSectorCard({
    required this.sector,
    required this.change,
    required this.onTap,
    super.key,
  });

  final MarketSector sector;
  final double change;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: marketSectorKey(sector.id),
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: sector.color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(sector.icon, color: sector.color, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sector.nameVi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sector.coinCount} coins',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              MarketSectorChangePill(value: change),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SectorMetric(
                  label: 'Vốn hóa',
                  value: formatMarketSectorBillions(sector.totalMarketCap),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SectorMetric(
                  label: 'KL 24h',
                  value: formatMarketSectorBillions(sector.volume24h),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          MarketSectorDominanceBar(sector: sector),
          const SizedBox(height: 12),
          _TopCoinChips(symbols: sector.topCoins),
        ],
      ),
    );
  }
}

class MarketSectorChangePill extends StatelessWidget {
  const MarketSectorChangePill({required this.value, super.key});

  final double value;

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.28)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            formatMarketSectorPercent(value),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class MarketSectorDominanceBar extends StatelessWidget {
  const MarketSectorDominanceBar({required this.sector, super.key});

  final MarketSector sector;

  @override
  Widget build(BuildContext context) {
    final widthFactor = math.min(1.0, sector.dominance * 3 / 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: widthFactor,
                  child: ColoredBox(color: sector.color),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${formatMarketSectorDominance(sector.dominance)}% dominance',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SectorMetric extends StatelessWidget {
  const _SectorMetric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignEnd
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignEnd ? TextAlign.right : TextAlign.left,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopCoinChips extends StatelessWidget {
  const _TopCoinChips({required this.symbols});

  final List<String> symbols;

  @override
  Widget build(BuildContext context) {
    final visible = symbols.take(4).toList();
    final remaining = math.max(0, symbols.length - visible.length);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final symbol in visible) _CoinChip(label: symbol),
        if (remaining > 0) _CoinChip(label: '+$remaining'),
      ],
    );
  }
}

class _CoinChip extends StatelessWidget {
  const _CoinChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSolid),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text2,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}
