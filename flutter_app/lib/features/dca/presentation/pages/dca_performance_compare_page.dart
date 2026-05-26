import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';

enum _CompareTab { compare, scenarios, analysis }

class DCAPerformanceComparePage extends ConsumerStatefulWidget {
  const DCAPerformanceComparePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc178_performance_compare_content');

  static Key tabKey(String tabName) => Key('sc178_tab_$tabName');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAPerformanceComparePage> createState() =>
      _DCAPerformanceComparePageState();
}

class _DCAPerformanceComparePageState
    extends ConsumerState<DCAPerformanceComparePage> {
  _CompareTab _activeTab = _CompareTab.compare;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaRepositoryProvider).getPerformanceCompare();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-178 DCAPerformanceComparePage',
      child: Column(
        children: [
          VitHeader(title: 'DCA vs Lump Sum', showBack: true, onBack: _close),
          _TopTabs(
            activeTab: _activeTab,
            onChanged: (tab) => setState(() => _activeTab = tab),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: DCAPerformanceComparePage.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollBottom),
              child: VitPageContent(
                customGap: AppSpacing.x5,
                children: [
                  if (_activeTab == _CompareTab.compare)
                    ..._buildCompare(snapshot),
                  if (_activeTab == _CompareTab.scenarios)
                    ..._buildScenarios(snapshot),
                  if (_activeTab == _CompareTab.analysis)
                    ..._buildAnalysis(snapshot),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCompare(DcaPerformanceCompareSnapshot snapshot) {
    return [
      Row(
        children: [
          Expanded(
            child: _StrategyCard(
              title: 'DCA Strategy',
              value: _formatUsd(snapshot.dcaFinalValueUsd),
              invested: _formatUsd(snapshot.investedUsd),
              returnPercent: snapshot.dcaReturnPercent,
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _StrategyCard(
              title: 'Lump Sum',
              value: _formatUsd(snapshot.lumpSumFinalValueUsd),
              invested: _formatUsd(snapshot.investedUsd),
              returnPercent: snapshot.lumpSumReturnPercent,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      _WinnerBanner(snapshot: snapshot),
      _ComparisonChartCard(points: snapshot.comparison),
      VitPageSection(
        label: 'Key Metrics',
        children: [
          for (final metric in snapshot.metrics) _MetricCompareCard(metric),
        ],
      ),
    ];
  }

  List<Widget> _buildScenarios(DcaPerformanceCompareSnapshot snapshot) {
    return [
      VitPageSection(
        label: 'Scenarios Analysis',
        children: [
          for (final scenario in snapshot.scenarios)
            _ScenarioCard(scenario: scenario),
        ],
      ),
      const _InfoCard(
        icon: Icons.info_outline_rounded,
        title: 'Recommendation',
        text:
            'DCA is optimal for volatile markets and when you want to reduce timing risk. Lump sum can win in steady bull markets with low volatility.',
      ),
    ];
  }

  List<Widget> _buildAnalysis(DcaPerformanceCompareSnapshot snapshot) {
    return [
      _RadarCard(metrics: snapshot.radar),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(child: _ProsConsCard.dca()),
          SizedBox(width: AppSpacing.x3),
          Expanded(child: _ProsConsCard.lumpSum()),
        ],
      ),
      const _WarningCard(
        text:
            'So sanh dua tren du lieu lich su cu the. Ket qua co the khac trong dieu kien thi truong khac. Khong dam bao hieu suat tuong lai.',
      ),
    ];
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }
}

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.activeTab, required this.onChanged});

  final _CompareTab activeTab;
  final ValueChanged<_CompareTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TopTab(
            label: 'So sanh',
            tab: _CompareTab.compare,
            active: activeTab == _CompareTab.compare,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Kich ban',
            tab: _CompareTab.scenarios,
            active: activeTab == _CompareTab.scenarios,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Phan tich',
            tab: _CompareTab.analysis,
            active: activeTab == _CompareTab.analysis,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.tab,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final _CompareTab tab;
  final bool active;
  final ValueChanged<_CompareTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        key: DCAPerformanceComparePage.tabKey(tab.name),
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(tab),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, AppSpacing.x4, 0, 0),
          child: Column(
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: 2,
                width: active ? 116 : 0,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.title,
    required this.value,
    required this.invested,
    required this.returnPercent,
    required this.color,
  });

  final String title;
  final String value;
  final String invested;
  final double returnPercent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: 0.28),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.x4),
          _SmallMetric(label: 'Invested', value: invested),
          const SizedBox(height: AppSpacing.x2),
          _SmallMetric(
            label: 'Return',
            value: _formatSignedPercent(returnPercent),
            valueColor: color,
          ),
        ],
      ),
    );
  }
}

class _WinnerBanner extends StatelessWidget {
  const _WinnerBanner({required this.snapshot});

  final DcaPerformanceCompareSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final dcaWins = snapshot.winner == DcaPerformanceWinner.dca;
    final color = dcaWins ? AppColors.buy : AppColors.primary;
    return VitCard(
      borderColor: color.withValues(alpha: 0.28),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.bolt_rounded, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dcaWins ? 'DCA Strategy Wins' : 'Lump Sum Wins',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text.rich(
                  TextSpan(
                    text: 'Outperformed by ',
                    children: [
                      TextSpan(
                        text:
                            '${snapshot.advantagePercent.abs().toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: color,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const TextSpan(text: ' in this period'),
                    ],
                  ),
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonChartCard extends StatelessWidget {
  const _ComparisonChartCard({required this.points});

  final List<DcaPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Portfolio Value Over Time'),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 240,
            width: double.infinity,
            child: CustomPaint(painter: _PerformanceLinePainter(points)),
          ),
          const SizedBox(height: AppSpacing.x3),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(label: 'DCA', color: AppColors.buy),
              SizedBox(width: AppSpacing.x5),
              _Legend(label: 'Lump Sum', color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCompareCard extends StatelessWidget {
  const _MetricCompareCard(this.metric);

  final DcaComparisonMetric metric;

  @override
  Widget build(BuildContext context) {
    final dcaWins = metric.winner == DcaPerformanceWinner.dca;
    return VitCard(
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _MetricValueBox(
                  value: metric.dcaValue,
                  label: 'DCA',
                  active: dcaWins,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricValueBox(
                  value: metric.lumpSumValue,
                  label: 'Lump Sum',
                  active: !dcaWins,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricValueBox extends StatelessWidget {
  const _MetricValueBox({
    required this.value,
    required this.label,
    required this.active,
    required this.color,
  });

  final String value;
  final String label;
  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.12) : AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: active ? color : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final DcaVolatilityScenario scenario;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scenario.name,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          Text(
            scenario.scenario,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            scenario.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          _AdvantageBar(
            label: 'DCA Advantage',
            value: scenario.dcaAdvantage,
            color: AppColors.buy,
          ),
          const SizedBox(height: AppSpacing.x3),
          _AdvantageBar(
            label: 'Lump Sum Advantage',
            value: scenario.lumpSumAdvantage,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _AdvantageBar extends StatelessWidget {
  const _AdvantageBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              '$value/10',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: 6,
            value: (value / 10).clamp(0.0, 1.0),
            backgroundColor: AppColors.surface3,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _RadarCard extends StatelessWidget {
  const _RadarCard({required this.metrics});

  final List<DcaRadarMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Multi-Dimensional Comparison'),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 280,
            width: double.infinity,
            child: CustomPaint(painter: _RadarPainter(metrics)),
          ),
          const SizedBox(height: AppSpacing.x3),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(label: 'DCA', color: AppColors.buy),
              SizedBox(width: AppSpacing.x5),
              _Legend(label: 'Lump Sum', color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProsConsCard extends StatelessWidget {
  const _ProsConsCard.dca()
    : title = 'DCA Strategy',
      color = AppColors.buy,
      pros = const [
        'Lower timing risk',
        'Easier emotionally',
        'Flexible budget',
      ],
      cons = const ['May miss rallies', 'Lower upside'];

  const _ProsConsCard.lumpSum()
    : title = 'Lump Sum',
      color = AppColors.primary,
      pros = const ['Max time in market', 'Higher upside'],
      cons = const ['High timing risk', 'Emotional stress', 'Large capital'];

  final String title;
  final Color color;
  final List<String> pros;
  final List<String> cons;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _ProsConsList(title: 'Pros', items: pros, icon: Icons.check_rounded),
          const SizedBox(height: AppSpacing.x4),
          _ProsConsList(
            title: 'Cons',
            items: cons,
            icon: Icons.warning_amber_rounded,
            warning: true,
          ),
        ],
      ),
    );
  }
}

class _ProsConsList extends StatelessWidget {
  const _ProsConsList({
    required this.title,
    required this.items,
    required this.icon,
    this.warning = false,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: warning ? AppColors.warn : AppColors.buy,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text2,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(label, style: AppTextStyles.caption.copyWith(color: color)),
      ],
    );
  }
}

class _PerformanceLinePainter extends CustomPainter {
  const _PerformanceLinePainter(this.points);

  final List<DcaPerformancePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const left = 36.0;
    const bottom = 24.0;
    final chart = Rect.fromLTWH(0, 0, size.width, size.height - bottom);
    final maxValue = points
        .map((point) => math.max(point.dcaValueUsd, point.lumpSumValueUsd))
        .reduce(math.max)
        .toDouble();
    _drawGrid(canvas, chart, maxValue, left);
    _drawLine(
      canvas,
      chart,
      values: points.map((point) => point.dcaValueUsd / maxValue).toList(),
      color: AppColors.buy,
      leftInset: left,
      fill: true,
    );
    _drawLine(
      canvas,
      chart,
      values: points.map((point) => point.lumpSumValueUsd / maxValue).toList(),
      color: AppColors.primary,
      leftInset: left,
    );
    for (var i = 1; i < points.length; i += 2) {
      _drawAxisLabel(
        canvas,
        points[i].month,
        Offset(
          left + (chart.width - left) * i / (points.length - 1),
          chart.bottom + 4,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PerformanceLinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter(this.metrics);

  final List<DcaRadarMetric> metrics;

  @override
  void paint(Canvas canvas, Size size) {
    if (metrics.length < 3) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;
    final grid = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var step = 1; step <= 4; step++) {
      final path = _radarPath(
        center,
        radius * step / 4,
        List<double>.filled(metrics.length, 1),
      );
      canvas.drawPath(path, grid);
    }
    for (var i = 0; i < metrics.length; i++) {
      final angle = -math.pi / 2 + math.pi * 2 * i / metrics.length;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(center, point, grid);
      _drawRadarLabel(canvas, metrics[i].metric, center, radius + 20, angle);
    }
    _drawRadarSeries(
      canvas,
      center,
      radius,
      metrics.map((metric) => metric.dcaScore / 200).toList(),
      AppColors.buy,
    );
    _drawRadarSeries(
      canvas,
      center,
      radius,
      metrics.map((metric) => metric.lumpSumScore / 200).toList(),
      AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.metrics != metrics;
  }
}

void _drawGrid(Canvas canvas, Rect chart, double maxValue, double leftInset) {
  final grid = Paint()
    ..color = AppColors.border
    ..strokeWidth = 1;
  for (var i = 0; i <= 4; i++) {
    final y = chart.bottom - chart.height * i / 4;
    canvas.drawLine(Offset(leftInset, y), Offset(chart.right, y), grid);
    _drawAxisLabel(canvas, '${(maxValue * i / 4).round()}', Offset(0, y - 7));
  }
}

void _drawLine(
  Canvas canvas,
  Rect chart, {
  required List<double> values,
  required Color color,
  required double leftInset,
  bool fill = false,
}) {
  if (values.isEmpty) return;
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = leftInset + (chart.width - leftInset) * i / (values.length - 1);
    final y = chart.bottom - chart.height * values[i];
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  if (fill) {
    final fillPath = Path.from(path)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(leftInset, chart.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke,
  );
}

Path _radarPath(Offset center, double radius, List<double> values) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final angle = -math.pi / 2 + math.pi * 2 * i / values.length;
    final point = Offset(
      center.dx + math.cos(angle) * radius * values[i],
      center.dy + math.sin(angle) * radius * values[i],
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  return path;
}

void _drawRadarSeries(
  Canvas canvas,
  Offset center,
  double radius,
  List<double> values,
  Color color,
) {
  final path = _radarPath(center, radius, values);
  canvas.drawPath(
    path,
    Paint()
      ..color = color.withValues(alpha: 0.24)
      ..style = PaintingStyle.fill,
  );
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke,
  );
}

void _drawRadarLabel(
  Canvas canvas,
  String label,
  Offset center,
  double radius,
  double angle,
) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(color: AppColors.text2),
    ),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: 90);
  final offset = Offset(
    center.dx + math.cos(angle) * radius - textPainter.width / 2,
    center.dy + math.sin(angle) * radius - textPainter.height / 2,
  );
  textPainter.paint(canvas, offset);
}

void _drawAxisLabel(Canvas canvas, String label, Offset offset) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  textPainter.paint(canvas, offset);
}

String _formatUsd(num value) => '\$${value.round()}';

String _formatSignedPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
