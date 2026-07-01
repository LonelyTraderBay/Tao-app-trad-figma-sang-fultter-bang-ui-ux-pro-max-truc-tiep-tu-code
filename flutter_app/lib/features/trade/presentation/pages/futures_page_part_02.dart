part of 'futures_page.dart';

class _SideSwitch extends StatelessWidget {
  const _SideSwitch({required this.side, required this.onChanged});

  final TradeFuturesSide side;
  final ValueChanged<TradeFuturesSide> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<TradeFuturesSide>(
      selected: side,
      onChanged: onChanged,
      height: AppSpacing.futuresSideSwitchHeight,
      options: [
        VitSegmentedChoiceOption(
          key: FuturesPage.sideKey('long'),
          value: TradeFuturesSide.long,
          label: 'Long',
          accentColor: _futuresGreen,
          leading: const Icon(Icons.trending_up_rounded),
          semanticLabel: 'Chon huong Long futures',
        ),
        VitSegmentedChoiceOption(
          key: FuturesPage.sideKey('short'),
          value: TradeFuturesSide.short,
          label: 'Short',
          accentColor: _futuresRed,
          leading: const Icon(Icons.trending_down_rounded),
          semanticLabel: 'Chon huong Short futures',
        ),
      ],
    );
  }
}

class _OrderTypeAndLeverage extends StatelessWidget {
  const _OrderTypeAndLeverage({
    required this.orderType,
    required this.leverage,
    required this.onOrderTypeChanged,
    required this.onLeverage,
  });

  final TradeFuturesOrderType orderType;
  final int leverage;
  final ValueChanged<TradeFuturesOrderType> onOrderTypeChanged;
  final VoidCallback onLeverage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 300;
        final orderTypeSelector = VitSegmentedChoice.withPrimaryAccent<TradeFuturesOrderType>(
          selected: orderType,
          onChanged: onOrderTypeChanged,
          height: AppSpacing.futuresOrderTypeSelectorHeight,
          options: [
            VitSegmentedChoiceOption(
              key: FuturesPage.orderTypeKey('market'),
              value: TradeFuturesOrderType.market,
              label: 'Thị trường',
            ),
            VitSegmentedChoiceOption(
              key: FuturesPage.orderTypeKey('limit'),
              value: TradeFuturesOrderType.limit,
              label: 'Giới hạn',
            ),
          ],
        );
        final leverageButton = VitCtaButton(
          key: FuturesPage.leverageKey,
          onPressed: onLeverage,
          fullWidth: stacked,
          height: AppSpacing.searchBarCompactHeight,
          variant: VitCtaButtonVariant.ghost,
          leading: const Icon(Icons.bolt_rounded),
          trailing: stacked ? null : const Icon(Icons.keyboard_arrow_down_rounded),
          padding: AppSpacing.zeroInsets.copyWith(
            left: AppSpacing.rowPy,
            right: AppSpacing.x2,
          ),
          child: Text(
            '${leverage}x',
            style: AppTextStyles.caption.copyWith(
              color: _tradePrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        );
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              orderTypeSelector,
              const SizedBox(height: AppSpacing.x2),
              leverageButton,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: orderTypeSelector),
            const SizedBox(width: AppSpacing.x2),
            leverageButton,
          ],
        );
      },
    );
  }
}

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
      height: AppSpacing.walletTransactionStepLineHeight,
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
          value: _formatMoney(preview.positionSize),
          leading: const Icon(Icons.stacked_line_chart_rounded),
        ),
        VitFinancialSafetyItem(
          label: 'Contract quantity',
          value: '${preview.contractQty.toStringAsFixed(4)} ${pair.baseAsset}',
          leading: const Icon(Icons.format_list_numbered_rounded),
        ),
        VitFinancialSafetyItem(
          label: 'Liquidation estimate',
          value: _formatMoney(preview.liquidationPrice),
          leading: const Icon(Icons.warning_amber_rounded),
          valueColor: _futuresRed,
        ),
        VitFinancialSafetyItem(
          label: 'Open fee',
          value: '\$${preview.openFee.toStringAsFixed(4)}',
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

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      height: AppSpacing.walletTransactionStepLineHeight,
      fullWidth: true,
      tone: activeColor == _futuresGreen
          ? VitChoicePillTone.success
          : VitChoicePillTone.danger,
      leading: Icon(icon),
      padding: AppSpacing.zeroInsets,
      semanticLabel: 'Bat tat $label',
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.side,
    required this.enabled,
    required this.receipt,
    required this.leverage,
    required this.onTap,
  });

  final TradeFuturesSide side;
  final bool enabled;
  final TradeFuturesReceipt? receipt;
  final int leverage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = receipt == null
        ? enabled
              ? 'Mở ${leverage}x ${side == TradeFuturesSide.long ? 'Long' : 'Short'}'
              : 'Nhập ký quỹ'
        : 'Đã gửi ${receipt!.orderId}';
    return VitCtaButton(
      key: FuturesPage.submitKey,
      onPressed: enabled ? onTap : null,
      height: AppSpacing.ctaHeight,
      variant: side == TradeFuturesSide.long
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.danger,
      child: Text(
        label,
        style: AppTextStyles.baseMedium.copyWith(
          color: enabled
              ? AppColors.onAccent
              : AppColors.text3.withValues(alpha: .32),
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
