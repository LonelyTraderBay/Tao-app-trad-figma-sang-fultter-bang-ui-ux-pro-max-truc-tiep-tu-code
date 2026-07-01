part of 'futures_page.dart';

class _FuturesPageState extends ConsumerState<FuturesPage> {
  final _marginController = TextEditingController();
  TradeFuturesSide _side = TradeFuturesSide.long;
  TradeFuturesOrderType _orderType = TradeFuturesOrderType.market;
  VitTradeViewMode _viewMode = VitTradeViewMode.charts;
  String _chartsSubTab = 'orderbook';
  String _dockTab = 'positions';
  final int _leverage = 10;
  bool _takeProfit = false;
  bool _stopLoss = false;
  TradeFuturesReceipt? _receipt;

  @override
  void dispose() {
    _marginController.dispose();
    super.dispose();
  }

  VitOrderBookPanel _orderBookPanel(TradeFuturesSnapshot snapshot) {
    final book = snapshot.trade.orderBook;
    return VitOrderBookPanel(
      density: _viewMode == VitTradeViewMode.trade
          ? VitOrderBookPanelDensity.compact
          : VitOrderBookPanelDensity.standard,
      asks: [
        for (final level in book.asks)
          VitOrderBookLevel(
            price: level.price,
            amount: level.amount,
            total: level.total,
          ),
      ],
      bids: [
        for (final level in book.bids)
          VitOrderBookLevel(
            price: level.price,
            amount: level.amount,
            total: level.total,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeFuturesProvider(widget.pairId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance = tradeTerminalScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    final tradeForm = _TradeTab(
      snapshot: snapshot,
      pairId: widget.pairId,
      side: _side,
      orderType: _orderType,
      leverage: _leverage,
      marginController: _marginController,
      takeProfit: _takeProfit,
      stopLoss: _stopLoss,
      receipt: _receipt,
      compact: _viewMode == VitTradeViewMode.trade,
      onSideChanged: (side) => setState(() {
        _side = side;
        _receipt = null;
      }),
      onOrderTypeChanged: (type) => setState(() {
        _orderType = type;
        _receipt = null;
      }),
      onLeverage: () =>
          context.go(AppRoutePaths.tradeFuturesLeverage(widget.pairId)),
      onPercent: _setPercent,
      onChanged: () => setState(() => _receipt = null),
      onTakeProfit: () => setState(() => _takeProfit = !_takeProfit),
      onStopLoss: () => setState(() => _stopLoss = !_stopLoss),
      onSubmit: _submit,
    );

    final bodyChildren = <Widget>[
      if (_viewMode == VitTradeViewMode.charts) ...[
        VitTradeChartPanel(variant: VitTradeChartVariant.pairRoute),
        const SizedBox(height: AppSpacing.x3),
        _FuturesChartsSubTabs(
          active: _chartsSubTab,
          onSelected: (value) => setState(() => _chartsSubTab = value),
        ),
        const SizedBox(height: AppSpacing.x3),
        if (_chartsSubTab == 'orderbook')
          _orderBookPanel(snapshot)
        else
          VitTradesTapePanel(
            trades: [
              for (final trade in snapshot.trade.trades)
                VitTradesTapePrint(
                  price: trade.price,
                  amount: trade.amount,
                  time: trade.time,
                  isBuy: trade.isBuy,
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.x3),
        tradeForm,
      ] else ...[
        VitTradeSplitPanel(
          form: tradeForm,
          marketPanel: _orderBookPanel(snapshot),
        ),
      ],
    ];

    return VitTradeTerminalLayout(
      semanticLabel: 'SC-057 FuturesPage',
      scrollKey: const Key('sc057_futures_scroll_content'),
      scrollBottomInset: scrollClearance,
      header: VitTradeTerminalHeader(
        symbol: snapshot.pair.symbol,
        showBack: true,
        onBack: () => context.go(AppRoutePaths.tradePair(widget.pairId)),
        backKey: FuturesPage.closeKey,
        onPairTap: () => context.go(AppRoutePaths.tradePair(widget.pairId)),
        trailing: VitIconButton(
          key: FuturesPage.chartKey,
          icon: Icons.trending_up_rounded,
          tooltip: 'Open futures chart',
          onPressed: () =>
              context.go(AppRoutePaths.tradeAdvancedChart(widget.pairId)),
          variant: VitIconButtonVariant.ghost,
          size: VitIconButtonSize.md,
        ),
        subtitle: Text(
          '${_formatMoney(snapshot.pair.price)} (+${snapshot.pair.changePct.toStringAsFixed(2)}%)',
          style: AppTextStyles.numericCode.copyWith(
            color: _futuresGreen,
            height: AppSpacing.futuresPriceLineHeight,
          ),
        ),
      ),
      ticker: VitTradeTickerStrip(
        symbol: snapshot.pair.symbol,
        priceLabel: _formatFuturesPrice(snapshot.pair.price),
        changePct: snapshot.pair.changePct,
        highLabel: _formatFuturesPrice(snapshot.pair.price * 1.02),
        lowLabel: _formatFuturesPrice(snapshot.pair.price * 0.98),
        volumeLabel: '1.2B',
        trailing: const VitStatusPill(
          label: 'FUTURES',
          status: VitStatusPillStatus.error,
          size: VitStatusPillSize.sm,
        ),
      ),
      productTabs: VitTradeProductTabs(
        activeId: 'futures',
        tabs: [
          VitTradeProductTab(
            id: 'spot',
            label: 'Spot',
            onTap: () => context.go(AppRoutePaths.tradePair(widget.pairId)),
          ),
          VitTradeProductTab(
            id: 'futures',
            label: 'Futures',
            onTap: () {},
          ),
          VitTradeProductTab(
            id: 'margin',
            label: 'Margin',
            onTap: () => context.go(AppRoutePaths.tradeMargin),
          ),
          VitTradeProductTab(
            id: 'convert',
            label: 'Convert',
            onTap: () => context.go(AppRoutePaths.tradeConvert),
          ),
        ],
      ),
      viewModeToggle: VitTradeViewModeToggle(
        mode: _viewMode,
        chartsKey: FuturesPage.viewModeChartsKey,
        tradeKey: FuturesPage.viewModeTradeKey,
        onChanged: (value) => setState(() => _viewMode = value),
      ),
      bodyChildren: bodyChildren,
      portfolioPanel: VitTradePortfolioPanel(
        expandKey: FuturesPage.portfolioExpandKey,
        activeKey: _dockTab,
        onChanged: (value) => setState(() => _dockTab = value),
        tabs: [
          VitTabItem(
            key: 'positions',
            label: 'Vị thế (${snapshot.positions.length})',
            widgetKey: FuturesPage.tabKey('positions'),
          ),
          VitTabItem(
            key: 'orders',
            label: 'Lệnh',
            widgetKey: FuturesPage.tabKey('orders'),
          ),
        ],
        child: _dockTab == 'orders'
            ? _OrdersTab(onTrade: () => setState(() => _dockTab = 'positions'))
            : _PositionsTab(snapshot: snapshot),
      ),
    );
  }

  void _setPercent(int pct) {
    final value = 5000 * pct / 100;
    setState(() {
      _marginController.text = value.toStringAsFixed(0);
      _receipt = null;
    });
  }

  void _submit() {
    final margin = double.tryParse(_marginController.text) ?? 0;
    final draft = TradeFuturesOrderDraft(
      pairId: widget.pairId,
      side: _side,
      type: _orderType,
      margin: margin,
      leverage: _leverage,
    );
    final controller = ref.read(
      tradeFuturesOrderControllerProvider((
        pairId: widget.pairId,
        draft: draft,
      )),
    );
    if (!controller.canSubmit) return;
    setState(() {
      _receipt = controller.submit();
      _marginController.clear();
    });
  }
}

class _FuturesChartsSubTabs extends StatelessWidget {
  const _FuturesChartsSubTabs({required this.active, required this.onSelected});

  final String active;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice.withPrimaryAccent<String>(
      selected: active,
      onChanged: onSelected,
      options: [
        VitSegmentedChoiceOption(
          key: FuturesPage.orderBookTabKey,
          value: 'orderbook',
          label: 'Sổ lệnh',
        ),
        VitSegmentedChoiceOption(
          key: FuturesPage.tradesTabKey,
          value: 'trades',
          label: 'Giao dịch',
        ),
      ],
    );
  }
}

class _FuturesHeader extends StatelessWidget {
  const _FuturesHeader({
    required this.pair,
    required this.onClose,
    required this.onChart,
  });

  final TradePair pair;
  final VoidCallback onClose;
  final VoidCallback onChart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonStandard + AppSpacing.hairlineStroke,
      child: Row(
        children: [
          VitIconButton(
            key: FuturesPage.closeKey,
            icon: Icons.close_rounded,
            tooltip: 'Close futures',
            onPressed: onClose,
            variant: VitIconButtonVariant.ghost,
            size: VitIconButtonSize.md,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pair.symbol,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    const VitStatusPill(
                      label: 'FUTURES',
                      status: VitStatusPillStatus.error,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.formFieldLabelGap),
                Text(
                  '${_formatMoney(pair.price)} (+${pair.changePct.toStringAsFixed(2)}%)',
                  style: AppTextStyles.numericCode.copyWith(
                    color: _futuresGreen,
                    height: AppSpacing.futuresPriceLineHeight,
                  ),
                ),
              ],
            ),
          ),
          VitIconButton(
            key: FuturesPage.chartKey,
            icon: Icons.trending_up_rounded,
            tooltip: 'Open futures chart',
            onPressed: onChart,
            variant: VitIconButtonVariant.ghost,
            size: VitIconButtonSize.md,
          ),
        ],
      ),
    );
  }
}

class _TradeTab extends ConsumerWidget {
  const _TradeTab({
    required this.snapshot,
    required this.pairId,
    required this.side,
    required this.orderType,
    required this.leverage,
    required this.marginController,
    required this.takeProfit,
    required this.stopLoss,
    required this.receipt,
    required this.compact,
    required this.onSideChanged,
    required this.onOrderTypeChanged,
    required this.onLeverage,
    required this.onPercent,
    required this.onChanged,
    required this.onTakeProfit,
    required this.onStopLoss,
    required this.onSubmit,
  });

  final TradeFuturesSnapshot snapshot;
  final String pairId;
  final TradeFuturesSide side;
  final TradeFuturesOrderType orderType;
  final int leverage;
  final TextEditingController marginController;
  final bool takeProfit;
  final bool stopLoss;
  final TradeFuturesReceipt? receipt;
  final bool compact;
  final ValueChanged<TradeFuturesSide> onSideChanged;
  final ValueChanged<TradeFuturesOrderType> onOrderTypeChanged;
  final VoidCallback onLeverage;
  final ValueChanged<int> onPercent;
  final VoidCallback onChanged;
  final VoidCallback onTakeProfit;
  final VoidCallback onStopLoss;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final margin = double.tryParse(marginController.text) ?? 0;
    final draft = TradeFuturesOrderDraft(
      pairId: pairId,
      side: side,
      type: orderType,
      margin: margin,
      leverage: leverage,
    );
    final preview = ref
        .watch(
          tradeFuturesOrderControllerProvider((pairId: pairId, draft: draft)),
        )
        .state
        .preview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MarketStats(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x3),
        _SideSwitch(side: side, onChanged: onSideChanged),
        const SizedBox(height: AppSpacing.x3),
        _OrderTypeAndLeverage(
          orderType: orderType,
          leverage: leverage,
          onOrderTypeChanged: onOrderTypeChanged,
          onLeverage: onLeverage,
        ),
        const SizedBox(height: AppSpacing.x3),
        _MarginInput(controller: marginController, onChanged: onChanged),
        const SizedBox(height: AppSpacing.x3),
        _PercentRow(onPercent: onPercent),
        if (margin > 0 && !compact) ...[
          const SizedBox(height: AppSpacing.x3),
          _PreviewCard(pair: snapshot.pair, preview: preview),
        ],
        if (margin > 0 && compact) ...[
          const SizedBox(height: AppSpacing.x2),
          _PreviewCard(pair: snapshot.pair, preview: preview),
        ],
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: _ToggleChip(
                key: FuturesPage.takeProfitKey,
                label: 'Take Profit',
                icon: Icons.gps_fixed_rounded,
                active: takeProfit,
                activeColor: _futuresGreen,
                onTap: onTakeProfit,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _ToggleChip(
                key: FuturesPage.stopLossKey,
                label: 'Stop Loss',
                icon: Icons.shield_outlined,
                active: stopLoss,
                activeColor: _futuresRed,
                onTap: onStopLoss,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        _SubmitButton(
          side: side,
          enabled: preview.canOpen,
          receipt: receipt,
          leverage: leverage,
          onTap: onSubmit,
        ),
        if (!compact) ...[
          const SizedBox(height: AppSpacing.rowPy),
          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Futures margin review',
            message:
                'Review leverage, margin, liquidation price, fees, TP/SL, and order side before opening a futures position.',
            contractId: 'SC-057',
          ),
          const SizedBox(height: AppSpacing.x3),
          const VitBanner(
            variant: VitBannerVariant.warning,
            icon: Icons.warning_amber_rounded,
            message:
                'Giao dịch hợp đồng tương lai có rủi ro cao. Bạn có thể mất toàn bộ ký quỹ. Chỉ giao dịch số tiền bạn có thể chấp nhận mất.',
          ),
          const SizedBox(height: AppSpacing.x3),
          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Futures order review',
            message:
                'Leverage limit, margin, liquidation price, fee preview, TP/SL, and order side must be reviewed before confirmation.',
            contractId: 'SC-057',
          ),
        ],
      ],
    );
  }
}

class _MarketStats extends StatelessWidget {
  const _MarketStats({required this.snapshot});

  final TradeFuturesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Mark Price', _formatMoney(snapshot.markPrice), AppColors.text1),
      ('Index', '\$${snapshot.indexPrice.toStringAsFixed(2)}', AppColors.text1),
      ('Funding', '+${snapshot.fundingRate.toStringAsFixed(2)}%', _futuresRed),
    ];
    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          Expanded(
            child: VitCard(
              variant: VitCardVariant.inner,
              height: AppSpacing.futuresMarketStatCardHeight,
              padding: AppSpacing.zeroInsets.copyWith(
                left: AppSpacing.x3,
                right: AppSpacing.x3,
              ),
              borderColor: AppColors.onAccent.withValues(alpha: .06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stats[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.amountSm.copyWith(
                      color: stats[i].$3,
                      fontWeight: AppTextStyles.bold,
                      height: AppSpacing.futuresPriceLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.formFieldLabelGap),
                  Text(
                    stats[i].$1,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
          if (i != stats.length - 1) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}
