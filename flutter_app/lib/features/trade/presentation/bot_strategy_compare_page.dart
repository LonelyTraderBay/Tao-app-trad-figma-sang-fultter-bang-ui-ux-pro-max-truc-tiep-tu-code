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

const _compareBackground = AppColors.bg;
const _comparePanel = AppColors.surface;
const _comparePanel2 = AppColors.surface2;
const _comparePrimary = AppColors.primary;
const _compareGreen = Color(0xFF10B981);
const _compareAxis = Color(0xFF475569);

class BotStrategyComparePage extends ConsumerStatefulWidget {
  const BotStrategyComparePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc126_bot_strategy_compare_content');

  static Key strategyKey(String id) => Key('sc126_bot_strategy_compare_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotStrategyComparePage> createState() =>
      _BotStrategyComparePageState();
}

class _BotStrategyComparePageState
    extends ConsumerState<BotStrategyComparePage> {
  final Set<String> _selected = {'grid', 'momentum'};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getBotStrategyCompare();
    final selectedStrategies = snapshot.strategies
        .where((strategy) => _selected.contains(strategy.id))
        .toList();
    final best = selectedStrategies.reduce(
      (best, current) => current.metrics.sharpeRatio > best.metrics.sharpeRatio
          ? current
          : best,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 132
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-126 BotStrategyComparePage',
      child: Material(
        color: _compareBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Strategy Compare',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotStrategyComparePage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SectionLabel('Select Strategies (2-4)'),
                    const SizedBox(height: 10),
                    _StrategySelectionGrid(
                      strategies: snapshot.strategies,
                      selectedIds: _selected,
                      onToggle: _toggleStrategy,
                    ),
                    const SizedBox(height: 18),
                    _BestStrategyCard(strategy: best),
                    const SizedBox(height: 18),
                    const _SectionLabel('Equity Curves Comparison'),
                    const SizedBox(height: 12),
                    _EquityChartCard(
                      points: snapshot.equityPoints,
                      strategies: selectedStrategies,
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel('Performance Radar'),
                    const SizedBox(height: 12),
                    _RadarCard(strategies: selectedStrategies),
                    const SizedBox(height: 18),
                    const _SectionLabel('Detailed Metrics'),
                    const SizedBox(height: 12),
                    _MetricsTable(strategies: selectedStrategies),
                    const SizedBox(height: 18),
                    const _SectionLabel('Which Strategy to Choose?'),
                    const SizedBox(height: 12),
                    for (final recommendation in snapshot.recommendations) ...[
                      _RecommendationCard(
                        recommendation: recommendation,
                        strategy: snapshot.strategies.firstWhere(
                          (item) => item.id == recommendation.strategyId,
                        ),
                      ),
                      if (recommendation != snapshot.recommendations.last)
                        const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 18),
                    _AnalysisPeriodCard(text: snapshot.analysisPeriod),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleStrategy(String id) {
    setState(() {
      if (_selected.contains(id)) {
        if (_selected.length > 1) _selected.remove(id);
      } else if (_selected.length < 4) {
        _selected.add(id);
      }
    });
  }
}

class _StrategySelectionGrid extends StatelessWidget {
  const _StrategySelectionGrid({
    required this.strategies,
    required this.selectedIds,
    required this.onToggle,
  });

  final List<TradeBotCompareStrategy> strategies;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.36,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        for (final strategy in strategies)
          _StrategyCard(
            key: BotStrategyComparePage.strategyKey(strategy.id),
            strategy: strategy,
            selected: selectedIds.contains(strategy.id),
            onTap: () => onToggle(strategy.id),
          ),
      ],
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    super.key,
    required this.strategy,
    required this.selected,
    required this.onTap,
  });

  final TradeBotCompareStrategy strategy;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: .10) : _comparePanel,
          border: Border.all(
            color: selected ? color : AppColors.borderSolid,
            width: selected ? 2 : 1.5,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? color : AppColors.borderSolid,
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? Icon(Icons.check_circle_outline, color: color, size: 14)
                      : null,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    strategy.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: selected ? color : AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _MiniMetric(
                    label: 'Return',
                    value:
                        '+${strategy.metrics.totalReturn.toStringAsFixed(1)}%',
                    color: _compareGreen,
                  ),
                ),
                Expanded(
                  child: _MiniMetric(
                    label: 'Sharpe',
                    value: strategy.metrics.sharpeRatio.toStringAsFixed(2),
                    color: AppColors.text1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
            height: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}

class _BestStrategyCard extends StatelessWidget {
  const _BestStrategyCard({required this.strategy});

  final TradeBotCompareStrategy strategy;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .05),
        border: Border.all(color: color.withValues(alpha: .30), width: 1.5),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.workspace_premium_outlined, color: color, size: 25),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Risk-Adjusted Returns',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: color,
                    fontSize: 16,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: strategy.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text:
                            ' has the highest Sharpe ratio (${strategy.metrics.sharpeRatio.toStringAsFixed(2)}) among selected strategies, indicating superior risk-adjusted performance.',
                      ),
                    ],
                  ),
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

class _EquityChartCard extends StatelessWidget {
  const _EquityChartCard({required this.points, required this.strategies});

  final List<TradeBotCompareEquityPoint> points;
  final List<TradeBotCompareStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        height: 220,
        child: CustomPaint(
          painter: _EquityChartPainter(points, strategies),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _RadarCard extends StatelessWidget {
  const _RadarCard({required this.strategies});

  final List<TradeBotCompareStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        height: 280,
        child: CustomPaint(
          painter: _RadarPainter(strategies),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _MetricsTable extends StatelessWidget {
  const _MetricsTable({required this.strategies});

  final List<TradeBotCompareStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _MetricRowData('Total Return', 'totalReturn', '%', _BestMode.highest),
      _MetricRowData('Sharpe Ratio', 'sharpeRatio', '', _BestMode.highest),
      _MetricRowData('Max Drawdown', 'maxDrawdown', '%', _BestMode.lowest),
      _MetricRowData('Win Rate', 'winRate', '%', _BestMode.highest),
      _MetricRowData('Profit Factor', 'profitFactor', '', _BestMode.highest),
      _MetricRowData('Total Trades', 'totalTrades', '', _BestMode.neutral),
      _MetricRowData('Avg Duration', 'avgTradeDuration', '', _BestMode.neutral),
      _MetricRowData('Volatility', 'volatility', '%', _BestMode.lowest),
    ];

    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          _TableHeader(strategies: strategies),
          for (final row in rows)
            _TableMetricRow(
              row: row,
              strategies: strategies,
              showDivider: row != rows.last,
            ),
        ],
      ),
    );
  }
}

enum _BestMode { highest, lowest, neutral }

class _MetricRowData {
  const _MetricRowData(this.label, this.key, this.suffix, this.bestMode);

  final String label;
  final String key;
  final String suffix;
  final _BestMode bestMode;
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.strategies});

  final List<TradeBotCompareStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSolid)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Metric',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          for (final strategy in strategies)
            SizedBox(
              width: 100,
              child: Text(
                strategy.name,
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: Color(strategy.colorHex),
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TableMetricRow extends StatelessWidget {
  const _TableMetricRow({
    required this.row,
    required this.strategies,
    required this.showDivider,
  });

  final _MetricRowData row;
  final List<TradeBotCompareStrategy> strategies;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final values = strategies.map(
      (strategy) => _metricValue(strategy, row.key),
    );
    final numericValues = values.whereType<double>().toList();
    final bestValue = switch (row.bestMode) {
      _BestMode.highest when numericValues.isNotEmpty => numericValues.reduce(
        math.max,
      ),
      _BestMode.lowest when numericValues.isNotEmpty => numericValues.reduce(
        math.min,
      ),
      _ => null,
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.borderSolid))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1,
              ),
            ),
          ),
          for (final strategy in strategies)
            SizedBox(
              width: 100,
              child: _TableValue(
                metricKey: row.key,
                strategy: strategy,
                value: _metricValue(strategy, row.key),
                suffix: row.suffix,
                isBest:
                    bestValue != null &&
                    _metricValue(strategy, row.key) == bestValue,
              ),
            ),
        ],
      ),
    );
  }
}

class _TableValue extends StatelessWidget {
  const _TableValue({
    required this.metricKey,
    required this.strategy,
    required this.value,
    required this.suffix,
    required this.isBest,
  });

  final String metricKey;
  final TradeBotCompareStrategy strategy;
  final Object value;
  final String suffix;
  final bool isBest;

  @override
  Widget build(BuildContext context) {
    final text = _formatMetricValue(metricKey, value, suffix);
    final color = isBest ? Color(strategy.colorHex) : AppColors.text1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ),
        if (isBest) ...[
          const SizedBox(width: 2),
          Icon(Icons.star_rounded, color: color, size: 10),
        ],
      ],
    );
  }
}

String _formatMetricValue(String metricKey, Object value, String suffix) {
  if (value is! num) return '$value$suffix';
  final decimals = switch (metricKey) {
    'sharpeRatio' || 'profitFactor' => 2,
    'totalTrades' => 0,
    _ => 1,
  };
  return '${value.toStringAsFixed(decimals)}$suffix';
}

Object _metricValue(TradeBotCompareStrategy strategy, String key) {
  final metrics = strategy.metrics;
  return switch (key) {
    'totalReturn' => metrics.totalReturn,
    'sharpeRatio' => metrics.sharpeRatio,
    'maxDrawdown' => metrics.maxDrawdown,
    'winRate' => metrics.winRate,
    'profitFactor' => metrics.profitFactor,
    'totalTrades' => metrics.totalTrades,
    'avgTradeDuration' => metrics.avgTradeDuration,
    'volatility' => metrics.volatility,
    _ => '',
  };
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.strategy,
  });

  final TradeBotRecommendation recommendation;
  final TradeBotCompareStrategy strategy;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Icon(Icons.trending_up_rounded, color: color, size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.title,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  recommendation.strategy,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recommendation.reason,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    height: 1.5,
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

class _AnalysisPeriodCard extends StatelessWidget {
  const _AnalysisPeriodCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _comparePanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Period',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.6,
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
        color: _comparePanel,
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
            color: _comparePrimary,
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

class _EquityChartPainter extends CustomPainter {
  const _EquityChartPainter(this.points, this.strategies);

  final List<TradeBotCompareEquityPoint> points;
  final List<TradeBotCompareStrategy> strategies;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 8, size.width - 90, size.height - 55);
    final axisPaint = Paint()
      ..color = _compareAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, 450, 900, 1350, 1800]) {
      final y = chart.bottom - (value / 1800) * chart.height;
      _paintText(
        canvas,
        '\$$value',
        Offset(10, y - 6),
        AppColors.text3,
        10,
        width: 48,
        align: TextAlign.right,
      );
    }
    for (var i = 0; i < points.length; i++) {
      final x =
          chart.left + i / (points.length - 1).clamp(1, 999) * chart.width;
      _paintText(
        canvas,
        points[i].date,
        Offset(x - 14, chart.bottom + 10),
        AppColors.text3,
        10,
        width: 30,
        align: TextAlign.center,
      );
    }

    for (final strategy in strategies) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x =
            chart.left + i / (points.length - 1).clamp(1, 999) * chart.width;
        final y =
            chart.bottom -
            (points[i].valueFor(strategy.id) / 1900).clamp(0, 1) * chart.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = Color(strategy.colorHex)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    final legendY = size.height - 18;
    var legendX = size.width / 2 - 70;
    for (final strategy in strategies) {
      final color = Color(strategy.colorHex);
      final paint = Paint()
        ..color = color
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(legendX, legendY),
        Offset(legendX + 10, legendY),
        paint,
      );
      canvas.drawCircle(
        Offset(legendX + 5, legendY),
        2.5,
        Paint()..color = color,
      );
      _paintText(
        canvas,
        strategy.name,
        Offset(legendX + 14, legendY - 6),
        color,
        11,
        width: 90,
      );
      legendX += 106;
    }
  }

  @override
  bool shouldRepaint(covariant _EquityChartPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.strategies != strategies;
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter(this.strategies);

  final List<TradeBotCompareStrategy> strategies;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 10);
    const radius = 84.0;
    final labels = [
      'Return',
      'Sharpe',
      'Win Rate',
      'Profit Factor',
      'Low Risk',
    ];
    final gridPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = .7
      ..style = PaintingStyle.stroke;

    for (final scale in [.25, .5, .75, 1.0]) {
      final path = Path();
      for (var i = 0; i < labels.length; i++) {
        final point = _radarPoint(center, radius * scale, i, labels.length);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }
    for (var i = 0; i < labels.length; i++) {
      final point = _radarPoint(center, radius, i, labels.length);
      canvas.drawLine(center, point, gridPaint);
      _paintText(
        canvas,
        labels[i],
        Offset(point.dx - 36, point.dy - 7),
        AppColors.text2,
        11,
        width: 72,
        align: TextAlign.center,
      );
    }

    for (final strategy in strategies) {
      final color = Color(strategy.colorHex);
      final values = _radarValues(strategy);
      final path = Path();
      for (var i = 0; i < values.length; i++) {
        final point = _radarPoint(
          center,
          radius * values[i].clamp(0, 100) / 100,
          i,
          values.length,
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas
        ..drawPath(path, Paint()..color = color.withValues(alpha: .15))
        ..drawPath(
          path,
          Paint()
            ..color = color
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke,
        );
    }

    var legendX = center.dx - 92;
    final legendY = size.height - 20;
    for (final strategy in strategies) {
      final color = Color(strategy.colorHex);
      canvas.drawRect(
        Rect.fromLTWH(legendX, legendY - 6, 14, 10),
        Paint()..color = color,
      );
      _paintText(
        canvas,
        strategy.name,
        Offset(legendX + 18, legendY - 8),
        color,
        11,
        width: 100,
      );
      legendX += 118;
    }
  }

  List<double> _radarValues(TradeBotCompareStrategy strategy) {
    final metrics = strategy.metrics;
    return [
      metrics.totalReturn,
      metrics.sharpeRatio / 3 * 100,
      metrics.winRate,
      metrics.profitFactor / 3 * 100,
      math.max(0, 100 + metrics.maxDrawdown),
    ];
  }

  Offset _radarPoint(Offset center, double radius, int index, int count) {
    final angle = -math.pi / 2 + math.pi * 2 * index / count;
    return Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.strategies != strategies;
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
