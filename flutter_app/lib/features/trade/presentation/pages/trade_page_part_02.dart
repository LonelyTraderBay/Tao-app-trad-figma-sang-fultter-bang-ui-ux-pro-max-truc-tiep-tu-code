part of 'trade_page.dart';

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: AppRadii.xsRadius),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.onAccent,
          fontFamily: 'monospace',
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _OrderBookPanel extends StatelessWidget {
  const _OrderBookPanel({required this.book});

  final TradeOrderBook book;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _BookHeader(),
          for (final ask in book.asks.reversed)
            _BookRow(level: ask, color: AppColors.sell),
          const Divider(color: AppColors.divider, height: 16),
          for (final bid in book.bids)
            _BookRow(level: bid, color: AppColors.buy),
        ],
      ),
    );
  }
}

class _BookHeader extends StatelessWidget {
  const _BookHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _BookCell('Giá', color: AppColors.text3),
        _BookCell('KL', color: AppColors.text3),
        _BookCell('Tổng', color: AppColors.text3, alignEnd: true),
      ],
    );
  }
}

class _BookRow extends StatelessWidget {
  const _BookRow({required this.level, required this.color});

  final TradeBookLevel level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          _BookCell(level.price.toStringAsFixed(2), color: color),
          _BookCell(level.amount.toStringAsFixed(3)),
          _BookCell(level.total.toStringAsFixed(0), alignEnd: true),
        ],
      ),
    );
  }
}

class _BookCell extends StatelessWidget {
  const _BookCell(
    this.label, {
    this.color = AppColors.text2,
    this.alignEnd = false,
  });

  final String label;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontFamily: 'monospace',
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _TradesPanel extends StatelessWidget {
  const _TradesPanel({required this.trades});

  final List<TradeTapePrint> trades;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          for (final trade in trades)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      trade.price.toStringAsFixed(2),
                      style: AppTextStyles.caption.copyWith(
                        color: trade.isBuy ? AppColors.buy : AppColors.sell,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      trade.amount.toStringAsFixed(3),
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

class _OrderTabs extends StatelessWidget {
  const _OrderTabs({
    required this.active,
    required this.openCount,
    required this.onSelected,
  });

  final String active;
  final int openCount;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('order', 'Đặt lệnh', TradePage.orderTabKey),
      ('open', 'Đang mở ($openCount)', TradePage.openOrdersTabKey),
      ('history', 'Lịch sử', TradePage.historyTabKey),
    ];
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _fieldBackground,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _SegmentButton(
                key: tab.$3,
                label: tab.$2,
                active: active == tab.$1,
                activeColor: _tradePrimary,
                onTap: () => onSelected(tab.$1),
              ),
            ),
        ],
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    final available = side == TradeOrderSide.buy
        ? balances.usdtAvailable
        : balances.baseAvailable;
    final availableAsset = side == TradeOrderSide.buy ? 'USDT' : pair.baseAsset;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SideSwitch(side: side, onChanged: onSideChanged),
          const SizedBox(height: 16),
          _OrderTypeRow(active: orderType, onSelected: onTypeChanged),
          const SizedBox(height: 16),
          _LabelValue(
            label: 'Khả dụng',
            value: '${_formatMoney(available)} $availableAsset',
          ),
          const SizedBox(height: 14),
          _TradeInput(
            label: 'Giá đặt (USDT)',
            suffix: 'USDT',
            controller: priceController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 14),
          _TradeInput(
            key: TradePage.amountFieldKey,
            label: 'Khối lượng (${pair.baseAsset})',
            suffix: pair.baseAsset,
            controller: amountController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final pct in const [25, 50, 75, 100]) ...[
                Expanded(
                  child: _PctButton(
                    key: TradePage.pctKey(pct),
                    pct: pct,
                    onTap: () => onPct(pct),
                  ),
                ),
                if (pct != 100) const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _TpslSwitch(value: tpslEnabled, onChanged: onTpslChanged),
          const SizedBox(height: 16),
          _FeeCard(preview: preview),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: TradePage.submitKey,
              onPressed: canSubmit ? onSubmit : null,
              style: FilledButton.styleFrom(
                backgroundColor: side == TradeOrderSide.buy
                    ? AppColors.buy
                    : AppColors.sell,
                disabledBackgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.cardRadius,
                ),
              ),
              child: Text(
                canSubmit
                    ? (side == TradeOrderSide.buy ? 'Mua BTC' : 'Bán BTC')
                    : 'Nhập thông tin lệnh',
                style: AppTextStyles.baseMedium.copyWith(
                  color: canSubmit ? AppColors.onAccent : AppColors.text3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Kiểm tra kỹ trước khi xác nhận.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _SideSwitch extends StatelessWidget {
  const _SideSwitch({required this.side, required this.onChanged});

  final TradeOrderSide side;
  final ValueChanged<TradeOrderSide> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _fieldBackground,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SideButton(
              key: TradePage.buySideKey,
              label: 'MUA',
              color: AppColors.buy,
              active: side == TradeOrderSide.buy,
              onTap: () => onChanged(TradeOrderSide.buy),
            ),
          ),
          Expanded(
            child: _SideButton(
              key: TradePage.sellSideKey,
              label: 'BÁN',
              color: AppColors.sell,
              active: side == TradeOrderSide.sell,
              onTap: () => onChanged(TradeOrderSide.sell),
            ),
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
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color : AppColors.transparent,
          borderRadius: AppRadii.cardRadius,
        ),
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

class _OrderTypeRow extends StatelessWidget {
  const _OrderTypeRow({required this.active, required this.onSelected});

  final TradeOrderType active;
  final ValueChanged<TradeOrderType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _OrderTypeChip(
          type: TradeOrderType.market,
          active: active == TradeOrderType.market,
          onSelected: onSelected,
        ),
        const SizedBox(width: 10),
        _OrderTypeChip(
          type: TradeOrderType.limit,
          active: active == TradeOrderType.limit,
          onSelected: onSelected,
        ),
        const SizedBox(width: 10),
        _OrderTypeChip(
          type: TradeOrderType.stop,
          active: active == TradeOrderType.stop,
          onSelected: onSelected,
        ),
        const SizedBox(width: 10),
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: _fieldBackground,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.cardRadius,
          ),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class _OrderTypeChip extends StatelessWidget {
  const _OrderTypeChip({
    required this.type,
    required this.active,
    required this.onSelected,
  });

  final TradeOrderType type;
  final bool active;
  final ValueChanged<TradeOrderType> onSelected;

  String get label => switch (type) {
    TradeOrderType.market => 'Thị trường',
    TradeOrderType.limit => 'Giới hạn',
    TradeOrderType.stop => 'Dừng lỗ',
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        key: TradePage.orderTypeKey(type),
        onTap: () => onSelected(type),
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: 39,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? AppColors.buy.withValues(alpha: .09)
                : _fieldBackground,
            border: Border.all(
              color: active
                  ? AppColors.buy.withValues(alpha: .75)
                  : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.buy : AppColors.text2,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ),
      ),
    );
  }
}
