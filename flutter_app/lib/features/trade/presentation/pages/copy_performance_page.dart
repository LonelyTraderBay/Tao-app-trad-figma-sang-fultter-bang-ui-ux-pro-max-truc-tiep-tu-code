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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _performancePrimary = AppColors.primary;
const _performancePurple = AppColors.accent;
const _performanceGreen = AppColors.buy;
const _performanceRed = AppColors.sell;
const _performancePanel = AppColors.surfaceNavy;

class CopyPerformancePage extends ConsumerStatefulWidget {
  const CopyPerformancePage({
    super.key,
    required this.copyId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc074_copy_performance_content');

  static Key tabKey(String id) => Key('sc074_copy_performance_tab_$id');

  final String copyId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyPerformancePage> createState() =>
      _CopyPerformancePageState();
}

class _CopyPerformancePageState extends ConsumerState<CopyPerformancePage> {
  String _activeTab = 'overview';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getCopyPerformance(copyId: widget.copyId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 26 : 14);

    return VitPageLayout(
      semanticLabel: 'SC-074 CopyPerformancePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Phân tích hiệu suất',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.trade),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CopyPerformancePage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PerformanceSummary(snapshot: snapshot),
                    const SizedBox(height: 24),
                    _PerformanceTabs(
                      activeTab: _activeTab,
                      onChanged: (value) => setState(() => _activeTab = value),
                    ),
                    const SizedBox(height: 22),
                    if (_activeTab == 'overview')
                      _OverviewTab(snapshot: snapshot)
                    else if (_activeTab == 'trades')
                      _TradesTab(snapshot: snapshot)
                    else if (_activeTab == 'costs')
                      _CostsTab(snapshot: snapshot)
                    else
                      _MetricsTab(snapshot: snapshot),
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

class _PerformanceSummary extends StatelessWidget {
  const _PerformanceSummary({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tổng quan so sánh',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ReturnCard(
                  title: 'Hiệu suất của bạn',
                  value: '+${snapshot.yourReturnPct.toStringAsFixed(1)}%',
                  range:
                      '\$${snapshot.initialCapital.toStringAsFixed(0)} → \$${snapshot.yourCurrentValue.toStringAsFixed(0)}',
                  background: AppColors.surfaceInfoLight,
                  border: _performancePrimary,
                  foreground: _performancePrimary,
                  textColor: AppColors.infoTextStrong,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReturnCard(
                  title: 'Provider lý thuyết',
                  value: '+${snapshot.providerReturnPct.toStringAsFixed(1)}%',
                  range:
                      '\$${snapshot.initialCapital.toStringAsFixed(0)} → \$${snapshot.providerTheoreticalValue.toStringAsFixed(0)}',
                  background: AppColors.surfaceAccentLight,
                  border: _performancePurple,
                  foreground: _performancePurple,
                  textColor: AppColors.accentTextStrong,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSuccessLight,
              border: Border.all(color: _performanceGreen),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: _performanceGreen,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Chênh lệch hiệu suất',
                        style: TextStyle(color: AppColors.buy20, fontSize: 12),
                      ),
                    ),
                    Text(
                      '${snapshot.performanceGapPct.toStringAsFixed(2)}%',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: _performanceGreen,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nguyên nhân chính: slippage (${snapshot.avgSlippagePct.toStringAsFixed(2)}%) và chi phí (\$${snapshot.totalCosts.toStringAsFixed(0)})',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy20,
                      fontSize: 10,
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

class _ReturnCard extends StatelessWidget {
  const _ReturnCard({
    required this.title,
    required this.value,
    required this.range,
    required this.background,
    required this.border,
    required this.foreground,
    required this.textColor,
  });

  final String title;
  final String value;
  final String range;
  final Color background;
  final Color border;
  final Color foreground;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: textColor, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            range,
            style: AppTextStyles.micro.copyWith(color: textColor, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _PerformanceTabs extends StatelessWidget {
  const _PerformanceTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('overview', 'Tổng quan'),
      ('trades', 'Trades'),
      ('costs', 'Chi phí'),
      ('metrics', 'Metrics'),
    ];
    return Container(
      height: 52,
      color: AppColors.surface,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: CopyPerformancePage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          style: AppTextStyles.caption.copyWith(
                            color: activeTab == tab.$1
                                ? _performancePrimary
                                : AppColors.text3,
                            fontWeight: activeTab == tab.$1
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: activeTab == tab.$1 ? 70 : 0,
                      height: 2,
                      color: _performancePrimary,
                    ),
                  ],
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

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Đường vốn so sánh (30 ngày)',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 258,
          child: CustomPaint(
            painter: _LineChartPainter(points: snapshot.equityCurve),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 14),
        _InfoBox(
          title: 'Tại sao có chênh lệch?',
          lines: const [
            'Slippage: Copy orders thực thi chậm hơn 0.5-3s',
            'Chi phí: Trading fees + performance fees',
            'Position sizing: Fixed mode sử dụng 50% capital',
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Phân bổ Slippage',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: CustomPaint(
            painter: _BarChartPainter(buckets: snapshot.slippageBuckets),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SmallMetricCard(
                label: 'Slippage TB của bạn',
                value: '${snapshot.avgSlippagePct.toStringAsFixed(2)}%',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SmallMetricCard(
                label: 'Provider TB',
                value: '${snapshot.providerAvgSlippagePct.toStringAsFixed(2)}%',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TradesTab extends StatelessWidget {
  const _TradesTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoBox(
          title: 'So sánh từng giao dịch',
          lines: const ['Chênh lệch chủ yếu do slippage và execution delay.'],
        ),
        const SizedBox(height: 12),
        for (final trade in snapshot.tradeComparisons) ...[
          VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SidePill(side: trade.side),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trade.pair,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      trade.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _TradeColumn(
                        title: 'Provider',
                        color: _performancePurple,
                        entry: trade.providerEntry,
                        exit: trade.providerExit,
                        pnl: trade.providerPnl,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _TradeColumn(
                        title: 'Bạn',
                        color: _performancePrimary,
                        entry: trade.yourEntry,
                        exit: trade.yourExit,
                        pnl: trade.yourPnl,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _InlineInfo(
                        icon: Icons.schedule_rounded,
                        label: 'Delay: ${trade.delay}',
                      ),
                    ),
                    Expanded(
                      child: _InlineInfo(
                        icon: Icons.show_chart_rounded,
                        label: 'Slippage: ${trade.slippagePct}%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CostsTab extends StatelessWidget {
  const _CostsTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in snapshot.costAttribution)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: VitCard(
              variant: VitCardVariant.inner,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: Color(item.colorHex),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    '\$${item.value.toStringAsFixed(0)}',
                    style: AppTextStyles.baseMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Divider(color: AppColors.divider, height: 22),
        _SmallMetricCard(
          label: 'Tổng chi phí',
          value: '\$${snapshot.totalCosts.toStringAsFixed(0)}',
          valueColor: _performanceRed,
        ),
      ],
    );
  }
}

class _MetricsTab extends StatelessWidget {
  const _MetricsTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final metric in snapshot.metrics)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: VitCard(
              variant: VitCardVariant.inner,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.name,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _SmallMetricCard(
                          label: 'Bạn',
                          value:
                              '${metric.you.toStringAsFixed(2)}${metric.suffix}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SmallMetricCard(
                          label: 'Provider',
                          value:
                              '${metric.provider.toStringAsFixed(2)}${metric.suffix}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _performancePanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text3,
                size: 13,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $line',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 10,
                  height: 1.25,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SmallMetricCard extends StatelessWidget {
  const _SmallMetricCard({
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _performancePanel,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({required this.points});

  final List<TradeCopyEquityPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 58.0;
    const right = 10.0;
    const top = 4.0;
    const bottom = 42.0;
    final chart = Rect.fromLTWH(
      left,
      top,
      size.width - left - right,
      size.height - top - bottom,
    );
    _drawGrid(canvas, chart, verticalCount: 15, horizontalCount: 4);

    final values = [
      for (final point in points) ...[point.you, point.provider],
    ];
    final min = values.reduce((a, b) => a < b ? a : b) - 80;
    final max = values.reduce((a, b) => a > b ? a : b) + 80;

    Offset project(TradeCopyEquityPoint point, double value) {
      final x = chart.left + (point.day - 1) / 29 * chart.width;
      final y = chart.bottom - (value - min) / (max - min) * chart.height;
      return Offset(x, y);
    }

    canvas.drawLine(
      Offset(chart.left, chart.top),
      Offset(chart.left, chart.bottom),
      _axisPaint,
    );
    canvas.drawLine(
      Offset(chart.left, chart.bottom),
      Offset(chart.right, chart.bottom),
      _axisPaint,
    );

    _drawText(canvas, '886891767', Offset(0, chart.top + 2), AppColors.text3);
    _drawText(
      canvas,
      '18128125',
      Offset(0, chart.center.dy - 4),
      AppColors.text3,
    );
    _drawText(canvas, '18128125', Offset(0, chart.bottom - 2), AppColors.text3);

    for (var day = 2; day <= 30; day += 2) {
      final x = chart.left + (day - 1) / 29 * chart.width;
      _drawText(
        canvas,
        '$day',
        Offset(x - 4, chart.bottom + 8),
        AppColors.text3,
      );
    }
    _drawText(
      canvas,
      'Ngày',
      Offset(chart.center.dx - 10, chart.bottom + 27),
      AppColors.text3,
    );

    _drawLine(
      canvas,
      [for (final point in points) project(point, point.you)],
      _performancePrimary,
      dashed: false,
    );
    _drawLine(
      canvas,
      [for (final point in points) project(point, point.provider)],
      _performancePurple,
      dashed: true,
    );

    final legendY = size.height - 16;
    _drawLegend(
      canvas,
      Offset(chart.left + 48, legendY),
      'Bạn',
      _performancePrimary,
    );
    _drawLegend(
      canvas,
      Offset(chart.left + 98, legendY),
      'Provider (lý thuyết)',
      _performancePurple,
    );
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({required this.buckets});

  final List<TradeCopySlippageBucket> buckets;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 58.0;
    const right = 10.0;
    const top = 8.0;
    const bottom = 44.0;
    final chart = Rect.fromLTWH(
      left,
      top,
      size.width - left - right,
      size.height - top - bottom,
    );
    _drawGrid(canvas, chart, verticalCount: 4, horizontalCount: 3);
    canvas.drawLine(
      Offset(chart.left, chart.top),
      Offset(chart.left, chart.bottom),
      _axisPaint,
    );
    canvas.drawLine(
      Offset(chart.left, chart.bottom),
      Offset(chart.right, chart.bottom),
      _axisPaint,
    );
    _drawText(canvas, '60', Offset(34, chart.top), AppColors.text3);
    _drawText(canvas, '30', Offset(34, chart.center.dy - 4), AppColors.text3);
    _drawText(canvas, '15', Offset(34, chart.center.dy + 30), AppColors.text3);
    _drawText(canvas, '0', Offset(42, chart.bottom - 6), AppColors.text3);
    _drawRotatedText(canvas, '% Trades', Offset(6, chart.center.dy + 20));

    final groupWidth = chart.width / buckets.length;
    const barWidth = 32.0;
    for (var i = 0; i < buckets.length; i++) {
      final bucket = buckets[i];
      final center = chart.left + groupWidth * i + groupWidth / 2;
      final youHeight = bucket.youPct / 60 * chart.height;
      final providerHeight = bucket.providerPct / 60 * chart.height;
      canvas.drawRect(
        Rect.fromLTWH(
          center - barWidth,
          chart.bottom - youHeight,
          barWidth,
          youHeight,
        ),
        Paint()..color = _performancePrimary,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          center + 3,
          chart.bottom - providerHeight,
          barWidth,
          providerHeight,
        ),
        Paint()..color = _performancePurple,
      );
      _drawText(
        canvas,
        bucket.range,
        Offset(center - 24, chart.bottom + 8),
        AppColors.text3,
      );
    }
    _drawLegend(
      canvas,
      Offset(chart.left + 78, size.height - 16),
      'Bạn',
      _performancePrimary,
    );
    _drawLegend(
      canvas,
      Offset(chart.left + 128, size.height - 16),
      'Provider',
      _performancePurple,
    );
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.buckets != buckets;
  }
}

class _SidePill extends StatelessWidget {
  const _SidePill({required this.side});

  final TradeOrderSide side;

  @override
  Widget build(BuildContext context) {
    final buy = side == TradeOrderSide.buy;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: buy ? AppColors.buy : AppColors.sell,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          buy ? 'BUY' : 'SELL',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.onAccent,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _TradeColumn extends StatelessWidget {
  const _TradeColumn({
    required this.title,
    required this.color,
    required this.entry,
    required this.exit,
    required this.pnl,
  });

  final String title;
  final Color color;
  final double entry;
  final double exit;
  final double pnl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        border: Border.all(color: color),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.micro.copyWith(color: color)),
          const SizedBox(height: 8),
          _MiniRow(label: 'Entry', value: '\$${entry.toStringAsFixed(0)}'),
          _MiniRow(label: 'Exit', value: '\$${exit.toStringAsFixed(0)}'),
          const Divider(color: AppColors.divider, height: 14),
          _MiniRow(
            label: 'P/L',
            value: '${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(0)}',
            valueColor: pnl >= 0 ? AppColors.buy : AppColors.sell,
          ),
        ],
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text3, size: 13),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniRow extends StatelessWidget {
  const _MiniRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
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
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

final Paint _axisPaint = Paint()
  ..color = AppColors.borderSolid
  ..strokeWidth = 1;

void _drawGrid(
  Canvas canvas,
  Rect chart, {
  required int verticalCount,
  required int horizontalCount,
}) {
  final paint = Paint()
    ..color = AppColors.borderSolid.withValues(alpha: .36)
    ..strokeWidth = 1;
  for (var i = 0; i <= verticalCount; i++) {
    final x = chart.left + chart.width * i / verticalCount;
    _drawDashedLine(
      canvas,
      Offset(x, chart.top),
      Offset(x, chart.bottom),
      paint,
    );
  }
  for (var i = 0; i <= horizontalCount; i++) {
    final y = chart.top + chart.height * i / horizontalCount;
    _drawDashedLine(
      canvas,
      Offset(chart.left, y),
      Offset(chart.right, y),
      paint,
    );
  }
}

void _drawLine(
  Canvas canvas,
  List<Offset> points,
  Color color, {
  required bool dashed,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  if (!dashed) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, paint);
    return;
  }
  for (var i = 0; i < points.length - 1; i++) {
    _drawDashedLine(canvas, points[i], points[i + 1], paint, dash: 5, gap: 5);
  }
}

void _drawDashedLine(
  Canvas canvas,
  Offset start,
  Offset end,
  Paint paint, {
  double dash = 3,
  double gap = 5,
}) {
  final delta = end - start;
  final distance = delta.distance;
  if (distance == 0) return;
  final direction = delta / distance;
  var current = 0.0;
  while (current < distance) {
    final next = (current + dash).clamp(0, distance).toDouble();
    canvas.drawLine(
      start + direction * current,
      start + direction * next,
      paint,
    );
    current += dash + gap;
  }
}

void _drawText(Canvas canvas, String text, Offset offset, Color color) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}

void _drawRotatedText(Canvas canvas, String text, Offset offset) {
  canvas.save();
  canvas.translate(offset.dx, offset.dy);
  canvas.rotate(-1.5708);
  _drawText(canvas, text, Offset.zero, AppColors.text3);
  canvas.restore();
}

void _drawLegend(Canvas canvas, Offset offset, String label, Color color) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = 2;
  canvas.drawLine(offset, offset + const Offset(14, 0), paint);
  canvas.drawCircle(offset + const Offset(7, 0), 2.5, paint);
  _drawText(canvas, label, offset + const Offset(18, -6), color);
}
