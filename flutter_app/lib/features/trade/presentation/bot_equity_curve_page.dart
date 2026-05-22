import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _equityBg = Color(0xFF080C14);
const _equitySurface = Color(0xFF151A23);
const _equitySurface2 = Color(0xFF1D2436);
const _equityGreen = Color(0xFF10B981);
const _equityBlue = Color(0xFF3B82F6);
const _equityRed = Color(0xFFEF4444);
const _equityAxis = Color(0xFF475569);

class BotEquityCurvePage extends ConsumerStatefulWidget {
  const BotEquityCurvePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc130_bot_equity_curve_content');
  static Key tabKey(String id) => Key('sc130_equity_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotEquityCurvePage> createState() => _BotEquityCurvePageState();
}

class _BotEquityCurvePageState extends ConsumerState<BotEquityCurvePage> {
  String _view = 'equity';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getBotEquityCurve();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 94
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-130 BotEquityCurvePage',
      child: Material(
        color: _equityBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Equity Curve',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotEquityCurvePage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryRow(summary: snapshot.summary),
                    const SizedBox(height: 14),
                    _Tabs(
                      active: _view,
                      onChanged: (id) => setState(() => _view = id),
                    ),
                    const SizedBox(height: 16),
                    if (_view == 'equity') ...[
                      const _SectionLabel('Equity Curve vs Buy & Hold'),
                      const SizedBox(height: 8),
                      _EquityChartCard(points: snapshot.equityPoints),
                    ] else if (_view == 'sharpe') ...[
                      const _SectionLabel('Rolling 30-Day Sharpe Ratio'),
                      const SizedBox(height: 8),
                      _SharpeCard(points: snapshot.equityPoints),
                    ] else ...[
                      const _SectionLabel('Monthly Alpha (Bot vs Market)'),
                      const SizedBox(height: 8),
                      _MonthlyAlphaCard(months: snapshot.monthlyReturns),
                    ],
                    const SizedBox(height: 18),
                    const _SectionLabel('Performance Statistics'),
                    const SizedBox(height: 8),
                    _PerformanceCard(stats: snapshot.performanceStats),
                    const SizedBox(height: 18),
                    _AnalysisCard(items: snapshot.analysisItems),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.summary});

  final TradeBotEquityCurveSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Bot Return',
        '+${summary.botReturnPct.toStringAsFixed(1)}%',
        _equityGreen,
      ),
      (
        'Buy & Hold',
        '+${summary.buyHoldReturnPct.toStringAsFixed(1)}%',
        AppColors.text1,
      ),
      ('Alpha', '+${summary.alphaPct.toStringAsFixed(1)}%', _equityGreen),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: _Card(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: SizedBox(
                height: 52,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      items[i].$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      items[i].$2,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: items[i].$3,
                        fontSize: 18,
                        fontWeight: AppTextStyles.bold,
                        fontFamily: 'Roboto',
                        fontFeatures: AppTextStyles.tabularFigures,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (i != items.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('equity', 'Equity Curve'),
      ('sharpe', 'Rolling Sharpe'),
      ('alpha', 'Monthly Alpha'),
    ];
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          Expanded(
            child: GestureDetector(
              key: BotEquityCurvePage.tabKey(tabs[i].$1),
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(tabs[i].$1),
              child: Container(
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active == tabs[i].$1
                      ? _equityBlue.withValues(alpha: .15)
                      : _equitySurface2,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: active == tabs[i].$1
                        ? _equityBlue.withValues(alpha: .50)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  tabs[i].$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active == tabs[i].$1 ? _equityBlue : AppColors.text3,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          if (i != tabs.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _EquityChartCard extends StatelessWidget {
  const _EquityChartCard({required this.points});

  final List<TradeBotEquityCurvePoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      child: Column(
        children: [
          SizedBox(
            height: 214,
            child: CustomPaint(
              painter: _EquityPainter(points),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hdr_strong_rounded,
                color: _equityGreen,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                'Bot',
                style: AppTextStyles.micro.copyWith(
                  color: _equityGreen,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SharpeCard extends StatelessWidget {
  const _SharpeCard({required this.points});

  final List<TradeBotEquityCurvePoint> points;

  @override
  Widget build(BuildContext context) {
    final rolling = points
        .where((point) => point.rollingSharpe != null)
        .toList();
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _SharpePainter(rolling),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _MiniStat(
                  label: 'Current',
                  value: '2.08',
                  status: 'Excellent',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MiniStat(
                  label: 'Average',
                  value: '1.94',
                  status: 'Good',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MiniStat(label: 'Min', value: '1.52', status: 'Fair'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.status,
  });

  final String label;
  final String value;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: _equitySurface2,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            status,
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

class _MonthlyAlphaCard extends StatelessWidget {
  const _MonthlyAlphaCard({required this.months});

  final List<TradeBotMonthlyReturn> months;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          for (final month in months) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    month.month,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 11,
                    ),
                  ),
                ),
                Text(
                  'Bot: +${month.botReturn.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: _equityGreen,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${month.alpha >= 0 ? '+' : ''}${month.alpha.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: month.alpha >= 0 ? _equityGreen : _equityRed,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: math.min(month.alpha.abs() * .20, 1),
                  child: Container(
                    height: 8,
                    color: month.alpha >= 0 ? _equityGreen : _equityRed,
                  ),
                ),
              ),
            ),
            if (month != months.last) const SizedBox(height: 13),
          ],
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.stats});

  final List<TradeBotPerformanceStat> stats;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.85,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [for (final stat in stats) _PerformanceTile(stat: stat)],
      ),
    );
  }
}

class _PerformanceTile extends StatelessWidget {
  const _PerformanceTile({required this.stat});

  final TradeBotPerformanceStat stat;

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorHex);
    final icon = switch (stat.id) {
      'annualized' => Icons.monitor_heart_outlined,
      'outperformance' => Icons.adjust_rounded,
      'average' => Icons.bar_chart_rounded,
      _ => Icons.trending_up_rounded,
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 12, 11),
      decoration: BoxDecoration(
        color: _equitySurface2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stat.value,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'Roboto',
                    height: 1,
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

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
      decoration: BoxDecoration(
        color: _equityGreen.withValues(alpha: .10),
        border: Border.all(color: _equityGreen.withValues(alpha: .30)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 13,
                height: 13,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Color(0xFF6EE7B7)),
                child: const Icon(
                  Icons.check_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'Strong Outperformance',
                style: AppTextStyles.caption.copyWith(
                  color: _equityGreen,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 7),
                  decoration: const BoxDecoration(
                    color: AppColors.text3,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _equitySurface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _equityBlue,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _EquityPainter extends CustomPainter {
  const _EquityPainter(this.points);

  final List<TradeBotEquityCurvePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 7, size.width - 88, size.height - 39);
    _drawAxes(canvas, chart, yLabels: [1800, 1350, 900, 450, 0]);
    const tickIndices = [0, 2, 4, 6, 8, 10, 12];
    for (final index in tickIndices) {
      final x = chart.left + index / (points.length - 1) * chart.width;
      _paintText(
        canvas,
        points[index].monthLabel,
        Offset(x - 14, chart.bottom + 10),
        AppColors.text3,
        10,
        width: 30,
        align: TextAlign.center,
      );
    }

    final line = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + i / (points.length - 1) * chart.width;
      final y = chart.bottom - points[i].equity / 1800 * chart.height;
      if (i == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }
    final fill = Path.from(line)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x5510B981), Color(0x0010B981)],
        ).createShader(chart),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = _equityGreen
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _EquityPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _SharpePainter extends CustomPainter {
  const _SharpePainter(this.points);

  final List<TradeBotEquityCurvePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(50, 8, size.width - 70, size.height - 36);
    final axisPaint = Paint()
      ..color = _equityAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final value = points[i].rollingSharpe ?? 0;
      final x = chart.left + i / (points.length - 1) * chart.width;
      final y = chart.bottom - value / 2.5 * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _equityBlue
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _SharpePainter oldDelegate) =>
      oldDelegate.points != points;
}

void _drawAxes(Canvas canvas, Rect chart, {required List<int> yLabels}) {
  final axisPaint = Paint()
    ..color = _equityAxis
    ..strokeWidth = 1;
  canvas
    ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
    ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
  for (final value in yLabels) {
    final y = chart.bottom - value / 1800 * chart.height;
    _paintText(
      canvas,
      '\$$value',
      Offset(8, y - 5),
      AppColors.text3,
      10,
      width: 48,
      align: TextAlign.right,
    );
  }
}

void _paintText(
  Canvas canvas,
  String text,
  Offset offset,
  Color color,
  double fontSize, {
  double width = 80,
  TextAlign align = TextAlign.left,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        height: 1,
        decoration: TextDecoration.none,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: align,
  )..layout(maxWidth: width);
  painter.paint(canvas, offset);
}
