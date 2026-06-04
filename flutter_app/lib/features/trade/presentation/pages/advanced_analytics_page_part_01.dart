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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

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
                child: SingleChildScrollView(
                  key: AdvancedAnalyticsPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeroCard(stats: snapshot.stats),
                      const SizedBox(height: 16),
                      _UnderlineTabs(
                        activeId: _tab,
                        onChanged: (id) => setState(() => _tab = id),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 12),
                      _ModelInfoCard(),
                      const SizedBox(height: 12),
                      _FeaturesCard(features: snapshot.features),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.surface2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .10)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.onAccent.withValues(alpha: .10),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.onAccent,
                  size: 34,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'P3: Advanced Analytics',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontSize: 24,
                        fontWeight: AppTextStyles.bold,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'AI-powered insights va professional trading tools',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .72),
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          Row(
            children: [
              for (final stat in stats) ...[
                Expanded(child: _HeroStat(stat: stat)),
                if (stat != stats.last) const SizedBox(width: 8),
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
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.onAccent.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stat.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent.withValues(alpha: .62),
              fontSize: 10,
              height: 1.2,
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
    return Container(
      height: 54,
      color: _advancedPanel,
      child: Row(
        children: [
          for (final tab in _tabs)
            Expanded(
              child: InkWell(
                key: AdvancedAnalyticsPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: activeId == tab.$1
                            ? _advancedPrimary
                            : AppColors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab.$3,
                        color: activeId == tab.$1
                            ? _advancedPrimary
                            : AppColors.text3,
                        size: 15,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: activeId == tab.$1
                              ? _advancedPrimary
                              : AppColors.text3,
                          fontSize: 10,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            icon: Icons.psychology_rounded,
            color: _advancedPurple,
            title: 'AI Trading Signals',
            subtitle: 'Machine learning powered predictions',
            iconSize: 24,
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _MiniStatBox(
                  label: 'Active',
                  value: '${snapshot.signals.length}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStatBox(
                  label: 'Avg Confidence',
                  value: '${avgConfidence.toStringAsFixed(0)}%',
                  valueColor: _advancedGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStatBox(
                  label: 'L/S Ratio',
                  value: '$longCount/$shortCount',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                if (filter != 'short') const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 16),
          for (final signal in visibleSignals) ...[
            _SignalCard(signal: signal),
            if (signal != visibleSignals.last) const SizedBox(height: 12),
          ],
          const SizedBox(height: 16),
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
    return InkWell(
      key: AdvancedAnalyticsPage.filterKey(id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? _advancedPurple.withValues(alpha: .18)
              : _advancedPanel2,
          border: Border.all(
            color: selected ? _advancedPurple : _advancedBorder,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          id.toUpperCase(),
          style: AppTextStyles.caption.copyWith(
            color: selected ? _advancedPurple : AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}
