import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import '../widgets/trade_body_review_widgets.dart';

part '../widgets/bot_backtesting_widgets.dart';

const _backtestBackground = AppColors.bg;
const _backtestPanel = AppColors.surface;
const _backtestPrimary = AppColors.primary;

class BotBacktestingPage extends ConsumerStatefulWidget {
  const BotBacktestingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc125_bot_backtesting_content');
  static const capitalKey = Key('sc125_bot_backtesting_capital');
  static const runKey = Key('sc125_bot_backtesting_run');

  static Key strategyKey(String id) =>
      Key('sc125_bot_backtesting_strategy_$id');
  static Key pairKey(String pair) =>
      Key('sc125_bot_backtesting_pair_${pair.replaceAll('/', '_')}');
  static Key rangeKey(String id) => Key('sc125_bot_backtesting_range_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotBacktestingPage> createState() => _BotBacktestingPageState();
}

class _BotBacktestingPageState extends ConsumerState<BotBacktestingPage> {
  late final TextEditingController _capitalController;
  String _selectedStrategy = 'grid';
  String _selectedPair = 'BTC/USDT';
  String _selectedRange = '6m';

  @override
  void initState() {
    super.initState();
    _capitalController = TextEditingController(text: '1000');
  }

  @override
  void dispose() {
    _capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotBacktesting();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomGap =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 154
            : DeviceMetrics.nativeBottomChrome + 36) +
        MediaQuery.paddingOf(context).bottom;
    final range = snapshot.dateRanges.firstWhere(
      (item) => item.id == _selectedRange,
      orElse: () => snapshot.dateRanges.first,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-125 BotBacktestingPage',
      child: Material(
        color: _backtestBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Backtest Strategy',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotBacktestingPage.contentKey,
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                        child: VitPageContent(
                          padding: VitContentPadding.none,
                          customGap: 10,
                          fullBleed: true,
                          children: [
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Review backtest assumptions',
                              message:
                                  'Backtests are simulated. Confirm strategy, pair, date range, capital, and risk limits before running.',
                            ),
                            const _SectionLabel('Strategy Selection'),
                            _StrategyGrid(
                              strategies: snapshot.strategies,
                              selectedId: _selectedStrategy,
                              onChanged: (id) =>
                                  setState(() => _selectedStrategy = id),
                            ),
                            const _SectionLabel('Trading Pair'),
                            _PairGrid(
                              pairs: snapshot.pairs,
                              selectedPair: _selectedPair,
                              onChanged: (pair) =>
                                  setState(() => _selectedPair = pair),
                            ),
                            const _SectionLabel('Date Range'),
                            _DateRangeGrid(
                              ranges: snapshot.dateRanges,
                              selectedId: _selectedRange,
                              onChanged: (id) =>
                                  setState(() => _selectedRange = id),
                            ),
                            const _SectionLabel('Initial Capital'),
                            _CapitalInput(controller: _capitalController),
                            _BacktestPeriodCard(
                              strategyId: _selectedStrategy,
                              pair: _selectedPair,
                              range: range,
                              capital: _capitalController.text,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _RunFooter(onRun: () => _handleRun(snapshot)),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                        child: TradeBodyReviewSection(
                          title: 'Backtest body review',
                          message: 'Bot backtesting body reviewed',
                          detail:
                              'Strategy, pair, range, capital, simulated period, submitting, and result states stay visible.',
                          primary:
                              'Assumption review remains above strategy and capital controls.',
                          secondary:
                              'Selected strategy, pair, and range stay visible before running.',
                          tertiary:
                              'Backtest output is framed as simulation, not guaranteed performance.',
                        ),
                      ),
                      SizedBox(height: bottomGap),
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

  void _handleRun(TradeBotBacktestingSnapshot snapshot) {
    final capital =
        double.tryParse(_capitalController.text) ?? snapshot.defaultCapital;
    ref
        .read(tradeReadModelControllerProvider)
        .runBotBacktest(
          TradeBotBacktestRequest(
            strategyId: _selectedStrategy,
            pair: _selectedPair,
            dateRangeId: _selectedRange,
            initialCapital: capital,
          ),
        );
  }
}
