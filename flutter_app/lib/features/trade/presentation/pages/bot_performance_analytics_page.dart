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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_performance_charts_strategy.dart';
part '../widgets/bot_performance_metrics_summary.dart';
part '../widgets/bot_performance_painters.dart';

const _analyticsBackground = AppColors.bg;
const _analyticsPanel = AppColors.surface;
const _analyticsPanel2 = AppColors.surface2;
const _analyticsPrimary = AppColors.primary;
const _analyticsGreen = AppColors.buy;
const _analyticsAmber = AppColors.caution;
const _analyticsRed = AppColors.sell;
const _chartAxis = AppColors.chartAxisStrong;
const _chartTrack = AppColors.chartTrack;

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
        .watch(tradeReadModelControllerProvider)
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
        color: _analyticsBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Performance Analytics',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotPerformanceAnalyticsPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 0,
                    children: [
                      _KeyMetricsCard(metrics: snapshot.metrics),
                      const SizedBox(height: 12),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Bot analytics review',
                              message:
                                  'PnL, win/loss distribution, strategy mix, duration and risk rating are reviewed before bot changes.',
                              contractId: 'bot-performance-analytics-review',
                            ),
                            SizedBox(height: 8),
                            VitStatusPill(
                              label: 'Risk-aware analytics',
                              status: VitStatusPillStatus.info,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _TimeframeTabs(
                        active: _timeframe,
                        onChanged: (timeframe) =>
                            setState(() => _timeframe = timeframe),
                      ),
                      const SizedBox(height: 18),
                      VitPageSection(
                        customGap: 0,
                        children: [
                          const _SectionLabel('Cumulative PnL'),
                          const SizedBox(height: 12),
                          _PnlChartCard(points: snapshot.pnlPoints),
                          const SizedBox(height: 18),
                          const _SectionLabel('Win/Loss Distribution'),
                          const SizedBox(height: 12),
                          _WinLossChartCard(points: snapshot.winLossPoints),
                        ],
                      ),
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
                      _DurationCard(
                        distribution: snapshot.durationDistribution,
                      ),
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
      ),
    );
  }
}
