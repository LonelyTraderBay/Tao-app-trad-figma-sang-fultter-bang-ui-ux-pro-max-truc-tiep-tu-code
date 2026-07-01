part of 'trade_page.dart';

class _OrderForm extends StatelessWidget {
  const _OrderForm({
    required this.side,
    required this.orderType,
    required this.pair,
    required this.balances,
    required this.priceController,
    required this.amountController,
    required this.tpslEnabled,
    required this.preview,
    required this.canSubmit,
    required this.onSideChanged,
    required this.onTypeChanged,
    required this.onPct,
    required this.onTpslChanged,
    required this.onChanged,
    required this.onSubmit,
    this.compact = false,
  });

  final TradeOrderSide side;
  final TradeOrderType orderType;
  final TradePair pair;
  final TradeBalances balances;
  final TextEditingController priceController;
  final TextEditingController amountController;
  final bool tpslEnabled;
  final TradeOrderPreview preview;
  final bool canSubmit;
  final ValueChanged<TradeOrderSide> onSideChanged;
  final ValueChanged<TradeOrderType> onTypeChanged;
  final ValueChanged<int> onPct;
  final ValueChanged<bool> onTpslChanged;
  final VoidCallback onChanged;
  final VoidCallback onSubmit;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final available = side == TradeOrderSide.buy
        ? balances.usdtAvailable
        : balances.baseAvailable;
    final availableAsset = side == TradeOrderSide.buy ? 'USDT' : pair.baseAsset;
    final baseAsset = pair.baseAsset;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SideSwitch(side: side, onChanged: onSideChanged),
        const SizedBox(height: AppSpacing.x3),
        _OrderTypeRow(active: orderType, onSelected: onTypeChanged),
        const SizedBox(height: AppSpacing.x3),
        _LabelValue(
          label: 'Khả dụng',
          value: '${_formatMoney(available)} $availableAsset',
        ),
        const SizedBox(height: AppSpacing.x2),
        _TradeInput(
          label: 'Giá đặt (USDT)',
          suffix: 'USDT',
          controller: priceController,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.x2),
        _TradeInput(
          key: TradePage.amountFieldKey,
          label: 'Khối lượng ($baseAsset)',
          suffix: baseAsset,
          controller: amountController,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitPresetChipRow.percentBalance(
          onTap: onPct,
          keyFor: TradePage.pctKey,
          accentColor: _tradePrimary,
        ),
        const SizedBox(height: AppSpacing.x3),
        _TpslSwitch(value: tpslEnabled, onChanged: onTpslChanged),
        if (!compact) ...[
          const SizedBox(height: AppSpacing.x3),
          _FeeCard(preview: preview),
        ],
        const SizedBox(height: AppSpacing.x3),
        VitCtaButton(
          key: TradePage.submitKey,
          onPressed: canSubmit ? onSubmit : null,
          density: VitDensity.compact,
          variant: side == TradeOrderSide.buy
              ? VitCtaButtonVariant.success
              : VitCtaButtonVariant.danger,
          child: Text(
            canSubmit
                ? (side == TradeOrderSide.buy
                    ? 'Mua $baseAsset'
                    : 'Bán $baseAsset')
                : 'Nhập thông tin lệnh',
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Kiểm tra kỹ trước khi xác nhận.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _SideSwitch extends StatelessWidget {
  const _SideSwitch({required this.side, required this.onChanged});

  final TradeOrderSide side;
  final ValueChanged<TradeOrderSide> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<TradeOrderSide>(
      selected: side,
      onChanged: onChanged,
      options: [
        VitSegmentedChoiceOption(
          key: TradePage.buySideKey,
          activeKey: const Key('sc048_trade_active_buy_side'),
          value: TradeOrderSide.buy,
          label: 'MUA',
          accentColor: AppColors.buy,
        ),
        VitSegmentedChoiceOption(
          key: TradePage.sellSideKey,
          activeKey: const Key('sc048_trade_active_sell_side'),
          value: TradeOrderSide.sell,
          label: 'BÁN',
          accentColor: AppColors.sell,
        ),
      ],
    );
  }
}

class _OrderTypeRow extends StatelessWidget {
  const _OrderTypeRow({required this.active, required this.onSelected});

  final TradeOrderType active;
  final ValueChanged<TradeOrderType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSegmentedChoice.withPrimaryAccent<TradeOrderType>(
            selected: active,
            onChanged: onSelected,
            options: [
              VitSegmentedChoiceOption(
                key: TradePage.orderTypeKey(TradeOrderType.market),
                value: TradeOrderType.market,
                label: 'Thị trường',
              ),
              VitSegmentedChoiceOption(
                key: TradePage.orderTypeKey(TradeOrderType.limit),
                value: TradeOrderType.limit,
                label: 'Giới hạn',
              ),
              VitSegmentedChoiceOption(
                key: TradePage.orderTypeKey(TradeOrderType.stop),
                value: TradeOrderType.stop,
                label: 'Dừng lỗ',
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        VitIconButton(
          icon: Icons.keyboard_arrow_down_rounded,
          tooltip: 'More order types',
          onPressed: () {},
          variant: VitIconButtonVariant.ghost,
          size: VitIconButtonSize.md,
        ),
      ],
    );
  }
}
