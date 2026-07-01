import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_hero_glow.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_metric_delta_pill.dart';

/// Compact one-line ticker for Bybit-style trade terminals.
class VitTradeTickerStrip extends StatelessWidget {
  const VitTradeTickerStrip({
    super.key,
    required this.symbol,
    required this.priceLabel,
    required this.changePct,
    this.highLabel,
    this.lowLabel,
    this.volumeLabel,
    this.trailing,
  });

  final String symbol;
  final String priceLabel;
  final double changePct;
  final String? highLabel;
  final String? lowLabel;
  final String? volumeLabel;
  final Widget? trailing;

  Color get _priceColor {
    if (changePct > 0) return AppColors.buy;
    if (changePct < 0) return AppColors.sell;
    return AppColors.text1;
  }

  @override
  Widget build(BuildContext context) {
    final deltaLabel =
        '${changePct >= 0 ? '+' : ''}${changePct.toStringAsFixed(2)}%';
    final deltaColor =
        changePct > 0
            ? AppColors.buy
            : changePct < 0
            ? AppColors.sell
            : AppColors.text2;

    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symbol,
                      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            priceLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: _priceColor,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          deltaLabel,
                          style: AppTextStyles.caption.copyWith(
                            color: deltaColor,
                            fontFeatures: AppTextStyles.tabularFigures,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (highLabel != null || lowLabel != null || volumeLabel != null) ...[
            const SizedBox(height: AppSpacing.x2),
            Row(
              children: [
                if (highLabel != null)
                  Expanded(child: _MetricCell(label: 'Cao', value: highLabel!)),
                if (lowLabel != null)
                  Expanded(child: _MetricCell(label: 'Thấp', value: lowLabel!)),
                if (volumeLabel != null)
                  Expanded(
                    child: _MetricCell(label: 'KL 24h', value: volumeLabel!),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class VitTradeInstrumentHero extends StatelessWidget {
  const VitTradeInstrumentHero({
    super.key,
    required this.symbol,
    required this.priceLabel,
    required this.changePct,
    this.highLabel,
    this.lowLabel,
    this.volumeLabel,
  });

  final String symbol;
  final String priceLabel;
  final double changePct;
  final String? highLabel;
  final String? lowLabel;
  final String? volumeLabel;

  VitMetricDeltaTone get _deltaTone {
    if (changePct > 0) return VitMetricDeltaTone.positive;
    if (changePct < 0) return VitMetricDeltaTone.negative;
    return VitMetricDeltaTone.neutral;
  }

  Color get _priceColor {
    if (changePct > 0) return AppColors.buy;
    if (changePct < 0) return AppColors.sell;
    return AppColors.text1;
  }

  @override
  Widget build(BuildContext context) {
    final deltaLabel =
        '${changePct >= 0 ? '+' : ''}${changePct.toStringAsFixed(2)}%';

    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: AppSpacing.tradeInstrumentHeroPadding,
      background: const VitHeroGlow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            symbol,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  priceLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heroNumber.copyWith(
                    color: _priceColor,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              VitMetricDeltaPill(label: deltaLabel, tone: _deltaTone),
            ],
          ),
          if (highLabel != null || lowLabel != null || volumeLabel != null) ...[
            const SizedBox(height: AppSpacing.tradeInstrumentHeroMetricGap),
            Row(
              children: [
                if (highLabel != null)
                  Expanded(child: _MetricCell(label: 'Cao', value: highLabel!)),
                if (lowLabel != null)
                  Expanded(child: _MetricCell(label: 'Thấp', value: lowLabel!)),
                if (volumeLabel != null)
                  Expanded(
                    child: _MetricCell(label: 'KL 24h', value: volumeLabel!),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
