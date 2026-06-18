part of '../pages/performance_attribution_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: AppSpacing.tradeBotGridColumns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.tradeBotCardGap,
      crossAxisSpacing: AppSpacing.tradeBotCardGap,
      childAspectRatio: AppSpacing.tradeBotAttributionMetricAspectRatio,
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
      padding: AppSpacing.tradeBotAttributionMetricPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightShort,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotLabelGap),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.extraBold,
              height: AppSpacing.tradeBotLineHeightShort,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            caption,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightShort,
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

    return VitCard(
      variant: VitCardVariant.inner,
      height: AppSpacing.tradeBotAttributionTabHeight,
      padding: AppSpacing.tradeSegmentedPadding,
      child: VitTabBar(
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: PerformanceAttributionPage.tabKey(tab.$1),
            ),
        ],
        activeKey: activeTab,
        onChanged: onChanged,
        variant: VitTabBarVariant.segment,
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
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        SizedBox(
          height: AppSpacing.tradeBotAttributionReturnsChartHeight,
          child: CustomPaint(
            painter: _ReturnDecompositionPainter(snapshot.returns),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotNarrowIconGap),
        const _LegendRow(
          items: [
            _LegendItem('Market (Beta)', _attributionGray),
            _LegendItem('Alpha (Skill)', _attributionPurple),
          ],
        ),
        const SizedBox(height: AppSpacing.tradeBotDisputeCasesTopGap),
        _InfoPanel(snapshot: snapshot),
        const SizedBox(height: AppSpacing.tradeBotRowGap),
        _ContributionBar(
          label: 'Market contribution (Beta)',
          value: snapshot.marketContributionPct,
          color: _attributionGray,
          ratio: .92,
        ),
        const SizedBox(height: AppSpacing.tradeBotRowGap),
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
