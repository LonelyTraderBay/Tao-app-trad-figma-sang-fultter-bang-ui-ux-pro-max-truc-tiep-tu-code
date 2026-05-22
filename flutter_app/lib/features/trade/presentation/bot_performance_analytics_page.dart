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

const _analyticsBg = Color(0xFF080C14);
const _analyticsSurface = Color(0xFF151A23);
const _analyticsSurface2 = Color(0xFF1D2436);
const _analyticsBlue = Color(0xFF3B82F6);
const _analyticsGreen = Color(0xFF10B981);
const _analyticsAmber = Color(0xFFF59E0B);
const _analyticsRed = Color(0xFFEF4444);
const _chartAxis = Color(0xFF475569);
const _chartTrack = Color(0xFF20283A);

enum _AnalyticsTimeframe { sevenDays, thirtyDays, allTime }

class BotPerformanceAnalyticsPage extends ConsumerStatefulWidget {
  const BotPerformanceAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc124_bot_performance_content');

  static Key timeframeKey(String id) => Key('sc124_bot_performance_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotPerformanceAnalyticsPage> createState() =>
      _BotPerformanceAnalyticsPageState();
}

class _BotPerformanceAnalyticsPageState
    extends ConsumerState<BotPerformanceAnalyticsPage> {
  _AnalyticsTimeframe _timeframe = _AnalyticsTimeframe.sevenDays;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getBotPerformanceAnalytics();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 120
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-124 BotPerformanceAnalyticsPage',
      child: Material(
        color: _analyticsBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Performance Analytics',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotPerformanceAnalyticsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _KeyMetricsCard(metrics: snapshot.metrics),
                    const SizedBox(height: 16),
                    _TimeframeTabs(
                      active: _timeframe,
                      onChanged: (timeframe) =>
                          setState(() => _timeframe = timeframe),
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel('Cumulative PnL'),
                    const SizedBox(height: 12),
                    _PnlChartCard(points: snapshot.pnlPoints),
                    const SizedBox(height: 18),
                    const _SectionLabel('Win/Loss Distribution'),
                    const SizedBox(height: 12),
                    _WinLossChartCard(points: snapshot.winLossPoints),
                    const SizedBox(height: 18),
                    const _SectionLabel('Performance by Strategy'),
                    const SizedBox(height: 12),
                    _StrategyPerformanceCard(
                      strategies: snapshot.strategyPerformance,
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel('Advanced Metrics'),
                    const SizedBox(height: 12),
                    _AdvancedMetricsGrid(metrics: snapshot.metrics),
                    const SizedBox(height: 18),
                    const _SectionLabel('Trade Duration Distribution'),
                    const SizedBox(height: 12),
                    _DurationCard(distribution: snapshot.durationDistribution),
                    const SizedBox(height: 18),
                    _PerformanceSummaryCard(metrics: snapshot.metrics),
                    const SizedBox(height: 18),
                    const _RatingCard(),
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

class _KeyMetricsCard extends StatelessWidget {
  const _KeyMetricsCard({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricColumn(
                  label: 'Total PnL',
                  value: '+\$${metrics.totalPnl.toStringAsFixed(2)}',
                  color: _analyticsGreen,
                ),
              ),
              Expanded(
                child: _MetricColumn(
                  label: 'Win Rate',
                  value: '${metrics.winRate.toStringAsFixed(1)}%',
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _MetricColumn(
                  label: 'Sharpe Ratio',
                  value: metrics.sharpeRatio.toStringAsFixed(2),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: _analyticsGreen.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 13,
                  height: 13,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: _analyticsGreen.withValues(alpha: .9),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 11,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Excellent performance - Sharpe > 1.5 indicates strong risk-adjusted returns',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: _analyticsGreen,
                      fontSize: 12,
                      height: 1.45,
                    ),
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

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontSize: 20,
            height: 1,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}

class _TimeframeTabs extends StatelessWidget {
  const _TimeframeTabs({required this.active, required this.onChanged});

  final _AnalyticsTimeframe active;
  final ValueChanged<_AnalyticsTimeframe> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      (_AnalyticsTimeframe.sevenDays, '7d', '7 Days'),
      (_AnalyticsTimeframe.thirtyDays, '30d', '30 Days'),
      (_AnalyticsTimeframe.allTime, 'all', 'All Time'),
    ];

    return Row(
      children: [
        for (final tab in tabs) ...[
          _TimeframePill(
            key: BotPerformanceAnalyticsPage.timeframeKey(tab.$2),
            label: tab.$3,
            active: active == tab.$1,
            onTap: () => onChanged(tab.$1),
          ),
          if (tab != tabs.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _TimeframePill extends StatelessWidget {
  const _TimeframePill({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _analyticsBlue.withValues(alpha: .12)
              : _analyticsSurface2,
          border: active
              ? Border.all(color: _analyticsBlue.withValues(alpha: .55))
              : null,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _analyticsBlue : AppColors.text3,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PnlChartCard extends StatelessWidget {
  const _PnlChartCard({required this.points});

  final List<TradeBotPnlPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: SizedBox(
        height: 220,
        child: CustomPaint(
          painter: _PnlChartPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _WinLossChartCard extends StatelessWidget {
  const _WinLossChartCard({required this.points});

  final List<TradeBotWinLossPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: SizedBox(
        height: 200,
        child: CustomPaint(
          painter: _WinLossChartPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _StrategyPerformanceCard extends StatelessWidget {
  const _StrategyPerformanceCard({required this.strategies});

  final List<TradeBotStrategyPerformance> strategies;

  @override
  Widget build(BuildContext context) {
    final maxPnl = strategies
        .map((strategy) => strategy.pnl.abs())
        .fold<double>(0, math.max);

    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        children: [
          for (final strategy in strategies) ...[
            _StrategyRow(strategy: strategy, maxPnl: maxPnl),
            if (strategy != strategies.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _StrategyRow extends StatelessWidget {
  const _StrategyRow({required this.strategy, required this.maxPnl});

  final TradeBotStrategyPerformance strategy;
  final double maxPnl;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    final isPositive = strategy.pnl >= 0;
    final widthFactor = maxPnl == 0 ? 0.0 : strategy.pnl.abs() / maxPnl;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${strategy.strategy} Bot',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            Text(
              '${isPositive ? '+' : ''}${strategy.pnl.toStringAsFixed(2)} USDT',
              style: AppTextStyles.caption.copyWith(
                color: isPositive ? _analyticsGreen : _analyticsRed,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: widthFactor.clamp(0, 1),
              backgroundColor: _chartTrack,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdvancedMetricsGrid extends StatelessWidget {
  const _AdvancedMetricsGrid({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final items = [
      _AdvancedMetricData(
        icon: Icons.adjust_rounded,
        label: 'Profit Factor',
        value: metrics.profitFactor.toStringAsFixed(2),
        helper: 'Gross profit / Gross loss',
        color: _analyticsBlue,
      ),
      _AdvancedMetricData(
        icon: Icons.workspace_premium_outlined,
        label: 'Avg Win',
        value: '+\$${metrics.avgWin.toStringAsFixed(1)}',
        helper: 'Per winning trade',
        color: _analyticsAmber,
        valueColor: _analyticsGreen,
      ),
      _AdvancedMetricData(
        icon: Icons.trending_up_rounded,
        label: 'Best Trade',
        value: '+\$${metrics.bestTrade.toStringAsFixed(1)}',
        helper: 'Largest single win',
        color: _analyticsGreen,
        valueColor: _analyticsGreen,
      ),
      _AdvancedMetricData(
        icon: Icons.show_chart_rounded,
        label: 'Avg Loss',
        value: metrics.avgLoss.toStringAsFixed(1),
        helper: 'Per losing trade',
        color: _analyticsRed,
        valueColor: _analyticsRed,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.48,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [for (final item in items) _AdvancedMetricCard(item: item)],
    );
  }
}

class _AdvancedMetricData {
  const _AdvancedMetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String helper;
  final Color color;
  final Color? valueColor;
}

class _AdvancedMetricCard extends StatelessWidget {
  const _AdvancedMetricCard({required this.item});

  final _AdvancedMetricData item;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: item.color, size: 22),
          const Spacer(),
          Text(
            item.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            item.value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: item.valueColor ?? AppColors.text1,
              fontSize: 20,
              height: 1,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.helper,
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
  const _DurationCard({required this.distribution});

  final List<TradeBotDurationDistribution> distribution;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: SizedBox(
        height: 180,
        child: CustomPaint(
          painter: _DurationDonutPainter(distribution),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _PerformanceSummaryCard extends StatelessWidget {
  const _PerformanceSummaryCard({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Total Trades', '${metrics.totalTrades}', 'trades'),
      ('Win Rate', '${metrics.winRate.toStringAsFixed(1)}%', '(45W / 21L)'),
      ('Sharpe Ratio', metrics.sharpeRatio.toStringAsFixed(2), '(Excellent)'),
      ('Profit Factor', metrics.profitFactor.toStringAsFixed(2), '(Good)'),
      ('Best Trade', '+\$${metrics.bestTrade.toStringAsFixed(1)}', ''),
      ('Worst Trade', '\$${metrics.worstTrade.toStringAsFixed(1)}', ''),
    ];

    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Performance Summary',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          for (final row in rows) ...[
            _SummaryRow(label: row.$1, value: row.$2, suffix: row.$3),
            if (row != rows.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.suffix,
  });

  final String label;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: _analyticsSurface2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                height: 1,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                  fontFamily: 'Roboto',
                ),
              ),
              if (suffix.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  suffix,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _analyticsGreen.withValues(alpha: .08),
        border: Border.all(color: _analyticsGreen.withValues(alpha: .22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            color: _analyticsGreen,
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Excellent Performance (A+)',
                  style: AppTextStyles.caption.copyWith(
                    color: _analyticsGreen,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Your bots are performing above average. Sharpe ratio > 1.5, win rate > 65%, and profit factor > 2 indicate strong risk-adjusted returns. Keep monitoring and adjusting as market conditions change.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.6,
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

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _analyticsSurface,
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
            color: _analyticsBlue,
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

class _PnlChartPainter extends CustomPainter {
  const _PnlChartPainter(this.points);

  final List<TradeBotPnlPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(50, 8, size.width - 72, size.height - 42);
    final axisPaint = Paint()
      ..color = _chartAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, 50, 100, 150, 200]) {
      final y = chart.bottom - (value / 200) * chart.height;
      _paintText(
        canvas,
        '\$$value',
        Offset(0, y - 6),
        AppColors.text3,
        10,
        width: 42,
        align: TextAlign.right,
      );
    }

    for (final item in [
      (label: 'Mar 2', index: 1),
      (label: 'Mar 4', index: 3),
      (label: 'Mar 6', index: 5),
      (label: 'Mar 8', index: 7),
    ]) {
      final x =
          chart.left +
          item.index / (points.length - 1).clamp(1, 999) * chart.width;
      _paintText(
        canvas,
        item.label,
        Offset(x - 18, chart.bottom + 10),
        AppColors.text3,
        10,
        width: 42,
        align: TextAlign.center,
      );
    }

    if (points.isEmpty) return;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x =
          chart.left + (i / (points.length - 1).clamp(1, 999)) * chart.width;
      final y = chart.bottom - (points[i].pnl / 220).clamp(0, 1) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = _analyticsGreen
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = _analyticsGreen;
    for (var i = 0; i < points.length; i++) {
      final x =
          chart.left + (i / (points.length - 1).clamp(1, 999)) * chart.width;
      final y = chart.bottom - (points[i].pnl / 220).clamp(0, 1) * chart.height;
      canvas.drawCircle(Offset(x, y), 6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PnlChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _WinLossChartPainter extends CustomPainter {
  const _WinLossChartPainter(this.points);

  final List<TradeBotWinLossPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(50, 6, size.width - 72, size.height - 46);
    final axisPaint = Paint()
      ..color = _chartAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, 7, 14, 28]) {
      final y = chart.bottom - (value / 28) * chart.height;
      _paintText(
        canvas,
        '$value',
        Offset(4, y - 6),
        AppColors.text3,
        10,
        width: 38,
        align: TextAlign.right,
      );
    }

    if (points.isEmpty) return;
    final groupWidth = chart.width / points.length;
    final barWidth = 27.0;
    final radius = Radius.circular(4);
    final winPaint = Paint()..color = _analyticsGreen;
    final lossPaint = Paint()..color = _analyticsRed;

    for (var i = 0; i < points.length; i++) {
      final center = chart.left + groupWidth * i + groupWidth / 2;
      final winHeight = points[i].wins / 28 * chart.height;
      final lossHeight = points[i].losses / 28 * chart.height;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            center - barWidth - 3,
            chart.bottom - winHeight,
            barWidth,
            winHeight,
          ),
          topLeft: radius,
          topRight: radius,
        ),
        winPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            center + 3,
            chart.bottom - lossHeight,
            barWidth,
            lossHeight,
          ),
          topLeft: radius,
          topRight: radius,
        ),
        lossPaint,
      );
      _paintText(
        canvas,
        points[i].week,
        Offset(center - 16, chart.bottom + 10),
        AppColors.text3,
        10,
        width: 32,
        align: TextAlign.center,
      );
    }

    final legendY = size.height - 18;
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - 38, legendY - 6, 14, 10),
      winPaint,
    );
    _paintText(
      canvas,
      'Wins',
      Offset(size.width / 2 - 20, legendY - 8),
      _analyticsGreen,
      12,
      width: 38,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 + 18, legendY - 6, 14, 10),
      lossPaint,
    );
    _paintText(
      canvas,
      'Losses',
      Offset(size.width / 2 + 36, legendY - 8),
      _analyticsRed,
      12,
      width: 54,
    );
  }

  @override
  bool shouldRepaint(covariant _WinLossChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _DurationDonutPainter extends CustomPainter {
  const _DurationDonutPainter(this.distribution);

  final List<TradeBotDurationDistribution> distribution;

  @override
  void paint(Canvas canvas, Size size) {
    final total = distribution.fold<int>(0, (sum, item) => sum + item.count);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: 70);
    var start = -math.pi / 2;
    final colors = [
      const Color(0xFFF5F7FA),
      const Color(0xFFE9EDF5),
      const Color(0xFFDDE3EE),
      const Color(0xFFF5F7FA),
    ];
    for (var i = 0; i < distribution.length; i++) {
      final sweep = distribution[i].count / total * math.pi * 2;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, start + .02, math.max(0, sweep - .04), false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DurationDonutPainter oldDelegate) =>
      oldDelegate.distribution != distribution;
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
