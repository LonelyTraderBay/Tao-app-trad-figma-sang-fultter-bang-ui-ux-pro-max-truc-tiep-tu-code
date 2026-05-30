import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';

class CrossModuleAnalytics extends ConsumerStatefulWidget {
  const CrossModuleAnalytics({super.key, this.shellRenderMode});

  static const contentKey = Key('sc322_cross_module_analytics_content');
  static Key tabKey(CrossModuleAnalyticsTab tab) =>
      Key('sc322_tab_${tab.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CrossModuleAnalytics> createState() =>
      _CrossModuleAnalyticsState();
}

class _CrossModuleAnalyticsState extends ConsumerState<CrossModuleAnalytics> {
  CrossModuleAnalyticsTab _activeTab = CrossModuleAnalyticsTab.performance;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(crossModuleAnalyticsControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-322 CrossModuleAnalytics',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            _AnalyticsTabs(
              tabs: snapshot.tabs,
              active: _activeTab,
              onChanged: (tab) {
                HapticFeedback.selectionClick();
                setState(() => _activeTab = tab);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CrossModuleAnalytics.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.defaultGap,
                  children: [
                    if (_activeTab == CrossModuleAnalyticsTab.performance)
                      _PerformanceTab(snapshot: snapshot)
                    else if (_activeTab == CrossModuleAnalyticsTab.metrics)
                      _MetricsTab(snapshot: snapshot)
                    else
                      _ComparisonTab(snapshot: snapshot),
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Avg ROI',
                value: '+${snapshot.averageRoi.toStringAsFixed(1)}%',
                valueColor: AppColors.buy,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _SummaryCard(
                label: 'Total Trades',
                value: '${snapshot.totalTrades}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Total Volume',
                value: '\$${(snapshot.totalVolume / 1000).toStringAsFixed(0)}K',
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _SummaryCard(
                label: 'Avg Win Rate',
                value: '${snapshot.averageWinRate.toStringAsFixed(0)}%',
                valueColor: AppColors.buy,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightCards extends StatelessWidget {
  const _HighlightCards({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HighlightCard(
            title: 'Best ROI',
            module: snapshot.bestRoiModule.name,
            value: '+${snapshot.bestRoiModule.roi.toStringAsFixed(1)}%',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _HighlightCard(
            title: 'Most Active',
            module: snapshot.mostActiveModule.name,
            value: '${snapshot.mostActiveModule.totalTrades} trades',
            icon: Icons.timeline_rounded,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.title,
    required this.module,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String module;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .24),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            module,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          SizedBox(
            height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
            child: child,
          ),
        ],
      ),
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

class _MetricDetailCard extends StatelessWidget {
  const _MetricDetailCard({required this.module});

  final CrossModuleMetricDraft module;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            module.name,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _MetricValue(label: 'ROI', value: '+${module.roi}%'),
              ),
              Expanded(
                child: _MetricValue(
                  label: 'Win Rate',
                  value: '${module.winRate}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _MetricValue(
                  label: 'Total Trades',
                  value: '${module.totalTrades}',
                ),
              ),
              Expanded(
                child: _MetricValue(
                  label: 'Avg Size',
                  value: '\$${module.avgTradeSize}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Risk Score',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${module.riskScore}/100',
                style: AppTextStyles.caption.copyWith(
                  color: _riskColor(module.riskScore),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: module.riskScore / 100,
              minHeight: AppSpacing.x2,
              backgroundColor: AppColors.surface3,
              color: _riskColor(module.riskScore),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricValue extends StatelessWidget {
  const _MetricValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
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

class _EfficiencyRow extends StatelessWidget {
  const _EfficiencyRow({required this.rank, required this.module});

  final int rank;
  final CrossModuleMetricDraft module;

  @override
  Widget build(BuildContext context) {
    final efficiency = _efficiency(module);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.buttonCompact,
                child: rank == 1
                    ? const Icon(
                        Icons.adjust_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconMd,
                      )
                    : Text(
                        '#$rank',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  module.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                efficiency.toStringAsFixed(1),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _MetricValue(label: 'ROI', value: '${module.roi}%'),
              ),
              Expanded(
                child: _MetricValue(
                  label: 'Risk',
                  value: '${module.riskScore}/100',
                ),
              ),
              Expanded(
                child: _MetricValue(
                  label: 'Efficiency',
                  value: efficiency.toStringAsFixed(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArenaAnalyticsDisclosure extends StatelessWidget {
  const _ArenaAnalyticsDisclosure();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.bolt_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Open Arena metrics are not included in financial analytics as Arena uses points-only system. See Arena leaderboard for trust and performance metrics.',
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

class _AnalyticsInfoCard extends StatelessWidget {
  const _AnalyticsInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Metrics calculated independently per module. Cross-module comparison helps identify best strategies.',
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

class _RoiBarPainter extends CustomPainter {
  const _RoiBarPainter({required this.modules});

  final List<CrossModuleMetricDraft> modules;

  @override
  void paint(Canvas canvas, Size size) {
    final maxRoi = modules.map((item) => item.roi).reduce(math.max);
    final slot = size.width / modules.length;
    final barWidth = math.min(AppSpacing.x7, slot * .56);
    final baseY = size.height - AppSpacing.x5;
    final axis = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, baseY), Offset(size.width, baseY), axis);

    for (var i = 0; i < modules.length; i++) {
      final module = modules[i];
      final height = module.roi / maxRoi * (size.height - AppSpacing.x7);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          slot * i + (slot - barWidth) / 2,
          baseY - height,
          barWidth,
          height,
        ),
        const Radius.circular(AppSpacing.x2),
      );
      canvas.drawRRect(rect, Paint()..color = AppColors.buy);
    }
  }

  @override
  bool shouldRepaint(covariant _RoiBarPainter oldDelegate) =>
      oldDelegate.modules != modules;
}

class _MonthlyLinePainter extends CustomPainter {
  const _MonthlyLinePainter({required this.points});

  final List<CrossModuleMonthlyPerformanceDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final allValues = [
      for (final point in points) ...[
        point.trading,
        point.p2p,
        point.predictions,
        point.dca,
      ],
    ];
    final minValue = allValues.reduce(math.min);
    final maxValue = allValues.reduce(math.max);

    void drawSeries(
      double Function(CrossModuleMonthlyPerformanceDraft point) valueOf,
      Color color,
    ) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x = i / (points.length - 1) * size.width;
        final y =
            size.height -
            (valueOf(points[i]) - minValue) /
                (maxValue - minValue) *
                (size.height - AppSpacing.x6);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = AppSpacing.x1
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }

    drawSeries((point) => point.trading, AppColors.buy);
    drawSeries((point) => point.p2p, AppModuleAccents.p2p);
    drawSeries((point) => point.predictions, AppModuleAccents.predictions);
    drawSeries((point) => point.dca, AppColors.accent);
  }

  @override
  bool shouldRepaint(covariant _MonthlyLinePainter oldDelegate) =>
      oldDelegate.points != points;
}

class _RadarMetricPainter extends CustomPainter {
  const _RadarMetricPainter({required this.modules});

  final List<CrossModuleMetricDraft> modules;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .38;
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.divider;
    for (final scale in [.35, .68, 1.0]) {
      _drawPolygon(canvas, center, radius * scale, gridPaint);
    }
    _drawRadarSeries(
      canvas,
      center,
      radius,
      modules.map((module) => module.roi * 4).toList(),
      AppColors.buy,
    );
    _drawRadarSeries(
      canvas,
      center,
      radius,
      modules.map((module) => module.winRate).toList(),
      AppColors.primary,
    );
    _drawRadarSeries(
      canvas,
      center,
      radius,
      modules.map((module) => module.totalVolume / 2500).toList(),
      AppColors.warn,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarMetricPainter oldDelegate) =>
      oldDelegate.modules != modules;
}

class _RiskReturnPainter extends CustomPainter {
  const _RiskReturnPainter({required this.modules});

  final List<CrossModuleMetricDraft> modules;

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - AppSpacing.x4),
      Offset(size.width, size.height - AppSpacing.x4),
      axis,
    );
    canvas.drawLine(
      const Offset(AppSpacing.x4, 0),
      Offset(AppSpacing.x4, size.height),
      axis,
    );

    for (final module in modules) {
      final x =
          AppSpacing.x4 + module.riskScore / 100 * (size.width - AppSpacing.x6);
      final y =
          size.height -
          AppSpacing.x4 -
          module.roi / 22 * (size.height - AppSpacing.x6);
      canvas.drawCircle(
        Offset(x, y),
        AppSpacing.x3,
        Paint()..color = _analyticsAccent(module.id),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RiskReturnPainter oldDelegate) =>
      oldDelegate.modules != modules;
}

void _drawPolygon(Canvas canvas, Offset center, double radius, Paint paint) {
  final path = Path();
  for (var i = 0; i < 4; i++) {
    final angle = -math.pi / 2 + i * math.pi / 2;
    final point = Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  canvas.drawPath(path, paint);
}

void _drawRadarSeries(
  Canvas canvas,
  Offset center,
  double radius,
  List<double> values,
  Color color,
) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final angle = -math.pi / 2 + i * math.pi * 2 / values.length;
    final normalized = values[i].clamp(0, 100) / 100;
    final point = Offset(
      center.dx + math.cos(angle) * radius * normalized,
      center.dy + math.sin(angle) * radius * normalized,
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  canvas.drawPath(
    path,
    Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: .18),
  );
  canvas.drawPath(
    path,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.x1
      ..color = color,
  );
}

double _efficiency(CrossModuleMetricDraft module) =>
    module.riskScore == 0 ? 0 : module.roi / module.riskScore * 100;

Color _riskColor(int riskScore) {
  if (riskScore > 70) return AppColors.sell;
  if (riskScore > 50) return AppColors.warn;
  return AppColors.buy;
}

Color _analyticsAccent(AnalyticsModuleId id) {
  switch (id) {
    case AnalyticsModuleId.trading:
      return AppColors.buy;
    case AnalyticsModuleId.p2p:
      return AppModuleAccents.p2p;
    case AnalyticsModuleId.predictions:
      return AppModuleAccents.predictions;
    case AnalyticsModuleId.dca:
      return AppColors.accent;
  }
}
