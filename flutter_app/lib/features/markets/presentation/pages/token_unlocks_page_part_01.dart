part of 'token_unlocks_page.dart';

class _TokenUnlocksPageState extends ConsumerState<TokenUnlocksPage> {
  String _tab = 'upcoming';
  MarketUnlockSort _sortBy = MarketUnlockSort.nearest;
  MarketUnlockImpact? _impactFilter;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(marketControllerProvider);
    final snapshot = repo.getTokenUnlocks(
      sortBy: _sortBy,
      impactFilter: _impactFilter,
    );
    final allSnapshot = repo.getTokenUnlocks();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _unlockVisualScrollClearance
            : _unlockNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-024 TokenUnlocksPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Token Unlock',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _UnlockTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: TokenUnlocksPage.contentKey,
                    padding: EdgeInsets.only(bottom: scrollEndClearance),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: [
                        if (_tab == 'upcoming') ...[
                          _UnlockHero(snapshot: allSnapshot),
                          _UnlockFilters(
                            sortBy: _sortBy,
                            impactFilter: _impactFilter,
                            impactConfigs: snapshot.impactConfigs,
                            onSortSelected: (value) =>
                                setState(() => _sortBy = value),
                            onImpactSelected: (value) => setState(() {
                              _impactFilter = _impactFilter == value
                                  ? null
                                  : value;
                            }),
                            onAllImpacts: () => setState(() {
                              _impactFilter = null;
                            }),
                          ),
                          if (snapshot.unlocks.isEmpty)
                            const _UnlockEmptyState()
                          else
                            _UnlockList(
                              unlocks: snapshot.unlocks,
                              impactConfigs: snapshot.impactConfigs,
                              categoryConfigs: snapshot.categoryConfigs,
                              expandedId: _expandedId,
                              onToggleExpanded: (unlock) => setState(() {
                                _expandedId = _expandedId == unlock.id
                                    ? null
                                    : unlock.id;
                              }),
                            ),
                        ] else if (_tab == 'analysis') ...[
                          _ImpactOverview(snapshot: allSnapshot),
                          const _SectionHeader(
                            label: 'Theo loại',
                            accentColor: AppColors.accent,
                          ),
                          _CategoryBreakdown(snapshot: allSnapshot),
                          const _SectionHeader(
                            label: 'Rủi ro pha loãng cao nhất',
                            accentColor: AppColors.sell,
                          ),
                          _DilutionRanking(snapshot: allSnapshot),
                          const _UnlockWarningCard(),
                        ] else ...[
                          _ScheduleList(snapshot: allSnapshot),
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

class _UnlockTabs extends StatelessWidget {
  const _UnlockTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: _unlockTabsHeight,
        child: Row(
          children: [
            _UnderlinedTab(
              key: TokenUnlocksPage.upcomingTabKey,
              label: 'Sắp mở khóa',
              value: 'upcoming',
              active: activeTab == 'upcoming',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: TokenUnlocksPage.analysisTabKey,
              label: 'Phân tích',
              value: 'analysis',
              active: activeTab == 'analysis',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: TokenUnlocksPage.scheduleTabKey,
              label: 'Lịch trình',
              value: 'schedule',
              active: activeTab == 'schedule',
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
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _unlockTabIndicatorHeight,
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

class _UnlockHero extends StatelessWidget {
  const _UnlockHero({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: double.infinity,
      padding: AppSpacing.tokenUnlocksHeroPadding,
      borderColor: _marketPrimary.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng giá trị mở khóa sắp tới',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: _unlockHeroLabelGap),
          Text(
            _formatCompactUsd(snapshot.totalValueNext30d),
            style: AppTextStyles.amountMd.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: _unlockHeroValueGap),
          Row(
            children: [
              Text(
                '${snapshot.highImpactCount} tác động cao',
                style: AppTextStyles.micro.copyWith(color: AppColors.sell),
              ),
              const SizedBox(width: AppSpacing.tokenUnlocksHeroMetaGap),
              Text(
                'TB dilution: ${snapshot.avgDilution.toStringAsFixed(1)}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnlockFilters extends StatelessWidget {
  const _UnlockFilters({
    required this.sortBy,
    required this.impactFilter,
    required this.impactConfigs,
    required this.onSortSelected,
    required this.onImpactSelected,
    required this.onAllImpacts,
  });

  final MarketUnlockSort sortBy;
  final MarketUnlockImpact? impactFilter;
  final Map<MarketUnlockImpact, UnlockImpactConfig> impactConfigs;
  final ValueChanged<MarketUnlockSort> onSortSelected;
  final ValueChanged<MarketUnlockImpact> onImpactSelected;
  final VoidCallback onAllImpacts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _FilterChipButton(
            label: 'Gần nhất',
            active: sortBy == MarketUnlockSort.nearest,
            color: _marketPrimary,
            onTap: () => onSortSelected(MarketUnlockSort.nearest),
          ),
          const SizedBox(width: _unlockFilterGap),
          _FilterChipButton(
            key: TokenUnlocksPage.sortValueKey,
            label: 'Giá trị cao',
            active: sortBy == MarketUnlockSort.value,
            color: _marketPrimary,
            onTap: () => onSortSelected(MarketUnlockSort.value),
          ),
          const SizedBox(width: _unlockFilterGap),
          _FilterChipButton(
            label: 'Tác động',
            active: sortBy == MarketUnlockSort.impact,
            color: _marketPrimary,
            onTap: () => onSortSelected(MarketUnlockSort.impact),
          ),
          const SizedBox(width: _unlockFilterGap),
          _FilterChipButton(
            label: 'Tất cả',
            active: impactFilter == null,
            color: AppColors.text3,
            onTap: onAllImpacts,
          ),
          const SizedBox(width: _unlockFilterGap),
          for (final entry in impactConfigs.entries) ...[
            _FilterChipButton(
              key: entry.key == MarketUnlockImpact.high
                  ? TokenUnlocksPage.impactHighKey
                  : null,
              label: entry.value.label,
              active: impactFilter == entry.key,
              color: entry.value.color,
              onTap: () => onImpactSelected(entry.key),
            ),
            if (entry.key != impactConfigs.keys.last)
              const SizedBox(width: _unlockFilterGap),
          ],
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active
          ? color.withValues(alpha: color == AppColors.text3 ? .06 : .12)
          : AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: Padding(
          padding: AppSpacing.tokenUnlocksFilterPadding,
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: active ? color : AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _UnlockList extends StatelessWidget {
  const _UnlockList({
    required this.unlocks,
    required this.impactConfigs,
    required this.categoryConfigs,
    required this.expandedId,
    required this.onToggleExpanded,
  });

  final List<TokenUnlockDraft> unlocks;
  final Map<MarketUnlockImpact, UnlockImpactConfig> impactConfigs;
  final Map<MarketUnlockCategory, UnlockCategoryConfig> categoryConfigs;
  final String? expandedId;
  final ValueChanged<TokenUnlockDraft> onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final unlock in unlocks) ...[
          _UnlockCard(
            key: TokenUnlocksPage.unlockCardKey(unlock.id),
            unlock: unlock,
            impactConfig: impactConfigs[unlock.impactLevel]!,
            categoryConfig: categoryConfigs[unlock.category]!,
            expanded: expandedId == unlock.id,
            onToggle: () => onToggleExpanded(unlock),
          ),
          if (unlock != unlocks.last) const SizedBox(height: _unlockListGap),
        ],
      ],
    );
  }
}
