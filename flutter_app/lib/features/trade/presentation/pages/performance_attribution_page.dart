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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _attributionPrimary = AppColors.primary;
const _attributionPurple = AppColors.accent;
const _attributionGreen = AppColors.buy;
const _attributionRed = AppColors.sell;
const _attributionGray = AppColors.text3;

class PerformanceAttributionPage extends ConsumerStatefulWidget {
  const PerformanceAttributionPage({
    super.key,
    required this.copyId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc075_performance_attribution_content');

  static Key tabKey(String id) => Key('sc075_performance_attribution_tab_$id');

  final String copyId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PerformanceAttributionPage> createState() =>
      _PerformanceAttributionPageState();
}

class _PerformanceAttributionPageState
    extends ConsumerState<PerformanceAttributionPage> {
  String _activeTab = 'attribution';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getPerformanceAttribution(copyId: widget.copyId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 26 : 14);

    return VitPageLayout(
      semanticLabel: 'SC-075 PerformanceAttributionPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Phân tích hiệu suất',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.tradeCopyPerformance(widget.copyId)),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: PerformanceAttributionPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryGrid(snapshot: snapshot),
                    const SizedBox(height: 24),
                    _AttributionTabs(
                      activeTab: _activeTab,
                      onChanged: (value) => setState(() => _activeTab = value),
                    ),
                    const SizedBox(height: 22),
                    if (_activeTab == 'attribution')
                      _AttributionTab(snapshot: snapshot)
                    else if (_activeTab == 'drawdown')
                      _DrawdownTab(snapshot: snapshot)
                    else if (_activeTab == 'projection')
                      _ProjectionTab(snapshot: snapshot)
                    else
                      _CorrelationTab(snapshot: snapshot),
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.18,
      children: [
        _MetricTile(
          label: 'Total Return',
          value: '+${snapshot.totalReturnPct.toStringAsFixed(1)}%',
          caption: '30 ngày',
          valueColor: _attributionGreen,
        ),
        _MetricTile(
          label: 'Alpha (Skill)',
          value:
              '${snapshot.alphaPct >= 0 ? '+' : ''}${snapshot.alphaPct.toStringAsFixed(1)}%',
          caption: 'vs market',
          valueColor: snapshot.alphaPct >= 0
              ? _attributionGreen
              : _attributionRed,
        ),
        _MetricTile(
          label: 'Beta (Market)',
          value: snapshot.beta.toStringAsFixed(2),
          caption: 'sensitivity',
          valueColor: AppColors.text1,
        ),
        _MetricTile(
          label: 'R² (Fit)',
          value: '${(snapshot.rSquared * 100).toStringAsFixed(0)}%',
          caption: 'explained',
          valueColor: AppColors.text1,
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            caption,
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

class _AttributionTabs extends StatelessWidget {
  const _AttributionTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('attribution', 'Attribution'),
      ('drawdown', 'Drawdown'),
      ('projection', 'Projection'),
      ('correlation', 'Correlation'),
    ];

    return Container(
      height: 54,
      color: AppColors.surface,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: PerformanceAttributionPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeTab == tab.$1
                                ? _attributionPrimary
                                : AppColors.text3,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      height: 2,
                      width: activeTab == tab.$1 ? 70 : 0,
                      color: _attributionPrimary,
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

class _AttributionTab extends StatelessWidget {
  const _AttributionTab({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(label: 'Returns Decomposition'),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: CustomPaint(
            painter: _ReturnDecompositionPainter(snapshot.returns),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 6),
        const _LegendRow(
          items: [
            _LegendItem('Market (Beta)', _attributionGray),
            _LegendItem('Alpha (Skill)', _attributionPurple),
          ],
        ),
        const SizedBox(height: 18),
        _InfoPanel(snapshot: snapshot),
        const SizedBox(height: 10),
        _ContributionBar(
          label: 'Market contribution (Beta)',
          value: snapshot.marketContributionPct,
          color: _attributionGray,
          ratio: .92,
        ),
        const SizedBox(height: 10),
        _ContributionBar(
          label: 'Skill contribution (Alpha)',
          value: snapshot.skillContributionPct,
          color: _attributionPurple,
          ratio: .45,
        ),
      ],
    );
  }
}

class _DrawdownTab extends StatelessWidget {
  const _DrawdownTab({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(label: 'Underwater Chart'),
        const SizedBox(height: 12),
        SizedBox(
          height: 252,
          child: CustomPaint(
            painter: _DrawdownPainter(snapshot.drawdowns),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Max Drawdown',
                value: '${snapshot.maxDrawdownPct.toStringAsFixed(2)}%',
                caption: 'lowest point',
                valueColor: _attributionRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricTile(
                label: 'Avg Drawdown',
                value: '${snapshot.avgDrawdownPct.toStringAsFixed(2)}%',
                caption: 'average',
                valueColor: AppColors.text1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _NoticePanel(
          color: AppColors.caution,
          text:
              'Underwater chart hiển thị khoảng cách từ đỉnh lịch sử. Recovery dài có thể gây stress tâm lý.',
        ),
      ],
    );
  }
}

class _ProjectionTab extends StatelessWidget {
  const _ProjectionTab({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(label: 'Monte Carlo Simulation (30 ngày)'),
        const SizedBox(height: 12),
        _NoticePanel(
          color: _attributionPrimary,
          text:
              '50 kịch bản ngẫu nhiên dựa trên volatility lịch sử. Vùng tím thể hiện khoảng xác suất tham khảo.',
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 270,
          child: CustomPaint(
            painter: _ProjectionPainter(snapshot.monteCarloPaths),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _ProjectionTile(
                label: '5th Percentile',
                value: snapshot.worstProjection,
                color: _attributionRed,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ProjectionTile(
                label: '50th Percentile',
                value: snapshot.medianProjection,
                color: _attributionPurple,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ProjectionTile(
                label: '95th Percentile',
                value: snapshot.bestProjection,
                color: _attributionGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CorrelationTab extends StatelessWidget {
  const _CorrelationTab({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(label: 'Daily Returns Correlation'),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: CustomPaint(
            painter: _CorrelationPainter(snapshot.correlationPoints),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 16),
        VitCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _KeyValueRow(
                label: 'Correlation coefficient (R)',
                value: math.sqrt(snapshot.rSquared).toStringAsFixed(2),
              ),
              const SizedBox(height: 12),
              _KeyValueRow(
                label: 'R² (explained variance)',
                value: '${(snapshot.rSquared * 100).toStringAsFixed(0)}%',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _NoticePanel(
          color: _attributionPrimary,
          text:
              'R² cho biết bao nhiêu biến động của bạn được giải thích bởi thị trường; phần còn lại đến từ strategy riêng.',
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        fontWeight: FontWeight.w800,
        letterSpacing: .2,
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _attributionPrimary.withValues(alpha: .10),
        border: Border.all(color: _attributionPrimary),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _attributionPrimary,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.micro.copyWith(
                  color: _attributionPrimary,
                  height: 1.45,
                  fontSize: 10,
                ),
                children: [
                  const TextSpan(
                    text: 'Giải thích\n',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(
                    text:
                        'Alpha: Phần lợi nhuận do kỹ năng provider. Beta: Phần lợi nhuận do thị trường chung tăng/giảm. ',
                  ),
                  TextSpan(
                    text:
                        'Beta ${snapshot.beta.toStringAsFixed(2)} nghĩa là khi thị trường +1%, bạn +${snapshot.beta.toStringAsFixed(2)}%.',
                    style: const TextStyle(fontWeight: FontWeight.w700),
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

class _ContributionBar extends StatelessWidget {
  const _ContributionBar({
    required this.label,
    required this.value,
    required this.color,
    required this.ratio,
  });

  final String label;
  final double value;
  final Color color;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              value: ratio.clamp(0, 1),
              minHeight: 8,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticePanel extends StatelessWidget {
  const _NoticePanel({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        border: Border.all(color: color.withValues(alpha: .55)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: color,
                height: 1.45,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectionTile extends StatelessWidget {
  const _ProjectionTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: color, fontSize: 9),
          ),
          const SizedBox(height: 7),
          Text(
            '\$${value.toStringAsFixed(0)}',
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _LegendItem {
  const _LegendItem(this.label, this.color);

  final String label;
  final Color color;
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.items});

  final List<_LegendItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final item in items) ...[
          Container(width: 18, height: 2, color: item.color),
          const SizedBox(width: 4),
          Text(
            item.label,
            style: AppTextStyles.micro.copyWith(
              color: item.color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _ReturnDecompositionPainter extends CustomPainter {
  const _ReturnDecompositionPainter(this.points);

  final List<TradePerformanceReturnPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(58, 8, size.width - 68, size.height - 42);
    _drawGrid(canvas, plot, yLabels: const ['16', '12', '8', '4', '0']);

    final marketPath = Path();
    final alphaPath = Path();
    final areaPath = Path();
    final minY = 0.0;
    final maxY = 16.0;
    Offset pointFor(TradePerformanceReturnPoint point, double value) {
      final x = plot.left + (point.day - 1) / 29 * plot.width;
      final y = plot.bottom - ((value - minY) / (maxY - minY)) * plot.height;
      return Offset(x, y);
    }

    for (var i = 0; i < points.length; i++) {
      final market = pointFor(points[i], points[i].market);
      final total = pointFor(points[i], points[i].total);
      if (i == 0) {
        marketPath.moveTo(market.dx, market.dy);
        alphaPath.moveTo(total.dx, total.dy);
        areaPath.moveTo(total.dx, plot.bottom);
        areaPath.lineTo(total.dx, total.dy);
      } else {
        marketPath.lineTo(market.dx, market.dy);
        alphaPath.lineTo(total.dx, total.dy);
        areaPath.lineTo(total.dx, total.dy);
      }
    }
    areaPath
      ..lineTo(pointFor(points.last, points.last.total).dx, plot.bottom)
      ..close();

    canvas.drawPath(
      areaPath,
      Paint()
        ..color = _attributionPurple.withValues(alpha: .28)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      marketPath,
      Paint()
        ..color = _attributionGray
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
    canvas.drawPath(
      alphaPath,
      Paint()
        ..color = _attributionPurple
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    _drawXAxis(canvas, plot);
  }

  @override
  bool shouldRepaint(covariant _ReturnDecompositionPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _DrawdownPainter extends CustomPainter {
  const _DrawdownPainter(this.points);

  final List<TradePerformanceDrawdownPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(54, 8, size.width - 64, size.height - 36);
    _drawGrid(canvas, plot, yLabels: const ['0', '-2', '-4', '-6', '-8']);
    final path = Path();
    final fill = Path();
    Offset pointFor(TradePerformanceDrawdownPoint point) {
      final x = plot.left + (point.day - 1) / 29 * plot.width;
      final y = plot.top + (point.drawdown.abs() / 9) * plot.height;
      return Offset(x, y);
    }

    for (var i = 0; i < points.length; i++) {
      final offset = pointFor(points[i]);
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
        fill.moveTo(offset.dx, plot.top);
        fill.lineTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
        fill.lineTo(offset.dx, offset.dy);
      }
    }
    fill
      ..lineTo(pointFor(points.last).dx, plot.top)
      ..close();
    canvas.drawPath(
      fill,
      Paint()..color = _attributionRed.withValues(alpha: .22),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = _attributionRed
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    _drawXAxis(canvas, plot);
  }

  @override
  bool shouldRepaint(covariant _DrawdownPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _ProjectionPainter extends CustomPainter {
  const _ProjectionPainter(this.paths);

  final List<List<TradePerformanceProjectionPoint>> paths;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(58, 8, size.width - 68, size.height - 40);
    _drawGrid(canvas, plot, yLabels: const ['6500', '6000', '5500', '5000']);
    for (var i = 0; i < paths.length; i++) {
      final line = Path();
      for (var j = 0; j < paths[i].length; j++) {
        final p = paths[i][j];
        final x = plot.left + (p.day - 1) / 29 * plot.width;
        final y = plot.bottom - ((p.value - 4800) / 1800) * plot.height;
        if (j == 0) {
          line.moveTo(x, y);
        } else {
          line.lineTo(x, y);
        }
      }
      canvas.drawPath(
        line,
        Paint()
          ..color = _attributionPurple.withValues(alpha: i == 0 ? .9 : .35)
          ..strokeWidth = i == 0 ? 2 : 1.2
          ..style = PaintingStyle.stroke,
      );
    }
    _drawXAxis(canvas, plot);
  }

  @override
  bool shouldRepaint(covariant _ProjectionPainter oldDelegate) {
    return oldDelegate.paths != paths;
  }
}

class _CorrelationPainter extends CustomPainter {
  const _CorrelationPainter(this.points);

  final List<TradePerformanceCorrelationPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(54, 8, size.width - 64, size.height - 38);
    _drawGrid(canvas, plot, yLabels: const ['2', '1', '0', '-1', '-2']);
    final axisPaint = Paint()
      ..color = AppColors.surface3
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(plot.left + plot.width / 2, plot.top),
      Offset(plot.left + plot.width / 2, plot.bottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(plot.left, plot.top + plot.height / 2),
      Offset(plot.right, plot.top + plot.height / 2),
      axisPaint,
    );
    final dotPaint = Paint()..color = _attributionPrimary;
    for (final point in points) {
      final x = plot.left + ((point.marketReturn + 2.5) / 5) * plot.width;
      final y = plot.bottom - ((point.yourReturn + 2.5) / 5) * plot.height;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CorrelationPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

void _drawGrid(Canvas canvas, Rect plot, {required List<String> yLabels}) {
  final gridPaint = Paint()
    ..color = AppColors.surfaceNavyDarker
    ..strokeWidth = 1;
  final axisPaint = Paint()
    ..color = AppColors.surfaceNavyStroke
    ..strokeWidth = 1;
  for (var i = 0; i < 14; i++) {
    final x = plot.left + i / 13 * plot.width;
    canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), gridPaint);
  }
  for (var i = 0; i < yLabels.length; i++) {
    final y = plot.top + i / (yLabels.length - 1) * plot.height;
    canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
    _drawChartText(
      canvas,
      yLabels[i],
      Offset(plot.left - 12, y - 6),
      align: TextAlign.right,
      width: 34,
    );
  }
  canvas.drawLine(plot.bottomLeft, plot.bottomRight, axisPaint);
  canvas.drawLine(plot.topLeft, plot.bottomLeft, axisPaint);
}

void _drawXAxis(Canvas canvas, Rect plot) {
  for (var day = 2; day <= 30; day += 2) {
    final x = plot.left + (day - 1) / 29 * plot.width;
    _drawChartText(canvas, '$day', Offset(x - 8, plot.bottom + 8), width: 18);
  }
  _drawChartText(canvas, 'Ngày', Offset(plot.center.dx - 18, plot.bottom + 22));
  _drawChartText(
    canvas,
    '%',
    Offset(plot.left - 54, plot.center.dy - 6),
    width: 30,
  );
}

void _drawChartText(
  Canvas canvas,
  String text,
  Offset offset, {
  TextAlign align = TextAlign.center,
  double width = 40,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(
        color: AppColors.attributionText,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),
    textAlign: align,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: width);
  painter.paint(canvas, offset);
}
