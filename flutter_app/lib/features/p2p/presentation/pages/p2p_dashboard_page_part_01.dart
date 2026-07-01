part of 'p2p_dashboard_page.dart';

const double _dashboardLargeChartExtent =
    AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x4;
const double _dashboardMediumChartExtent =
    AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5;

class _FilterRail extends StatelessWidget {
  const _FilterRail({required this.snapshot, required this.onChanged});

  final P2PDashboardSnapshot snapshot;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: P2PDashboardPage.filterKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final filter in snapshot.filters) ...[
            _FilterChip(
              filter: filter,
              selected: filter.id == snapshot.selectedFilter.id,
              onTap: () => onChanged(filter.id),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final P2PDashboardFilterDraft filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: P2PDashboardPage.filterChipKey(filter.id),
      label: filter.label,
      selected: selected,
      onTap: onTap,
      padding: AppSpacing.p2pDashboardFilterChipPadding,
      accentColor: AppModuleAccents.p2p,
      semanticLabel: 'P2P dashboard filter ${filter.label}',
    );
  }
}

class _VolumeHero extends StatelessWidget {
  const _VolumeHero({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.volumeHeroKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: AppSpacing.p2pDashboardCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _IconBubble(
                icon: Icons.monitor_heart_outlined,
                color: AppModuleAccents.p2p,
                small: true,
              ),
              const SizedBox(width: AppSpacing.p2pDashboardMetricRowGap),
              Expanded(
                child: Text(
                  'Tổng Volume (${snapshot.selectedFilter.label})',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const _TrendBadge(value: '+12.5%'),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            _formatMoneyCompact(snapshot.selectedVolume),
            style: AppTextStyles.pageTitle.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _TinyLegend(
                color: AppColors.buy,
                label:
                    'Mua: ${_formatMoneyCompact(snapshot.stats.buyVolume30d)}',
              ),
              const SizedBox(width: AppSpacing.x5),
              _TinyLegend(
                color: AppColors.sell,
                label:
                    'Bán: ${_formatMoneyCompact(snapshot.stats.sellVolume30d)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.stats;
    final items = [
      _MetricConfig(
        label: 'Đơn hoàn thành',
        value: '${stats.completedOrders}',
        sub: '/ ${stats.totalOrders} tổng',
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.buy,
        trend: '+8.30%',
      ),
      _MetricConfig(
        label: 'Tỷ lệ hoàn thành',
        value: '${stats.completionRate.toStringAsFixed(1)}%',
        sub: 'Platform: ${stats.platformAvgCompletionRate.toStringAsFixed(1)}%',
        icon: Icons.track_changes_rounded,
        color: AppColors.warn,
      ),
      _MetricConfig(
        label: 'Lợi nhuận Spread',
        value: _formatMoneyCompact(stats.spreadRevenue30d),
        sub: '30 ngày qua',
        icon: Icons.attach_money_rounded,
        color: AppColors.warn,
        trend: '+15.20%',
      ),
      _MetricConfig(
        label: 'TB Thời gian',
        value: stats.avgCompletionTime,
        sub: 'Platform: ${stats.platformAvgResponseTime}',
        icon: Icons.schedule_rounded,
        color: AppColors.primary,
      ),
    ];

    return Column(
      key: P2PDashboardPage.metricsKey,
      children: [
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              Expanded(child: _MetricCard(config: items[row * 2])),
              const SizedBox(width: AppSpacing.x3),
              Expanded(child: _MetricCard(config: items[row * 2 + 1])),
            ],
          ),
          if (row == 0)
            const SizedBox(height: AppSpacing.p2pDashboardMetricRowGap),
        ],
      ],
    );
  }
}

class _MetricConfig {
  const _MetricConfig({
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    required this.color,
    this.trend,
  });

  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color color;
  final String? trend;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.config});

  final _MetricConfig config;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pDashboardCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _IconBubble(icon: config.icon, color: config.color, small: true),
              if (config.trend != null) _TrendBadge(value: config.trend!),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            config.value,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            config.label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            config.sub,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _WeeklyVolumeCard extends StatelessWidget {
  const _WeeklyVolumeCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.weeklyChartKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
            icon: Icons.bar_chart_rounded,
            label: 'Volume theo tuần',
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: _dashboardLargeChartExtent,
            child: CustomPaint(
              painter: _LineChartPainter(snapshot.weeklyVolume),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyOrdersCard extends StatelessWidget {
  const _MonthlyOrdersCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.monthlyChartKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionTitle(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Đơn hàng theo tháng',
                ),
              ),
              const _TinyLegend(color: AppColors.buy, label: 'Mua'),
              const SizedBox(width: AppSpacing.x3),
              const _TinyLegend(color: AppColors.sell, label: 'Bán'),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: _dashboardMediumChartExtent,
            child: CustomPaint(
              painter: _MonthlyBarPainter(snapshot.monthlyOrders),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetDistributionCard extends StatelessWidget {
  const _AssetDistributionCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.assetDistributionKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            icon: Icons.donut_large_outlined,
            label: 'Phân bổ tài sản',
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              SizedBox(
                width: AppSpacing.p2pDashboardDonutSize,
                height: AppSpacing.p2pDashboardDonutSize,
                child: CustomPaint(
                  painter: _DonutPainter(snapshot.assetDistribution),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  children: [
                    for (final item in snapshot.assetDistribution)
                      _AssetLine(item: item),
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

class _AssetLine extends StatelessWidget {
  const _AssetLine({required this.item});

  final P2PDashboardAssetDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(item.asset);
    return Padding(
      padding: AppSpacing.p2pDashboardAssetLinePadding,
      child: Row(
        children: [
          Material(
            color: color,
            borderRadius: AppRadii.xsRadius,
            child: const SizedBox(
              width: AppSpacing.p2pDashboardAssetSwatch,
              height: AppSpacing.p2pDashboardAssetSwatch,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              item.asset,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            '${item.percentage.toStringAsFixed(0)}%',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            _formatMoneyCompact(item.volume),
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final current = snapshot.currentLevel;
    final next = snapshot.nextLevel;
    final dailyPct = current.dailyUsed / current.dailyLimit;
    return VitCard(
      key: P2PDashboardPage.levelKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionTitle(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Cấp & Hạn mức',
                ),
              ),
              _SmallPill(
                label: 'Lv.${current.id} ${current.name}',
                color: AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _ProgressLine(
            label: 'Hạn mức hôm nay',
            value:
                '${_formatMoneyCompact(current.dailyUsed)} / ${_formatMoneyCompact(current.dailyLimit)}',
            progress: dailyPct,
            color: AppColors.buy,
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            radius: VitCardRadius.large,
            variant: VitCardVariant.inner,
            padding: AppSpacing.p2pDashboardCompactCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProgressLine(
                  label: 'Lên Lv.${next.id} ${next.name}',
                  value: '${(next.progress * 100).round()}%',
                  progress: next.progress,
                  color: AppModuleAccents.p2p,
                ),
                const SizedBox(height: AppSpacing.x3),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final requirement in next.requirements)
                      _RequirementPill(label: requirement),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformComparisonCard extends StatelessWidget {
  const _PlatformComparisonCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.comparisonKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            icon: Icons.trending_up_rounded,
            label: 'So sánh với Platform',
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final item in snapshot.platformComparisons) ...[
            _ComparisonLine(item: item),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}
