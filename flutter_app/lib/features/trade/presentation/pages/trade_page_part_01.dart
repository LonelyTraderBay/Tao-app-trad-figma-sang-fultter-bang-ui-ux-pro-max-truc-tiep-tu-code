part of 'trade_page.dart';

class _TradePageState extends ConsumerState<TradePage> {
  TradeOrderSide _side = TradeOrderSide.buy;
  TradeOrderType _orderType = TradeOrderType.limit;
  String _dataTab = 'chart';
  String _activeTab = 'order';
  final _priceController = TextEditingController(text: '67543.21');
  final _amountController = TextEditingController();
  bool _tpslEnabled = false;

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeScreenProvider(widget.pairId));
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);
    final amount = double.tryParse(_amountController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? pair.price;
    final draft = TradeOrderDraft(
      pairId: pair.id,
      side: _side,
      type: _orderType,
      price: price,
      amount: amount,
    );
    final orderController = ref.watch(
      tradeOrderControllerProvider((pairId: widget.pairId, draft: draft)),
    );
    final preview = orderController.state.preview;
    final canSubmit = orderController.canSubmit;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-048 TradePage',
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          key: TradePage.contentKey,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TradeHeader(pair: pair),
              _QuickNavRow(pair: pair),
              _DataTabs(
                active: _dataTab,
                onSelected: (value) => setState(() => _dataTab = value),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _MarketDataPanel(
                  active: _dataTab,
                  snapshot: snapshot,
                  chartVariant: widget.chartVariant,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _OrderTabs(
                  active: _activeTab,
                  openCount: snapshot.orders.length + 2,
                  onSelected: (value) => setState(() => _activeTab = value),
                ),
              ),
              const SizedBox(height: 20),
              if (_activeTab == 'order')
                _OrderForm(
                  side: _side,
                  orderType: _orderType,
                  pair: pair,
                  balances: snapshot.balances,
                  priceController: _priceController,
                  amountController: _amountController,
                  tpslEnabled: _tpslEnabled,
                  preview: preview,
                  canSubmit: canSubmit,
                  onSideChanged: (side) => setState(() => _side = side),
                  onTypeChanged: (type) => setState(() => _orderType = type),
                  onPct: (pct) => setState(() {
                    final available = _side == TradeOrderSide.buy
                        ? snapshot.balances.usdtAvailable / price
                        : snapshot.balances.baseAvailable;
                    _amountController.text = (available * pct / 100)
                        .toStringAsFixed(6);
                  }),
                  onTpslChanged: (value) =>
                      setState(() => _tpslEnabled = value),
                  onChanged: () => setState(() {}),
                  onSubmit: () {
                    final receipt = orderController.submit();
                    context.go(AppRoutePaths.tradeOrderReceipt);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã gửi ${receipt.orderId}')),
                    );
                  },
                )
              else if (_activeTab == 'open')
                _OpenOrdersList(orders: snapshot.orders)
              else
                _HistoryList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TradeHeader extends StatelessWidget {
  const _TradeHeader({required this.pair});

  final TradePair pair;

  @override
  Widget build(BuildContext context) {
    final logoColor = Color(pair.logoColorHex);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: logoColor.withValues(alpha: .20),
              shape: BoxShape.circle,
            ),
            child: Text(
              pair.baseAsset.substring(0, 3),
              style: AppTextStyles.micro.copyWith(
                color: logoColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => context.go(AppRoutePaths.tradePair(pair.id)),
              borderRadius: AppRadii.mdRadius,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      pair.symbol,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 21),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text2,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 128,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(pair.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.buy,
                    fontFamily: 'monospace',
                    fontSize: 18,
                    letterSpacing: .6,
                  ),
                ),
                Text(
                  '+${pair.changePct.toStringAsFixed(2)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
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

class _QuickNavRow extends StatelessWidget {
  const _QuickNavRow({required this.pair});

  final TradePair pair;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        children: [
          _QuickNavChip(
            key: TradePage.quickNavKey('convert'),
            icon: Icons.swap_horiz_rounded,
            label: 'Convert',
            color: AppColors.buy,
            onTap: () => context.go(AppRoutePaths.tradeConvert),
          ),
          _QuickNavChip(
            key: TradePage.quickNavKey('dca'),
            icon: Icons.repeat_rounded,
            label: 'Mua định kỳ',
            color: AppColors.accent,
            highlighted: true,
            onTap: () => context.go(AppRoutePaths.dca),
          ),
          _QuickNavChip(
            key: TradePage.quickNavKey('futures'),
            icon: Icons.bar_chart_rounded,
            label: 'Futures',
            color: AppColors.sell,
            onTap: () => context.go(AppRoutePaths.tradeFutures(pair.id)),
          ),
          _QuickNavChip(
            key: TradePage.quickNavKey('positions'),
            icon: Icons.work_outline_rounded,
            label: 'Vị thế',
            color: _tradePrimary,
            onTap: () => context.go('/trade/positions'),
          ),
          _QuickNavChip(
            key: TradePage.quickNavKey('settings'),
            icon: Icons.settings_outlined,
            label: 'Cài đặt',
            color: AppColors.text3,
            onTap: () => context.go('/trade/settings'),
          ),
        ],
      ),
    );
  }
}

class _QuickNavChip extends StatelessWidget {
  const _QuickNavChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: highlighted
                  ? color.withValues(alpha: .10)
                  : AppColors.surface2,
              border: Border.all(
                color: highlighted
                    ? color.withValues(alpha: .25)
                    : AppColors.borderSolid.withValues(alpha: .72),
              ),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 15),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: highlighted ? color : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DataTabs extends StatelessWidget {
  const _DataTabs({required this.active, required this.onSelected});

  final String active;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      ('chart', 'Chart', TradePage.chartTabKey),
      ('orderbook', 'Sổ lệnh', TradePage.orderBookTabKey),
      ('trades', 'Giao dịch', TradePage.tradesTabKey),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Container(
        height: 34,
        padding: const EdgeInsets.all(2),
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
                  onTap: () => onSelected(tab.$1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MarketDataPanel extends StatelessWidget {
  const _MarketDataPanel({
    required this.active,
    required this.snapshot,
    required this.chartVariant,
  });

  final String active;
  final TradeScreenSnapshot snapshot;
  final TradeChartVariant chartVariant;

  @override
  Widget build(BuildContext context) {
    if (active == 'orderbook') return _OrderBookPanel(book: snapshot.orderBook);
    if (active == 'trades') return _TradesPanel(trades: snapshot.trades);
    return _ChartPanel(variant: chartVariant);
  }
}

class _ChartPanel extends StatelessWidget {
  const _ChartPanel({required this.variant});

  final TradeChartVariant variant;

  @override
  Widget build(BuildContext context) {
    final pairRoute = variant == TradeChartVariant.pairRoute;
    return Container(
      height: 122,
      decoration: BoxDecoration(
        color: AppColors.surfaceTradeDeep,
        border: Border.all(color: _tradePrimary.withValues(alpha: .35)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: pairRoute
                  ? _PairRouteChartPainter()
                  : _CandlestickPainter(),
            ),
          ),
          Positioned(
            left: 10,
            top: 12,
            child: pairRoute
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sell.withValues(alpha: .20),
                      border: Border.all(
                        color: AppColors.sell.withValues(alpha: .55),
                      ),
                      borderRadius: AppRadii.lgRadius,
                    ),
                    child: Text(
                      '24H',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  )
                : Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.sell.withValues(alpha: .30),
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
          Positioned(
            left: 12,
            bottom: 8,
            child: Text(
              'TV',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.onAccent,
                fontSize: 28,
                fontFamily: 'monospace',
              ),
            ),
          ),
          if (pairRoute) ...[
            Positioned(
              right: 10,
              top: 46,
              child: Text(
                '70000.00',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3.withValues(alpha: .85),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 22,
              child: Text(
                '68000.00',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3.withValues(alpha: .85),
                ),
              ),
            ),
          ],
          Positioned(
            right: 8,
            top: pairRoute ? 18 : 38,
            child: _PriceBadge(
              label: pairRoute ? '70821.46' : '67545.13',
              color: AppColors.sell,
            ),
          ),
          Positioned(
            right: 8,
            top: pairRoute ? 40 : 60,
            child: _PriceBadge(
              label: pairRoute ? '70821.46' : '67254.13',
              color: AppColors.buy,
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: _PriceBadge(
              label: pairRoute ? '70.39K' : '252.58K',
              color: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}
