import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

class LaunchpadPerformancePage extends ConsumerStatefulWidget {
  const LaunchpadPerformancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc297_launchpad_performance_content');
  static const heroKey = Key('sc297_launchpad_performance_hero');
  static const tabsKey = Key('sc297_launchpad_performance_tabs');
  static const bestWorstKey = Key('sc297_launchpad_performance_best_worst');
  static const distributionKey = Key(
    'sc297_launchpad_performance_distribution',
  );
  static const disclaimerKey = Key('sc297_launchpad_performance_disclaimer');

  static Key tabKey(String id) => Key('sc297_launchpad_performance_tab_$id');
  static Key projectKey(String id) =>
      Key('sc297_launchpad_performance_project_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadPerformancePage> createState() =>
      _LaunchpadPerformancePageState();
}

class _LaunchpadPerformancePageState
    extends ConsumerState<LaunchpadPerformancePage> {
  var _activeTab = _PerformanceTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getPerformance();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-297 LaunchpadPerformancePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            _PerformanceTabs(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: LaunchpadPerformancePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    customGap: AppSpacing.x4,
                    children: [
                      switch (_activeTab) {
                        _PerformanceTab.overview => _OverviewTab(
                          snapshot: snapshot,
                        ),
                        _PerformanceTab.projects => _ProjectsTab(
                          projects: snapshot.projects,
                        ),
                        _PerformanceTab.chart => _ChartTab(
                          points: snapshot.chartPoints,
                        ),
                      },
                      const _PerformanceDisclaimer(),
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

class _PerformanceTabs extends StatelessWidget {
  const _PerformanceTabs({required this.activeTab, required this.onChanged});

  final _PerformanceTab activeTab;
  final ValueChanged<_PerformanceTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        key: LaunchpadPerformancePage.tabsKey,
        children: [
          for (final tab in _PerformanceTab.values)
            Expanded(
              child: InkWell(
                key: LaunchpadPerformancePage.tabKey(tab.id),
                onTap: () => onChanged(tab),
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.x4),
                  child: Column(
                    children: [
                      Text(
                        tab.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: tab == activeTab
                              ? AppColors.primary
                              : AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: tab == activeTab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppRadii.xsRadius,
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

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final LaunchpadPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final summary = snapshot.summary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: LaunchpadPerformancePage.heroKey,
          variant: VitCardVariant.hero,
          radius: VitCardRadius.lg,
          borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ROI trung bình (ATH)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                '+${summary.averageRoiAth}%',
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.buy,
                  fontSize: 36,
                ),
              ),
              Text(
                'Trung vị: +${summary.medianRoi}% · Tỷ lệ dương: ${summary.positiveRate.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.x5),
              Row(
                children: [
                  Expanded(
                    child: _HeroMetric(
                      icon: Icons.rocket_launch_outlined,
                      label: 'Tổng dự án',
                      value: '${summary.totalProjects}',
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _HeroMetric(
                      icon: Icons.bar_chart_rounded,
                      label: 'Tổng huy động',
                      value: summary.totalRaised,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _HeroMetric(
                      icon: Icons.groups_2_outlined,
                      label: 'Người tham gia',
                      value: summary.totalParticipants,
                      color: AppColors.warn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          key: LaunchpadPerformancePage.bestWorstKey,
          children: [
            Expanded(
              child: _BestWorstCard(
                icon: Icons.trending_up_rounded,
                eyebrow: 'Tốt nhất',
                value: '+${summary.bestProjectRoi}%',
                title: summary.bestProjectName,
                color: AppColors.buy,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _BestWorstCard(
                icon: Icons.trending_down_rounded,
                eyebrow: 'Kém nhất',
                value: '${summary.worstProjectRoi}%',
                title: summary.worstProjectName,
                color: AppColors.sell,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _RoiDistribution(projects: snapshot.projects),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _BestWorstCard extends StatelessWidget {
  const _BestWorstCard({
    required this.icon,
    required this.eyebrow,
    required this.value,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String eyebrow;
  final String value;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.x3),
          Text(
            eyebrow,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _RoiDistribution extends StatelessWidget {
  const _RoiDistribution({required this.projects});

  final List<LaunchpadHistoricalProjectDraft> projects;

  @override
  Widget build(BuildContext context) {
    final maxRoi = projects.fold<int>(
      1,
      (max, project) => project.roiAth > max ? project.roiAth : max,
    );

    return VitCard(
      key: LaunchpadPerformancePage.distributionKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Phân bổ ROI (ATH)',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 210,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 42,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final label in ['380%', '285%', '190%', '95%', '0%'])
                        Text(
                          label,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: 1,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final project in projects) ...[
                        Expanded(
                          child: _RoiBar(
                            project: project,
                            heightFactor: project.roiAth / maxRoi,
                          ),
                        ),
                        if (project != projects.last)
                          const SizedBox(width: AppSpacing.x2),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoiBar extends StatelessWidget {
  const _RoiBar({required this.project, required this.heightFactor});

  final LaunchpadHistoricalProjectDraft project;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: FractionallySizedBox(
            heightFactor: heightFactor.clamp(.10, 1.0),
            alignment: Alignment.bottomCenter,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: project.roiAth >= 0 ? AppColors.buy : AppColors.sell,
                borderRadius: AppRadii.mdRadius,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          project.symbol,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _ProjectsTab extends StatelessWidget {
  const _ProjectsTab({required this.projects});

  final List<LaunchpadHistoricalProjectDraft> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final project in projects) ...[
          if (project != projects.first) const SizedBox(height: AppSpacing.x3),
          _HistoricalProjectCard(project: project),
        ],
      ],
    );
  }
}

class _HistoricalProjectCard extends StatelessWidget {
  const _HistoricalProjectCard({required this.project});

  final LaunchpadHistoricalProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final currentColor = project.roiCurrent >= 0
        ? AppColors.buy
        : AppColors.sell;
    return VitCard(
      key: LaunchpadPerformancePage.projectKey(project.id),
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: project.accent.withValues(alpha: .12),
                  border: Border.all(
                    color: project.accent.withValues(alpha: .30),
                  ),
                  borderRadius: AppRadii.lgRadius,
                ),
                child: Text(
                  project.symbol.substring(0, 2),
                  style: AppTextStyles.caption.copyWith(
                    color: project.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: 1.15,
                      ),
                    ),
                    Text(
                      '\$${project.symbol} · ${project.launchDate}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _TinyPill(label: project.type, color: project.accent),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _PriceBox(
                  label: 'Giá launch',
                  value: project.launchPrice,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _PriceBox(
                  label: 'ATH',
                  value: project.athPrice,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _PriceBox(
                  label: 'Hiện tại',
                  value: project.currentPrice,
                  color: currentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _RoiBox(label: 'ROI ATH', value: project.roiAth),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _RoiBox(
                  label: 'ROI hiện tại',
                  value: project.roiCurrent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            '${_formatInt(project.participants)} người · ${project.totalRaised}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _PriceBox extends StatelessWidget {
  const _PriceBox({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            '\$${_formatPrice(value)}',
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoiBox extends StatelessWidget {
  const _RoiBox({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .18)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            '${value >= 0 ? '+' : ''}$value%',
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartTab extends StatelessWidget {
  const _ChartTab({required this.points});

  final List<LaunchpadPerformancePointDraft> points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.md,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ROI trung bình theo tháng (ATH)',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Chỉ tính các tháng có dự án launch. Tháng không có dự án hiện 0%.',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x5),
              _PointBars(
                points: points,
                valueFor: (point) => point.avgRoi.toDouble(),
                suffix: '%',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          radius: VitCardRadius.md,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Khối lượng huy động theo tháng',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Tổng số USDT huy động qua tất cả dự án trong tháng.',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x5),
              _PointBars(
                points: points,
                valueFor: (point) => point.volume / 1000,
                suffix: 'K',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PointBars extends StatelessWidget {
  const _PointBars({
    required this.points,
    required this.valueFor,
    required this.suffix,
  });

  final List<LaunchpadPerformancePointDraft> points;
  final double Function(LaunchpadPerformancePointDraft point) valueFor;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final max = points.fold<double>(
      1,
      (largest, point) => valueFor(point) > largest ? valueFor(point) : largest,
    );
    return SizedBox(
      height: 190,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final point in points) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${valueFor(point).round()}$suffix',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Flexible(
                    child: FractionallySizedBox(
                      heightFactor: (valueFor(point) / max).clamp(.08, 1.0),
                      alignment: Alignment.bottomCenter,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppRadii.mdRadius,
                        ),
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    point.month,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (point != points.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _PerformanceDisclaimer extends StatelessWidget {
  const _PerformanceDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadPerformancePage.disclaimerKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Hiệu suất quá khứ không đảm bảo kết quả tương lai. Dữ liệu chỉ mang tính tham khảo. ROI được tính từ giá launch đến giá hiện tại hoặc ATH, chưa trừ phí và slippage. Nghiên cứu kỹ trước khi tham gia bất kỳ dự án nào.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1.1,
        ),
      ),
    );
  }
}

enum _PerformanceTab {
  overview('overview', 'Tổng quan'),
  projects('projects', 'Dự án'),
  chart('chart', 'ROI Chart');

  const _PerformanceTab(this.id, this.label);

  final String id;
  final String label;
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _formatPrice(double value) {
  if (value < .1) return value.toStringAsFixed(3);
  return value.toStringAsFixed(value < 1 ? 2 : 0);
}
