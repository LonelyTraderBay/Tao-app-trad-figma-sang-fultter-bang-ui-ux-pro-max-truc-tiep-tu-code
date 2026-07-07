import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/market_icon_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_sector_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

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
      padding: MarketsSpacingTokens.marketSectorCardPadding,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Material(
                color: sector.color.resolve().withValues(alpha: 0.16),
                shape: const CircleBorder(),
                child: SizedBox.square(
                  dimension: MarketsSpacingTokens.marketSectorCardIcon,
                  child: Icon(
                    MarketIconTokens.icon(sector.icon),
                    color: sector.color.resolve(),
                    size: MarketsSpacingTokens.marketSectorCardIconGlyph,
                  ),
                ),
              ),
              const SizedBox(
                width: MarketsSpacingTokens.marketSectorCardHeaderGap,
              ),
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
                        height:
                            MarketsSpacingTokens.marketSectorLineHeightTitle,
                      ),
                    ),
                    const SizedBox(
                      height: MarketsSpacingTokens.marketSectorTitleGap,
                    ),
                    Text(
                      '${sector.coinCount} coins',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height:
                            MarketsSpacingTokens.marketSectorLineHeightTight,
                      ),
                    ),
                  ],
                ),
              ),
              MarketSectorChangePill(value: change),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _SectorMetric(
                  label: 'Vốn hóa',
                  value: formatMarketSectorBillions(sector.totalMarketCap),
                ),
              ),
              const SizedBox(width: MarketsSpacingTokens.marketSectorMetricGap),
              Expanded(
                child: _SectorMetric(
                  label: 'KL 24h',
                  value: formatMarketSectorBillions(sector.volume24h),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: MarketsSpacingTokens.marketSectorMetricGap),
          MarketSectorDominanceBar(sector: sector),
          const SizedBox(
            height: MarketsSpacingTokens.marketSectorCardHeaderGap,
          ),
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
    return VitMetricDeltaPill(
      label: formatMarketSectorPercent(value),
      tone: positive
          ? VitMetricDeltaTone.positive
          : VitMetricDeltaTone.negative,
      icon: positive
          ? Icons.arrow_upward_rounded
          : Icons.arrow_downward_rounded,
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
        LinearProgressIndicator(
          value: widthFactor,
          minHeight: MarketsSpacingTokens.marketSectorDominanceHeight,
          borderRadius: AppRadii.pillRadius,
          backgroundColor: AppColors.surface3,
          color: sector.color.resolve(),
        ),
        const SizedBox(
          height: MarketsSpacingTokens.marketSectorDominanceLabelGap,
        ),
        Text(
          '${formatMarketSectorDominance(sector.dominance)}% dominance',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: MarketsSpacingTokens.marketSectorLineHeightTight,
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
        const SizedBox(width: MarketsSpacingTokens.marketSectorMetricInlineGap),
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
              height: MarketsSpacingTokens.marketSectorLineHeightTight,
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
      spacing: MarketsSpacingTokens.marketSectorChipGap,
      runSpacing: MarketsSpacingTokens.marketSectorChipGap,
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
    return VitAccentPill(label: label, accentColor: AppColors.text2);
  }
}
