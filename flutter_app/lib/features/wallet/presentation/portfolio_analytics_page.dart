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
import '../data/wallet_repository.dart';

const _analyticsBackground = AppColors.bg;
const _analyticsPanel = AppColors.surface;
const _analyticsPanel2 = AppColors.surface2;
const _analyticsPrimary = AppColors.primary;
const _analyticsGreen = Color(0xFF10B981);
const _analyticsRed = Color(0xFFEF4444);

class PortfolioAnalyticsPage extends ConsumerStatefulWidget {
  const PortfolioAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc142_portfolio_analytics_content');
  static Key periodKey(String period) => Key('sc142_period_$period');
  static Key viewKey(String id) => Key('sc142_view_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PortfolioAnalyticsPage> createState() =>
      _PortfolioAnalyticsPageState();
}

class _PortfolioAnalyticsPageState
    extends ConsumerState<PortfolioAnalyticsPage> {
  String _activeView = 'overview';
  late String _activePeriod;

  @override
  void initState() {
    super.initState();
    _activePeriod = '1M';
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(walletRepositoryProvider)
        .getPortfolioAnalytics();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-142 PortfolioAnalyticsPage',
      child: Material(
        color: _analyticsBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Phân tích Danh mục',
              subtitle: 'Phân tích · Wallet',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: PortfolioAnalyticsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ValueSummary(snapshot: snapshot),
                    const SizedBox(height: 18),
                    _ViewSwitcher(
                      active: _activeView,
                      onChanged: (view) => setState(() => _activeView = view),
                    ),
                    const SizedBox(height: 19),
                    if (_activeView == 'overview')
                      _OverviewContent(
                        snapshot: snapshot,
                        activePeriod: _activePeriod,
                        onPeriodChanged: (period) =>
                            setState(() => _activePeriod = period),
                      )
                    else
                      _PlaceholderAnalyticsView(view: _activeView),
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

class _ValueSummary extends StatelessWidget {
  const _ValueSummary({required this.snapshot});

  final WalletPortfolioAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 222,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surface2],
        ),
        border: Border.all(color: _analyticsPrimary.withValues(alpha: .32)),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng giá trị danh mục',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _formatUsd(snapshot.totalUsd),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.text1,
              fontSize: 27,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 164,
                child: Container(
                  height: 23,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _analyticsGreen.withValues(alpha: .16),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        color: _analyticsGreen,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '+${_formatUsd(snapshot.totalReturnUsd, symbol: false)} (+${snapshot.totalReturnPct.toStringAsFixed(2)}%)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: _analyticsGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                'so với đầu kỳ',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _QuickStat(
                  label: 'Lợi nhuận tốt nhất',
                  value: '+\$${_formatCompactMoney(snapshot.bestProfitUsd)}',
                  sub: snapshot.bestProfitAsset,
                  color: _analyticsGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickStat(
                  label: 'Thua lỗ nhất',
                  value:
                      '-\$${_formatCompactMoney(snapshot.worstLossUsd.abs())}',
                  sub: snapshot.worstLossAsset,
                  color: _analyticsRed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickStat(
                  label: 'Tài sản',
                  value: '${snapshot.assets.length}',
                  sub: 'loại coin',
                  color: _analyticsPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  final String label;
  final String value;
  final String sub;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .055),
        borderRadius: AppRadii.inputRadius,
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
          const SizedBox(height: 5),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewSwitcher extends StatelessWidget {
  const _ViewSwitcher({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      _ViewItem('overview', 'Tổng quan', Icons.bar_chart_rounded),
      _ViewItem('allocation', 'Phân bổ', Icons.pie_chart_outline_rounded),
      _ViewItem('pnl', 'Lãi/Lỗ', Icons.trending_up_rounded),
    ];

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _analyticsPanel2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: GestureDetector(
                key: PortfolioAnalyticsPage.viewKey(item.id),
                onTap: () => onChanged(item.id),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active == item.id
                        ? _analyticsPrimary.withValues(alpha: .18)
                        : Colors.transparent,
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: active == item.id
                            ? _analyticsPrimary
                            : AppColors.text2,
                        size: 14,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        item.label,
                        style: AppTextStyles.micro.copyWith(
                          color: active == item.id
                              ? _analyticsPrimary
                              : AppColors.text2,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({
    required this.snapshot,
    required this.activePeriod,
    required this.onPeriodChanged,
  });

  final WalletPortfolioAnalyticsSnapshot snapshot;
  final String activePeriod;
  final ValueChanged<String> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PeriodSelector(
          periods: snapshot.periods,
          active: activePeriod,
          onChanged: onPeriodChanged,
        ),
        const SizedBox(height: 14),
        _ChartCard(points: snapshot.history),
        const SizedBox(height: 16),
        _MetricsCard(metrics: snapshot.metrics),
        const SizedBox(height: 18),
        _AssetsCard(assets: snapshot.assets, totalUsd: snapshot.totalUsd),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.periods,
    required this.active,
    required this.onChanged,
  });

  final List<String> periods;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final period in periods)
          Expanded(
            child: GestureDetector(
              key: PortfolioAnalyticsPage.periodKey(period),
              onTap: () => onChanged(period),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 29,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active == period
                      ? _analyticsPrimary.withValues(alpha: .20)
                      : Colors.transparent,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Text(
                  period,
                  style: AppTextStyles.caption.copyWith(
                    color: active == period
                        ? _analyticsPrimary
                        : AppColors.text2,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.points});

  final List<WalletPortfolioPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      height: 214,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
      child: CustomPaint(
        painter: _PortfolioAreaPainter(points),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PortfolioAreaPainter extends CustomPainter {
  const _PortfolioAreaPainter(this.points);

  final List<WalletPortfolioPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final chart = Rect.fromLTWH(0, 8, size.width, size.height - 34);
    final minValue = points.map((p) => p.value).reduce(math.min);
    final maxValue = points.map((p) => p.value).reduce(math.max);
    final valueRange = math.max(1, maxValue - minValue);
    final mapped = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + (i / (points.length - 1)) * chart.width;
      final y =
          chart.bottom -
          ((points[i].value - minValue) / valueRange) * chart.height;
      mapped.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(mapped.first.dx, mapped.first.dy);
    for (var i = 1; i < mapped.length; i++) {
      final previous = mapped[i - 1];
      final current = mapped[i];
      final controlX = (previous.dx + current.dx) / 2;
      linePath.cubicTo(
        controlX,
        previous.dy,
        controlX,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final fillPath = Path.from(linePath)
      ..lineTo(mapped.last.dx, chart.bottom)
      ..lineTo(mapped.first.dx, chart.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _analyticsGreen.withValues(alpha: .28),
            _analyticsGreen.withValues(alpha: .00),
          ],
        ).createShader(chart),
    );
    canvas.drawPath(
      linePath,
      Paint()
        ..color = _analyticsGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final labels = [
      '18/4',
      '23/4',
      '27/4',
      '1/5',
      '4/5',
      '7/5',
      '10/5',
      '18/5',
    ];
    final labelPaint = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    for (var i = 0; i < labels.length; i++) {
      final x = i / (labels.length - 1) * chart.width;
      labelPaint.text = TextSpan(
        text: labels[i],
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 10,
          fontFamily: 'Roboto',
          height: 1,
        ),
      );
      labelPaint.layout();
      labelPaint.paint(
        canvas,
        Offset(x - labelPaint.width / 2, size.height - 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PortfolioAreaPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.metrics});

  final List<WalletPortfolioMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chỉ số hiệu suất',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 13,
              height: 1,
            ),
          ),
          const SizedBox(height: 17),
          for (final metric in metrics)
            _MetricRow(metric: metric, isLast: metric == metrics.last),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.metric, required this.isLast});

  final WalletPortfolioMetric metric;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              metric.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            metric.value,
            style: AppTextStyles.caption.copyWith(
              color: Color(metric.colorHex),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetsCard extends StatelessWidget {
  const _AssetsCard({required this.assets, required this.totalUsd});

  final List<WalletAsset> assets;
  final double totalUsd;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 17, 16, 13),
            child: Text(
              'Vị thế hiện tại',
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          for (var i = 0; i < assets.length; i++)
            _AssetRow(
              asset: assets[i],
              totalUsd: totalUsd,
              isLast: i == assets.length - 1,
            ),
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.asset,
    required this.totalUsd,
    required this.isLast,
  });

  final WalletAsset asset;
  final double totalUsd;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    final pct = totalUsd == 0 ? 0.0 : (asset.usdValue / totalUsd) * 100;
    final trendColor = asset.change24h >= 0 ? _analyticsGreen : _analyticsRed;

    return Container(
      constraints: const BoxConstraints(minHeight: 91),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 13),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _AssetAvatar(asset: asset, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        asset.symbol,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    Text(
                      _formatUsd(asset.usdValue),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        fontFeatures: AppTextStyles.tabularFigures,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: math.min(1, pct / 100),
                          minHeight: 4,
                          backgroundColor: AppColors.surface3,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${asset.change24h >= 0 ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: trendColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Text(
                  '${pct.toStringAsFixed(1)}% danh mục',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
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

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.asset, required this.color});

  final WalletAsset asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: .56)),
      ),
      alignment: Alignment.center,
      child: Text(
        asset.symbol.length <= 3 ? asset.symbol : asset.symbol.substring(0, 3),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: asset.symbol.length > 3 ? 8 : 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _PlaceholderAnalyticsView extends StatelessWidget {
  const _PlaceholderAnalyticsView({required this.view});

  final String view;

  @override
  Widget build(BuildContext context) {
    final title = view == 'allocation' ? 'Phân bổ danh mục' : 'Lãi/Lỗ';
    return _Card(
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding, this.height});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: _analyticsPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

final class _ViewItem {
  const _ViewItem(this.id, this.label, this.icon);

  final String id;
  final String label;
  final IconData icon;
}

String _formatUsd(double value, {bool symbol = true}) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs();
  final fixed = abs.toStringAsFixed(abs < 1 ? 4 : 2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  final prefix = symbol ? '\$' : '';
  return '$sign$prefix${buffer.toString()}.${parts[1]}';
}

String _formatCompactMoney(double value) {
  final fixed = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < fixed.length; i++) {
    if (i > 0 && (fixed.length - i) % 3 == 0) buffer.write(',');
    buffer.write(fixed[i]);
  }
  return buffer.toString();
}
