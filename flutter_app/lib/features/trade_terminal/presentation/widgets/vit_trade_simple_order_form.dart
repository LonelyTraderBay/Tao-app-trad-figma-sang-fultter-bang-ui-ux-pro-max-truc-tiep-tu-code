import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/vit_trade_side_switch.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_preset_chip_row.dart';

const _tradePrimary = AppColors.primary;

/// Market-only spot order form for beginner mode.
class VitTradeSimpleOrderForm extends StatelessWidget {
  const VitTradeSimpleOrderForm({
    super.key,
    required this.side,
    required this.pair,
    required this.balances,
    required this.amountController,
    required this.preview,
    required this.canSubmit,
    required this.marketPriceLabel,
    required this.onSideChanged,
    required this.onPct,
    required this.onChanged,
    required this.onConfirmedSubmit,
    this.buyKey,
    this.sellKey,
    this.amountFieldKey,
    this.submitKey,
    this.pctKeyBuilder,
  });

  final TradeOrderSide side;
  final TradePair pair;
  final TradeBalances balances;
  final TextEditingController amountController;
  final TradeOrderPreview preview;
  final bool canSubmit;
  final String marketPriceLabel;
  final ValueChanged<TradeOrderSide> onSideChanged;
  final ValueChanged<int> onPct;
  final VoidCallback onChanged;
  final VoidCallback onConfirmedSubmit;
  final Key? buyKey;
  final Key? sellKey;
  final Key? amountFieldKey;
  final Key? submitKey;
  final Key Function(int pct)? pctKeyBuilder;

  String get _submitLabel {
    if (!canSubmit) return 'Nhập số lượng để tiếp tục';
    return side == TradeOrderSide.buy ? 'Xác nhận MUA' : 'Đặt lệnh BÁN';
  }

  Future<void> _openConfirm(BuildContext context) async {
    if (!canSubmit) return;
    final sideLabel = side == TradeOrderSide.buy ? 'MUA' : 'BÁN';
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xem lại lệnh',
      lines: [
        VitTradeConfirmLine(label: 'Cặp', value: pair.symbol),
        VitTradeConfirmLine(label: 'Loại', value: sideLabel),
        VitTradeConfirmLine(
          label: 'Giá',
          value: 'Giá thị trường · $marketPriceLabel',
        ),
        VitTradeConfirmLine(
          label: 'Số lượng',
          value: '${amountController.text} ${pair.baseAsset}',
        ),
        VitTradeConfirmLine(
          label: 'Phí ước tính',
          value: formatTradeMoney(preview.fee),
        ),
        VitTradeConfirmLine(
          label: 'Tổng thanh toán',
          value: '${formatTradeMoney(preview.total)} USDT',
        ),
      ],
    );
    if (confirmed && context.mounted) {
      onConfirmedSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseAsset = pair.baseAsset;
    final actionVerb = side == TradeOrderSide.buy ? 'mua' : 'bán';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTradeSpotSideSwitch(
          side: side,
          onChanged: onSideChanged,
          buyKey: buyKey,
          sellKey: sellKey,
          activeBuyKey: const Key('sc048_trade_active_buy_side'),
          activeSellKey: const Key('sc048_trade_active_sell_side'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitInput(
          key: amountFieldKey,
          label: 'Số lượng $actionVerb ($baseAsset)',
          controller: amountController,
          onChanged: (_) => onChanged(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitPresetChipRow.percentBalance(
          onTap: onPct,
          keyFor: pctKeyBuilder ?? (pct) => Key('sc048_pct_$pct'),
          accentColor: _tradePrimary,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _SummaryRow(label: 'Giá thị trường', value: marketPriceLabel),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _SummaryRow(
          label: 'Phí ước tính',
          value: formatTradeMoney(preview.fee),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _SummaryRow(
          label: 'Tổng thanh toán',
          value: '${formatTradeMoney(preview.total)} USDT',
          emphasized: true,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          'Giá thị trường có thể thay đổi',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCtaButton(
          key: submitKey,
          onPressed: canSubmit ? () => _openConfirm(context) : null,
          density: VitDensity.compact,
          variant: side == TradeOrderSide.buy
              ? VitCtaButtonVariant.success
              : VitCtaButtonVariant.danger,
          child: Text(_submitLabel),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        Text(
          value,
          style: (emphasized ? AppTextStyles.body : AppTextStyles.caption)
              .copyWith(
                color: AppColors.text1,
                fontWeight: emphasized ? AppTextStyles.bold : null,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
        ),
      ],
    );
  }
}
