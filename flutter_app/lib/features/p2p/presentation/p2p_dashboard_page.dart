import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PDashboardPage extends ConsumerStatefulWidget {
  const P2PDashboardPage({super.key, this.shellRenderMode});

  static const filterKey = Key('sc274_p2p_dashboard_filters');
  static const volumeHeroKey = Key('sc274_p2p_dashboard_volume_hero');
  static const metricsKey = Key('sc274_p2p_dashboard_metrics');
  static const weeklyChartKey = Key('sc274_p2p_dashboard_weekly_chart');
  static const monthlyChartKey = Key('sc274_p2p_dashboard_monthly_chart');
  static const assetDistributionKey = Key(
    'sc274_p2p_dashboard_asset_distribution',
  );
  static const levelKey = Key('sc274_p2p_dashboard_level');
  static const comparisonKey = Key('sc274_p2p_dashboard_comparison');
  static const breakdownKey = Key('sc274_p2p_dashboard_breakdown');
  static const merchantsKey = Key('sc274_p2p_dashboard_merchants');
  static const activityKey = Key('sc274_p2p_dashboard_activity');
  static const quickNavKey = Key('sc274_p2p_dashboard_quick_nav');
  static const myOrdersKey = Key('sc274_p2p_dashboard_my_orders');

  static Key filterChipKey(String id) => Key('sc274_p2p_dashboard_filter_$id');

  static Key merchantKey(String id) => Key('sc274_p2p_dashboard_merchant_$id');

  static Key quickActionKey(String id) => Key('sc274_p2p_dashboard_quick_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDashboardPage> createState() => _P2PDashboardPageState();
}

class _P2PDashboardPageState extends ConsumerState<P2PDashboardPage> {
  String _timeFilter = '30d';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getDashboard(timeFilter: _timeFilter);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-274 P2PDashboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x5,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FilterRail(
                        snapshot: snapshot,
                        onChanged: (id) {
                          HapticFeedback.selectionClick();
                          setState(() => _timeFilter = id);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _VolumeHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _MetricsGrid(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _WeeklyVolumeCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _MonthlyOrdersCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _AssetDistributionCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _LevelCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _PlatformComparisonCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _ExtraStats(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _OrderBreakdownCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _TopMerchantsCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _RecentActivityCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _QuickNavigation(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({required this.snapshot, required this.onChanged});

  final P2PDashboardSnapshot snapshot;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2PDashboardPage.filterKey,
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
    return Material(
      key: P2PDashboardPage.filterChipKey(filter.id),
      color: selected ? AppColors.warn10 : AppColors.bg,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppModuleAccents.p2p : AppColors.border,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            filter.label,
            style: AppTextStyles.micro.copyWith(
              color: selected ? AppModuleAccents.p2p : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
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
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x3),
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
              const SizedBox(width: AppSpacing.x3),
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
              fontSize: 28,
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
          if (row == 0) const SizedBox(height: AppSpacing.x3),
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBubble(icon: config.icon, color: config.color, small: true),
              const Spacer(),
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
            icon: Icons.bar_chart_rounded,
            label: 'Volume theo tuần',
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 140,
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
            height: 130,
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
                width: 94,
                height: 94,
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
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadii.xsRadius,
            ),
            child: const SizedBox(width: 10, height: 10),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            item.asset,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const Spacer(),
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
            radius: VitCardRadius.lg,
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x3),
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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

class _ExtraStats extends StatelessWidget {
  const _ExtraStats({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.stats;
    return Row(
      children: [
        Expanded(
          child: _CenteredStat(
            icon: Icons.groups_outlined,
            value: '${stats.uniqueCounterparties}',
            label: 'Đối tác',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _CenteredStat(
            icon: Icons.swap_horiz_rounded,
            value: '${stats.repeatCustomerRate.toStringAsFixed(1)}%',
            label: 'Quay lại',
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _CenteredStat(
            icon: Icons.attach_money_rounded,
            value: _formatMoneyCompact(stats.avgOrderSize),
            label: 'TB đơn hàng',
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _OrderBreakdownCard extends StatelessWidget {
  const _OrderBreakdownCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.stats;
    final rows = [
      _BreakdownConfig(
        label: 'Hoàn thành',
        count: stats.completedOrders,
        color: AppColors.buy,
        icon: Icons.check_circle_outline_rounded,
      ),
      _BreakdownConfig(
        label: 'Đã hủy',
        count: stats.cancelledOrders,
        color: AppColors.sell,
        icon: Icons.cancel_outlined,
      ),
      _BreakdownConfig(
        label: 'Tranh chấp',
        count: stats.disputedOrders,
        color: AppColors.warn,
        icon: Icons.warning_amber_rounded,
      ),
    ];
    return VitCard(
      key: P2PDashboardPage.breakdownKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            icon: Icons.shopping_cart_outlined,
            label: 'Phân tích đơn hàng',
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final row in rows) ...[
            _BreakdownLine(row: row, total: stats.totalOrders),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _TopMerchantsCard extends StatelessWidget {
  const _TopMerchantsCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.merchantsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionTitle(
                  icon: Icons.star_border_rounded,
                  label: 'Top Merchants',
                ),
              ),
              Text(
                '30 ngày qua',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var index = 0; index < snapshot.topMerchants.length; index++)
            _MerchantRow(
              rank: index + 1,
              merchant: snapshot.topMerchants[index],
              onTap: () {
                HapticFeedback.selectionClick();
                context.go('/p2p/merchant/${snapshot.topMerchants[index].id}');
              },
            ),
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.activityKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionTitle(
                  icon: Icons.schedule_rounded,
                  label: 'Hoạt động gần đây',
                ),
              ),
              _TextLinkButton(
                key: P2PDashboardPage.myOrdersKey,
                label: 'Xem tất cả',
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.go(snapshot.myOrdersRoute);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var index = 0; index < snapshot.recentActivity.length; index++)
            _ActivityRow(
              activity: snapshot.recentActivity[index],
              last: index == snapshot.recentActivity.length - 1,
            ),
        ],
      ),
    );
  }
}

class _QuickNavigation extends StatelessWidget {
  const _QuickNavigation({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PDashboardPage.quickNavKey,
      children: [
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              Expanded(
                child: _QuickActionTile(action: snapshot.quickActions[row * 2]),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _QuickActionTile(
                  action: snapshot.quickActions[row * 2 + 1],
                ),
              ),
            ],
          ),
          if (row == 0) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final P2PDashboardQuickActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = _quickColor(action.id);
    return Material(
      key: P2PDashboardPage.quickActionKey(action.id),
      color: AppColors.surface,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(action.route);
        },
        borderRadius: AppRadii.cardRadius,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.x4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            children: [
              _IconBubble(icon: _quickIcon(action.iconKey), color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  action.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text2, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    this.small = false,
  });

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? AppSpacing.buttonCompact : AppSpacing.inputHeight;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.inputRadius,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, color: color, size: small ? 16 : AppSpacing.iconMd),
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.arrow_outward_rounded, color: AppColors.buy, size: 11),
        const SizedBox(width: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TinyLegend extends StatelessWidget {
  const _TinyLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Container(
            width: AppSpacing.x2,
            height: AppSpacing.x2,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RequirementPill extends StatelessWidget {
  const _RequirementPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _ComparisonLine extends StatelessWidget {
  const _ComparisonLine({required this.item});

  final P2PDashboardComparisonDraft item;

  @override
  Widget build(BuildContext context) {
    final better = item.lowerBetter
        ? item.yours < item.platform
        : item.yours > item.platform;
    final color = better ? AppColors.buy : AppColors.warn;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              '${_formatDecimal(item.yours)}${item.suffix}',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'vs ${_formatDecimal(item.platform)}${item.suffix}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            value: (item.yours / 100).clamp(.02, 1),
            minHeight: 5,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _CenteredStat extends StatelessWidget {
  const _CenteredStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _BreakdownConfig {
  const _BreakdownConfig({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  final String label;
  final int count;
  final Color color;
  final IconData icon;
}

class _BreakdownLine extends StatelessWidget {
  const _BreakdownLine({required this.row, required this.total});

  final _BreakdownConfig row;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = row.count / total * 100;
    return Row(
      children: [
        Icon(row.icon, color: row.color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    '${row.count} (+${pct.toStringAsFixed(2)}%)',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              ClipRRect(
                borderRadius: AppRadii.xsRadius,
                child: LinearProgressIndicator(
                  value: pct / 100,
                  minHeight: 5,
                  backgroundColor: AppColors.surface2,
                  valueColor: AlwaysStoppedAnimation<Color>(row.color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MerchantRow extends StatelessWidget {
  const _MerchantRow({
    required this.rank,
    required this.merchant,
    required this.onTap,
  });

  final int rank;
  final P2PDashboardMerchantDraft merchant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rankColor = rank <= 3 ? AppModuleAccents.p2p : AppColors.text3;
    return Material(
      key: P2PDashboardPage.merchantKey(merchant.id),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          child: Row(
            children: [
              SizedBox(
                width: AppSpacing.buttonCompact,
                child: Text(
                  '#$rank',
                  style: AppTextStyles.caption.copyWith(
                    color: rankColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _Avatar(label: merchant.name.characters.first),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchant.name,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${merchant.trades} đơn · ${_formatMoneyCompact(merchant.volume)}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.star_rounded, color: AppColors.warn, size: 12),
              const SizedBox(width: AppSpacing.x1),
              Text(
                merchant.rating.toStringAsFixed(1),
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppModuleAccents.p2p,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: AppSpacing.buttonCompact,
        height: AppSpacing.buttonCompact,
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity, required this.last});

  final P2PDashboardActivityDraft activity;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final buy = activity.type == 'buy';
    final color = buy ? AppColors.buy : AppColors.sell;
    final status = _statusInfo(activity.status);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _IconBubble(
            icon: buy ? Icons.south_west_rounded : Icons.north_east_rounded,
            color: color,
            small: true,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${buy ? 'Mua' : 'Bán'} ${_formatAmount(activity.amount)} ${activity.asset}',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${activity.merchant} · ${activity.date}',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatMoneyCompact(activity.total),
                style: AppTextStyles.micro.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              _SmallPill(label: status.label, color: status.color),
            ],
          ),
        ],
      ),
    );
  }
}

class _TextLinkButton extends StatelessWidget {
  const _TextLinkButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppModuleAccents.p2p,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppModuleAccents.p2p,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter(this.points);

  final List<P2PDashboardSeriesPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const left = 14.0;
    const top = 8.0;
    const bottom = 22.0;
    final width = size.width - left - AppSpacing.x2;
    final height = size.height - top - bottom;
    final maxValue = points.map((item) => item.value).reduce(math.max);
    final path = Path();
    final fillPath = Path();
    final offsets = <Offset>[];

    for (var i = 0; i < points.length; i++) {
      final x = left + width * (i / (points.length - 1));
      final y = top + height - (points[i].value / maxValue) * height;
      offsets.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, top + height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(left + width, top + height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()..color = AppModuleAccents.p2p.withValues(alpha: .10),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppModuleAccents.p2p
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    for (var i = 0; i < offsets.length; i++) {
      canvas.drawCircle(offsets[i], 3, Paint()..color = AppColors.bg);
      canvas.drawCircle(
        offsets[i],
        3,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
      _paintTinyText(
        canvas,
        points[i].label,
        Offset(offsets[i].dx - 8, top + height + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _MonthlyBarPainter extends CustomPainter {
  const _MonthlyBarPainter(this.rows);

  final List<P2PDashboardMonthlyOrdersDraft> rows;

  @override
  void paint(Canvas canvas, Size size) {
    if (rows.isEmpty) return;
    const top = 8.0;
    const bottom = 22.0;
    final height = size.height - top - bottom;
    final groupWidth = size.width / rows.length;
    final maxValue = rows
        .expand((item) => [item.buy, item.sell])
        .reduce(math.max)
        .toDouble();

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final centerX = groupWidth * i + groupWidth / 2;
      _drawBar(
        canvas,
        centerX - 9,
        top,
        height,
        row.buy / maxValue,
        AppColors.buy,
      );
      _drawBar(
        canvas,
        centerX + 7,
        top,
        height,
        row.sell / maxValue,
        AppColors.sell,
      );
      _paintTinyText(canvas, row.month, Offset(centerX - 10, top + height + 8));
    }
  }

  void _drawBar(
    Canvas canvas,
    double x,
    double top,
    double height,
    double factor,
    Color color,
  ) {
    final barHeight = math.max(6.0, height * factor);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, top + height - barHeight, 12, barHeight),
      const Radius.circular(3),
    );
    canvas.drawRRect(rect, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MonthlyBarPainter oldDelegate) {
    return oldDelegate.rows != rows;
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.rows);

  final List<P2PDashboardAssetDraft> rows;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;
    for (final row in rows) {
      final sweep = math.pi * 2 * (row.percentage / 100);
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = _assetColor(row.asset)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.rows != rows;
  }
}

void _paintTinyText(Canvas canvas, String text, Offset offset) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3, fontSize: 9),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'ETH' => AppColors.primary,
    'BNB' => AppModuleAccents.p2p,
    'SOL' => AppColors.accent,
    _ => AppColors.text2,
  };
}

Color _quickColor(String id) {
  return switch (id) {
    'orders' => AppColors.primary,
    'reviews' => AppColors.warn,
    'ads' => AppColors.accent,
    'express' => AppColors.buy,
    _ => AppColors.text2,
  };
}

IconData _quickIcon(String iconKey) {
  return switch (iconKey) {
    'orders' => Icons.shopping_cart_outlined,
    'reviews' => Icons.star_border_rounded,
    'ads' => Icons.bar_chart_rounded,
    'express' => Icons.bolt_outlined,
    _ => Icons.chevron_right_rounded,
  };
}

({String label, Color color}) _statusInfo(String status) {
  return switch (status) {
    'pending_payment' => (label: 'Chờ TT', color: AppColors.warn),
    'paid' => (label: 'Đã TT', color: AppColors.primary),
    'released' => (label: 'Hoàn tất', color: AppColors.buy),
    'cancelled' => (label: 'Đã hủy', color: AppColors.sell),
    'disputed' => (label: 'Tranh chấp', color: AppColors.sell),
    _ => (label: status, color: AppColors.text2),
  };
}

String _formatMoneyCompact(double value) {
  if (value >= 1000000000) {
    return '₫${(value / 1000000000).toStringAsFixed(value % 1000000000 == 0 ? 0 : 2)}B';
  }
  if (value >= 1000000) {
    final scaled = value / 1000000;
    final text = scaled >= 100
        ? scaled.toStringAsFixed(0)
        : scaled >= 10
        ? scaled.toStringAsFixed(1)
        : scaled.toStringAsFixed(2);
    return '₫${text.replaceAll(RegExp(r'\.00$'), '')}M';
  }
  return '₫${_formatWhole(value.round())}';
}

String _formatWhole(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}

String _formatDecimal(double value) {
  if (value % 1 == 0) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}

String _formatAmount(double value) {
  if (value >= 1) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(4);
  }
  return value.toStringAsFixed(6);
}
