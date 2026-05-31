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
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_strategy_compare_selection.dart';
part '../widgets/bot_strategy_compare_metrics.dart';
part '../widgets/bot_strategy_compare_recommendations_common.dart';
part '../widgets/bot_strategy_compare_painters.dart';

const _compareBackground = AppColors.bg;
const _comparePanel = AppColors.surface;
const _comparePanel2 = AppColors.surface2;
const _comparePrimary = AppColors.primary;
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
