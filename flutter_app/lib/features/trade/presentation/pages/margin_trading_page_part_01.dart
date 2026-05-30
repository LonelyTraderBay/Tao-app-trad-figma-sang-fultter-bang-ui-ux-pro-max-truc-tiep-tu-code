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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _marginAmber.withValues(alpha: .13),
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _marginAmber,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.title,
                        style: AppTextStyles.body.copyWith(
                          color: _marginAmber,
                          fontSize: 14,
                          fontWeight: AppTextStyles.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _marginAmber.withValues(alpha: .13),
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: Text(
                        category.badgeLabel,
                        style: AppTextStyles.micro.copyWith(
                          color: _marginAmber,
                          fontSize: 10,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  category.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                for (final limit in category.limits) ...[
                  _Bullet(text: limit, color: _marginAmber),
                  if (limit != category.limits.last) const SizedBox(height: 4),
                ],
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
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _marginPanel,
        borderRadius: AppRadii.cardRadius,
      ),
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
                      fontSize: 12,
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _formatMoney(account.totalEquity),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.onAccent,
                        fontSize: 28,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _marginGreen.withValues(alpha: .13),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      color: _marginGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '+${_formatMoneyCompact(totalPnl)}',
                      style: AppTextStyles.caption.copyWith(
                        color: _marginGreen,
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
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
          const SizedBox(height: 17),
          Row(
            children: [
              Text(
                'Margin Level',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${account.marginLevel.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: _marginGreen,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: LinearProgressIndicator(
              minHeight: 7,
              value: (account.marginLevel / 300).clamp(0, 1),
              backgroundColor: AppColors.onAccent.withValues(alpha: .13),
              valueColor: const AlwaysStoppedAnimation(_marginGreen),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '0%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              Text(
                '300%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
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
      child: Container(
        height: 58,
        padding: const EdgeInsets.fromLTRB(10, 11, 8, 9),
        decoration: BoxDecoration(
          color: AppColors.onAccent.withValues(alpha: .12),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 10,
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
                fontSize: 14,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PriceComparison(prices: snapshot.referencePrices),
        const SizedBox(height: 13),
        _PairCard(snapshot: snapshot),
        const SizedBox(height: 13),
        _SideToggle(side: side, onChanged: onSideChanged),
        const SizedBox(height: 15),
        _LeverageSelector(
          leverage: leverage,
          expanded: showLeverageSheet,
          onTap: onLeverageToggle,
        ),
        if (showLeverageSheet) ...[
          const SizedBox(height: 10),
          _LeverageSheet(selected: leverage, onChanged: onLeverageChanged),
        ],
        const SizedBox(height: 13),
        _SegmentedTabs(
          tabs: snapshot.orderDraft.orderTypes,
          activeId: orderType,
          activeColor: _marginPrimary.withValues(alpha: .16),
          height: 46,
          onChanged: onOrderTypeChanged,
          keyBuilder: MarginTradingPage.orderTypeKey,
        ),
        const SizedBox(height: 12),
        if (orderType == 'limit') _PriceInput(price: snapshot.orderDraft.price),
        if (orderType == 'limit') const SizedBox(height: 12),
        _AmountInput(amount: amount, onMaxAmount: onMaxAmount),
        const SizedBox(height: 14),
        _OrderSummary(
          available: snapshot.account.availableMargin,
          liquidationPrice: snapshot.orderDraft.liquidationPriceLabel,
        ),
        const SizedBox(height: 13),
        _MarginOrderReviewCard(leverage: leverage),
        const SizedBox(height: 13),
        _SubmitButton(
          side: side,
          leverage: leverage,
          pairSymbol: snapshot.pair.symbol,
          disabled: amount == '0.00',
        ),
        const SizedBox(height: 14),
        _RiskWarningCard(warning: snapshot.riskWarning),
        const SizedBox(height: 14),
        _NegativeBalanceCard(disclosure: snapshot.negativeBalance),
        const SizedBox(height: 14),
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
