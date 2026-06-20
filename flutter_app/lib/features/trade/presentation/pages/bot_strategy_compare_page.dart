import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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

part '../widgets/bot_strategy_compare_selection.dart';
part '../widgets/bot_strategy_compare_metrics.dart';
part '../widgets/bot_strategy_compare_recommendations_common.dart';
part '../widgets/bot_strategy_compare_painters.dart';

const _compareBackground = AppColors.bg;
const _compareGreen = AppColors.buy;
const _compareAxis = AppColors.chartAxisStrong;

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
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotStrategyCompare();
    final selectedStrategies = snapshot.strategies
        .where((strategy) => _selected.contains(strategy.id))
        .toList();
    final best = selectedStrategies.reduce(
      (best, current) => current.metrics.sharpeRatio > best.metrics.sharpeRatio
          ? current
          : best,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final chromeInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        chromeInset +
        (mode.usesVisualQaFrame
            ? AppSpacing.x6 + AppSpacing.x4
            : AppSpacing.x5 + AppSpacing.x2) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-126 BotStrategyComparePage',
      child: Material(
        color: _compareBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Strategy Compare',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotStrategyComparePage.contentKey,
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.contentPad,
                    top: AppSpacing.x2,
                    right: AppSpacing.contentPad,
                    bottom: bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      VitPageSection(
                        label: 'Select Strategies (2-4)',
                        density: VitDensity.compact,
                        children: [
                          _StrategySelectionGrid(
                            strategies: snapshot.strategies,
                            selectedIds: _selected,
                            onToggle: _toggleStrategy,
                          ),
                        ],
                      ),
                      _BestStrategyCard(strategy: best),
                      VitPageSection(
                        label: 'Equity Curves Comparison',
                        density: VitDensity.compact,
                        children: [
                          _EquityChartCard(
                            points: snapshot.equityPoints,
                            strategies: selectedStrategies,
                          ),
                        ],
                      ),
                      VitPageSection(
                        label: 'Performance Radar',
                        density: VitDensity.compact,
                        children: [_RadarCard(strategies: selectedStrategies)],
                      ),
                      VitPageSection(
                        label: 'Detailed Metrics',
                        density: VitDensity.compact,
                        children: [
                          _MetricsTable(strategies: selectedStrategies),
                        ],
                      ),
                      VitPageSection(
                        label: 'Which Strategy to Choose?',
                        density: VitDensity.compact,
                        children: [
                          for (final recommendation in snapshot.recommendations)
                            _RecommendationCard(
                              recommendation: recommendation,
                              strategy: snapshot.strategies.firstWhere(
                                (item) => item.id == recommendation.strategyId,
                              ),
                            ),
                        ],
                      ),
                      _AnalysisPeriodCard(text: snapshot.analysisPeriod),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Strategy comparison review',
                        message:
                            'Selected strategies, performance spread, radar metrics, recommendation rationale and next step are reviewed before allocation changes.',
                        contractId: 'bot-strategy-compare-review',
                        density: VitDensity.compact,
                      ),
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
