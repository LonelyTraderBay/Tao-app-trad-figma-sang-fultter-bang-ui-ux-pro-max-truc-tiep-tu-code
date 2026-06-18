part of '../pages/pair_detail_page.dart';

class _ViewTabs extends StatelessWidget {
  const _ViewTabs({required this.activeView, required this.onChanged});

  final _PairView activeView;
  final ValueChanged<_PairView> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PairDetailPage.chartTabKey,
        view: _PairView.chart,
        icon: Icons.show_chart_rounded,
        label: 'Bieu do',
      ),
      (
        key: PairDetailPage.orderBookTabKey,
        view: _PairView.orderBook,
        icon: Icons.bar_chart_rounded,
        label: 'So lenh',
      ),
      (
        key: PairDetailPage.tradesTabKey,
        view: _PairView.trades,
        icon: Icons.currency_exchange_rounded,
        label: 'Giao dich',
      ),
    ];

    return Padding(
      padding: AppSpacing.pairViewTabsPadding,
      child: Row(
        children: [
          for (final tab in tabs) ...[
            Expanded(
              child: _ViewTab(
                key: tab.key,
                selected: activeView == tab.view,
                icon: tab.icon,
                label: tab.label,
                onTap: () => onChanged(tab.view),
              ),
            ),
            if (tab.view != _PairView.trades)
              const SizedBox(width: AppSpacing.pairViewTabGap),
          ],
        ],
      ),
    );
  }
}

class _ViewTab extends StatelessWidget {
  const _ViewTab({
    super.key,
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? _marketPrimary.withValues(alpha: .2)
          : AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(
          color: selected
              ? _marketPrimary.withValues(alpha: .45)
              : AppColors.transparent,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: SizedBox(
          height: AppSpacing.pairViewTabHeight,
          child: Padding(
            padding: AppSpacing.pairViewTabPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: selected ? _marketPrimary : AppColors.text3,
                  size: AppSpacing.pairViewTabIcon,
                ),
                const SizedBox(width: AppSpacing.pairViewTabIconGap),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: selected ? _marketPrimary : AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
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

class _TimeframeRow extends StatelessWidget {
  const _TimeframeRow({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = ['15m', '1H', '4H', '1D', '1W', '1M'];
    return Padding(
      padding: AppSpacing.pairTimeframePadding,
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(item),
                borderRadius: AppRadii.cardRadius,
                child: Center(
                  child: Material(
                    color: active == item
                        ? _marketPrimary.withValues(alpha: .2)
                        : AppColors.transparent,
                    shape: const CircleBorder(),
                    child: SizedBox.square(
                      dimension: AppSpacing.pairTimeframeHeight,
                      child: Center(
                        child: Text(
                          item,
                          style: AppTextStyles.badge.copyWith(
                            color: active == item
                                ? _marketPrimary
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
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

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({
    required this.active,
    required this.onToggle,
    required this.onAdvanced,
  });

  final Set<String> active;
  final ValueChanged<String> onToggle;
  final VoidCallback onAdvanced;

  @override
  Widget build(BuildContext context) {
    const items = ['MA', 'EMA', 'BOLL', 'MACD', 'RSI', 'Vol'];
    return SizedBox(
      height: AppSpacing.pairIndicatorHeight,
      child: ListView(
        padding: AppSpacing.pairIndicatorListPadding,
        scrollDirection: Axis.horizontal,
        children: [
          for (final item in items) ...[
            _IndicatorChip(
              label: item,
              selected: active.contains(item),
              onTap: () => onToggle(item),
            ),
            const SizedBox(width: AppSpacing.pairIndicatorGap),
          ],
          _AdvancedChip(onTap: onAdvanced),
        ],
      ),
    );
  }
}

class _IndicatorChip extends StatelessWidget {
  const _IndicatorChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? _marketPrimary.withValues(alpha: .2)
          : AppColors.surface2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(
          color: selected
              ? _marketPrimary.withValues(alpha: .5)
              : AppColors.borderSolid,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: SizedBox(
          height: AppSpacing.pairIndicatorChipHeight,
          child: Padding(
            padding: AppSpacing.pairIndicatorChipPadding,
            child: Center(
              child: Text(
                label,
                style: AppTextStyles.badge.copyWith(
                  color: selected ? _marketPrimary : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdvancedChip extends StatelessWidget {
  const _AdvancedChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warn.withValues(alpha: .12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(color: AppColors.warn.withValues(alpha: .32)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: SizedBox(
          height: AppSpacing.pairIndicatorChipHeight,
          child: Padding(
            padding: AppSpacing.pairIndicatorChipPadding,
            child: Center(
              child: Text(
                'Nang cao',
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PairChart extends StatelessWidget {
  const _PairChart({required this.series});

  final List<double> series;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.pairChartHeight,
      child: CustomPaint(
        painter: _PairChartPainter(series),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pairRiskMargin,
      child: Material(
        color: AppColors.warn.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.warn.withValues(alpha: .24)),
        ),
        child: Padding(
          padding: AppSpacing.pairRiskPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: AppSpacing.pairRiskIcon,
              ),
              const SizedBox(width: AppSpacing.pairRiskGap),
              Expanded(
                child: Text(
                  'Giao dich crypto co rui ro cao. Chi dau tu so tien ban co the chiu mat.',
                  style: AppTextStyles.micro.copyWith(color: AppColors.warn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pairLinkMargin,
      child: VitCard(
        borderColor: iconColor.withValues(alpha: .18),
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.pairLinkPadding,
          child: Row(
            children: [
              Material(
                color: iconColor.withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
                child: SizedBox(
                  width: AppSpacing.pairLinkIconBox,
                  height: AppSpacing.pairLinkIconBox,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: AppSpacing.pairLinkIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.pairLinkGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pairLinkSubtitleGap),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: iconColor,
                size: AppSpacing.pairLinkChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TradeCtas extends StatelessWidget {
  const _TradeCtas({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pairTradeCtaPadding,
      child: Row(
        children: [
          Expanded(
            child: _TradeButton(
              key: PairDetailPage.buyButtonKey,
              label: 'MUA',
              color: AppColors.buy,
              shadowColor: AppColors.buy,
              onTap: () =>
                  context.go('${AppRoutePaths.tradePair(pairId)}?side=buy'),
            ),
          ),
          const SizedBox(width: AppSpacing.pairTradeCtaGap),
          Expanded(
            child: _TradeButton(
              key: PairDetailPage.sellButtonKey,
              label: 'BAN',
              color: AppColors.sell,
              shadowColor: AppColors.sell,
              onTap: () =>
                  context.go('${AppRoutePaths.tradePair(pairId)}?side=sell'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeButton extends StatelessWidget {
  const _TradeButton({
    super.key,
    required this.label,
    required this.color,
    required this.shadowColor,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color shadowColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: AppRadii.cardRadius,
      elevation: 0,
      shadowColor: shadowColor.withValues(alpha: .3),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: SizedBox(
          height: AppSpacing.pairTradeButtonHeight,
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.base.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
