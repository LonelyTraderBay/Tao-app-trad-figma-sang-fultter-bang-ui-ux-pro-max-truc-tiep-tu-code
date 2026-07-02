part of 'futures_page.dart';

class _FuturesPageState extends ConsumerState<FuturesPage> {
  final _marginController = TextEditingController();
  TradeFuturesSide _side = TradeFuturesSide.long;
  final int _leverage = 10;

  @override
  void dispose() {
    _marginController.dispose();
    super.dispose();
  }

  void _setPercent(int pct) {
    final value = 5000 * pct / 100;
    setState(() {
      _marginController.text = value.toStringAsFixed(0);
    });
  }

  void _submit() {
    final margin = double.tryParse(_marginController.text) ?? 0;
    final draft = TradeFuturesOrderDraft(
      pairId: widget.pairId,
      side: _side,
      type: TradeFuturesOrderType.market,
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
    final receipt = controller.submit();
    setState(() {
      _marginController.clear();
    });
    if (Scaffold.maybeOf(context) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã gửi ${receipt.orderId}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeFuturesProvider(widget.pairId));
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final productNav = buildTradeProductNavigation(
      context: context,
      pair: pair,
      activeId: 'futures',
      quickNavKey: FuturesPage.quickNavKey,
    );

    return VitTradeSimpleShell(
      title: pair.symbol,
      subtitle: 'Hợp đồng tương lai',
      semanticLabel: 'SC-057 FuturesPage',
      contentKey: const Key('sc057_futures_scroll_content'),
      shellRenderMode: mode,
      showBack: true,
      backKey: FuturesPage.closeKey,
      onBack: () => context.go(AppRoutePaths.tradePair(widget.pairId)),
      children: [
        VitTradeProductTabs(
          activeId: 'futures',
          tabs: productNav.tabs,
          overflowItems: productNav.overflow,
        ),
        VitTradeSimpleHero(
          symbol: pair.symbol,
          priceLabel: formatTradePrice(pair.price),
          changePct: pair.changePct,
          highLabel: formatTradePrice(pair.price * 1.02),
          lowLabel: formatTradePrice(pair.price * 0.98),
          volumeLabel: '1.2B',
        ),
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          density: VitDensity.compact,
          title: 'Rủi ro cao',
          message:
              'Hợp đồng tương lai có thể làm bạn mất toàn bộ ký quỹ. Chỉ dùng số tiền bạn chấp nhận mất.',
          contractId: 'SC-057',
        ),
        VitTradeSection(
          title: 'Giao dịch',
          child: _FuturesSimpleForm(
            snapshot: snapshot,
            pairId: widget.pairId,
            side: _side,
            leverage: _leverage,
            marginController: _marginController,
            onSideChanged: (side) => setState(() => _side = side),
            onPercent: _setPercent,
            onChanged: () => setState(() {}),
            onConfirmedSubmit: _submit,
          ),
        ),
      ],
    );
  }
}

class _FuturesSimpleForm extends ConsumerWidget {
  const _FuturesSimpleForm({
    required this.snapshot,
    required this.pairId,
    required this.side,
    required this.leverage,
    required this.marginController,
    required this.onSideChanged,
    required this.onPercent,
    required this.onChanged,
    required this.onConfirmedSubmit,
  });

  final TradeFuturesSnapshot snapshot;
  final String pairId;
  final TradeFuturesSide side;
  final int leverage;
  final TextEditingController marginController;
  final ValueChanged<TradeFuturesSide> onSideChanged;
  final ValueChanged<int> onPercent;
  final VoidCallback onChanged;
  final VoidCallback onConfirmedSubmit;

  Future<void> _openConfirm(
    BuildContext context,
    TradeFuturesPreview preview,
  ) async {
    if (!preview.canOpen) return;
    final sideLabel = side == TradeFuturesSide.long ? 'Giá tăng' : 'Giá giảm';
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xem lại hợp đồng',
      lines: [
        VitTradeConfirmLine(label: 'Cặp', value: snapshot.pair.symbol),
        VitTradeConfirmLine(label: 'Hướng', value: sideLabel),
        VitTradeConfirmLine(label: 'Đòn bẩy', value: '${leverage}x'),
        VitTradeConfirmLine(
          label: 'Ký quỹ',
          value: '${marginController.text} USDT',
        ),
        VitTradeConfirmLine(
          label: 'Quy mô vị thế',
          value: formatTradeMoney(preview.positionSize),
        ),
        VitTradeConfirmLine(
          label: 'Giá thanh lý',
          value: formatTradePrice(preview.liquidationPrice),
        ),
      ],
      riskMessage:
          'Hợp đồng tương lai có rủi ro cao. Bạn có thể mất toàn bộ ký quỹ.',
    );
    if (confirmed && context.mounted) {
      onConfirmedSubmit();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final margin = double.tryParse(marginController.text) ?? 0;
    final draft = TradeFuturesOrderDraft(
      pairId: pairId,
      side: side,
      type: TradeFuturesOrderType.market,
      margin: margin,
      leverage: leverage,
    );
    final preview = ref
        .watch(
          tradeFuturesOrderControllerProvider((pairId: pairId, draft: draft)),
        )
        .state
        .preview;

    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Bước 1 · Chọn hướng',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          VitSegmentedChoice<TradeFuturesSide>(
            selected: side,
            onChanged: onSideChanged,
            options: [
              VitSegmentedChoiceOption(
                key: FuturesPage.sideKey('long'),
                value: TradeFuturesSide.long,
                label: 'Giá tăng',
                accentColor: _futuresGreen,
                leading: const Icon(Icons.trending_up_rounded),
              ),
              VitSegmentedChoiceOption(
                key: FuturesPage.sideKey('short'),
                value: TradeFuturesSide.short,
                label: 'Giá giảm',
                accentColor: _futuresRed,
                leading: const Icon(Icons.trending_down_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            side == TradeFuturesSide.long
                ? 'Kỳ vọng giá sẽ tăng'
                : 'Kỳ vọng giá sẽ giảm',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Đòn bẩy ${leverage}x',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Bước 2 · Số tiền ký quỹ',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          _MarginInput(controller: marginController, onChanged: onChanged),
          const SizedBox(height: AppSpacing.x3),
          _PercentRow(onPercent: onPercent),
          if (margin > 0) ...[
            const SizedBox(height: AppSpacing.x4),
            _PreviewCard(pair: snapshot.pair, preview: preview),
          ],
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            key: FuturesPage.submitKey,
            onPressed: preview.canOpen
                ? () => _openConfirm(context, preview)
                : null,
            density: VitDensity.compact,
            variant: side == TradeFuturesSide.long
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger,
            child: Text(
              preview.canOpen
                  ? 'Xem lại & xác nhận'
                  : 'Nhập ký quỹ để tiếp tục',
            ),
          ),
        ],
      ),
    );
  }
}
