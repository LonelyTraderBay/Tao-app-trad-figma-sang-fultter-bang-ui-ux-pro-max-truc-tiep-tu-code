part of '../pages/cross_module_analytics.dart';

class _AnalyticsTabs extends StatelessWidget {
  const _AnalyticsTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<CrossModuleAnalyticsTabDraft> tabs;
  final CrossModuleAnalyticsTab active;
  final ValueChanged<CrossModuleAnalyticsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSpacing.crossModuleTabBarPadding,
            child: Row(
              children: [
                for (final tab in tabs)
                  Expanded(
                    child: VitCard(
                      key: CrossModuleAnalytics.tabKey(tab.tab),
                      onTap: () => onChanged(tab.tab),
                      variant: VitCardVariant.ghost,
                      radius: VitCardRadius.standard,
                      padding: EdgeInsets.zero,
                      borderColor: AppColors.transparent,
                      child: Column(
                        children: [
                          Padding(
                            padding: AppSpacing.crossModuleTabLabelPadding,
                            child: Text(
                              tab.label,
                              style: AppTextStyles.caption.copyWith(
                                color: tab.tab == active
                                    ? AppColors.primary
                                    : AppColors.text3,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: AppSpacing.buttonHero,
                            height: AppSpacing.x1,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                end: tab.tab == active ? 1 : 0,
                              ),
                              duration: const Duration(milliseconds: 160),
                              builder: (context, value, child) =>
                                  Transform.scale(scaleX: value, child: child),
                              child: const DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadii.xlRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: AppColors.divider),
          ),
        ],
      ),
    );
  }
}

class _PerformanceTab extends StatelessWidget {
  const _PerformanceTab({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryGrid(snapshot: snapshot),
        const SizedBox(height: AppSpacing.sectionGap),
        _HighlightCards(snapshot: snapshot),
        const SizedBox(height: AppSpacing.sectionGap),
        _ChartCard(
          title: 'ROI by Module',
          child: CustomPaint(
            painter: _RoiBarPainter(modules: snapshot.modules),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        _ChartCard(
          title: 'Monthly ROI Trends',
          child: CustomPaint(
            painter: _MonthlyLinePainter(points: snapshot.monthlyPerformance),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class _MetricsTab extends StatelessWidget {
  const _MetricsTab({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChartCard(
          title: 'Multi-Metric Comparison',
          child: CustomPaint(
            painter: _RadarMetricPainter(modules: snapshot.modules),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Chi tiet chi so',
          children: [
            for (final module in snapshot.modules)
              _MetricDetailCard(module: module),
          ],
        ),
      ],
    );
  }
}

class _ComparisonTab extends StatelessWidget {
  const _ComparisonTab({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ranked = [...snapshot.modules]
      ..sort((a, b) => _efficiency(b).compareTo(_efficiency(a)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChartCard(
          title: 'Risk vs Return Analysis',
          child: CustomPaint(
            painter: _RiskReturnPainter(modules: snapshot.modules),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Efficiency Comparison',
          children: [
            for (var i = 0; i < ranked.length; i++)
              _EfficiencyRow(rank: i + 1, module: ranked[i]),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const _ArenaAnalyticsDisclosure(),
        const SizedBox(height: AppSpacing.sectionGap),
        const _AnalyticsInfoCard(),
      ],
    );
  }
}
