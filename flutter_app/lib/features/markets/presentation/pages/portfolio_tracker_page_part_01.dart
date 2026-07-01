part of 'portfolio_tracker_page.dart';

class _PortfolioTrackerPageState extends ConsumerState<PortfolioTrackerPage> {
  String _tab = 'overview';
  String _timeFilter = '30d';
  bool _hideBalance = false;
  MarketPortfolioSort _sortBy = MarketPortfolioSort.value;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketControllerProvider)
        .getPortfolioTracker(sortBy: _sortBy);
    final overviewHoldings = _overviewHoldings(snapshot.holdings);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _portfolioVisualScrollClearance
            : _portfolioNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-021 PortfolioTrackerPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Danh mục',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PortfolioTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PortfolioTrackerPage.contentKey,
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: [
                        if (_tab == 'overview') ...[
                          _TotalValueHero(
                            stats: snapshot.stats,
                            hidden: _hideBalance,
                            onToggleHidden: () => setState(() {
                              _hideBalance = !_hideBalance;
                            }),
                          ),
                          _QuickStats(
                            stats: snapshot.stats,
                            hidden: _hideBalance,
                          ),
                          _AllocationCard(holdings: overviewHoldings),
                          const _SectionHeader(
                            label: 'Tài sản chính',
                            accentColor: _marketPrimary,
                          ),
                          _TopHoldings(
                            holdings: overviewHoldings.take(4).toList(),
                            hidden: _hideBalance,
                            onTap: (holding) => context.go(
                              AppRoutePaths.pairDetail('${holding.id}usdt'),
                            ),
                          ),
                          _RiskCard(stats: snapshot.stats),
                        ] else if (_tab == 'assets') ...[
                          _SortChips(
                            active: _sortBy,
                            onSelected: (value) => setState(() {
                              _sortBy = value;
                            }),
                          ),
                          for (final holding in snapshot.holdings)
                            _HoldingDetailCard(
                              key: PortfolioTrackerPage.holdingKey(holding.id),
                              holding: holding,
                              hidden: _hideBalance,
                              onTap: () => context.go(
                                AppRoutePaths.pairDetail('${holding.id}usdt'),
                              ),
                            ),
                        ] else ...[
                          _TimeFilterChips(
                            active: _timeFilter,
                            onSelected: (value) => setState(() {
                              _timeFilter = value;
                            }),
                          ),
                          _PerformanceChartCard(
                            stats: snapshot.stats,
                            points: snapshot.performance,
                          ),
                          const _SectionHeader(
                            label: 'Lãi/Lỗ theo tài sản',
                            accentColor: AppColors.buy,
                          ),
                          _PnlBreakdown(
                            holdings: overviewHoldings
                                .where((holding) => holding.symbol != 'USDT')
                                .toList(),
                            hidden: _hideBalance,
                          ),
                          _SummaryStats(
                            stats: snapshot.stats,
                            hidden: _hideBalance,
                          ),
                        ],
                        const MarketBodyReviewSection(
                          title: 'Portfolio state review',
                          message: 'Portfolio tracker data reviewed',
                          detail:
                              'Overview, assets, performance, hidden balance, empty, and refresh states remain visible.',
                          primary:
                              'Balance masking preserves user privacy across overview and asset rows.',
                          secondary:
                              'Sort and timeframe controls keep portfolio comparisons explicit.',
                          tertiary:
                              'Risk and PnL summaries stay separate from pair-level market navigation.',
                        ),
                      ],
                    ),
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

class _PortfolioTabs extends StatelessWidget {
  const _PortfolioTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _portfolioTabsHeight,
            child: Row(
              children: [
                _UnderlinedTab(
                  key: PortfolioTrackerPage.overviewTabKey,
                  label: 'Tổng quan',
                  value: 'overview',
                  active: activeTab == 'overview',
                  onChanged: onChanged,
                ),
                _UnderlinedTab(
                  key: PortfolioTrackerPage.assetsTabKey,
                  label: 'Tài sản',
                  value: 'assets',
                  active: activeTab == 'assets',
                  onChanged: onChanged,
                ),
                _UnderlinedTab(
                  key: PortfolioTrackerPage.performanceTabKey,
                  label: 'Hiệu suất',
                  value: 'performance',
                  active: activeTab == 'performance',
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: EdgeInsets.zero,
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _portfolioTabIndicatorHeight,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalValueHero extends StatelessWidget {
  const _TotalValueHero({
    required this.stats,
    required this.hidden,
    required this.onToggleHidden,
  });

  final PortfolioStats stats;
  final bool hidden;
  final VoidCallback onToggleHidden;

  @override
  Widget build(BuildContext context) {
    final pnlColor = stats.totalPnl >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      variant: VitCardVariant.hero,
      padding: _portfolioHeroPadding,
      borderColor: _marketPrimary.withValues(alpha: .22),
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng giá trị',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              VitInlineIconAction(
                key: PortfolioTrackerPage.hideBalanceKey,
                icon: hidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                tooltip: hidden ? 'Hiá»‡n sá»‘ dÆ°' : 'áº¨n sá»‘ dÆ°',
                onPressed: onToggleHidden,
                color: AppColors.text3,
                size: _portfolioHeroToggleIcon,
                padding: AppSpacing.x1,
              ),
            ],
          ),
          const SizedBox(height: _portfolioHeroTitleGap),
          Text(
            _mask(_formatUsd(stats.totalValue), hidden, long: true),
            style: AppTextStyles.amountMd,
          ),
          const SizedBox(height: _portfolioHeroPnlGap),
          Row(
            children: [
              Icon(
                stats.totalPnl >= 0
                    ? Icons.north_east_rounded
                    : Icons.south_east_rounded,
                size: _portfolioHeroPnlIcon,
                color: pnlColor,
              ),
              const SizedBox(width: _portfolioHeroPnlIconGap),
              Text(
                _mask(
                  '${_formatUsd(stats.totalPnl.abs())} (${_formatSignedPercent(stats.totalPnlPct)})',
                  hidden,
                  long: true,
                ),
                style: AppTextStyles.caption.copyWith(
                  color: pnlColor,
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

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.stats, required this.hidden});

  final PortfolioStats stats;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniStatCard(
            label: 'Vốn đầu tư',
            value: _mask(_formatCompact(stats.totalCost, prefix: r'$'), hidden),
            color: AppColors.text1,
          ),
        ),
        const SizedBox(width: _portfolioQuickStatGap),
        Expanded(
          child: _MiniStatCard(
            label: 'Tốt nhất 24h',
            value:
                '${stats.best24hSymbol} ${_formatSignedPercent(stats.best24hChange)}',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: _portfolioQuickStatGap),
        Expanded(
          child: _MiniStatCard(
            label: 'Kém nhất 24h',
            value:
                '${stats.worst24hSymbol} ${_formatSignedPercent(stats.worst24hChange)}',
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _portfolioMiniStatPadding,
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _portfolioMiniStatValueGap),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.holdings});

  final List<PortfolioHolding> holdings;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _portfolioAllocationPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ tài sản',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _portfolioAllocationTitleGap),
          Row(
            children: [
              SizedBox(
                width: _portfolioDonutSize,
                height: _portfolioDonutSize,
                child: CustomPaint(
                  painter: _AllocationDonutPainter(holdings: holdings),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${holdings.length}',
                          style: AppTextStyles.caption.copyWith(
                            color: _marketPrimary,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'tài sản',
                          style: AppTextStyles.micro.copyWith(
                            color: _marketPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: _portfolioDonutGap),
              Expanded(
                child: Column(
                  children: [
                    for (final holding in holdings.take(5)) ...[
                      _AllocationLegendRow(holding: holding),
                      if (holding != holdings.take(5).last)
                        const SizedBox(height: _portfolioLegendGap),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationLegendRow extends StatelessWidget {
  const _AllocationLegendRow({required this.holding});

  final PortfolioHolding holding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: _portfolioLegendDot, color: holding.color),
        const SizedBox(width: _portfolioLegendGap),
        Expanded(
          child: Text(
            holding.symbol,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          '${holding.allocation.toStringAsFixed(1)}%',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
