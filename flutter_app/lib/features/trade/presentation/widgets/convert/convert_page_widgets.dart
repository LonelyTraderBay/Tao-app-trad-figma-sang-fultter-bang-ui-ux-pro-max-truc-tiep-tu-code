import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

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
    return Column(
      children: [
        SizedBox(
          height: AppSpacing.buttonStandard + AppSpacing.rowGapRegular,
          child: Padding(
            padding: AppSpacing.zeroInsets.copyWith(
              left: AppSpacing.x4,
              right: AppSpacing.x4,
            ),
            child: Row(
              children: [
                // card-tile: allow-start — fixed surface, not horizontal strip tile
                const VitCard(
                  width: AppSpacing.buttonCompact,
                  height: AppSpacing.buttonCompact,
                  variant: VitCardVariant.ghost,
                  radius: VitCardRadius.tight,
                  alignment: Alignment.center,
                  borderColor: AppColors.buy20,
                  child: Icon(
                    Icons.swap_vert_rounded,
                    color: AppColors.buy,
                    size: TradeSpacingTokens.tradeReceiptFooterIcon,
                  ),
                ),
                const SizedBox(width: AppSpacing.rowGapRegular),
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
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: AppColors.text3,
                            size: AppSpacing.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.x1),
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
                const SizedBox(width: AppSpacing.rowGap),
                VitAccentPill(label: record.status, accentColor: AppColors.buy),
                const SizedBox(width: AppSpacing.x2),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
      ],
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
    return VitSheetPanel(
      title: side == 'from' ? 'Chọn tài sản gửi' : 'Chọn tài sản nhận',
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
            leading: VitAssetAvatar(
              label: asset.symbol,
              accentColor: Color(asset.colorHex),
              size: AppSpacing.buttonCompact,
              radius: AppRadii.cardRadius,
              border: true,
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
