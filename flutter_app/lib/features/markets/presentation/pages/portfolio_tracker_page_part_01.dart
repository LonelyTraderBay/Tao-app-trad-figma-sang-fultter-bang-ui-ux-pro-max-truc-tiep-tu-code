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
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

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
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.relaxed,
                      customGap: 12,
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 54,
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
      child: InkWell(
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
              height: 2,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_heroPrimary, AppColors.surface],
        ),
        border: Border.all(color: _marketPrimary.withValues(alpha: .22)),
        borderRadius: AppRadii.cardLargeRadius,
      ),
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
              InkWell(
                key: PortfolioTrackerPage.hideBalanceKey,
                onTap: onToggleHidden,
                borderRadius: AppRadii.cardRadius,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    hidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 16,
                    color: AppColors.text3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _mask(_formatUsd(stats.totalValue), hidden, long: true),
            style: AppTextStyles.heroNumber.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                stats.totalPnl >= 0
                    ? Icons.north_east_rounded
                    : Icons.south_east_rounded,
                size: 15,
                color: pnlColor,
              ),
              const SizedBox(width: 8),
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
        const SizedBox(width: 8),
        Expanded(
          child: _MiniStatCard(
            label: 'Tốt nhất 24h',
            value:
                '${stats.best24hSymbol} ${_formatSignedPercent(stats.best24hChange)}',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 5),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
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
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
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
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 28),
              Expanded(
                child: Column(
                  children: [
                    for (final holding in holdings.take(5)) ...[
                      _AllocationLegendRow(holding: holding),
                      if (holding != holdings.take(5).last)
                        const SizedBox(height: 8),
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
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: holding.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
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
