part of 'futures_page.dart';

class _SideSwitch extends StatelessWidget {
  const _SideSwitch({required this.side, required this.onChanged});

  final TradeFuturesSide side;
  final ValueChanged<TradeFuturesSide> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      height: AppSpacing.futuresSideSwitchHeight,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.hairlineStroke * 2,
        top: AppSpacing.hairlineStroke * 2,
        right: AppSpacing.hairlineStroke * 2,
        bottom: AppSpacing.hairlineStroke * 2,
      ),
      child: Row(
        children: [
          _SideButton(
            key: FuturesPage.sideKey('long'),
            label: 'Long',
            icon: Icons.trending_up_rounded,
            active: side == TradeFuturesSide.long,
            color: _futuresGreen,
            onTap: () => onChanged(TradeFuturesSide.long),
          ),
          _SideButton(
            key: FuturesPage.sideKey('short'),
            label: 'Short',
            icon: Icons.trending_down_rounded,
            active: side == TradeFuturesSide.short,
            color: _futuresRed,
            onTap: () => onChanged(TradeFuturesSide.short),
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCtaButton(
        onPressed: onTap,
        variant: active
            ? (color == _futuresGreen
                  ? VitCtaButtonVariant.success
                  : VitCtaButtonVariant.danger)
            : VitCtaButtonVariant.ghost,
        leading: Icon(icon),
        padding: AppSpacing.zeroInsets,
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
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
    return Row(
      children: [
        Expanded(
          child: VitCard(
            variant: VitCardVariant.inner,
            height: AppSpacing.futuresOrderTypeSelectorHeight,
            padding: AppSpacing.zeroInsets.copyWith(
              left: AppSpacing.hairlineStroke * 2,
              top: AppSpacing.hairlineStroke * 2,
              right: AppSpacing.hairlineStroke * 2,
              bottom: AppSpacing.hairlineStroke * 2,
            ),
            child: Row(
              children: [
                _OrderTypeButton(
                  key: FuturesPage.orderTypeKey('market'),
                  label: 'Thị trường',
                  active: orderType == TradeFuturesOrderType.market,
                  onTap: () => onOrderTypeChanged(TradeFuturesOrderType.market),
                ),
                _OrderTypeButton(
                  key: FuturesPage.orderTypeKey('limit'),
                  label: 'Giới hạn',
                  active: orderType == TradeFuturesOrderType.limit,
                  onTap: () => onOrderTypeChanged(TradeFuturesOrderType.limit),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        VitCtaButton(
          key: FuturesPage.leverageKey,
          onPressed: onLeverage,
          fullWidth: false,
          height: AppSpacing.searchBarCompactHeight,
          variant: VitCtaButtonVariant.ghost,
          leading: const Icon(Icons.bolt_rounded),
          trailing: const Icon(Icons.keyboard_arrow_down_rounded),
          padding: AppSpacing.zeroInsets.copyWith(
            left: AppSpacing.rowPy,
            right: AppSpacing.x3,
          ),
          child: Text(
            '${leverage}x',
            style: AppTextStyles.caption.copyWith(
              color: _tradePrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderTypeButton extends StatelessWidget {
  const _OrderTypeButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCtaButton(
        onPressed: onTap,
        height: AppSpacing.buttonCompact,
        variant: active
            ? VitCtaButtonVariant.primary
            : VitCtaButtonVariant.ghost,
        padding: AppSpacing.zeroInsets,
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
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
    return Row(
      children: [
        for (final pct in const [10, 25, 50, 100]) ...[
          Expanded(
            child: VitCtaButton(
              key: FuturesPage.pctKey(pct),
              onPressed: () => onPercent(pct),
              height: AppSpacing.walletTransactionStepLineHeight,
              variant: VitCtaButtonVariant.ghost,
              padding: AppSpacing.zeroInsets,
              child: Text(
                '$pct%',
                style: AppTextStyles.numericCode.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.futuresPercentButtonLineHeight,
                ),
              ),
            ),
          ),
          if (pct != 100) const SizedBox(width: AppSpacing.x3),
        ],
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
    final rows = [
      ('Giá trị hợp đồng', _formatMoney(preview.positionSize), AppColors.text1),
      (
        'Số lượng',
        '${preview.contractQty.toStringAsFixed(4)} ${pair.baseAsset}',
        AppColors.text1,
      ),
      ('Giá thanh lý', _formatMoney(preview.liquidationPrice), _futuresRed),
      (
        'Phí mở vị thế',
        '\$${preview.openFee.toStringAsFixed(4)}',
        AppColors.primary,
      ),
    ];
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowPy,
        top: AppSpacing.rowPy,
        right: AppSpacing.rowPy,
        bottom: AppSpacing.rowPy,
      ),
      borderColor: AppColors.onAccent.withValues(alpha: .06),
      child: Column(
        children: [
          for (final row in rows)
            Padding(
              padding: AppSpacing.zeroInsets.copyWith(bottom: AppSpacing.x3),
              child: Row(
                children: [
                  Text(row.$1, style: AppTextStyles.caption),
                  const Spacer(),
                  Text(
                    row.$2,
                    style: AppTextStyles.numericCode.copyWith(
                      color: row.$3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
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
    return VitCtaButton(
      onPressed: onTap,
      height: AppSpacing.walletTransactionStepLineHeight,
      variant: active
          ? (activeColor == _futuresGreen
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger)
          : VitCtaButtonVariant.ghost,
      leading: Icon(icon),
      padding: AppSpacing.zeroInsets,
      child: Text(
        label,
        style: AppTextStyles.captionSm.copyWith(
          color: active ? AppColors.onAccent : AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
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
