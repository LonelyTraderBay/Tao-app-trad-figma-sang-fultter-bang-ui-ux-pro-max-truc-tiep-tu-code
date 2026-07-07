import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/bot_performance_charts_strategy.dart';
part '../widgets/bot_performance_metrics_summary.dart';
part '../widgets/bot_performance_painters.dart';

const _analyticsPrimary = AppColors.primary;
const _analyticsGreen = AppColors.buy;
const _analyticsAmber = AppColors.caution;
const _analyticsRed = AppColors.sell;
const _chartAxis = AppColors.chartAxisStrong;
const _chartTrack = AppColors.chartTrack;
const double _analyticsSpace = AppSpacing.x2;
const double _analyticsTinySpace = AppSpacing.x1;
const double _analyticsChartExtent = 150;
const double _analyticsDistributionExtent = 130;
const double _analyticsDonutExtent = 118;
const double _analyticsProgressExtent = 5;
const double _analyticsMetricMinExtent = 44;
const double _analyticsPainterLineHeight = 1;

enum _AnalyticsTimeframe { sevenDays, thirtyDays, allTime }

class BotPerformanceAnalyticsPage extends ConsumerStatefulWidget {
  const BotPerformanceAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc124_bot_performance_content');
  static const pnlChartKey = Key('sc124_bot_performance_pnl_chart');

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
        .watch(tradeReadModelControllerProvider)
        .getBotPerformanceAnalytics();
    return VitTradeHubScaffold(
      title: 'Performance Analytics',
      subtitle: 'Phân tích hiệu suất bot theo thời gian',
      semanticLabel: 'SC-124 BotPerformanceAnalyticsPage',
      contentKey: BotPerformanceAnalyticsPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => context.go(AppRoutePaths.tradeBots),
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Lãi/lỗ',
          primaryValue:
              '${snapshot.metrics.totalPnl >= 0 ? '+' : ''}\$${snapshot.metrics.totalPnl.toStringAsFixed(0)}',
          primaryColor: snapshot.metrics.totalPnl >= 0
              ? _analyticsGreen
              : _analyticsRed,
          secondaryLabel: 'Tỷ lệ thắng',
          secondaryValue: '${snapshot.metrics.winRate.toStringAsFixed(1)}%',
          secondaryColor: _analyticsGreen,
        ),
        VitTradeSection(
          title: 'Key metrics',
          child: _KeyMetricsCard(metrics: snapshot.metrics),
        ),
        VitTradeSection(
          title: 'Timeframe',
          child: _TimeframeTabs(
            active: _timeframe,
            onChanged: (timeframe) => setState(() => _timeframe = timeframe),
          ),
        ),
        VitTradeSection(
          title: 'Cumulative PnL',
          child: _PnlChartCard(points: snapshot.pnlPoints),
        ),
        VitTradeSection(
          title: 'Win/Loss Distribution',
          child: _WinLossChartCard(points: snapshot.winLossPoints),
        ),
        VitTradeSection(
          title: 'Performance by Strategy',
          child: _StrategyPerformanceCard(
            strategies: snapshot.strategyPerformance,
          ),
        ),
        VitTradeSection(
          title: 'Advanced Metrics',
          child: _AdvancedMetricsGrid(metrics: snapshot.metrics),
        ),
        VitTradeSection(
          title: 'Trade Duration Distribution',
          child: _DurationCard(distribution: snapshot.durationDistribution),
        ),
        VitTradeSection(
          title: 'Summary',
          child: _PerformanceSummaryCard(metrics: snapshot.metrics),
        ),
        VitTradeSection(title: 'Rating', child: const _RatingCard()),
        const VitBotRiskReviewFooter(
          title: 'Bot analytics review',
          message:
              'PnL, win/loss distribution, strategy mix, duration and risk rating are reviewed before bot changes.',
          contractId: 'bot-performance-analytics-review',
          statusLabel: 'Risk-aware analytics',
        ),
      ],
    );
  }
}
