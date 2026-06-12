part of 'margin_trading_page.dart';

class _ClientCategoryCard extends StatelessWidget {
  const _ClientCategoryCard({required this.category});

  final TradeMarginClientCategory category;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginAmber.withValues(alpha: .06),
      borderColor: _marginAmber.withValues(alpha: .28),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: _marginAmber.withValues(alpha: .13),
              borderRadius: AppRadii.mdRadius,
            ),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.shield_outlined, color: _marginAmber, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: VitPageContent(
              padding: VitContentPadding.none,
              customGap: 8,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.title,
                        style: AppTextStyles.body.copyWith(
                          color: _marginAmber,
                          fontWeight: AppTextStyles.bold,
                          height: 1.2,
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
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                VitPageContent(
                  padding: VitContentPadding.none,
                  customGap: 4,
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
    required this.activeColor,
    required this.height,
    required this.onChanged,
    required this.keyBuilder,
  });

  final List<TradeMarginTab> tabs;
  final String activeId;
  final Color activeColor;
  final double height;
  final ValueChanged<String> onChanged;
  final Key Function(String id) keyBuilder;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: height,
      padding: const EdgeInsets.all(4),
      variant: VitCardVariant.inner,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: keyBuilder(tab.id),
                onTap: () => onChanged(tab.id),
                borderRadius: AppRadii.inputRadius,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tab.id == activeId
                        ? activeColor
                        : AppColors.transparent,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: tab.id == activeId
                          ? AppColors.onAccent
                          : AppColors.text3,
                      fontWeight: tab.id == activeId
                          ? AppTextStyles.bold
                          : AppTextStyles.medium,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 4,
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
                        height: 1.05,
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
              const SizedBox(width: 10),
              _HeroStat(
                label: 'Khả dụng',
                value: _formatMoney(account.availableMargin),
                color: AppColors.onAccent,
              ),
              const SizedBox(width: 10),
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
              const Spacer(),
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
              minHeight: 7,
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
        height: 42,
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
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
                height: 1.15,
              ),
            ),
            const Spacer(),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: 1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
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
      customGap: 13,
      children: [
        _PriceComparison(prices: snapshot.referencePrices),
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
          activeColor: _marginPrimary.withValues(alpha: .16),
          height: 46,
          onChanged: onOrderTypeChanged,
          keyBuilder: MarginTradingPage.orderTypeKey,
        ),
        if (orderType == 'limit') _PriceInput(price: snapshot.orderDraft.price),
        _AmountInput(amount: amount, onMaxAmount: onMaxAmount),
        _OrderSummary(
          available: snapshot.account.availableMargin,
          liquidationPrice: snapshot.orderDraft.liquidationPriceLabel,
        ),
        _MarginOrderReviewCard(leverage: leverage),
        _SubmitButton(
          side: side,
          leverage: leverage,
          pairSymbol: snapshot.pair.symbol,
          disabled: amount == '0.00',
        ),
        _RiskWarningCard(warning: snapshot.riskWarning),
        _NegativeBalanceCard(disclosure: snapshot.negativeBalance),
        _BestExecutionCard(
          disclosure: snapshot.bestExecution,
          onTap: () => onNotice(
            'Best execution details use local read-model data only; no live venue order is submitted from this repo.',
          ),
        ),
      ],
    );
  }
}
