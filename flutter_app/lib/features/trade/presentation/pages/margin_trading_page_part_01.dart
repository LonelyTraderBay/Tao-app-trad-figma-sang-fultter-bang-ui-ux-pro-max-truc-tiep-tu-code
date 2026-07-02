part of 'margin_trading_page.dart';

class _ClientCategoryCard extends StatelessWidget {
  const _ClientCategoryCard({required this.category});

  final TradeMarginClientCategory category;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginAmber.withValues(alpha: .06),
      borderColor: _marginAmber.withValues(alpha: .28),
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.walletAssetSectionGap,
        top: AppSpacing.walletTransactionProgressBottomGap,
        right: AppSpacing.walletAssetSectionGap,
        bottom: AppSpacing.walletAssetSectionGap,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MarginIconSurface(
            icon: Icons.shield_outlined,
            color: _marginAmber,
            size: AppSpacing.walletAddressIconSize,
            iconSize: AppSpacing.walletAssetActionIconInner,
          ),
          const SizedBox(width: AppSpacing.rowPy),
          Expanded(
            child: VitPageContent(
              padding: VitContentPadding.none,
              density: VitDensity.compact,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.title,
                        style: AppTextStyles.body.copyWith(
                          color: _marginAmber,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    VitStatusPill(
                      label: category.badgeLabel,
                      status: VitStatusPillStatus.warning,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                Text(
                  category.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                VitPageContent(
                  padding: VitContentPadding.none,
                  density: VitDensity.compact,
                  children: [
                    for (final limit in category.limits)
                      _Bullet(text: limit, color: _marginAmber),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
    required this.keyBuilder,
  });

  final List<TradeMarginTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;
  final Key Function(String id) keyBuilder;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: keyBuilder(tab.id),
          ),
      ],
    );
  }
}

class _AccountHero extends StatelessWidget {
  const _AccountHero({required this.account, required this.totalPnl});

  final TradeMarginAccount account;
  final double totalPnl;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginHero,
      borderColor: _marginHeroBorder,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowPy,
        top: AppSpacing.walletAssetChartBottomGap,
        right: AppSpacing.rowPy,
        bottom: AppSpacing.walletAssetChartBottomGap,
      ),
      child: VitPageContent(
        padding: VitContentPadding.none,
        density: VitDensity.compact,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng vốn ký quỹ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      _formatMoney(account.totalEquity),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.onAccent,
                      ),
                    ),
                  ],
                ),
              ),
              VitStatusPill(
                label: '+${_formatMoneyCompact(totalPnl)}',
                status: VitStatusPillStatus.success,
                icon: Icons.trending_up_rounded,
                size: VitStatusPillSize.lg,
              ),
            ],
          ),
          Row(
            children: [
              _HeroStat(
                label: 'Margin đã dùng',
                value: _formatMoneyCompact(account.totalMargin),
                color: _marginAmber,
              ),
              const SizedBox(width: AppSpacing.walletAssetChartBottomGap),
              _HeroStat(
                label: 'Khả dụng',
                value: _formatMoney(account.availableMargin),
                color: AppColors.onAccent,
              ),
              const SizedBox(width: AppSpacing.walletAssetChartBottomGap),
              _HeroStat(
                label: 'PnL chưa chốt',
                value: '+${_formatMoneyCompact(totalPnl)}',
                color: _marginGreen,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Margin Level',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const Expanded(child: SizedBox.shrink()),
              Text(
                '${account.marginLevel.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: _marginGreen,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.transferTileGap,
              value: (account.marginLevel / 300).clamp(0, 1),
              backgroundColor: AppColors.onAccent.withValues(alpha: .13),
              valueColor: const AlwaysStoppedAnimation(_marginGreen),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        density: VitDensity.compact,
        variant: VitCardVariant.inner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarginSimpleForm extends StatefulWidget {
  const _MarginSimpleForm({
    required this.snapshot,
    required this.side,
    required this.leverage,
    required this.amount,
    required this.onSideChanged,
    required this.onMaxAmount,
    required this.onAmountChanged,
  });

  final TradeMarginTradingSnapshot snapshot;
  final String side;
  final int leverage;
  final String amount;
  final ValueChanged<String> onSideChanged;
  final VoidCallback onMaxAmount;
  final ValueChanged<String> onAmountChanged;

  @override
  State<_MarginSimpleForm> createState() => _MarginSimpleFormState();
}

class _MarginSimpleFormState extends State<_MarginSimpleForm> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.amount == '0.00' ? '' : widget.amount,
    );
  }

  @override
  void didUpdateWidget(covariant _MarginSimpleForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount &&
        widget.amount != _amountController.text) {
      _amountController.text = widget.amount == '0.00' ? '' : widget.amount;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _openConfirm(BuildContext context) async {
    final amount = widget.amount;
    if (amount == '0.00' || amount.isEmpty) return;
    final sideLabel = widget.side == 'long' ? 'Giá tăng' : 'Giá giảm';
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xem lại lệnh ký quỹ',
      lines: [
        VitTradeConfirmLine(label: 'Cặp', value: widget.snapshot.pair.symbol),
        VitTradeConfirmLine(label: 'Hướng', value: sideLabel),
        VitTradeConfirmLine(label: 'Chế độ', value: 'Cross'),
        VitTradeConfirmLine(label: 'Đòn bẩy', value: '${widget.leverage}x'),
        VitTradeConfirmLine(label: 'Số lượng', value: amount),
        VitTradeConfirmLine(
          label: 'Giá thanh lý ước tính',
          value: widget.snapshot.orderDraft.liquidationPriceLabel,
        ),
      ],
    );
    if (confirmed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi lệnh ký quỹ (mock)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = widget.amount != '0.00' && widget.amount.isNotEmpty;
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
          VitSegmentedChoice<String>(
            selected: widget.side,
            onChanged: widget.onSideChanged,
            options: [
              VitSegmentedChoiceOption(
                key: MarginTradingPage.sideKey('long'),
                value: 'long',
                label: 'Giá tăng',
                accentColor: AppColors.buy,
                leading: const Icon(Icons.trending_up_rounded),
              ),
              VitSegmentedChoiceOption(
                key: MarginTradingPage.sideKey('short'),
                value: 'short',
                label: 'Giá giảm',
                accentColor: AppColors.sell,
                leading: const Icon(Icons.trending_down_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Đòn bẩy ${widget.leverage}x · Chỉnh trong Chế độ Pro',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Bước 2 · Số lượng',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: VitInput(
                  controller: _amountController,
                  label: 'Bạn muốn giao dịch bao nhiêu?',
                  onChanged: widget.onAmountChanged,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                key: MarginTradingPage.maxAmountKey,
                label: 'Tối đa',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
                onTap: widget.onMaxAmount,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _OrderSummary(
            available: widget.snapshot.account.availableMargin,
            liquidationPrice: widget.snapshot.orderDraft.liquidationPriceLabel,
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            key: MarginTradingPage.submitKey,
            density: VitDensity.compact,
            onPressed: canSubmit ? () => _openConfirm(context) : null,
            variant: widget.side == 'long'
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger,
            child: Text(
              canSubmit ? 'Xem lại & xác nhận' : 'Nhập số lượng để tiếp tục',
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeTab extends StatelessWidget {
  const _TradeTab({
    required this.snapshot,
    required this.side,
    required this.leverage,
    required this.orderType,
    required this.amount,
    required this.showLeverageSheet,
    required this.compact,
    required this.onSideChanged,
    required this.onLeverageToggle,
    required this.onLeverageChanged,
    required this.onOrderTypeChanged,
    required this.onMaxAmount,
    required this.onNotice,
  });

  final TradeMarginTradingSnapshot snapshot;
  final String side;
  final int leverage;
  final String orderType;
  final String amount;
  final bool showLeverageSheet;
  final bool compact;
  final ValueChanged<String> onSideChanged;
  final VoidCallback onLeverageToggle;
  final ValueChanged<int> onLeverageChanged;
  final ValueChanged<String> onOrderTypeChanged;
  final VoidCallback onMaxAmount;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      density: VitDensity.compact,
      children: [
        _PairCard(snapshot: snapshot),
        _SideToggle(side: side, onChanged: onSideChanged),
        _LeverageSelector(
          leverage: leverage,
          expanded: showLeverageSheet,
          onTap: onLeverageToggle,
        ),
        if (showLeverageSheet)
          _LeverageSheet(selected: leverage, onChanged: onLeverageChanged),
        _SegmentedTabs(
          tabs: snapshot.orderDraft.orderTypes,
          activeId: orderType,
          onChanged: onOrderTypeChanged,
          keyBuilder: MarginTradingPage.orderTypeKey,
        ),
        if (orderType == 'limit') _PriceInput(price: snapshot.orderDraft.price),
        _AmountInput(amount: amount, onMaxAmount: onMaxAmount),
        _OrderSummary(
          available: snapshot.account.availableMargin,
          liquidationPrice: snapshot.orderDraft.liquidationPriceLabel,
        ),
        if (!compact) ...[
          _PriceComparison(prices: snapshot.referencePrices),
          _MarginOrderReviewCard(leverage: leverage),
        ],
        _SubmitButton(
          side: side,
          leverage: leverage,
          pairSymbol: snapshot.pair.symbol,
          disabled: amount == '0.00',
        ),
        if (!compact) ...[
          _RiskWarningCard(warning: snapshot.riskWarning),
          _NegativeBalanceCard(disclosure: snapshot.negativeBalance),
          _BestExecutionCard(
            disclosure: snapshot.bestExecution,
            onTap: () => onNotice(
              'Best execution details use local read-model data only; no live venue order is submitted from this repo.',
            ),
          ),
        ],
      ],
    );
  }
}
