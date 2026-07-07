import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/bot_strategy_compare_selection.dart';
part '../widgets/bot_strategy_compare_metrics.dart';
part '../widgets/bot_strategy_compare_recommendations_common.dart';
part '../widgets/bot_strategy_compare_painters.dart';

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
    return VitTradeHubScaffold(
      title: 'Strategy Compare',
      subtitle: 'So sánh hiệu suất các chiến lược bot',
      semanticLabel: 'SC-126 BotStrategyComparePage',
      contentKey: BotStrategyComparePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => context.go(AppRoutePaths.tradeBots),
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Đã chọn',
          primaryValue: '${selectedStrategies.length}',
          secondaryLabel: 'Sharpe tốt nhất',
          secondaryValue: best.metrics.sharpeRatio.toStringAsFixed(2),
          secondaryColor: _compareGreen,
        ),
        VitTradeSection(
          title: 'Select Strategies (2-4)',
          child: _StrategySelectionGrid(
            strategies: snapshot.strategies,
            selectedIds: _selected,
            onToggle: _toggleStrategy,
          ),
        ),
        VitTradeSection(
          title: 'Best strategy',
          child: _BestStrategyCard(strategy: best),
        ),
        VitTradeSection(
          title: 'Equity Curves Comparison',
          child: _EquityChartCard(
            points: snapshot.equityPoints,
            strategies: selectedStrategies,
          ),
        ),
        VitTradeSection(
          title: 'Performance Radar',
          child: _RadarCard(strategies: selectedStrategies),
        ),
        VitTradeSection(
          title: 'Detailed Metrics',
          child: _MetricsTable(strategies: selectedStrategies),
        ),
        VitTradeSection(
          title: 'Which Strategy to Choose?',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
        ),
        VitTradeSection(
          title: 'Analysis period',
          child: _AnalysisPeriodCard(text: snapshot.analysisPeriod),
        ),
        const VitBotRiskReviewFooter(
          title: 'Strategy comparison review',
          message:
              'Selected strategies, performance spread, radar metrics, recommendation rationale and next step are reviewed before allocation changes.',
          contractId: 'bot-strategy-compare-review',
        ),
      ],
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
