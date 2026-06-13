part of 'futures_page.dart';

class _SideSwitch extends StatelessWidget {
  const _SideSwitch({required this.side, required this.onChanged});

  final TradeFuturesSide side;
  final ValueChanged<TradeFuturesSide> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _chipBackground,
        borderRadius: AppRadii.cardRadius,
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
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? color : AppColors.transparent,
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active ? AppColors.onAccent : AppColors.text2,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.baseMedium.copyWith(
                  color: active ? AppColors.onAccent : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
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
          child: Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _chipBackground,
              borderRadius: AppRadii.cardRadius,
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
        const SizedBox(width: 8),
        InkWell(
          key: FuturesPage.leverageKey,
          onTap: onLeverage,
          borderRadius: AppRadii.cardRadius,
          child: Container(
            width: 100,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _tradePrimary.withValues(alpha: .13),
              border: Border.all(color: _tradePrimary.withValues(alpha: .35)),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, color: _tradePrimary, size: 17),
                const SizedBox(width: 6),
                Text(
                  '${leverage}x',
                  style: AppTextStyles.caption.copyWith(
                    color: _tradePrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _tradePrimary,
                  size: 16,
                ),
              ],
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
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? _tradePrimary.withValues(alpha: .18)
                : AppColors.transparent,
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? _tradePrimary : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
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
            child: InkWell(
              key: FuturesPage.pctKey(pct),
              onTap: () => onPercent(pct),
              borderRadius: AppRadii.cardRadius,
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _chipBackground,
                  border: Border.all(
                    color: _tradePrimary.withValues(alpha: .18),
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Text(
                  '$pct%',
                  style: AppTextStyles.numericCode.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          if (pct != 100) const SizedBox(width: 8),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .06)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? activeColor.withValues(alpha: .12) : _chipBackground,
          border: Border.all(
            color: active
                ? activeColor.withValues(alpha: .35)
                : _tradePrimary.withValues(alpha: .18),
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? activeColor : AppColors.text2, size: 14),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppTextStyles.captionSm.copyWith(
                color: active ? activeColor : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
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
    final color = side == TradeFuturesSide.long ? _futuresGreen : _futuresRed;
    final label = receipt == null
        ? enabled
              ? 'Mở ${leverage}x ${side == TradeFuturesSide.long ? 'Long' : 'Short'}'
              : 'Nhập ký quỹ'
        : 'Đã gửi ${receipt!.orderId}';
    return InkWell(
      key: FuturesPage.submitKey,
      onTap: enabled ? onTap : null,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? color : AppColors.surface3,
          gradient: enabled
              ? LinearGradient(
                  colors: [
                    color,
                    Color.lerp(color, AppColors.dynamicIslandBg, .18)!,
                  ],
                )
              : null,
          borderRadius: AppRadii.inputRadius,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: .30),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled
                ? AppColors.onAccent
                : AppColors.text3.withValues(alpha: .32),
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
