import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';

const marketDerivativesPrimary = AppColors.primary;

final class MarketDerivativesKeys {
  const MarketDerivativesKeys._();

  static const content = Key('sc018_derivatives_scroll_content');
  static const overviewTab = Key('sc018_tab_overview');
  static const perpetualTab = Key('sc018_tab_perpetual');
  static const liquidationTab = Key('sc018_tab_liquidation');

  static Key sort(MarketDerivativesSort sort) => Key('sc018_sort_${sort.name}');
}

class MarketDerivativesSplitBar extends StatelessWidget {
  const MarketDerivativesSplitBar({
    super.key,
    required this.leftPercent,
    required this.leftLabel,
    required this.rightLabel,
    this.compact = false,
  });

  final double leftPercent;
  final String leftLabel;
  final String rightLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final rightPercent = 100 - leftPercent;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: (leftPercent * 10).round(),
              child: Container(
                height: compact ? 4 : 6,
                decoration: const BoxDecoration(
                  color: AppColors.buy,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(4),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: (rightPercent * 10).round(),
              child: Container(
                height: compact ? 4 : 6,
                decoration: const BoxDecoration(
                  color: AppColors.sell,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                leftLabel,
                style: AppTextStyles.micro.copyWith(color: AppColors.buy),
              ),
            ),
            Text(
              rightLabel,
              style: AppTextStyles.micro.copyWith(color: AppColors.sell),
            ),
          ],
        ),
      ],
    );
  }
}

class MarketDerivativesMetric extends StatelessWidget {
  const MarketDerivativesMetric({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class MarketDerivativesTinyPill extends StatelessWidget {
  const MarketDerivativesTinyPill(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class MarketDerivativesPairLogo extends StatelessWidget {
  const MarketDerivativesPairLogo({
    super.key,
    required this.pair,
    required this.size,
  });

  final DerivativePair pair;
  final double size;

  @override
  Widget build(BuildContext context) {
    final base = pair.symbol.split('/').first;
    final labelStyle = size <= 30
        ? AppTextStyles.micro
        : AppTextStyles.captionSm;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.color.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Text(
        base.length <= 2 ? base : base.substring(0, 2),
        style: labelStyle.copyWith(
          color: pair.color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String marketDerivativesSortLabel(MarketDerivativesSort sort) {
  return switch (sort) {
    MarketDerivativesSort.openInterest => 'OI',
    MarketDerivativesSort.volume => 'Volume',
    MarketDerivativesSort.funding => 'Funding',
    MarketDerivativesSort.change => 'Thay đổi',
  };
}

String marketDerivativesFormatSignedPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String marketDerivativesFormatCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${_trimFixed(value / 1000000000, 2)}B';
  }
  if (value >= 1000000) {
    return '$prefix${_trimFixed(value / 1000000, 2)}M';
  }
  if (value >= 1000) {
    return '$prefix${_trimFixed(value / 1000, 2)}K';
  }
  return '$prefix${_trimFixed(value, 2)}';
}

String marketDerivativesFormatPrice(double value) {
  if (value >= 1000) return _formatNumber(value, 2);
  if (value >= 1) return _formatNumber(value, 2);
  return _formatNumber(value, 4);
}

String _trimFixed(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}

String _formatNumber(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length == 1) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}
