import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../widgets/backtest/bot_backtesting_widgets.dart';

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
    final snapshotAsync = ref.watch(tradeBotBacktestingProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    const runFooterHeight = AppSpacing.inputHeight + AppSpacing.x4;
    final scrollEndClearance =
        tradeScrollBottomInset(context, shellRenderMode: mode) +
        runFooterHeight;

    return VitTradeDetailScaffold(
      title: 'Backtest Strategy',
      subtitle: 'Mô phỏng chiến lược trên dữ liệu lịch sử',
      semanticLabel: 'Kiểm thử chiến lược bot trên dữ liệu lịch sử',
      semanticIdentifier: 'SC-125',
      contentKey: BotBacktestingPage.contentKey,
      shellRenderMode: mode,
      bottomInset: scrollEndClearance,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu backtest',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotBacktestingProvider),
          ),
        ],
        data: (snapshot) {
          final range = snapshot.dateRanges.firstWhere(
            (item) => item.id == _selectedRange,
            orElse: () => snapshot.dateRanges.first,
          );
          return [
            VitBotSubpageHero(
              primaryLabel: 'Chiến lược',
              primaryValue: '${snapshot.strategies.length}',
              secondaryLabel: 'Cặp giao dịch',
              secondaryValue: '${snapshot.pairs.length}',
            ),
            VitTradeSection(
              title: 'Strategy Selection',
              child: _StrategyGrid(
                strategies: snapshot.strategies,
                selectedId: _selectedStrategy,
                onChanged: (id) => setState(() => _selectedStrategy = id),
              ),
            ),
            VitTradeSection(
              title: 'Trading Pair',
              child: _PairGrid(
                pairs: snapshot.pairs,
                selectedPair: _selectedPair,
                onChanged: (pair) => setState(() => _selectedPair = pair),
              ),
            ),
            VitTradeSection(
              title: 'Date Range',
              child: _DateRangeGrid(
                ranges: snapshot.dateRanges,
                selectedId: _selectedRange,
                onChanged: (id) => setState(() => _selectedRange = id),
              ),
            ),
            VitTradeSection(
              title: 'Initial Capital',
              child: _CapitalInput(controller: _capitalController),
            ),
            VitTradeSection(
              title: 'Backtest period',
              child: _BacktestPeriodCard(
                strategyId: _selectedStrategy,
                pair: _selectedPair,
                range: range,
                capital: _capitalController.text,
              ),
            ),
            _RunFooter(onRun: () => _handleRun(snapshot)),
            const TradeBodyReviewSection(
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
            const VitBotRiskReviewFooter(
              title: 'Review backtest assumptions',
              message:
                  'Backtests are simulated. Confirm strategy, pair, date range, capital, and risk limits before running.',
            ),
          ];
        },
      ),
    );
  }

  void _handleRun(TradeBotBacktestingSnapshot snapshot) {
    final capital =
        double.tryParse(_capitalController.text) ?? snapshot.defaultCapital;
    unawaited(
      ref
          .read(tradeBotAnalyticsRepositoryProvider)
          .runBotBacktest(
            TradeBotBacktestRequest(
              strategyId: _selectedStrategy,
              pair: _selectedPair,
              dateRangeId: _selectedRange,
              initialCapital: capital,
            ),
          ),
    );
  }
}
