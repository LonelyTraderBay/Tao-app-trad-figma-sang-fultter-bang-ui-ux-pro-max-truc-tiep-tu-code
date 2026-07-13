part of 'futures_page.dart';

class _MarginInput extends StatelessWidget {
  const _MarginInput({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: controller,
      fieldKey: FuturesPage.marginFieldKey,
      label: 'Ký quỹ (USDT)',
      semanticLabel: 'Futures margin in USDT',
      hintText: 'Nhập số tiền ký quỹ',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
      ],
      textStyle: AppTextStyles.base.copyWith(
        color: AppColors.text1,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
      suffix: Text(
        'USDT',
        style: AppTextStyles.caption.copyWith(color: AppColors.text3),
      ),
      onChanged: (_) => onChanged(),
    );
  }
}

class _PercentRow extends StatelessWidget {
  const _PercentRow({required this.onPercent});

  final ValueChanged<int> onPercent;

  @override
  Widget build(BuildContext context) {
    return VitPresetChipRow<int>(
      onTap: onPercent,
      gap: AppSpacing.x2,
      height: WalletSpacingTokens.walletTransactionStepLineHeight,
      padding: AppSpacing.zeroInsets,
      tone: VitChoicePillTone.neutral,
      items: [
        for (final pct in const [10, 25, 50, 100])
          VitPresetChipItem(
            key: FuturesPage.pctKey(pct),
            value: pct,
            label: '$pct%',
            semanticLabel: 'Dung $pct phan tram ky quy',
          ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.pair, required this.preview});

  final TradePair pair;
  final TradeFuturesPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitFinancialSafetySummary(
      title: 'Futures order preview',
      contractId: 'SC-057 Futures preview',
      density: VitDensity.compact,
      footer:
          'Review leverage, margin, liquidation, fee, TP/SL, and side before opening a futures position.',
      items: [
        VitFinancialSafetyItem(
          label: 'Contract value',
          value: formatTradeMoney(preview.positionSize),
          leading: const Icon(Icons.stacked_line_chart_rounded),
        ),
        VitFinancialSafetyItem(
          label: 'Contract quantity',
          value: '${preview.contractQty.toStringAsFixed(4)} ${pair.baseAsset}',
          leading: const Icon(Icons.format_list_numbered_rounded),
        ),
        VitFinancialSafetyItem(
          label: 'Liquidation estimate',
          value: formatTradeMoney(preview.liquidationPrice),
          leading: const Icon(Icons.warning_amber_rounded),
          valueColor: _futuresRed,
        ),
        VitFinancialSafetyItem(
          label: 'Open fee',
          value: formatTradeMoney(preview.openFee),
          leading: const Icon(Icons.receipt_long_outlined),
          valueColor: AppColors.primary,
        ),
        const VitFinancialSafetyItem(
          label: 'Risk check',
          value: 'Confirm before submit',
          leading: Icon(Icons.verified_user_outlined),
          valueColor: AppColors.warn,
        ),
      ],
    );
  }
}
