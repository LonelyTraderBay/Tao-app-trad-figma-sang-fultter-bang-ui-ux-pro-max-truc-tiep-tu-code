part of 'trade_page.dart';

class _TradePageState extends ConsumerState<TradePage> {
  late TradeOrderSide _side;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _side = widget.initialSide;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitOrder(TradeOrderController orderController) {
    final receipt = orderController.submit();
    context.go(AppRoutePaths.tradeOrderReceipt);
    if (context.mounted) {
      showVitNoticeSheet(
        context: context,
        title: 'Lệnh đã gửi',
        message: 'Đã gửi ${receipt.orderId}',
        variant: VitBannerVariant.success,
      );
    }
  }

  _TradeNextAction _resolveNextAction(TradeScreenSnapshot snapshot) {
    if (snapshot.orders.isNotEmpty) {
      return _TradeNextAction(
        icon: Icons.pending_actions_outlined,
        title: 'Hoàn tất lệnh đang chờ',
        subtitle: 'Bạn có ${snapshot.orders.length} lệnh mở cần theo dõi',
        statusLabel: 'Lệnh mở',
        ctaLabel: 'Xem lệnh',
        onTap: () => context.push(AppRoutePaths.tradeOrdersHistory),
      );
    }
    if (snapshot.positions.isEmpty) {
      return _TradeNextAction(
        icon: Icons.play_circle_outline_rounded,
        title: 'Bắt đầu giao dịch đầu tiên',
        subtitle: 'Chọn MUA hoặc BÁN, nhập số lượng và xác nhận',
        statusLabel: 'Mới',
        ctaLabel: 'Bắt đầu',
        onTap: () {
          HapticFeedback.selectionClick();
          showVitNoticeSheet(
            context: context,
            title: 'Bắt đầu giao dịch',
            message: 'Tính năng bắt đầu giao dịch sẽ sớm ra mắt',
          );
        },
      );
    }
    return _TradeNextAction(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Theo dõi tài sản Spot',
      subtitle: 'Bạn đang giữ ${snapshot.positions.length} vị thế',
      statusLabel: 'Vị thế',
      ctaLabel: 'Xem',
      onTap: () => context.push(AppRoutePaths.tradePositions),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeScreenProvider(widget.pairId));
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final amount = double.tryParse(_amountController.text) ?? 0;
    final draft = TradeOrderDraft(
      pairId: pair.id,
      side: _side,
      type: TradeOrderType.market,
      price: pair.price,
      amount: amount,
    );
    final orderController = ref.watch(
      tradeOrderControllerProvider((pairId: widget.pairId, draft: draft)),
    );
    final preview = orderController.state.preview;
    final canSubmit = orderController.canSubmit;
    final showBack =
        widget.chartVariant == TradeChartVariant.pairRoute || context.canPop();
    final marketPrice = formatTradePrice(pair.price);
    final nextAction = _resolveNextAction(snapshot);
    final availableBalanceLabel = _side == TradeOrderSide.buy
        ? '${formatTradeMoney(snapshot.balances.usdtAvailable)} USDT'
        : '${formatTradeMoney(snapshot.balances.baseAvailable)} ${pair.baseAsset}';

    return VitTradeSimpleShell(
      title: pair.symbol,
      subtitle: 'Giao dịch Spot',
      semanticLabel: 'SC-048 TradePage',
      contentKey: TradePage.contentKey,
      shellRenderMode: mode,
      showBack: showBack,
      backKey: TradePage.backKey,
      onBack: showBack
          ? () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.trade,
              mode: BackNavigationMode.historyThenFallback,
            )
          : null,
      activeProductId: 'spot',
      productPair: pair,
      quickNavKey: TradePage.quickNavKey,
      children: [
        VitTradeSimpleHero(
          symbol: pair.symbol,
          priceLabel: marketPrice,
          changePct: pair.changePct,
          availableBalanceLabel: availableBalanceLabel,
        ),
        VitTradeSimpleOrderForm(
          side: _side,
          pair: pair,
          balances: snapshot.balances,
          amountController: _amountController,
          preview: preview,
          canSubmit: canSubmit,
          marketPriceLabel: marketPrice,
          buyKey: TradePage.buySideKey,
          sellKey: TradePage.sellSideKey,
          amountFieldKey: TradePage.amountFieldKey,
          submitKey: TradePage.submitKey,
          pctKeyBuilder: TradePage.pctKey,
          onSideChanged: (side) => setState(() => _side = side),
          onPct: (pct) => setState(() {
            final available = _side == TradeOrderSide.buy
                ? snapshot.balances.usdtAvailable / pair.price
                : snapshot.balances.baseAvailable;
            _amountController.text = (available * pct / 100).toStringAsFixed(6);
          }),
          onChanged: () => setState(() {}),
          onConfirmedSubmit: () => _submitOrder(orderController),
        ),
        if (snapshot.highRiskContractId != null)
          VitTradeSection(
            title: 'Đánh giá rủi ro',
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Review spot order risk',
              message:
                  'Preview fees, slippage, and available balance before submitting a market order.',
              contractId: snapshot.highRiskContractId,
              density: VitDensity.compact,
            ),
          ),
        VitTradeSection(
          title: 'Tiếp theo',
          child: VitNextActionCard(
            key: TradePage.nextActionKey,
            icon: nextAction.icon,
            title: nextAction.title,
            subtitle: nextAction.subtitle,
            statusLabel: nextAction.statusLabel,
            ctaLabel: nextAction.ctaLabel,
            accentColor: AppModuleAccents.trade,
            onTap: nextAction.onTap,
          ),
        ),
        VitTradeSection(
          title: 'Tài sản của bạn',
          actionLabel: snapshot.positions.isNotEmpty ? 'Xem tất cả' : null,
          onAction: snapshot.positions.isNotEmpty
              ? () => context.push(AppRoutePaths.tradePositions)
              : null,
          child: _SimplePositionsList(positions: snapshot.positions),
        ),
      ],
    );
  }
}

class _TradeNextAction {
  const _TradeNextAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.ctaLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String statusLabel;
  final String ctaLabel;
  final VoidCallback onTap;
}

class _SimplePositionsList extends StatelessWidget {
  const _SimplePositionsList({required this.positions});

  final List<TradePosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return VitEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Chưa có tài sản Spot',
        message: 'Mua coin đầu tiên để bắt đầu.',
      );
    }

    final visible = positions.take(3).toList();
    return VitTradeOrderList(
      records: [
        for (final position in visible)
          VitTradeOrderRecord(
            id: position.symbol,
            symbol: position.symbol,
            sideLabel: position.side == TradeOrderSide.buy ? 'MUA' : 'BÁN',
            sideColor: position.side == TradeOrderSide.buy
                ? AppColors.buy
                : AppColors.sell,
            detail:
                '${formatTradeMoney(position.notional)} · PnL ${formatTradeMoney(position.pnl)}',
          ),
      ],
      emptyLabel: 'Chưa có tài sản Spot',
    );
  }
}
