part of 'active_copies_page.dart';

class _PortfolioOverview extends StatelessWidget {
  const _PortfolioOverview({required this.snapshot});

  final TradeActiveCopyPortfolio snapshot;

  @override
  Widget build(BuildContext context) {
    final positive = snapshot.totalPnl >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    final bg = positive ? _lightBuyBackground : _lightSellBackground;
    final labelColor = positive ? AppColors.buy20 : AppColors.sellDeep;

    return Container(
      height: 194,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _copyPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng quan portfolio',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Text(
                '${snapshot.activeCopies} active',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _PortfolioMetric(
                  label: 'Vốn đầu tư',
                  value: _formatUsd(snapshot.totalCapital),
                ),
              ),
              Expanded(
                child: _PortfolioMetric(
                  label: 'Giá trị hiện tại',
                  value: _formatUsd(snapshot.totalValue),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: color),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Icon(
                  positive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: color,
                  size: 17,
                ),
                const SizedBox(width: 7),
                Text(
                  'P/L tổng',
                  style: AppTextStyles.micro.copyWith(
                    color: labelColor,
                    fontSize: 11,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatSignedUsd(snapshot.totalPnl),
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontSize: 16,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatPercent(snapshot.totalPnlPct),
                      style: AppTextStyles.micro.copyWith(
                        color: labelColor,
                        fontSize: 11,
                        height: 1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
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

class _PortfolioMetric extends StatelessWidget {
  const _PortfolioMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 18,
            fontWeight: AppTextStyles.bold,
            height: 1.15,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<TradeActiveCopiesTab> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _copySegmentBackground,
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _SegmentedTabButton(
                tab: tab,
                active: activeTab == tab.id,
                onTap: () => onChanged(tab.id),
              ),
            ),
        ],
      ),
    );
  }
}

class _SegmentedTabButton extends StatelessWidget {
  const _SegmentedTabButton({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final TradeActiveCopiesTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ActiveCopiesPage.tabKey(tab.id),
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _copyPrimary : AppColors.transparent,
          borderRadius: AppRadii.lgRadius,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            tab.label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.onAccent : AppColors.text3,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveCopyCard extends StatelessWidget {
  const _ActiveCopyCard({
    super.key,
    required this.copy,
    required this.expanded,
    required this.onToggle,
    required this.onViewDetails,
    required this.onConfigure,
    required this.onStop,
  });

  final TradeActiveCopy copy;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onViewDetails;
  final VoidCallback onConfigure;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(copy.status);
    final positive = copy.pnl >= 0;
    final pnlColor = positive ? AppColors.buy : AppColors.sell;
    final pnlBg = positive ? _lightBuyBackground : _lightSellBackground;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _copyPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProviderAvatar(copy: copy),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            copy.providerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontSize: 15,
                              fontWeight: AppTextStyles.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        if (copy.providerVerified) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: _copyPrimary,
                            size: 12,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        _StatusPill(style: status),
                        if (copy.coolingOffUntil != null) ...[
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              'đến ${copy.coolingOffUntil}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontSize: 10,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                key: ActiveCopiesPage.expandKey(copy.id),
                onTap: onToggle,
                borderRadius: AppRadii.cardRadius,
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniValueCard(
                  label: 'Vốn',
                  value: _formatUsd(copy.capital),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniValueCard(
                  label: 'Hiện tại',
                  value: _formatUsd(copy.currentValue),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniValueCard(
                  label: 'P/L',
                  value: _formatSignedUsd(copy.pnl),
                  valueColor: pnlColor,
                  background: pnlBg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _ReturnBar(value: copy.pnlPct),
          if (expanded) ...[
            const SizedBox(height: 16),
            _ExpandedCopyDetails(
              copy: copy,
              onViewDetails: onViewDetails,
              onConfigure: onConfigure,
              onStop: onStop,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.copy});

  final TradeActiveCopy copy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _copyPrimary.withValues(alpha: .08),
        shape: BoxShape.circle,
        border: Border.all(color: _copyPrimary, width: 2),
      ),
      child: Text(
        copy.providerAvatar,
        style: AppTextStyles.baseMedium.copyWith(
          color: _copyPrimary,
          fontSize: 17,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.style});

  final _StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        style.label,
        style: AppTextStyles.micro.copyWith(
          color: style.color,
          fontSize: 11,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _MiniValueCard extends StatelessWidget {
  const _MiniValueCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.background = _copyPanel2,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontSize: 13,
                fontWeight: AppTextStyles.bold,
                height: 1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
