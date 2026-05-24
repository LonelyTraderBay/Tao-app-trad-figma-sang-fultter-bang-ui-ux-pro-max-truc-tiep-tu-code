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

const _portfolioBackground = AppColors.bg;
const _portfolioPanel = AppColors.surface;
const _portfolioPrimary = AppColors.primary;
const _portfolioGreen = Color(0xFF10B981);
const _portfolioAmber = Color(0xFFF59E0B);
const _portfolioRed = Color(0xFFEF4444);
const _portfolioAxis = Color(0xFF475569);

class BotPortfolioDashboardPage extends ConsumerWidget {
  const BotPortfolioDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc128_bot_portfolio_dashboard_content');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getBotPortfolioDashboard();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-128 BotPortfolioDashboardPage',
      child: Material(
        color: _portfolioBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Portfolio Dashboard',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: EdgeInsets.fromLTRB(20, 11, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryGrid(summary: snapshot.summary),
                    const SizedBox(height: 12),
                    const _SectionLabel('Portfolio Equity Curve'),
                    const SizedBox(height: 10),
                    _EquityCard(points: snapshot.equityPoints),
                    const SizedBox(height: 18),
                    const _SectionLabel('Allocation Breakdown'),
                    const SizedBox(height: 10),
                    _AllocationCard(allocations: snapshot.allocations),
                    const SizedBox(height: 18),
                    const _SectionLabel('Bot Correlation Matrix'),
                    const SizedBox(height: 10),
                    _CorrelationCard(rows: snapshot.correlations),
                    const SizedBox(height: 18),
                    _HealthCard(items: snapshot.healthItems),
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
  const _SummaryGrid({required this.summary});

  final TradeBotPortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCardData(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: _portfolioPrimary,
        label: 'Total Equity',
        value: _formatUsd(summary.totalEquity),
      ),
      _SummaryCardData(
        icon: Icons.trending_up_rounded,
        iconColor: _portfolioGreen,
        label: 'Total PnL',
        value: '+\$${summary.totalPnl.toStringAsFixed(0)}',
        valueColor: _portfolioGreen,
        caption: '+${summary.pnlPercent.toStringAsFixed(1)}%',
        captionColor: _portfolioGreen,
      ),
      _SummaryCardData(
        icon: Icons.show_chart_rounded,
        iconColor: _portfolioPrimary,
        label: 'Portfolio Sharpe',
        value: summary.portfolioSharpe.toStringAsFixed(2),
        caption: 'Excellent',
        captionColor: _portfolioGreen,
      ),
      _SummaryCardData(
        icon: Icons.pie_chart_outline_rounded,
        iconColor: _portfolioAmber,
        label: 'Diversification',
        value: '${summary.diversificationScore}/100',
        caption: 'Good',
        captionColor: _portfolioAmber,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.53,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [for (final card in cards) _SummaryCard(data: card)],
    );
  }
}

class _SummaryCardData {
  const _SummaryCardData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.caption,
    this.captionColor = AppColors.text3,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final String? caption;
  final Color captionColor;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _SummaryCardData data;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: data.iconColor, size: 21),
          const SizedBox(height: 8),
          Text(
            data.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: data.valueColor,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          if (data.caption != null) ...[
            const SizedBox(height: 4),
            Text(
              data.caption!,
              style: AppTextStyles.micro.copyWith(
                color: data.captionColor,
                fontSize: 11,
                fontFamily: 'Roboto',
                height: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EquityCard extends StatelessWidget {
  const _EquityCard({required this.points});

  final List<TradeBotPortfolioEquityPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        height: 180,
        child: CustomPaint(
          painter: _EquityPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.allocations});

  final List<TradeBotPortfolioAllocation> allocations;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 9),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _DonutPainter(allocations),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 4.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              for (final item in allocations) _AllocationLegend(item: item),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationLegend extends StatelessWidget {
  const _AllocationLegend({required this.item});

  final TradeBotPortfolioAllocation item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Color(item.colorHex),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.strategy,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '\$${item.value.toStringAsFixed(0)}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CorrelationCard extends StatelessWidget {
  const _CorrelationCard({required this.rows});

  final List<TradeBotCorrelationRow> rows;

  @override
  Widget build(BuildContext context) {
    final headers = rows.map((row) => row.bot).toList();
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _TableHeaderText('Bot', alignLeft: true)),
              for (final header in headers)
                SizedBox(width: 74, child: _TableHeaderText(header)),
            ],
          ),
          const SizedBox(height: 13),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.bot,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                for (final header in headers)
                  SizedBox(
                    width: 74,
                    child: Center(
                      child: _CorrelationPill(value: row.values[header] ?? 0),
                    ),
                  ),
              ],
            ),
            if (row != rows.last) const SizedBox(height: 14),
          ],
          const SizedBox(height: 15),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Low correlation (<0.2) = Good diversification ',
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: _portfolioGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
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

class _TableHeaderText extends StatelessWidget {
  const _TableHeaderText(this.text, {this.alignLeft = false});

  final String text;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignLeft ? TextAlign.left : TextAlign.center,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontSize: 10,
        fontWeight: AppTextStyles.bold,
        height: 1,
      ),
    );
  }
}

class _CorrelationPill extends StatelessWidget {
  const _CorrelationPill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value.abs() < .2
        ? _portfolioGreen
        : value.abs() < .5
        ? _portfolioAmber
        : _portfolioRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        value.toStringAsFixed(2),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          fontFamily: 'Roboto',
          height: 1,
        ),
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  const _HealthCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: _portfolioGreen.withValues(alpha: .10),
        border: Border.all(color: _portfolioGreen.withValues(alpha: .30)),
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
                decoration: const BoxDecoration(
                  color: Color(0xFF6EE7B7),
                  shape: BoxShape.rectangle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Portfolio Health: Excellent',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: _portfolioGreen,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
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
            if (item != items.last) const SizedBox(height: 12),
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
        color: _portfolioPanel,
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
            color: _portfolioPrimary,
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

  final List<TradeBotPortfolioEquityPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 14, size.width - 90, size.height - 48);
    final axisPaint = Paint()
      ..color = _portfolioAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, 850, 1700, 3400]) {
      final y = chart.bottom - (value / 3400) * chart.height;
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
      final x = chart.left + i / (points.length - 1) * chart.width;
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

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + i / (points.length - 1) * chart.width;
      final y = chart.bottom - (points[i].equity / 3400) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _portfolioGreen
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _EquityPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.allocations);

  final List<TradeBotPortfolioAllocation> allocations;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const outerRadius = 65.0;
    const strokeWidth = 30.0;
    final rect = Rect.fromCircle(center: center, radius: outerRadius);
    final total = allocations.fold<double>(0, (sum, item) => sum + item.value);
    var start = -math.pi / 2;

    for (final item in allocations) {
      final sweep = item.value / total * math.pi * 2;
      canvas.drawArc(
        rect,
        start + .02,
        sweep - .04,
        false,
        Paint()
          ..color = Color(item.colorHex)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.allocations != allocations;
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

String _formatUsd(double value) {
  final whole = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '\$$buffer';
}
