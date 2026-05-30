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
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
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
            if (tab.view != _PairView.trades) const SizedBox(width: 8),
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
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: AppRadii.cardRadius,
            border: Border.all(
              color: selected
                  ? _marketPrimary.withValues(alpha: .45)
                  : AppColors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? _marketPrimary : AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: 6),
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
      padding: const EdgeInsets.fromLTRB(24, 0, 20, 5),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(item),
                borderRadius: AppRadii.cardRadius,
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active == item
                        ? _marketPrimary.withValues(alpha: .2)
                        : AppColors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    item,
                    style: AppTextStyles.micro.copyWith(
                      color: active == item ? _marketPrimary : AppColors.text3,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
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
      height: 42,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: [
          for (final item in items) ...[
            _IndicatorChip(
              label: item,
              selected: active.contains(item),
              onTap: () => onToggle(item),
            ),
            const SizedBox(width: 8),
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
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? _marketPrimary.withValues(alpha: .5)
                  : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? _marketPrimary : AppColors.text3,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
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
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.warn.withValues(alpha: .32)),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Text(
            'Nang cao',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.warn,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
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
      height: 230,
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
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warn.withValues(alpha: .08),
        border: Border.all(color: AppColors.warn.withValues(alpha: .24)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Giao dich crypto co rui ro cao. Chi dau tu so tien ban co the chiu mat.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                height: 1.45,
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 13),
      child: VitCard(
        borderColor: iconColor.withValues(alpha: .18),
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: .12),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Icon(icon, color: iconColor, size: 19),
              ),
              const SizedBox(width: 13),
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: iconColor, size: 20),
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
          const SizedBox(width: 12),
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
          height: 55,
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
