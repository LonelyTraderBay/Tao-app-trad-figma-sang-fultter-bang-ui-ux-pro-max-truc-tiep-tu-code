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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
        child: Row(
          children: [
            for (final tab in tabs)
              Expanded(
                child: InkWell(
                  key: CrossModuleAnalytics.tabKey(tab.tab),
                  onTap: () => onChanged(tab.tab),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x4,
                        ),
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
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: AppSpacing.x1,
                        width: tab.tab == active ? AppSpacing.buttonHero : 0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppRadii.xlRadius,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
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
