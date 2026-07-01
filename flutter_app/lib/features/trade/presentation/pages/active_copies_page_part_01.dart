part of 'active_copies_page.dart';

class _ActiveCopyList extends StatelessWidget {
  const _ActiveCopyList({
    required this.copies,
    required this.expandedCopyId,
    required this.onToggle,
    required this.onViewDetails,
    required this.onConfigure,
    required this.onStop,
  });

  final List<TradeActiveCopy> copies;
  final String? expandedCopyId;
  final ValueChanged<String> onToggle;
  final ValueChanged<TradeActiveCopy> onViewDetails;
  final ValueChanged<TradeActiveCopy> onConfigure;
  final ValueChanged<TradeActiveCopy> onStop;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      density: VitDensity.compact,
      child: Column(
        children: [
          for (var i = 0; i < copies.length; i++) ...[
            _ActiveCopyCard(
              key: ActiveCopiesPage.copyKey(copies[i].id),
              copy: copies[i],
              expanded: expandedCopyId == copies[i].id,
              onToggle: () => onToggle(copies[i].id),
              onViewDetails: () => onViewDetails(copies[i]),
              onConfigure: () => onConfigure(copies[i]),
              onStop: copies[i].status == TradeActiveCopyStatus.coolingOff
                  ? null
                  : () => onStop(copies[i]),
            ),
            if (i < copies.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _PortfolioOverview extends StatelessWidget {
  const _PortfolioOverview({required this.snapshot});

  final TradeActiveCopyPortfolio snapshot;

  @override
  Widget build(BuildContext context) {
    final positive = snapshot.totalPnl >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    final labelColor = positive ? AppColors.buy20 : AppColors.sellDeep;

    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.compact,
        children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${snapshot.activeCopies} active',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            density: VitDensity.compact,
            borderColor: color,
            child: Row(
              children: [
                Icon(
                  positive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: color,
                  size: AppSpacing.activeCopiesPnlIcon,
                ),
                const SizedBox(width: AppSpacing.walletAssetSmallGap),
                Text(
                  'P/L tổng',
                  style: AppTextStyles.micro.copyWith(
                    color: labelColor,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                const Expanded(child: SizedBox.shrink()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatSignedUsd(snapshot.totalPnl),
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatPercent(snapshot.totalPnlPct),
                      style: AppTextStyles.micro.copyWith(
                        color: labelColor,
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
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
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
    return VitSegmentedTabBar(
      activeKey: activeTab,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: ActiveCopiesPage.tabKey(tab.id),
          ),
      ],
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

    return Padding(
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProviderAvatar(copy: copy),
              const SizedBox(width: AppSpacing.cardGap),
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
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (copy.providerVerified) ...[
                          const SizedBox(width: AppSpacing.x2),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: _copyPrimary,
                            size: AppSpacing.activeCopiesVerifiedIcon,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        _StatusPill(style: status),
                        if (copy.coolingOffUntil != null) ...[
                          const SizedBox(width: AppSpacing.walletAssetSmallGap),
                          Flexible(
                            child: Text(
                              'đến ${copy.coolingOffUntil}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              VitInlineIconAction(
                key: ActiveCopiesPage.expandKey(copy.id),
                icon: expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                tooltip: expanded
                    ? 'Collapse copy details'
                    : 'Expand copy details',
                onPressed: onToggle,
                color: AppColors.text3,
                size: AppSpacing.activeCopiesExpandIcon,
                padding: AppSpacing.activeCopiesExpandPadding,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4 + AppSpacing.x1),
          Row(
            children: [
              Expanded(
                child: _MiniValueCard(
                  label: 'Vốn',
                  value: _formatUsd(copy.capital),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniValueCard(
                  label: 'Hiện tại',
                  value: _formatUsd(copy.currentValue),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniValueCard(
                  label: 'P/L',
                  value: _formatSignedUsd(copy.pnl),
                  valueColor: pnlColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _ReturnBar(value: copy.pnlPct),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.x4 + AppSpacing.x1),
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
    return VitAssetAvatar(
      label: copy.providerAvatar,
      accentColor: _copyPrimary,
      size: AppSpacing.walletTokenHeroIcon,
      radius: AppRadii.avatarRadius,
      border: true,
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.style});

  final _StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: style.label, accentColor: style.color);
  }
}

class _MiniValueCard extends StatelessWidget {
  const _MiniValueCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
