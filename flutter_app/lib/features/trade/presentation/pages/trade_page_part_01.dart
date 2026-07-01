part of 'trade_page.dart';

class _TradePageState extends ConsumerState<TradePage> {
  late TradeOrderSide _side;
  TradeOrderType _orderType = TradeOrderType.limit;
  VitTradeViewMode _viewMode = VitTradeViewMode.charts;
  String _chartsSubTab = 'orderbook';
  String _dockTab = 'positions';
  final _priceController = TextEditingController(text: '67543.21');
  final _amountController = TextEditingController();
  bool _tpslEnabled = false;

  @override
  void initState() {
    super.initState();
    _side = widget.initialSide;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  VitOrderBookPanel _orderBookPanel(TradeScreenSnapshot snapshot) {
    return VitOrderBookPanel(
      density: _viewMode == VitTradeViewMode.trade
          ? VitOrderBookPanelDensity.compact
          : VitOrderBookPanelDensity.standard,
      asks: [
        for (final level in snapshot.orderBook.asks)
          VitOrderBookLevel(
            price: level.price,
            amount: level.amount,
            total: level.total,
          ),
      ],
      bids: [
        for (final level in snapshot.orderBook.bids)
          VitOrderBookLevel(
            price: level.price,
            amount: level.amount,
            total: level.total,
          ),
      ],
    );
  }

  Widget _orderForm({
    required TradePair pair,
    required TradeScreenSnapshot snapshot,
    required TradeOrderPreview preview,
    required bool canSubmit,
    required TradeOrderController orderController,
    required bool compact,
  }) {
    return KeyedSubtree(
      key: TradePage.orderTabKey,
      child: _OrderForm(
        side: _side,
        orderType: _orderType,
        pair: pair,
        balances: snapshot.balances,
        priceController: _priceController,
        amountController: _amountController,
        tpslEnabled: _tpslEnabled,
        preview: preview,
        canSubmit: canSubmit,
        compact: compact,
        onSideChanged: (side) => setState(() => _side = side),
        onTypeChanged: (type) => setState(() => _orderType = type),
        onPct: (pct) => setState(() {
          final price = double.tryParse(_priceController.text) ?? pair.price;
          final available = _side == TradeOrderSide.buy
              ? snapshot.balances.usdtAvailable / price
              : snapshot.balances.baseAvailable;
          _amountController.text = (available * pct / 100).toStringAsFixed(6);
        }),
        onTpslChanged: (value) => setState(() => _tpslEnabled = value),
        onChanged: () => setState(() {}),
        onSubmit: () {
          final receipt = orderController.submit();
          context.go(AppRoutePaths.tradeOrderReceipt);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã gửi ${receipt.orderId}')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeScreenProvider(widget.pairId));
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance = tradeTerminalScrollBottomInset(
      context,
      shellRenderMode: mode,
    );
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
    final showBack =
        widget.chartVariant == TradeChartVariant.pairRoute || context.canPop();
    final productNav = _tradeProductNavigation(context, pair);
    final orderForm = _orderForm(
      pair: pair,
      snapshot: snapshot,
      preview: preview,
      canSubmit: canSubmit,
      orderController: orderController,
      compact: _viewMode == VitTradeViewMode.trade,
    );

    final bodyChildren = <Widget>[
      if (_viewMode == VitTradeViewMode.charts) ...[
        VitTradeChartPanel(variant: _mapChartVariant(widget.chartVariant)),
        const SizedBox(height: AppSpacing.x3),
        _ChartsSubTabs(
          active: _chartsSubTab,
          onSelected: (value) => setState(() => _chartsSubTab = value),
        ),
        const SizedBox(height: AppSpacing.x3),
        if (_chartsSubTab == 'orderbook')
          _orderBookPanel(snapshot)
        else
          VitTradesTapePanel(
            trades: [
              for (final trade in snapshot.trades)
                VitTradesTapePrint(
                  price: trade.price,
                  amount: trade.amount,
                  time: trade.time,
                  isBuy: trade.isBuy,
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.x3),
        orderForm,
      ] else ...[
        VitTradeSplitPanel(
          form: orderForm,
          marketPanel: _orderBookPanel(snapshot),
        ),
      ],
    ];

    return VitTradeTerminalLayout(
      semanticLabel: 'SC-048 TradePage',
      scrollKey: TradePage.contentKey,
      scrollBottomInset: scrollClearance,
      header: _TradeTerminalHeader(
        pair: pair,
        showBack: showBack,
        onBack: showBack
            ? () => goBackOrFallback(
                context,
                fallbackPath: AppRoutePaths.trade,
                mode: BackNavigationMode.historyThenFallback,
              )
            : null,
      ),
      ticker: VitTradeTickerStrip(
        symbol: pair.symbol,
        priceLabel: _formatPrice(pair.price),
        changePct: pair.changePct,
        highLabel: _formatPrice(pair.price * 1.02),
        lowLabel: _formatPrice(pair.price * 0.98),
        volumeLabel: '252.58K',
      ),
      productTabs: VitTradeProductTabs(
        activeId: 'spot',
        tabs: productNav.tabs,
        overflowItems: productNav.overflow,
      ),
      viewModeToggle: VitTradeViewModeToggle(
        mode: _viewMode,
        chartsKey: TradePage.viewModeChartsKey,
        tradeKey: TradePage.viewModeTradeKey,
        onChanged: (value) => setState(() => _viewMode = value),
      ),
      bodyChildren: bodyChildren,
      footer: snapshot.highRiskContractId != null
          ? VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.compact,
              title: 'Spot order risk states active',
              message:
                  'Setup, preview, confirmation, submission, receipt and support use the shared high-risk flow contract.',
              contractId: snapshot.highRiskContractId,
            )
          : null,
      portfolioPanel: VitTradePortfolioPanel(
        expandKey: TradePage.portfolioExpandKey,
        activeKey: _dockTab,
        onChanged: (value) => setState(() => _dockTab = value),
        tabs: [
          VitTabItem(
            key: 'positions',
            label: 'Vị thế (${snapshot.positions.length})',
            widgetKey: TradePage.positionsTabKey,
          ),
          VitTabItem(
            key: 'open',
            label: 'Lệnh mở (${snapshot.orders.length + 2})',
            widgetKey: TradePage.openOrdersTabKey,
          ),
          VitTabItem(
            key: 'history',
            label: 'Lịch sử',
            widgetKey: TradePage.historyTabKey,
          ),
        ],
        child: switch (_dockTab) {
          'open' => _OpenOrdersList(orders: snapshot.orders),
          'history' => const _HistoryList(),
          _ => _PositionsList(positions: snapshot.positions),
        },
      ),
    );
  }
}

class _TradeTerminalHeader extends StatelessWidget {
  const _TradeTerminalHeader({
    required this.pair,
    required this.showBack,
    required this.onBack,
  });

  final TradePair pair;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final logoColor = Color(pair.logoColorHex);
    return VitTradeTerminalHeader(
      symbol: pair.symbol,
      showBack: showBack,
      onBack: onBack,
      backKey: TradePage.backKey,
      onPairTap: () => context.go(AppRoutePaths.tradePair(pair.id)),
      leading: VitCard(
        width: AppSpacing.tradeHeaderLogo,
        height: AppSpacing.tradeHeaderLogo,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.large,
        alignment: Alignment.center,
        borderColor: logoColor.withValues(alpha: .26),
        child: Text(
          pair.baseAsset.substring(0, 3),
          style: AppTextStyles.micro.copyWith(
            color: logoColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _TradeProductNavigation {
  const _TradeProductNavigation({required this.tabs, required this.overflow});

  final List<VitTradeProductTab> tabs;
  final List<VitTradeProductOverflowItem> overflow;
}

_TradeProductNavigation _tradeProductNavigation(
  BuildContext context,
  TradePair pair,
) {
  final hubItems = _tradeHubItems(context, pair);
  const primaryIds = ['spot', 'futures', 'margin', 'convert'];
  VitTradeProductTab tabFor(VitTradeHubItem item) => VitTradeProductTab(
    id: item.id,
    label: item.label,
    tabKey: item.tileKey,
    onTap: item.onTap,
  );
  VitTradeProductOverflowItem overflowFor(VitTradeHubItem item) =>
      VitTradeProductOverflowItem(
        id: item.id,
        label: item.label,
        badge: item.badge,
        icon: item.icon,
        accentColor: item.accentColor,
        tileKey: item.tileKey,
        onTap: item.onTap,
      );

  return _TradeProductNavigation(
    tabs: [
      for (final id in primaryIds)
        tabFor(hubItems.firstWhere((item) => item.id == id)),
    ],
    overflow: [
      for (final item in hubItems)
        if (!primaryIds.contains(item.id)) overflowFor(item),
    ],
  );
}

List<VitTradeHubItem> _tradeHubItems(BuildContext context, TradePair pair) {
  return [
    VitTradeHubItem(
      id: 'spot',
      label: 'Spot',
      badge: 'Core',
      icon: Icons.show_chart_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: TradePage.quickNavKey('spot'),
      onTap: () => context.go(AppRoutePaths.tradePair(pair.id)),
    ),
    VitTradeHubItem(
      id: 'convert',
      label: 'Convert',
      badge: 'Core',
      icon: Icons.swap_horiz_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: TradePage.quickNavKey('convert'),
      onTap: () => context.go(AppRoutePaths.tradeConvert),
    ),
    VitTradeHubItem(
      id: 'futures',
      label: 'Futures',
      badge: 'Risk',
      icon: Icons.bar_chart_rounded,
      accentColor: AppColors.sell,
      tileKey: TradePage.quickNavKey('futures'),
      onTap: () => context.go(AppRoutePaths.tradeFutures(pair.id)),
    ),
    VitTradeHubItem(
      id: 'margin',
      label: 'Margin',
      badge: 'Pro',
      icon: Icons.trending_up_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: TradePage.quickNavKey('margin'),
      onTap: () => context.go(AppRoutePaths.tradeMargin),
    ),
    VitTradeHubItem(
      id: 'bots',
      label: 'Bot',
      badge: 'Auto',
      icon: Icons.smart_toy_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: TradePage.quickNavKey('bots'),
      onTap: () => context.go(AppRoutePaths.tradeBots),
    ),
    VitTradeHubItem(
      id: 'copy',
      label: 'Copy',
      badge: 'Social',
      icon: Icons.content_copy_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: TradePage.quickNavKey('copy'),
      onTap: () => context.go(AppRoutePaths.tradeCopyTrading),
    ),
    VitTradeHubItem(
      id: 'dca',
      label: 'DCA',
      badge: 'Plan',
      icon: Icons.repeat_rounded,
      accentColor: AppModuleAccents.dca,
      tileKey: TradePage.quickNavKey('dca'),
      onTap: () => context.go(AppRoutePaths.dca),
    ),
    VitTradeHubItem(
      id: 'wallet',
      label: 'Wallet',
      badge: 'Funds',
      icon: Icons.account_balance_wallet_rounded,
      accentColor: AppModuleAccents.wallet,
      tileKey: TradePage.quickNavKey('wallet'),
      onTap: () => context.go(AppRoutePaths.wallet),
    ),
    VitTradeHubItem(
      id: 'p2p',
      label: 'P2P',
      badge: 'Escrow',
      icon: Icons.groups_rounded,
      accentColor: AppModuleAccents.p2p,
      tileKey: TradePage.quickNavKey('p2p'),
      onTap: () => context.go(AppRoutePaths.p2p),
    ),
    VitTradeHubItem(
      id: 'earn',
      label: 'Earn',
      badge: 'Yield',
      icon: Icons.account_balance_rounded,
      accentColor: AppModuleAccents.earn,
      tileKey: TradePage.quickNavKey('earn'),
      onTap: () => context.go(AppRoutePaths.earnStaking),
    ),
    VitTradeHubItem(
      id: 'launchpad',
      label: 'Launchpad',
      badge: 'Token',
      icon: Icons.rocket_launch_rounded,
      accentColor: AppModuleAccents.launchpad,
      tileKey: TradePage.quickNavKey('launchpad'),
      onTap: () => context.go(AppRoutePaths.launchpad),
    ),
    VitTradeHubItem(
      id: 'predictions',
      label: 'Dự đoán',
      badge: 'Market',
      icon: Icons.adjust_rounded,
      accentColor: AppModuleAccents.predictions,
      tileKey: TradePage.quickNavKey('predictions'),
      onTap: () => context.go(AppRoutePaths.marketsPredictions),
    ),
    VitTradeHubItem(
      id: 'arena',
      label: 'Arena',
      badge: 'Points',
      icon: Icons.sports_esports_outlined,
      accentColor: AppModuleAccents.arena,
      tileKey: TradePage.quickNavKey('arena'),
      onTap: () => context.go(AppRoutePaths.arena),
    ),
    VitTradeHubItem(
      id: 'rewards',
      label: 'Rewards',
      badge: 'Growth',
      icon: Icons.card_giftcard_rounded,
      accentColor: AppModuleAccents.rewards,
      tileKey: TradePage.quickNavKey('rewards'),
      onTap: () => context.go(AppRoutePaths.rewards),
    ),
    VitTradeHubItem(
      id: 'support',
      label: 'Hỗ trợ',
      badge: 'Help',
      icon: Icons.support_agent_rounded,
      accentColor: AppModuleAccents.support,
      tileKey: TradePage.quickNavKey('support'),
      onTap: () => context.go(AppRoutePaths.support),
    ),
  ];
}

class _ChartsSubTabs extends StatelessWidget {
  const _ChartsSubTabs({required this.active, required this.onSelected});

  final String active;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      ('orderbook', 'Sổ lệnh', TradePage.orderBookTabKey),
      ('trades', 'Giao dịch', TradePage.tradesTabKey),
    ];
    return VitSegmentedChoice.withPrimaryAccent<String>(
      selected: active,
      onChanged: onSelected,
      options: [
        for (final tab in tabs)
          VitSegmentedChoiceOption(key: tab.$3, value: tab.$1, label: tab.$2),
      ],
    );
  }
}

class _PositionsList extends StatelessWidget {
  const _PositionsList({required this.positions});

  final List<TradePosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return Text(
        'Chưa có vị thế Spot',
        style: AppTextStyles.caption.copyWith(color: AppColors.text3),
      );
    }
    return VitTradeOrderList(
      records: [
        for (final position in positions)
          VitTradeOrderRecord(
            id: position.symbol,
            symbol: position.symbol,
            sideLabel: position.side == TradeOrderSide.buy ? 'MUA' : 'BÁN',
            sideColor: position.side == TradeOrderSide.buy
                ? AppColors.buy
                : AppColors.sell,
            detail:
                '${_formatMoney(position.notional)} · PnL ${_formatMoney(position.pnl)}',
          ),
      ],
      emptyLabel: 'Chưa có vị thế Spot',
    );
  }
}
