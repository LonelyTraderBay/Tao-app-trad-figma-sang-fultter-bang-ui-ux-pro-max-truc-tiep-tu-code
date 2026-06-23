part of 'trade_page.dart';

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _OrderBookPanel extends StatelessWidget {
  const _OrderBookPanel({required this.book});

  final TradeOrderBook book;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          _BookHeader(),
          for (final ask in book.asks.reversed)
            _BookRow(level: ask, color: AppColors.sell),
          const Divider(
            color: AppColors.divider,
            height: AppSpacing.tradeBookDividerHeight,
          ),
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
      padding: AppSpacing.zeroInsets.copyWith(
        top: AppSpacing.tradeBookRowTopGap,
      ),
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
          fontFeatures: AppTextStyles.tabularFigures,
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
                      trade.price.toStringAsFixed(2),
                      style: AppTextStyles.caption.copyWith(
                        color: trade.isBuy ? AppColors.buy : AppColors.sell,
                        fontFeatures: AppTextStyles.tabularFigures,
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
    return VitCard(
      density: VitDensity.tool,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x1),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
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
      padding: AppSpacing.contentInsets,
      child: Column(
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
            label: 'Khối lượng (${pair.baseAsset})',
            suffix: pair.baseAsset,
            controller: amountController,
            onChanged: onChanged,
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            density: VitDensity.tool,
            padding: AppSpacing.tradeSegmentedPadding,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            borderColor: AppColors.cardBorder,
            child: Row(
              children: [
                for (final pct in const [25, 50, 75, 100]) ...[
                  Expanded(
                    child: _PctButton(
                      key: TradePage.pctKey(pct),
                      pct: pct,
                      onTap: () => onPct(pct),
                    ),
                  ),
                  if (pct != 100) const SizedBox(width: AppSpacing.x1),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _TpslSwitch(value: tpslEnabled, onChanged: onTpslChanged),
          const SizedBox(height: AppSpacing.x3),
          _FeeCard(preview: preview),
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
                  ? (side == TradeOrderSide.buy ? 'Mua BTC' : 'Bán BTC')
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
    return VitCard(
      density: VitDensity.tool,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x1),
      variant: VitCardVariant.inner,
      child: Row(
        children: [
          Expanded(
            child: _SideButton(
              key: TradePage.buySideKey,
              activeKey: const Key('sc048_trade_active_buy_side'),
              label: 'MUA',
              color: AppColors.buy,
              active: side == TradeOrderSide.buy,
              onTap: () => onChanged(TradeOrderSide.buy),
            ),
          ),
          Expanded(
            child: _SideButton(
              key: TradePage.sellSideKey,
              activeKey: const Key('sc048_trade_active_sell_side'),
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
    required this.activeKey,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final Key activeKey;
  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: active ? activeKey : null,
      onPressed: onTap,
      variant: active
          ? (color == AppColors.buy
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger)
          : VitCtaButtonVariant.ghost,
      density: VitDensity.compact,
      child: Text(
        label,
        style: AppTextStyles.baseMedium.copyWith(
          fontWeight: AppTextStyles.bold,
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
    return VitCard(
      density: VitDensity.tool,
      padding: AppSpacing.tradeSegmentedPadding,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          _OrderTypeChip(
            type: TradeOrderType.market,
            active: active == TradeOrderType.market,
            onSelected: onSelected,
          ),
          const SizedBox(width: AppSpacing.x1),
          _OrderTypeChip(
            type: TradeOrderType.limit,
            active: active == TradeOrderType.limit,
            onSelected: onSelected,
          ),
          const SizedBox(width: AppSpacing.x1),
          _OrderTypeChip(
            type: TradeOrderType.stop,
            active: active == TradeOrderType.stop,
            onSelected: onSelected,
          ),
          const SizedBox(width: AppSpacing.x1),
          VitCard(
            width: AppSpacing.buttonCompact,
            height: AppSpacing.buttonCompact,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.sm,
            borderColor: AppColors.borderSolid,
            background: const DecoratedBox(
              decoration: BoxDecoration(color: AppColors.portfolioBtnGhost),
            ),
            clip: true,
            child: const Center(
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: AppSpacing.iconMd,
                color: AppColors.text2,
              ),
            ),
          ),
        ],
      ),
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
      child: VitChoicePill(
        key: TradePage.orderTypeKey(type),
        label: label,
        selected: active,
        onTap: () => onSelected(type),
        fullWidth: true,
        height: AppSpacing.buttonCompact,
        accentColor: _tradePrimary,
      ),
    );
  }
}
