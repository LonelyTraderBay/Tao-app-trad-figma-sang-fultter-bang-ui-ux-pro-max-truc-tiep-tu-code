part of 'advanced_analytics_page.dart';

class _AdvancedAnalyticsPageState extends ConsumerState<AdvancedAnalyticsPage> {
  String _tab = 'ai';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getAdvancedAnalytics();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance = tradeScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-092 AdvancedAnalyticsPage',
      child: Material(
        color: _advancedBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Advanced Analytics',
            subtitle: 'AI & Professional Tools',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeMargin),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: AdvancedAnalyticsPage.contentKey,
                  bottomInset: scrollClearance,
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      VitTradeSection(
                        title: 'Tổng quan',
                        child: _HeroCard(stats: snapshot.stats),
                      ),
                      _UnderlineTabs(
                        activeId: _tab,
                        onChanged: (id) => setState(() => _tab = id),
                      ),
                      if (_tab == 'ai')
                        _AiSignalsTab(
                          snapshot: snapshot,
                          activeFilter: _filter,
                          onFilterChanged: (id) => setState(() => _filter = id),
                        )
                      else if (_tab == 'risk')
                        _RiskAnalysisTab(snapshot: snapshot)
                      else if (_tab == 'journal')
                        _TradeJournalTab(snapshot: snapshot)
                      else
                        _PositionSizingTab(snapshot: snapshot),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        density: VitDensity.compact,
                        title: 'Analytics risk review',
                        message:
                            'AI signals, sizing, and journal metrics are decision-support tools. Confirm risk limits before using them for live orders.',
                        contractId: 'SC-092',
                      ),
                      VitTradeSection(
                        title: 'Model info',
                        child: _ModelInfoCard(),
                      ),
                      VitTradeSection(
                        title: 'Features',
                        child: _FeaturesCard(features: snapshot.features),
                      ),
                    ],
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

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.stats});

  final List<TradeAdvancedAnalyticsStat> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      borderColor: AppColors.onAccent.withValues(alpha: .10),
      density: VitDensity.compact,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppSpacing.x4,
                backgroundColor: AppColors.onAccent.withValues(alpha: .10),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.onAccent,
                  size: AppSpacing.iconLg,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'P3: Advanced Analytics',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'AI-powered insights va professional trading tools',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              for (final stat in stats) ...[
                Expanded(child: _HeroStat(stat: stat)),
                if (stat != stats.last) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.stat});

  final TradeAdvancedAnalyticsStat stat;

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorHex);
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent.withValues(alpha: .62),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnderlineTabs extends StatelessWidget {
  const _UnderlineTabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('ai', 'AI Signals', Icons.psychology_rounded),
    ('risk', 'Risk Analysis', Icons.shield_outlined),
    ('journal', 'Trade Journal', Icons.menu_book_rounded),
    ('sizing', 'Position Sizing', Icons.calculate_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in _tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            icon: tab.$3,
            widgetKey: AdvancedAnalyticsPage.tabKey(tab.$1),
          ),
      ],
    );
  }
}

class _AiSignalsTab extends StatelessWidget {
  const _AiSignalsTab({
    required this.snapshot,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final TradeAdvancedAnalyticsSnapshot snapshot;
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final visibleSignals = activeFilter == 'all'
        ? snapshot.signals
        : snapshot.signals
              .where((signal) => signal.direction == activeFilter)
              .toList();
    final avgConfidence =
        snapshot.signals.fold<int>(0, (sum, item) => sum + item.confidence) /
        snapshot.signals.length;
    final longCount = snapshot.signals
        .where((signal) => signal.direction == 'long')
        .length;
    final shortCount = snapshot.signals
        .where((signal) => signal.direction == 'short')
        .length;

    return _Card(
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.compact,
        children: [
          const _SectionHeader(
            icon: Icons.psychology_rounded,
            color: _advancedPurple,
            title: 'AI Trading Signals',
            subtitle: 'Machine learning powered predictions',
            iconSize: 24,
          ),
          Row(
            children: [
              Expanded(
                child: _MiniStatBox(
                  label: 'Active',
                  value: '${snapshot.signals.length}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatBox(
                  label: 'Avg Confidence',
                  value: '${avgConfidence.toStringAsFixed(0)}%',
                  valueColor: _advancedGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatBox(
                  label: 'L/S Ratio',
                  value: '$longCount/$shortCount',
                ),
              ),
            ],
          ),
          Row(
            children: [
              for (final filter in const ['all', 'long', 'short']) ...[
                Expanded(
                  child: _FilterChip(
                    id: filter,
                    selected: activeFilter == filter,
                    onTap: () => onFilterChanged(filter),
                  ),
                ),
                if (filter != 'short') const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
          VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.compact,
            children: [
              for (final signal in visibleSignals) _SignalCard(signal: signal),
            ],
          ),
          const _DisclaimerCard(),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.id,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: AdvancedAnalyticsPage.filterKey(id),
      onTap: onTap,
      density: VitDensity.compact,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      borderColor: selected ? _advancedPurple : _advancedBorder,
      child: Text(
        id.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: selected ? _advancedPurple : AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
