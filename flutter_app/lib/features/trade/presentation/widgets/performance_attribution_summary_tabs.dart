part of '../pages/performance_attribution_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.18,
      children: [
        _MetricTile(
          label: 'Total Return',
          value: '+${snapshot.totalReturnPct.toStringAsFixed(1)}%',
          caption: '30 ngày',
          valueColor: _attributionGreen,
        ),
        _MetricTile(
          label: 'Alpha (Skill)',
          value:
              '${snapshot.alphaPct >= 0 ? '+' : ''}${snapshot.alphaPct.toStringAsFixed(1)}%',
          caption: 'vs market',
          valueColor: snapshot.alphaPct >= 0
              ? _attributionGreen
              : _attributionRed,
        ),
        _MetricTile(
          label: 'Beta (Market)',
          value: snapshot.beta.toStringAsFixed(2),
          caption: 'sensitivity',
          valueColor: AppColors.text1,
        ),
        _MetricTile(
          label: 'R² (Fit)',
          value: '${(snapshot.rSquared * 100).toStringAsFixed(0)}%',
          caption: 'explained',
          valueColor: AppColors.text1,
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            caption,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttributionTabs extends StatelessWidget {
  const _AttributionTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('attribution', 'Attribution'),
      ('drawdown', 'Drawdown'),
      ('projection', 'Projection'),
      ('correlation', 'Correlation'),
    ];

    return Container(
      height: 54,
      color: AppColors.surface,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: PerformanceAttributionPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeTab == tab.$1
                                ? _attributionPrimary
                                : AppColors.text3,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      height: 2,
                      width: activeTab == tab.$1 ? 70 : 0,
                      color: _attributionPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AttributionTab extends StatelessWidget {
  const _AttributionTab({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(label: 'Returns Decomposition'),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: CustomPaint(
            painter: _ReturnDecompositionPainter(snapshot.returns),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 6),
        const _LegendRow(
          items: [
            _LegendItem('Market (Beta)', _attributionGray),
            _LegendItem('Alpha (Skill)', _attributionPurple),
          ],
        ),
        const SizedBox(height: 18),
        _InfoPanel(snapshot: snapshot),
        const SizedBox(height: 10),
        _ContributionBar(
          label: 'Market contribution (Beta)',
          value: snapshot.marketContributionPct,
          color: _attributionGray,
          ratio: .92,
        ),
        const SizedBox(height: 10),
        _ContributionBar(
          label: 'Skill contribution (Alpha)',
          value: snapshot.skillContributionPct,
          color: _attributionPurple,
          ratio: .45,
        ),
      ],
    );
  }
}
