part of 'advanced_charts_page.dart';

class _AdvancedChartsPageState extends ConsumerState<AdvancedChartsPage> {
  String _tab = 'indicators';
  String _indicatorCategory = 'all';
  String _drawingCategory = 'all';
  final Set<String> _activeIndicatorIds = {'sma', 'rsi'};
  String? _expandedIndicatorId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketControllerProvider)
        .getAdvancedCharts(
          indicatorCategory: _indicatorCategory,
          drawingCategory: _drawingCategory,
        );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _advancedVisualScrollClearance
            : _advancedNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-023 AdvancedChartsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phân tích kỹ thuật',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AdvancedChartsTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: AdvancedChartsPage.contentKey,
                    padding: EdgeInsets.only(bottom: scrollEndClearance),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: [
                        if (_tab == 'indicators') ...[
                          _ActiveIndicatorSummary(
                            activeCount: _activeIndicatorIds.length,
                            onClearAll: _activeIndicatorIds.isEmpty
                                ? null
                                : () => setState(_activeIndicatorIds.clear),
                          ),
                          if (_activeIndicatorIds.isNotEmpty)
                            _ActiveIndicatorChips(
                              indicators: _activeIndicators(snapshot),
                              onRemove: _toggleIndicator,
                            ),
                          _IndicatorCategoryFilter(
                            categories: snapshot.indicatorCategories,
                            activeCategory: _indicatorCategory,
                            onSelected: (value) => setState(() {
                              _indicatorCategory = value;
                            }),
                          ),
                          _IndicatorList(
                            indicators: snapshot.indicators,
                            categories: snapshot.indicatorCategories,
                            activeIndicatorIds: _activeIndicatorIds,
                            expandedIndicatorId: _expandedIndicatorId,
                            onToggleActive: _toggleIndicator,
                            onToggleExpanded: (indicator) => setState(() {
                              _expandedIndicatorId =
                                  _expandedIndicatorId == indicator.id
                                  ? null
                                  : indicator.id;
                            }),
                          ),
                        ] else if (_tab == 'drawing') ...[
                          const _DrawingInfoCard(),
                          _DrawingCategoryFilter(
                            categories: snapshot.drawingCategories,
                            activeCategory: _drawingCategory,
                            onSelected: (value) => setState(() {
                              _drawingCategory = value;
                            }),
                          ),
                          _DrawingToolsGrid(
                            tools: snapshot.drawingTools,
                            categories: snapshot.drawingCategories,
                          ),
                          const _SectionHeader(
                            label: 'Mẹo sử dụng',
                            accentColor: AppColors.warn,
                          ),
                          const _TipsCard(),
                        ] else ...[
                          const _SignalDisclaimerCard(),
                          for (final signal in snapshot.signalSummaries)
                            _SignalSummaryCard(signal: signal),
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

  List<TechnicalIndicator> _activeIndicators(
    MarketAdvancedChartsSnapshot snapshot,
  ) {
    final all = ref.watch(marketControllerProvider).getAdvancedCharts();
    return [
      for (final id in _activeIndicatorIds)
        all.indicators.firstWhere(
          (indicator) => indicator.id == id,
          orElse: () => snapshot.indicators.first,
        ),
    ];
  }

  void _toggleIndicator(String id) {
    setState(() {
      if (_activeIndicatorIds.contains(id)) {
        _activeIndicatorIds.remove(id);
      } else {
        _activeIndicatorIds.add(id);
      }
    });
  }
}

class _AdvancedChartsTabs extends StatelessWidget {
  const _AdvancedChartsTabs({required this.activeTab, required this.onChanged});

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
            height: _advancedTabsHeight,
            child: Row(
              children: [
                _UnderlinedTab(
                  key: AdvancedChartsPage.indicatorsTabKey,
                  label: 'Chỉ báo',
                  value: 'indicators',
                  active: activeTab == 'indicators',
                  onChanged: onChanged,
                ),
                _UnderlinedTab(
                  key: AdvancedChartsPage.drawingTabKey,
                  label: 'Công cụ vẽ',
                  value: 'drawing',
                  active: activeTab == 'drawing',
                  onChanged: onChanged,
                ),
                _UnderlinedTab(
                  key: AdvancedChartsPage.signalsTabKey,
                  label: 'Tín hiệu kỹ thuật',
                  value: 'signals',
                  active: activeTab == 'signals',
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
          const Divider(height: AppSpacing.dividerHairline),
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
              height: _advancedTabIndicatorHeight,
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

class _ActiveIndicatorSummary extends StatelessWidget {
  const _ActiveIndicatorSummary({
    required this.activeCount,
    required this.onClearAll,
  });

  final int activeCount;
  final VoidCallback? onClearAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Đang sử dụng: $activeCount chỉ báo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
        if (onClearAll != null)
          TextButton(
            key: AdvancedChartsPage.clearAllKey,
            onPressed: onClearAll,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, _advancedActionMinHeight),
              padding: _advancedClearButtonPadding,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Xóa tất cả',
              style: AppTextStyles.micro.copyWith(color: AppColors.sell),
            ),
          ),
      ],
    );
  }
}

class _ActiveIndicatorChips extends StatelessWidget {
  const _ActiveIndicatorChips({
    required this.indicators,
    required this.onRemove,
  });

  final List<TechnicalIndicator> indicators;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: _advancedSmallGap,
      runSpacing: _advancedSmallGap,
      children: [
        for (final indicator in indicators)
          Material(
            color: indicator.color.withValues(alpha: .08),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
              side: BorderSide(color: indicator.color.withValues(alpha: .22)),
            ),
            child: Padding(
              padding: _advancedActiveChipPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    indicator.shortName,
                    style: AppTextStyles.micro.copyWith(
                      color: indicator.color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: _advancedSmallGap),
                  GestureDetector(
                    onTap: () => onRemove(indicator.id),
                    child: Icon(
                      Icons.close_rounded,
                      size: _advancedChipRemoveIcon,
                      color: indicator.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _IndicatorCategoryFilter extends StatelessWidget {
  const _IndicatorCategoryFilter({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<AdvancedChartCategory> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _FilterChipButton(
            key: AdvancedChartsPage.categoryAllKey,
            label: 'Tất cả',
            active: activeCategory == 'all',
            color: _marketPrimary,
            onTap: () => onSelected('all'),
          ),
          const SizedBox(width: _advancedCompactGap),
          for (final category in categories) ...[
            _FilterChipButton(
              key: category.id == 'trend'
                  ? AdvancedChartsPage.categoryTrendKey
                  : null,
              label: category.label,
              active: activeCategory == category.id,
              color: category.color,
              onTap: () => onSelected(category.id),
            ),
            if (category != categories.last)
              const SizedBox(width: _advancedCompactGap),
          ],
        ],
      ),
    );
  }
}

class _DrawingCategoryFilter extends StatelessWidget {
  const _DrawingCategoryFilter({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<AdvancedChartCategory> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _FilterChipButton(
            label: 'Tất cả',
            active: activeCategory == 'all',
            color: _marketPrimary,
            onTap: () => onSelected('all'),
          ),
          const SizedBox(width: _advancedCompactGap),
          for (final category in categories) ...[
            _FilterChipButton(
              key: category.id == 'line'
                  ? AdvancedChartsPage.drawingLineKey
                  : null,
              label: category.label,
              active: activeCategory == category.id,
              color: _marketPrimary,
              onTap: () => onSelected(category.id),
            ),
            if (category != categories.last)
              const SizedBox(width: _advancedCompactGap),
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
      color: active ? color.withValues(alpha: .10) : AppColors.surface2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.mdRadius,
        side: BorderSide(
          color: active ? color.withValues(alpha: .28) : AppColors.transparent,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: _advancedFilterChipPadding,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? color : AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ),
    );
  }
}
