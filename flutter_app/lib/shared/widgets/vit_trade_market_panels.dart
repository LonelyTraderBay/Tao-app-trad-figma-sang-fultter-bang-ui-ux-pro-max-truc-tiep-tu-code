import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Generic order-book level for shared market panels.
final class VitOrderBookLevel {
  const VitOrderBookLevel({
    required this.price,
    required this.amount,
    required this.total,
  });

  final double price;
  final double amount;
  final double total;
}

/// Generic tape print for shared trades panel.
final class VitTradesTapePrint {
  const VitTradesTapePrint({
    required this.price,
    required this.amount,
    required this.time,
    required this.isBuy,
  });

  final double price;
  final double amount;
  final String time;
  final bool isBuy;
}

enum VitOrderBookPanelDensity { standard, compact }

class VitOrderBookPanel extends StatelessWidget {
  const VitOrderBookPanel({
    super.key,
    required this.asks,
    required this.bids,
    this.title,
    this.midPriceLabel,
    this.priceDecimals = 2,
    this.amountDecimals = 3,
    this.totalDecimals = 0,
    this.density = VitOrderBookPanelDensity.standard,
    this.maxLevels,
  });

  final List<VitOrderBookLevel> asks;
  final List<VitOrderBookLevel> bids;
  final String? title;
  final String? midPriceLabel;
  final int priceDecimals;
  final int amountDecimals;
  final int totalDecimals;
  final VitOrderBookPanelDensity density;
  final int? maxLevels;

  int get _levelCap =>
      maxLevels ??
      (density == VitOrderBookPanelDensity.compact ? 5 : asks.length + bids.length);

  List<VitOrderBookLevel> get _visibleAsks {
    final cap = (_levelCap / 2).ceil();
    if (asks.length <= cap) return asks;
    return asks.sublist(asks.length - cap);
  }

  List<VitOrderBookLevel> get _visibleBids {
    final cap = _levelCap ~/ 2;
    if (bids.length <= cap) return bids;
    return bids.sublist(0, cap);
  }

  @override
  Widget build(BuildContext context) {
    final compact = density == VitOrderBookPanelDensity.compact;
    final textStyle = compact ? AppTextStyles.micro : AppTextStyles.micro;

    return VitCard(
      density: VitDensity.compact,
      padding: compact
          ? EdgeInsets.all(AppSpacing.x2)
          : AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || midPriceLabel != null)
            Padding(
              padding: AppSpacing.zeroInsets.copyWith(
                bottom: AppSpacing.x2,
              ),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  if (midPriceLabel != null)
                    Text(
                      midPriceLabel!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                ],
              ),
            ),
          _VitOrderBookHeader(textStyle: textStyle),
          for (final ask in _visibleAsks.reversed)
            _VitOrderBookRow(
              level: ask,
              color: AppColors.sell,
              priceDecimals: priceDecimals,
              amountDecimals: amountDecimals,
              totalDecimals: totalDecimals,
              textStyle: textStyle,
              rowGap: compact ? AppSpacing.x1 : AppSpacing.tradeBookRowTopGap,
            ),
          const Divider(
            color: AppColors.divider,
            height: AppSpacing.tradeBookDividerHeight,
          ),
          for (final bid in _visibleBids)
            _VitOrderBookRow(
              level: bid,
              color: AppColors.buy,
              priceDecimals: priceDecimals,
              amountDecimals: amountDecimals,
              totalDecimals: totalDecimals,
              textStyle: textStyle,
              rowGap: compact ? AppSpacing.x1 : AppSpacing.tradeBookRowTopGap,
            ),
        ],
      ),
    );
  }
}

class _VitOrderBookHeader extends StatelessWidget {
  const _VitOrderBookHeader({required this.textStyle});

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _VitOrderBookCell('Giá', color: AppColors.text3, textStyle: textStyle),
        _VitOrderBookCell('KL', textStyle: textStyle),
        _VitOrderBookCell('Tổng', alignEnd: true, textStyle: textStyle),
      ],
    );
  }
}

class _VitOrderBookRow extends StatelessWidget {
  const _VitOrderBookRow({
    required this.level,
    required this.color,
    required this.priceDecimals,
    required this.amountDecimals,
    required this.totalDecimals,
    required this.textStyle,
    required this.rowGap,
  });

  final VitOrderBookLevel level;
  final Color color;
  final int priceDecimals;
  final int amountDecimals;
  final int totalDecimals;
  final TextStyle textStyle;
  final double rowGap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.zeroInsets.copyWith(top: rowGap),
      child: Row(
        children: [
          _VitOrderBookCell(
            level.price.toStringAsFixed(priceDecimals),
            color: color,
            textStyle: textStyle,
          ),
          _VitOrderBookCell(
            level.amount.toStringAsFixed(amountDecimals),
            textStyle: textStyle,
          ),
          _VitOrderBookCell(
            level.total.toStringAsFixed(totalDecimals),
            alignEnd: true,
            textStyle: textStyle,
          ),
        ],
      ),
    );
  }
}

class _VitOrderBookCell extends StatelessWidget {
  const _VitOrderBookCell(
    this.label, {
    this.color = AppColors.text2,
    this.alignEnd = false,
    required this.textStyle,
  });

  final String label;
  final Color color;
  final bool alignEnd;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        style: textStyle.copyWith(
          color: color,
          fontFeatures: AppTextStyles.tabularFigures,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class VitTradesTapePanel extends StatelessWidget {
  const VitTradesTapePanel({
    super.key,
    required this.trades,
    this.priceDecimals = 2,
    this.amountDecimals = 3,
  });

  final List<VitTradesTapePrint> trades;
  final int priceDecimals;
  final int amountDecimals;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          for (final trade in trades)
            Padding(
              padding: AppSpacing.zeroInsets.copyWith(
                bottom: AppSpacing.tradeTapeRowBottomGap,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      trade.price.toStringAsFixed(priceDecimals),
                      style: AppTextStyles.caption.copyWith(
                        color: trade.isBuy ? AppColors.buy : AppColors.sell,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      trade.amount.toStringAsFixed(amountDecimals),
                      style: AppTextStyles.caption,
                    ),
                  ),
                  Text(trade.time, style: AppTextStyles.micro),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
