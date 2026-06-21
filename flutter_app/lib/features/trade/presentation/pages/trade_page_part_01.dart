part of 'trade_page.dart';

class _TradePageState extends ConsumerState<TradePage> {
  late TradeOrderSide _side;
  TradeOrderType _orderType = TradeOrderType.limit;
  String _dataTab = 'chart';
  String _activeTab = 'order';
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

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeScreenProvider(widget.pairId));
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final chromeInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollClearance =
        chromeInset +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? AppSpacing.x6 + AppSpacing.x5
            : AppSpacing.x5 + AppSpacing.x3);
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

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-048 TradePage',
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          key: TradePage.contentKey,
          padding: AppSpacing.zeroInsets.copyWith(bottom: scrollClearance),
          child: VitPageContent(
            padding: VitContentPadding.none,
            density: VitDensity.compact,
            fullBleed: true,
            children: [
              _TradeHeader(
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
              _QuickNavRow(pair: pair),
              _DataTabs(
                active: _dataTab,
                onSelected: (value) => setState(() => _dataTab = value),
              ),
              Padding(
                padding: AppSpacing.zeroInsets.copyWith(
                  left: AppSpacing.contentPad,
                  right: AppSpacing.contentPad,
                ),
                child: _MarketDataPanel(
                  active: _dataTab,
                  snapshot: snapshot,
                  chartVariant: widget.chartVariant,
                ),
              ),
              Padding(
                padding: AppSpacing.contentInsets,
                child: _OrderTabs(
                  active: _activeTab,
                  openCount: snapshot.orders.length + 2,
                  onSelected: (value) => setState(() => _activeTab = value),
                ),
              ),
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
              if (snapshot.highRiskContractId != null) ...[
                Padding(
                  padding: AppSpacing.contentInsets,
                  child: VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    density: VitDensity.compact,
                    title: 'Spot order risk states active',
                    message:
                        'Setup, preview, confirmation, submission, receipt and support use the shared high-risk flow contract.',
                    contractId: snapshot.highRiskContractId,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TradeHeader extends StatelessWidget {
  const _TradeHeader({
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
    return VitTopChrome(
      type: VitTopChromeType.instrument,
      showBack: showBack,
      onBack: onBack,
      backKey: TradePage.backKey,
      leading: VitCard(
        width: AppSpacing.tradeHeaderLogo,
        height: AppSpacing.tradeHeaderLogo,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.lg,
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
      body: Semantics(
        button: true,
        label: 'Ch\u1ECDn c\u1EB7p giao d\u1ECBch ${pair.symbol}',
        child: InkWell(
          onTap: () => context.go(AppRoutePaths.tradePair(pair.id)),
          borderRadius: AppRadii.mdRadius,
          child: Padding(
            padding: AppSpacing.tradeHeaderBodyPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    pair.symbol,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle,
                  ),
                ),
                const SizedBox(width: AppSpacing.tradeHeaderChevronGap),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: AppSpacing.tradeHeaderChevron,
                ),
              ],
            ),
          ),
        ),
      ),
      trailing: SizedBox(
        width: AppSpacing.tradeHeaderTrailingWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatPrice(pair.price),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.buy,
                fontFeatures: AppTextStyles.tabularFigures,
                letterSpacing: .6,
              ),
            ),
            Text(
              '+${pair.changePct.toStringAsFixed(2)}%',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickNavRow extends StatelessWidget {
  const _QuickNavRow({required this.pair});

  final TradePair pair;

  @override
  Widget build(BuildContext context) {
    final items = [
      _TradeHubItem(
        id: 'spot',
        label: 'Spot',
        badge: 'Core',
        icon: Icons.show_chart_rounded,
        color: AppModuleAccents.trade,
        route: AppRoutePaths.tradePair(pair.id),
      ),
      const _TradeHubItem(
        id: 'convert',
        label: 'Convert',
        badge: 'Core',
        icon: Icons.swap_horiz_rounded,
        color: AppModuleAccents.trade,
        route: AppRoutePaths.tradeConvert,
      ),
      _TradeHubItem(
        id: 'futures',
        label: 'Futures',
        badge: 'Risk',
        icon: Icons.bar_chart_rounded,
        color: AppColors.sell,
        route: AppRoutePaths.tradeFutures(pair.id),
      ),
      const _TradeHubItem(
        id: 'margin',
        label: 'Margin',
        badge: 'Pro',
        icon: Icons.trending_up_rounded,
        color: AppModuleAccents.trade,
        route: AppRoutePaths.tradeMargin,
      ),
      const _TradeHubItem(
        id: 'bots',
        label: 'Bot',
        badge: 'Auto',
        icon: Icons.smart_toy_rounded,
        color: AppModuleAccents.trade,
        route: AppRoutePaths.tradeBots,
      ),
      const _TradeHubItem(
        id: 'copy',
        label: 'Copy',
        badge: 'Social',
        icon: Icons.content_copy_rounded,
        color: AppModuleAccents.trade,
        route: AppRoutePaths.tradeCopyTrading,
      ),
      const _TradeHubItem(
        id: 'dca',
        label: 'DCA',
        badge: 'Plan',
        icon: Icons.repeat_rounded,
        color: AppModuleAccents.dca,
        route: AppRoutePaths.dca,
      ),
      const _TradeHubItem(
        id: 'wallet',
        label: 'Wallet',
        badge: 'Funds',
        icon: Icons.account_balance_wallet_rounded,
        color: AppModuleAccents.wallet,
        route: AppRoutePaths.wallet,
      ),
      const _TradeHubItem(
        id: 'p2p',
        label: 'P2P',
        badge: 'Escrow',
        icon: Icons.groups_rounded,
        color: AppModuleAccents.p2p,
        route: AppRoutePaths.p2p,
      ),
      const _TradeHubItem(
        id: 'earn',
        label: 'Earn',
        badge: 'Yield',
        icon: Icons.account_balance_rounded,
        color: AppModuleAccents.earn,
        route: AppRoutePaths.earnStaking,
      ),
      const _TradeHubItem(
        id: 'launchpad',
        label: 'Launchpad',
        badge: 'Token',
        icon: Icons.rocket_launch_rounded,
        color: AppModuleAccents.launchpad,
        route: AppRoutePaths.launchpad,
      ),
      const _TradeHubItem(
        id: 'predictions',
        label: 'Dự đoán',
        badge: 'Market',
        icon: Icons.adjust_rounded,
        color: AppModuleAccents.predictions,
        route: AppRoutePaths.marketsPredictions,
      ),
      const _TradeHubItem(
        id: 'arena',
        label: 'Arena',
        badge: 'Points',
        icon: Icons.sports_esports_outlined,
        color: AppModuleAccents.arena,
        route: AppRoutePaths.arena,
      ),
      const _TradeHubItem(
        id: 'rewards',
        label: 'Rewards',
        badge: 'Growth',
        icon: Icons.card_giftcard_rounded,
        color: AppModuleAccents.rewards,
        route: AppRoutePaths.rewards,
      ),
      const _TradeHubItem(
        id: 'support',
        label: 'Hỗ trợ',
        badge: 'Help',
        icon: Icons.support_agent_rounded,
        color: AppModuleAccents.support,
        route: AppRoutePaths.support,
      ),
    ];

    return SizedBox(
      height: _tradeCompactQuickNavHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.contentPad,
          right: AppSpacing.contentPad,
        ),
        children: [
          for (final item in items)
            _QuickNavChip(
              key: TradePage.quickNavKey(item.id),
              icon: item.icon,
              label: item.label,
              badge: item.badge,
              color: item.color,
              onTap: () => context.go(item.route),
            ),
        ],
      ),
    );
  }
}

class _TradeHubItem {
  const _TradeHubItem({
    required this.id,
    required this.label,
    required this.badge,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String id;
  final String label;
  final String badge;
  final IconData icon;
  final Color color;
  final String route;
}

class _QuickNavChip extends StatelessWidget {
  const _QuickNavChip({
    super.key,
    required this.icon,
    required this.label,
    required this.badge,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String badge;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.zeroInsets.copyWith(right: AppSpacing.x2),
      child: VitCard(
        onTap: onTap,
        width: _tradeCompactQuickChipWidth,
        density: VitDensity.tool,
        padding: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.x3,
          top: AppSpacing.x2,
          right: AppSpacing.x3,
          bottom: AppSpacing.x2,
        ),
        radius: VitCardRadius.sm,
        borderColor: color.withValues(alpha: .24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x1),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x1),
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.x7 + AppSpacing.x5,
                ),
                child: VitAccentPill(label: badge, accentColor: color),
              ),
            ),
          ],
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
      padding: AppSpacing.contentInsets,
      child: VitCard(
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
    return VitCard(
      height: _tradeCompactChartHeight,
      borderColor: _tradePrimary.withValues(alpha: .35),
      clip: true,
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
            left: AppSpacing.tradeChartOverlayInset,
            top: AppSpacing.tradeChartOverlayTop,
            child: pairRoute
                ? const VitStatusPill(
                    label: '24H',
                    status: VitStatusPillStatus.error,
                    size: VitStatusPillSize.sm,
                  )
                : VitCard(
                    width: AppSpacing.tradeChartLogoSize,
                    height: AppSpacing.tradeChartLogoSize,
                    variant: VitCardVariant.ghost,
                    radius: VitCardRadius.lg,
                    borderColor: AppColors.sell.withValues(alpha: .30),
                    child: const SizedBox.shrink(),
                  ),
          ),
          Positioned(
            left: AppSpacing.tradeChartTvLeft,
            bottom: AppSpacing.tradeChartTvBottom,
            child: Text(
              'TV',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.onAccent,
              ),
            ),
          ),
          if (pairRoute) ...[
            Positioned(
              right: AppSpacing.tradeChartOverlayInset,
              top: AppSpacing.tradeChartPriceRightTop,
              child: Text(
                '70000.00',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3.withValues(alpha: .85),
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.tradeChartOverlayInset,
              bottom: AppSpacing.tradeChartPriceRightBottom,
              child: Text(
                '68000.00',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3.withValues(alpha: .85),
                ),
              ),
            ),
          ],
          Positioned(
            right: AppSpacing.tradeChartPriceRight,
            top: pairRoute
                ? AppSpacing.tradeChartPriceTopPair
                : AppSpacing.tradeChartPriceTopDefault,
            child: _PriceBadge(
              label: pairRoute ? '70821.46' : '67545.13',
              color: AppColors.sell,
            ),
          ),
          Positioned(
            right: AppSpacing.tradeChartPriceRight,
            top: pairRoute
                ? AppSpacing.tradeChartPriceTopPairSecond
                : AppSpacing.tradeChartPriceTopDefaultSecond,
            child: _PriceBadge(
              label: pairRoute ? '70821.46' : '67254.13',
              color: AppColors.buy,
            ),
          ),
          Positioned(
            right: AppSpacing.tradeChartPriceRight,
            bottom: AppSpacing.tradeChartTvBottom,
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
