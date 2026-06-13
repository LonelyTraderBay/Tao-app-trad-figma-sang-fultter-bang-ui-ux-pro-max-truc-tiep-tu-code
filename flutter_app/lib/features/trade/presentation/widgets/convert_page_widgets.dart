import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

class ConvertHistoryRow extends StatelessWidget {
  const ConvertHistoryRow({
    super.key,
    required this.record,
    required this.showDivider,
  });

  final TradeConvertHistoryRecord record;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.buy.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.swap_vert_rounded,
              color: AppColors.buy,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${formatConvertHistoryAmount(record.fromAmount, record.fromSymbol)} ${record.fromSymbol} → ${formatConvertHistoryAmount(record.toAmount, record.toSymbol)} ${record.toSymbol}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${record.timeLabel}  ·  Phí: \$${record.feeUsd.toStringAsFixed(record.feeUsd < 1 ? 4 : 2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.buy.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Text(
              record.status,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class ConvertAssetSheet extends StatelessWidget {
  const ConvertAssetSheet({
    super.key,
    required this.side,
    required this.assets,
    required this.selectedSymbol,
    required this.excludedSymbol,
    required this.optionKeyBuilder,
  });

  final String side;
  final List<TradeConvertAsset> assets;
  final String selectedSymbol;
  final String excludedSymbol;
  final Key Function(String side, String symbol) optionKeyBuilder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 620),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSolid,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Row(
                children: [
                  Text('Chọn tài sản', style: AppTextStyles.sectionTitleSm),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  final disabled = asset.symbol == excludedSymbol;
                  final selected = asset.symbol == selectedSymbol;
                  return ListTile(
                    key: optionKeyBuilder(side, asset.symbol),
                    enabled: !disabled,
                    onTap: disabled
                        ? null
                        : () => Navigator.of(context).pop(asset.symbol),
                    leading: CircleAvatar(
                      backgroundColor: Color(
                        asset.colorHex,
                      ).withValues(alpha: .18),
                      child: Text(
                        asset.symbol.substring(
                          0,
                          math.min(3, asset.symbol.length),
                        ),
                        style: AppTextStyles.micro.copyWith(
                          color: Color(asset.colorHex),
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    title: Text(asset.symbol, style: AppTextStyles.baseMedium),
                    subtitle: Text(asset.name, style: AppTextStyles.caption),
                    trailing: selected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          )
                        : Text(
                            formatConvertBalance(asset.balance, asset.symbol),
                            style: AppTextStyles.caption.copyWith(
                              color: disabled
                                  ? AppColors.text3.withValues(alpha: .55)
                                  : AppColors.text2,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatConvertInputAmount(double value) {
  if (value >= 1000) return value.toStringAsFixed(2);
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}

String formatConvertBalance(double value, String symbol) {
  final decimals = value < 1 || symbol == 'BTC' ? 6 : 2;
  return _groupNumber(value.toStringAsFixed(decimals));
}

String formatConvertQuoteAmount(double value, String symbol) {
  if (value <= 0) return '0.00';
  final decimals = symbol == 'BTC'
      ? 6
      : value >= 100
      ? 2
      : 4;
  return _groupNumber(value.toStringAsFixed(decimals));
}

String formatConvertHistoryAmount(double value, String symbol) {
  final decimals = symbol == 'BTC' ? 6 : 4;
  return _groupNumber(value.toStringAsFixed(decimals));
}

String _groupNumber(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final left = whole.length - i;
    buffer.write(whole[i]);
    if (left > 1 && left % 3 == 1) buffer.write(',');
  }
  if (parts.length == 1) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}
