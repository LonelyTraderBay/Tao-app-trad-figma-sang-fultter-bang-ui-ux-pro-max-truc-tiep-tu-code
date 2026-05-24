import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/predictions_repository.dart';

const _predictionPrimary = AppColors.primary;
const _purple = Color(0xFF8B5CF6);

enum _AnalyzerTab { overview, performance, risk }

class PredictionPortfolioAnalyzerPage extends ConsumerStatefulWidget {
  const PredictionPortfolioAnalyzerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc038_portfolio_analyzer_content');
  static const overviewTabKey = Key('sc038_tab_overview');
  static const performanceTabKey = Key('sc038_tab_performance');
  static const riskTabKey = Key('sc038_tab_risk');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionPortfolioAnalyzerPage> createState() =>
      _PredictionPortfolioAnalyzerPageState();
}

class _PredictionPortfolioAnalyzerPageState
    extends ConsumerState<PredictionPortfolioAnalyzerPage> {
  _AnalyzerTab _activeTab = _AnalyzerTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getPortfolioAnalyzer();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-038 PredictionPortfolioAnalyzerPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Portfolio Analyzer',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            _AnalyzerTabBar(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionPortfolioAnalyzerPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: switch (_activeTab) {
                      _AnalyzerTab.overview => [
                        _PortfolioSummaryCard(snapshot: snapshot),
                        _StatsGrid(snapshot: snapshot),
                        _CategoryCard(snapshot: snapshot),
                      ],
                      _AnalyzerTab.performance => [
                        _PerformanceChartCard(snapshot: snapshot),
                        _TradeStatsSection(snapshot: snapshot),
                        _AttributionSection(snapshot: snapshot),
                      ],
                      _AnalyzerTab.risk => [
                        _RiskMetricsSection(snapshot: snapshot),
                        _CategoryRiskCard(snapshot: snapshot),
                        _DiversificationCard(snapshot: snapshot),
                        const _RiskWarning(),
                      ],
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyzerTabBar extends StatelessWidget {
  const _AnalyzerTabBar({required this.activeTab, required this.onChanged});

  final _AnalyzerTab activeTab;
  final ValueChanged<_AnalyzerTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionPortfolioAnalyzerPage.overviewTabKey,
        tab: _AnalyzerTab.overview,
        label: 'Tong quan',
      ),
      (
        key: PredictionPortfolioAnalyzerPage.performanceTabKey,
        tab: _AnalyzerTab.performance,
        label: 'Hieu suat',
      ),
      (
        key: PredictionPortfolioAnalyzerPage.riskTabKey,
        tab: _AnalyzerTab.risk,
        label: 'Rui ro',
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
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

class _PortfolioSummaryCard extends StatelessWidget {
  const _PortfolioSummaryCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pnlColor = snapshot.totalPnl >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 11),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatMoney(snapshot.totalPortfolioValue),
                style: AppTextStyles.heroNumber.copyWith(
                  fontSize: 29,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    Icon(
                      snapshot.totalPnl >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: pnlColor,
                      size: 15,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${snapshot.totalPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.totalPnl)}',
                      style: AppTextStyles.caption.copyWith(
                        color: pnlColor,
                        fontWeight: AppTextStyles.bold,
                        fontSize: 16,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Invested',
                  value: _formatMoney(snapshot.totalInvested),
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Return %',
                  value:
                      '${snapshot.totalPnlPercent >= 0 ? '+' : ''}${snapshot.totalPnlPercent.toStringAsFixed(2)}%',
                  valueColor: pnlColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Realized P/L',
                  value:
                      '${snapshot.realizedPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.realizedPnl)}',
                  valueColor: snapshot.realizedPnl >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  small: true,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Unrealized P/L',
                  value:
                      '${snapshot.unrealizedPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.unrealizedPnl)}',
                  valueColor: snapshot.unrealizedPnl >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        icon: Icons.show_chart_rounded,
        label: 'Open Positions',
        value: '${snapshot.openPositions.length}',
        color: _predictionPrimary,
      ),
      (
        icon: Icons.adjust_rounded,
        label: 'Win Rate',
        value: '${snapshot.winRate.toStringAsFixed(1)}%',
        color: AppColors.buy,
      ),
      (
        icon: Icons.workspace_premium_outlined,
        label: 'Total Trades',
        value: '${snapshot.totalTrades}',
        color: _purple,
      ),
      (
        icon: Icons.bar_chart_rounded,
        label: 'Avg Trade',
        value: _formatMoneyCompact(snapshot.averageTrade),
        color: AppColors.warn,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 84,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(stat.icon, color: stat.color, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stat.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                stat.value,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 20,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final categories = snapshot.categories;
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio by Category',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              height: 190,
              width: 240,
              child: CustomPaint(
                painter: _DonutChartPainter(categories: categories),
              ),
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 42,
              crossAxisSpacing: 16,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryLegendItem(
                category: category,
                color: _categoryColor(index),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PerformanceChartCard extends StatelessWidget {
  const _PerformanceChartCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'P/L Over Time',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _PnlLinePainter(points: snapshot.pnlHistory),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeStatsSection extends StatelessWidget {
  const _TradeStatsSection({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Trade Statistics',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Win Rate',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${snapshot.winRate.toStringAsFixed(1)}%',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Winning',
                      value: '${snapshot.winningTrades}',
                      valueColor: AppColors.buy,
                    ),
                  ),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Losing',
                      value: '${snapshot.losingTrades}',
                      valueColor: AppColors.sell,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: snapshot.winRate / 100,
                  color: AppColors.buy,
                  backgroundColor: AppColors.bg,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttributionSection extends StatelessWidget {
  const _AttributionSection({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final closed = snapshot.closedPositions.toList()
      ..sort((a, b) => b.pnl.compareTo(a.pnl));
    return VitPageSection(
      label: 'Performance Attribution',
      accentColor: _predictionPrimary,
      children: [
        for (final position in closed)
          VitCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position.eventName,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        position.category,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${position.pnl >= 0 ? '+' : ''}${_formatMoney(position.pnl)}',
                      style: AppTextStyles.caption.copyWith(
                        color: position.pnl >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      position.resolvedAtLabel ?? '',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _RiskMetricsSection extends StatelessWidget {
  const _RiskMetricsSection({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Risk Exposure',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              _RiskMetricRow(
                icon: Icons.shield_outlined,
                label: 'Max Drawdown',
                value: '-12.4%',
                valueColor: AppColors.sell,
              ),
              _RiskMetricRow(
                icon: Icons.monitor_heart_outlined,
                label: 'Portfolio Volatility',
                value: '18.2%',
              ),
              _RiskMetricRow(
                icon: Icons.donut_small_rounded,
                label: 'Concentration (Top 3)',
                value: '62.3%',
              ),
              _RiskMetricRow(
                icon: Icons.percent_rounded,
                label: 'Sharpe Ratio',
                value: '1.42',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryRiskCard extends StatelessWidget {
  const _CategoryRiskCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk by Category',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final category in snapshot.categories)
                  Expanded(child: _CategoryRiskBar(category: category)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiversificationCard extends StatelessWidget {
  const _DiversificationCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.buy, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diversification Score',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Portfolio da phan tan hop ly qua ${snapshot.categories.length} categories',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '7.2',
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.buy,
                  fontSize: 25,
                  height: 1,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '/ 10',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Phan tich rui ro dua tren du lieu lich su. Hieu suat qua khu khong dam bao ket qua tuong lai. Luon quan ly rui ro va phan tan dau tu.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.small = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: (small ? AppTextStyles.caption : AppTextStyles.baseMedium)
              .copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
        ),
      ],
    );
  }
}

class _CategoryLegendItem extends StatelessWidget {
  const _CategoryLegendItem({required this.category, required this.color});

  final PredictionAnalyzerCategoryDraft category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 11,
                ),
              ),
              Text(
                '${category.pnl >= 0 ? '+' : ''}${_formatMoney(category.pnl)}',
                style: AppTextStyles.micro.copyWith(
                  color: category.pnl >= 0 ? AppColors.buy : AppColors.sell,
                  fontSize: 10,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RiskMetricRow extends StatelessWidget {
  const _RiskMetricRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.text3, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRiskBar extends StatelessWidget {
  const _CategoryRiskBar({required this.category});

  final PredictionAnalyzerCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    final height = 30 + category.invested.clamp(0, 95);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height.toDouble(),
            decoration: BoxDecoration(
              color: _predictionPrimary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter({required this.categories});

  final List<PredictionAnalyzerCategoryDraft> categories;

  @override
  void paint(Canvas canvas, Size size) {
    final total = categories.fold<double>(
      0,
      (sum, category) => sum + category.invested,
    );
    if (total <= 0) return;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: math.min(size.width, size.height) / 2 - 16,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30
      ..strokeCap = StrokeCap.butt;
    var start = 0.0;
    for (var i = 0; i < categories.length; i += 1) {
      final sweep = -(categories[i].invested / total) * math.pi * 2;
      paint.color = _categoryColor(i);
      canvas.drawArc(rect, start, sweep + .025, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.categories != categories;
  }
}

class _PnlLinePainter extends CustomPainter {
  const _PnlLinePainter({required this.points});

  final List<PredictionAnalyzerPnlPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = AppColors.buy
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    final dotPaint = Paint()..color = AppColors.buy;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    const left = 30.0;
    const bottom = 28.0;
    final chart = Rect.fromLTWH(
      left,
      4,
      size.width - left - 6,
      size.height - bottom - 8,
    );
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    final values = points.map((point) => point.value).toList();
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(1, maxValue - minValue);
    final path = Path();
    for (var i = 0; i < points.length; i += 1) {
      final x = chart.left + (chart.width / (points.length - 1)) * i;
      final y =
          chart.bottom - ((points[i].value - minValue) / range) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3.6, dotPaint);
      textPainter.text = TextSpan(
        text: points[i].date,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chart.bottom + 8),
      );
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _PnlLinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

Color _categoryColor(int index) {
  return const [
    _predictionPrimary,
    AppColors.buy,
    AppColors.warn,
    _purple,
    AppColors.sell,
  ][index % 5];
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String _formatMoneyCompact(double value) => '\$${value.round()}';
