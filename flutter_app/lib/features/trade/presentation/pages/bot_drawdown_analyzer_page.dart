import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _drawdownBackground = AppColors.bg;
const _drawdownPanel = AppColors.surface;
const _drawdownPanel2 = AppColors.surface2;
const _drawdownRed = AppColors.sell;
const _drawdownAmber = AppColors.caution;
const _drawdownGreen = AppColors.buy;
const _drawdownPrimary = AppColors.primary;
const _drawdownAxis = AppColors.chartAxisStrong;

class BotDrawdownAnalyzerPage extends ConsumerWidget {
  const BotDrawdownAnalyzerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc129_bot_drawdown_analyzer_content');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotDrawdownAnalyzer();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 96
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-129 BotDrawdownAnalyzerPage',
      child: Material(
        color: _drawdownBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Drawdown Analyzer',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _MetricGrid(summary: snapshot.summary),
                    const SizedBox(height: 17),
                    const _SectionLabel('Underwater Equity'),
                    const SizedBox(height: 10),
                    _UnderwaterCard(points: snapshot.underwaterPoints),
                    const SizedBox(height: 18),
                    const _SectionLabel('Drawdown Duration Distribution'),
                    const SizedBox(height: 10),
                    _DurationCard(buckets: snapshot.durationBuckets),
                    const SizedBox(height: 18),
                    const _SectionLabel('Major Drawdown Events'),
                    const SizedBox(height: 10),
                    _EventsList(events: snapshot.events),
                    const SizedBox(height: 18),
                    _AnalysisCard(insights: snapshot.insights),
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

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.summary});

  final TradeBotDrawdownSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                height: 109,
                icon: Icons.trending_down_rounded,
                iconColor: _drawdownRed,
                label: 'Max Drawdown',
                value: '${summary.maxDrawdownPct.toStringAsFixed(1)}%',
                valueColor: _drawdownRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                height: 109,
                icon: Icons.bar_chart_rounded,
                iconColor: _drawdownAmber,
                label: 'Avg Drawdown',
                value: '${summary.avgDrawdownPct.toStringAsFixed(1)}%',
                valueColor: _drawdownAmber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                height: 124,
                icon: Icons.schedule_rounded,
                iconColor: _drawdownPrimary,
                label: 'Drawdown Days',
                value: summary.drawdownDays.toString(),
                caption: 'of ${summary.totalDays} days',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                height: 124,
                icon: Icons.report_problem_outlined,
                iconColor: _drawdownGreen,
                label: 'DD Frequency',
                value: summary.frequency.toString(),
                caption: 'events',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.height,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.caption,
  });

  final double height;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: SizedBox(
        height: height - 32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 21),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: valueColor,
                fontSize: 20,
                fontWeight: AppTextStyles.bold,
                fontFamily: 'Roboto',
                fontFeatures: AppTextStyles.tabularFigures,
                height: 1,
              ),
            ),
            if (caption != null) ...[
              const SizedBox(height: 5),
              Text(
                caption!,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UnderwaterCard extends StatelessWidget {
  const _UnderwaterCard({required this.points});

  final List<TradeBotUnderwaterPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _UnderwaterPainter(points),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Below zero = in drawdown (underwater)',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  const _DurationCard({required this.buckets});

  final List<TradeBotDrawdownDurationBucket> buckets;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: SizedBox(
        height: 160,
        child: CustomPaint(
          painter: _DurationPainter(buckets),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _EventsList extends StatelessWidget {
  const _EventsList({required this.events});

  final List<TradeBotDrawdownEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final event in events) ...[
          _EventCard(event: event),
          if (event != events.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final TradeBotDrawdownEvent event;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event #${event.id}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1,
                ),
              ),
              if (event.severe) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _drawdownRed.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Severe',
                    style: AppTextStyles.micro.copyWith(
                      color: _drawdownRed,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                '${event.depthPct.toStringAsFixed(1)}%',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _drawdownRed,
                  fontSize: 16,
                  fontWeight: AppTextStyles.bold,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _EventStat(label: 'Start', value: event.startLabel),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _EventStat(label: 'Duration', value: event.duration),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _EventStat(
                  label: 'Recovery',
                  value: event.recovery,
                  valueColor: event.recovery == 'Ongoing'
                      ? _drawdownAmber
                      : _drawdownGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventStat extends StatelessWidget {
  const _EventStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      decoration: BoxDecoration(
        color: _drawdownPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: valueColor,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard({required this.insights});

  final List<TradeBotDrawdownInsight> insights;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 23),
      decoration: BoxDecoration(
        color: _drawdownPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Drawdown Analysis',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          for (final insight in insights) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 12,
                  child: insight.symbol == 'alert'
                      ? Text(
                          '!',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: Color(insight.colorHex),
                            fontSize: 15,
                            height: 1,
                          ),
                        )
                      : Icon(
                          Icons.check_rounded,
                          color: Color(insight.colorHex),
                          size: 15,
                        ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    insight.text,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (insight != insights.last) const SizedBox(height: 15),
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
        color: _drawdownPanel,
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
            color: _drawdownPrimary,
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

class _UnderwaterPainter extends CustomPainter {
  const _UnderwaterPainter(this.points);

  final List<TradeBotUnderwaterPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 6, size.width - 88, size.height - 42);
    final axisPaint = Paint()
      ..color = _drawdownAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, -3, -6, -9, -12]) {
      final y = _scaleY(value.toDouble(), chart);
      _paintText(
        canvas,
        '$value%',
        Offset(12, y - 5),
        AppColors.text3,
        10,
        width: 44,
        align: TextAlign.right,
      );
    }

    const tickIndices = [0, 2, 4, 6, 8, 10, 12, 14];
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
      final y = _scaleY(points[i].underwaterPct, chart);
      if (i == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }

    final fill = Path.from(line)
      ..lineTo(chart.right, chart.top)
      ..lineTo(chart.left, chart.top)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.sell33, AppColors.sell.withValues(alpha: 0)],
        ).createShader(chart),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = _drawdownRed
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  double _scaleY(double value, Rect chart) {
    const min = -12.0;
    const max = 0.0;
    return chart.bottom - ((value - min) / (max - min)) * chart.height;
  }

  @override
  bool shouldRepaint(covariant _UnderwaterPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _DurationPainter extends CustomPainter {
  const _DurationPainter(this.buckets);

  final List<TradeBotDrawdownDurationBucket> buckets;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 6, size.width - 88, size.height - 36);
    final axisPaint = Paint()
      ..color = _drawdownAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [8, 4, 2, 0]) {
      final y = chart.bottom - value / 8 * chart.height;
      _paintText(
        canvas,
        '$value',
        Offset(22, y - 5),
        AppColors.text3,
        10,
        width: 34,
        align: TextAlign.right,
      );
    }

    final barArea = chart.deflate(8);
    final slot = barArea.width / buckets.length;
    final barWidth = math.min(60.0, slot * .78);
    final barPaint = Paint()..color = _drawdownAmber;
    for (var i = 0; i < buckets.length; i++) {
      final item = buckets[i];
      final left = barArea.left + i * slot + (slot - barWidth) / 2;
      final barTop = chart.bottom - item.count / 8 * chart.height;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, barTop, barWidth, chart.bottom - barTop),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      canvas.drawRRect(rect, barPaint);
      _paintText(
        canvas,
        item.range,
        Offset(barArea.left + i * slot, chart.bottom + 9),
        AppColors.text3,
        10,
        width: slot,
        align: TextAlign.center,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DurationPainter oldDelegate) =>
      oldDelegate.buckets != buckets;
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
