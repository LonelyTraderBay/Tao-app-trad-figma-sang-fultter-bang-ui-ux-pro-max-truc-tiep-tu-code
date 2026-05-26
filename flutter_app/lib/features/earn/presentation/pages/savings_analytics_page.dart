import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

class SavingsAnalyticsPage extends ConsumerStatefulWidget {
  const SavingsAnalyticsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc343_summary');
  static const yieldChartKey = Key('sc343_yield_chart');
  static const monthlyChartKey = Key('sc343_monthly_chart');
  static const metricsKey = Key('sc343_metrics');

  static Key tabKey(String tab) => Key('sc343_tab_$tab');
  static Key rangeKey(String range) => Key('sc343_range_$range');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsAnalyticsPage> createState() =>
      _SavingsAnalyticsPageState();
}

class _SavingsAnalyticsPageState extends ConsumerState<SavingsAnalyticsPage> {
  String? _tab;
  String? _range;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsAnalyticsRepositoryProvider)
        .getAnalytics();
    final activeTab = _tab ?? snapshot.defaultTab;
    final activeRange = _range ?? snapshot.defaultTimeRange;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-343 SavingsAnalyticsPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.contentPad,
                ),
                child: VitTabBar(
                  variant: VitTabBarVariant.underline,
                  activeKey: activeTab,
                  onChanged: (tab) {
                    HapticFeedback.selectionClick();
                    setState(() => _tab = tab);
                  },
                  tabs: [
                    for (final tab in snapshot.tabs)
                      VitTabItem(key: tab, label: tab),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _SummaryHero(summary: snapshot.summary),
                    if (activeTab == 'Yield') ...[
                      _TimeRangeSelector(
                        ranges: snapshot.timeRanges,
                        activeRange: activeRange,
                        onChanged: (range) {
                          HapticFeedback.selectionClick();
                          setState(() => _range = range);
                        },
                      ),
                      _YieldChartCard(
                        summary: snapshot.summary,
                        points: snapshot.yieldHistory,
                      ),
                      _MonthlyIncomeCard(points: snapshot.monthlyEarnings),
                      _MetricRow(summary: snapshot.summary),
                    ] else
                      _SecondaryTabContent(
                        tab: activeTab,
                        summary: snapshot.summary,
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

class _SummaryHero extends StatelessWidget {
  const _SummaryHero({required this.summary});

  final SavingsAnalyticsSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAnalyticsPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _SummaryTile(
              label: 'Tổng tiết kiệm',
              value: _formatUsd(summary.totalInvested),
              color: AppColors.text1,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              label: 'Tổng yield',
              value: '+${_formatUsd(summary.totalEarned)}',
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              label: 'APY BQ',
              value: '${summary.weightedApy.toStringAsFixed(2)}%',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeRangeSelector extends StatelessWidget {
  const _TimeRangeSelector({
    required this.ranges,
    required this.activeRange,
    required this.onChanged,
  });

  final List<String> ranges;
  final String activeRange;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final range in ranges) ...[
          Expanded(
            child: _RangeChip(
              range: range,
              selected: range == activeRange,
              onTap: () => onChanged(range),
            ),
          ),
          if (range != ranges.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.range,
    required this.selected,
    required this.onTap,
  });

  final String range;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        key: SavingsAnalyticsPage.rangeKey(range),
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadii.mdRadius,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
            child: Text(
              range,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.primary : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _YieldChartCard extends StatelessWidget {
  const _YieldChartCard({required this.summary, required this.points});

  final SavingsAnalyticsSummaryDraft summary;
  final List<SavingsYieldPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAnalyticsPage.yieldChartKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng yield tích lũy',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatUsd(summary.totalEarned),
                      style: AppTextStyles.pageTitle.copyWith(
                        color: AppColors.buy,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.buy10,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x2,
                    vertical: AppSpacing.x1,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        '+${summary.yieldChange.toStringAsFixed(2)}%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          SizedBox(height: 226, child: _YieldChart(points: points)),
          const SizedBox(height: AppSpacing.x3),
          const _YieldLegend(),
        ],
      ),
    );
  }
}

class _YieldLegend extends StatelessWidget {
  const _YieldLegend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.x4,
      runSpacing: AppSpacing.x2,
      children: const [
        _LegendItem(label: 'USDT', color: AppColors.buy),
        _LegendItem(label: 'BTC', color: AppColors.warn),
        _LegendItem(label: 'SOL', color: AppColors.accent),
        _LegendItem(label: 'ETH', color: AppColors.primary),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: const SizedBox(width: AppSpacing.x2, height: AppSpacing.x2),
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

class _MonthlyIncomeCard extends StatelessWidget {
  const _MonthlyIncomeCard({required this.points});

  final List<SavingsMonthlyEarningsPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAnalyticsPage.monthlyChartKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Thu nhập hằng tháng',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(height: 184, child: _MonthlyBars(points: points)),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.summary});

  final SavingsAnalyticsSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: SavingsAnalyticsPage.metricsKey,
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.attach_money_rounded,
            label: 'Thu nhập/ngày',
            value: _formatUsd(summary.dailyEarnings),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.calendar_month_outlined,
            label: 'Thu nhập/tháng',
            value: _formatUsd(summary.monthlyEarnings),
            color: AppColors.warn,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.trending_up_rounded,
            label: 'Dự kiến/năm',
            value: _formatUsd(summary.annualProjection),
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
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
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
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

class _SecondaryTabContent extends StatelessWidget {
  const _SecondaryTabContent({required this.tab, required this.summary});

  final String tab;
  final SavingsAnalyticsSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    final icon = switch (tab) {
      'Compound' => Icons.auto_awesome_outlined,
      'APY' => Icons.percent_rounded,
      _ => Icons.pie_chart_outline_rounded,
    };
    final title = switch (tab) {
      'Compound' => 'Hiệu quả lãi kép',
      'APY' => 'Xu hướng APY',
      _ => 'Phân bổ tài sản',
    };
    final value = switch (tab) {
      'Compound' => '+\$121.48',
      'APY' => '${summary.weightedApy.toStringAsFixed(2)}%',
      _ => _formatUsd(summary.totalInvested),
    };
    final description = switch (tab) {
      'Compound' =>
        'Mô phỏng compound hằng ngày so với lãi đơn trong 12 tháng.',
      'APY' => 'Theo dõi APY bình quân gia quyền và độ ổn định theo thời gian.',
      _ => 'Tổng hợp flexible/locked và tỷ trọng từng tài sản trong danh mục.',
    };

    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: AppSpacing.iconLg),
          const SizedBox(height: AppSpacing.x3),
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.pageTitle.copyWith(
              color: AppColors.buy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _YieldChart extends StatelessWidget {
  const _YieldChart({required this.points});

  final List<SavingsYieldPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labels = [180, 135, 90, 45, 0];
        final chartTop = 12.0;
        final chartHeight = constraints.maxHeight - 42;
        final xLabels = [
          points[1].date,
          points[3].date,
          points[5].date,
          points.last.date,
        ];
        const labelWidth = 56.0;
        final chartLeft = 38.0;
        final chartRight = constraints.maxWidth - 22;
        final labelStep = (chartRight - chartLeft) / (xLabels.length - 1);

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _YieldChartPainter(points: points)),
            ),
            for (final label in labels)
              Positioned(
                left: 0,
                top: chartTop + chartHeight * (1 - label / 180) - 6,
                child: _AxisText('\$$label'),
              ),
            for (var i = 0; i < xLabels.length; i++)
              Positioned(
                left: (chartLeft + labelStep * i - labelWidth / 2).clamp(
                  0.0,
                  constraints.maxWidth - labelWidth,
                ),
                bottom: 0,
                width: labelWidth,
                child: _AxisText(xLabels[i], align: TextAlign.center),
              ),
          ],
        );
      },
    );
  }
}

class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({required this.points});

  final List<SavingsMonthlyEarningsPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labels = [60, 45, 30, 15, 0];
        final chartTop = 8.0;
        final chartHeight = constraints.maxHeight - 28;
        final step = (constraints.maxWidth - 42) / points.length;

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _MonthlyBarsPainter(points: points)),
            ),
            for (final label in labels)
              Positioned(
                left: 0,
                top: chartTop + chartHeight * (1 - label / 60) - 6,
                child: _AxisText('\$$label'),
              ),
            for (var i = 0; i < points.length; i++)
              Positioned(
                left: 34 + step * i,
                bottom: 0,
                width: step,
                child: _AxisText(points[i].month, align: TextAlign.center),
              ),
          ],
        );
      },
    );
  }
}

class _AxisText extends StatelessWidget {
  const _AxisText(this.text, {this.align = TextAlign.left});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: 1,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        height: 1,
        fontWeight: AppTextStyles.bold,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _YieldChartPainter extends CustomPainter {
  const _YieldChartPainter({required this.points});

  final List<SavingsYieldPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(38, 12, size.width - 60, size.height - 42);
    _drawGrid(canvas, chart, const [0, 45, 90, 135, 180], maxY: 180);
    _drawLine(
      canvas,
      chart,
      [for (final point in points) point.usdt],
      AppColors.buy,
      maxY: 180,
    );
    _drawLine(
      canvas,
      chart,
      [for (final point in points) point.btc],
      AppColors.warn,
      maxY: 180,
    );
    _drawLine(
      canvas,
      chart,
      [for (final point in points) point.sol],
      AppColors.accent,
      maxY: 180,
    );
    _drawLine(
      canvas,
      chart,
      [for (final point in points) point.total],
      AppColors.primary,
      maxY: 180,
    );
  }

  @override
  bool shouldRepaint(_YieldChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _MonthlyBarsPainter extends CustomPainter {
  const _MonthlyBarsPainter({required this.points});

  final List<SavingsMonthlyEarningsPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(34, 8, size.width - 42, size.height - 28);
    _drawGrid(canvas, chart, const [0, 15, 30, 45, 60], maxY: 60);

    final barWidth = chart.width / (points.length * 1.7);
    final step = chart.width / points.length;
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.buy, Color(0x3310B981)],
      ).createShader(chart);

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = chart.left + step * i + (step - barWidth) / 2;
      final height = chart.height * (point.earned / 60).clamp(0, 1);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chart.bottom - height, barWidth, height),
        const Radius.circular(AppRadii.xs),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_MonthlyBarsPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

void _drawGrid(
  Canvas canvas,
  Rect chart,
  List<int> labels, {
  required double maxY,
}) {
  final gridPaint = Paint()
    ..color = AppColors.divider
    ..strokeWidth = 1;
  for (final label in labels.reversed) {
    final y = chart.bottom - chart.height * (label / maxY);
    canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
  }
}

void _drawLine(
  Canvas canvas,
  Rect chart,
  List<double> values,
  Color color, {
  required double maxY,
}) {
  if (values.isEmpty) return;
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = chart.left + (chart.width / (values.length - 1)) * i;
    final y = chart.bottom - chart.height * (values[i] / maxY).clamp(0, 1);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke,
  );
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}
