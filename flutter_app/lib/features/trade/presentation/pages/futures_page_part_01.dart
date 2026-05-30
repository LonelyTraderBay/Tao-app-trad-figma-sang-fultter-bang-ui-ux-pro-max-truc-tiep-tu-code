part of 'futures_page.dart';

class _FuturesPageState extends ConsumerState<FuturesPage> {
  final _marginController = TextEditingController();
  TradeFuturesSide _side = TradeFuturesSide.long;
  TradeFuturesOrderType _orderType = TradeFuturesOrderType.market;
  String _tab = 'trade';
  final int _leverage = 10;
  bool _takeProfit = false;
  bool _stopLoss = false;
  TradeFuturesReceipt? _receipt;

  @override
  void dispose() {
    _marginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeFuturesProvider(widget.pairId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 34 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-057 FuturesPage',
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FuturesHeader(
                pair: snapshot.pair,
                onClose: () =>
                    context.go(AppRoutePaths.tradePair(widget.pairId)),
                onChart: () =>
                    context.go(AppRoutePaths.tradeAdvancedChart(widget.pairId)),
              ),
              const SizedBox(height: 20),
              _FuturesTabs(
                active: _tab,
                positionCount: snapshot.positions.length,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
              const SizedBox(height: 12),
              if (_tab == 'trade')
                _TradeTab(
                  snapshot: snapshot,
                  pairId: widget.pairId,
                  side: _side,
                  orderType: _orderType,
                  leverage: _leverage,
                  marginController: _marginController,
                  takeProfit: _takeProfit,
                  stopLoss: _stopLoss,
                  receipt: _receipt,
                  onSideChanged: (side) => setState(() {
                    _side = side;
                    _receipt = null;
                  }),
                  onOrderTypeChanged: (type) => setState(() {
                    _orderType = type;
                    _receipt = null;
                  }),
                  onLeverage: () => context.go(
                    AppRoutePaths.tradeFuturesLeverage(widget.pairId),
                  ),
                  onPercent: _setPercent,
                  onChanged: () => setState(() => _receipt = null),
                  onTakeProfit: () =>
                      setState(() => _takeProfit = !_takeProfit),
                  onStopLoss: () => setState(() => _stopLoss = !_stopLoss),
                  onSubmit: _submit,
                )
              else if (_tab == 'positions')
                _PositionsTab(snapshot: snapshot)
              else
                _OrdersTab(onTrade: () => setState(() => _tab = 'trade')),
            ],
          ),
        ),
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
      height: AppSpacing.buttonStandard,
      child: Row(
        children: [
          InkWell(
            key: FuturesPage.closeKey,
            onTap: onClose,
            borderRadius: AppRadii.lgRadius,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.onAccent.withValues(alpha: .05),
                borderRadius: AppRadii.lgRadius,
              ),
              child: const Icon(Icons.close_rounded, color: AppColors.text1),
            ),
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
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 17),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _futuresRed.withValues(alpha: .16),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'FUTURES',
                        style: AppTextStyles.micro.copyWith(
                          color: _futuresRed,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${_formatMoney(pair.price)} (+${pair.changePct.toStringAsFixed(2)}%)',
                  style: AppTextStyles.caption.copyWith(
                    color: _futuresGreen,
                    fontSize: 13,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            key: FuturesPage.chartKey,
            onTap: onChart,
            borderRadius: AppRadii.lgRadius,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.onAccent.withValues(alpha: .05),
                borderRadius: AppRadii.lgRadius,
              ),
              child: const Icon(
                Icons.trending_up_rounded,
                color: AppColors.text2,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FuturesTabs extends StatelessWidget {
  const _FuturesTabs({
    required this.active,
    required this.positionCount,
    required this.onChanged,
  });

  final String active;
  final int positionCount;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('trade', 'Giao dịch', Icons.bolt_rounded),
      ('positions', 'Vị thế ($positionCount)', Icons.bar_chart_rounded),
      ('orders', 'Lệnh', Icons.receipt_long_rounded),
    ];
    return Container(
      height: AppSpacing.inputHeight,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _chipBackground,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: FuturesPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                borderRadius: AppRadii.inputRadius,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active == tab.$1
                        ? _tradePrimary
                        : AppColors.transparent,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab.$3,
                        color: active == tab.$1
                            ? AppColors.onAccent
                            : AppColors.text3,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab.$1
                                ? AppColors.onAccent
                                : AppColors.text3,
                            fontSize: 13,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
        const SizedBox(height: 12),
        _SideSwitch(side: side, onChanged: onSideChanged),
        const SizedBox(height: 12),
        _OrderTypeAndLeverage(
          orderType: orderType,
          leverage: leverage,
          onOrderTypeChanged: onOrderTypeChanged,
          onLeverage: onLeverage,
        ),
        const SizedBox(height: 12),
        _MarginInput(controller: marginController, onChanged: onChanged),
        const SizedBox(height: 12),
        _PercentRow(onPercent: onPercent),
        const SizedBox(height: 12),
        if (margin > 0) ...[
          _PreviewCard(pair: snapshot.pair, preview: preview),
          const SizedBox(height: 12),
        ],
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
            const SizedBox(width: 8),
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
        const SizedBox(height: 12),
        _SubmitButton(
          side: side,
          enabled: preview.canOpen,
          receipt: receipt,
          leverage: leverage,
          onTap: onSubmit,
        ),
        const SizedBox(height: 14),
        const _RiskWarning(),
        const SizedBox(height: 12),
        const _FuturesSafetyChecklist(),
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
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: _panelBackground,
                border: Border.all(
                  color: AppColors.onAccent.withValues(alpha: .06),
                ),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stats[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: stats[i].$3,
                      fontSize: 20,
                      fontFamily: 'monospace',
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stats[i].$1,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i != stats.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}
