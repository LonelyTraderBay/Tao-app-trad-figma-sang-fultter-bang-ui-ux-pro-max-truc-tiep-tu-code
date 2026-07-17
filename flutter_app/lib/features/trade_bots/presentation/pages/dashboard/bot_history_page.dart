import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';

part '../../widgets/dashboard/bot_history_page_sections.dart';
part '../../widgets/dashboard/bot_history_page_common.dart';

const _historyGreen = AppColors.buy;
const _historyRed = AppColors.sell;

enum _HistoryFilter { all, buy, sell }

class BotHistoryPage extends ConsumerStatefulWidget {
  const BotHistoryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc123_bot_history_content');
  static const exportHeaderKey = Key('sc123_bot_history_export_header');
  static const exportAllKey = Key('sc123_bot_history_export_all');

  static Key filterKey(String id) => Key('sc123_bot_history_filter_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotHistoryPage> createState() => _BotHistoryPageState();
}

class _BotHistoryPageState extends ConsumerState<BotHistoryPage> {
  _HistoryFilter _filter = _HistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradingBotsRepositoryProvider).getBotHistory();
    final filteredTrades = _filtered(snapshot.trades);
    final totalPnL = filteredTrades.fold<double>(
      0,
      (sum, trade) => sum + trade.pnl,
    );
    final totalFees = filteredTrades.fold<double>(
      0,
      (sum, trade) => sum + trade.fee,
    );
    return VitTradeHubScaffold(
      title: 'Trade History',
      subtitle: 'Lịch sử giao dịch và lãi/lỗ bot',
      semanticLabel: 'Lịch sử giao dịch của bot',
      semanticIdentifier: 'SC-123',
      contentKey: BotHistoryPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      headerActions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.export,
          onPressed: _handleExport,
        ),
      ],
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Giao dịch',
          primaryValue: '${filteredTrades.length}',
          secondaryLabel: 'Lãi/lỗ',
          secondaryValue:
              '${totalPnL >= 0 ? '+' : ''}\$${totalPnL.toStringAsFixed(2)}',
          secondaryColor: totalPnL >= 0 ? _historyGreen : _historyRed,
        ),
        VitTradeSection(
          title: 'Summary',
          child: _StatsCard(
            totalTrades: filteredTrades.length,
            totalPnL: totalPnL,
            totalFees: totalFees,
          ),
        ),
        VitTradeSection(
          title: 'Search',
          child: const VitSearchBar(
            enabled: false,
            placeholder: 'Search by bot name or pair...',
          ),
        ),
        VitTradeSection(
          title: 'Filter',
          child: VitTabBar(
            tabs: [
              VitTabItem(
                key: _HistoryFilter.all.name,
                label: 'All (${snapshot.trades.length})',
                widgetKey: BotHistoryPage.filterKey(_HistoryFilter.all.name),
              ),
              VitTabItem(
                key: _HistoryFilter.buy.name,
                label:
                    'Buy (${snapshot.trades.where((t) => t.side == TradeBotHistorySide.buy).length})',
                widgetKey: BotHistoryPage.filterKey(_HistoryFilter.buy.name),
              ),
              VitTabItem(
                key: _HistoryFilter.sell.name,
                label:
                    'Sell (${snapshot.trades.where((t) => t.side == TradeBotHistorySide.sell).length})',
                widgetKey: BotHistoryPage.filterKey(_HistoryFilter.sell.name),
              ),
            ],
            activeKey: _filter.name,
            onChanged: (key) => setState(
              () => _filter = _HistoryFilter.values.firstWhere(
                (filter) => filter.name == key,
              ),
            ),
            variant: VitTabBarVariant.segment,
          ),
        ),
        VitTradeSection(
          title: 'Trades (${filteredTrades.length})',
          child: filteredTrades.isEmpty
              ? const _EmptyHistory()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final trade in filteredTrades)
                      _TradeCard(trade: trade),
                  ],
                ),
        ),
        VitTradeSection(
          title: 'Export',
          child: _ExportNote(onTap: _handleExport),
        ),
        const VitBotRiskReviewFooter(
          title: 'History export review',
          message:
              'Trade filters, realized PnL, fee totals, export scope and receipt next step are reviewed before records are generated.',
          contractId: 'bot-history-export-review',
        ),
      ],
    );
  }

  List<TradeBotHistoryTrade> _filtered(List<TradeBotHistoryTrade> trades) {
    return switch (_filter) {
      _HistoryFilter.buy =>
        trades.where((trade) => trade.side == TradeBotHistorySide.buy).toList(),
      _HistoryFilter.sell =>
        trades
            .where((trade) => trade.side == TradeBotHistorySide.sell)
            .toList(),
      _HistoryFilter.all => trades,
    };
  }

  void _handleExport() {
    ref
        .read(tradingBotsRepositoryProvider)
        .createBotHistoryExport(
          const TradeBotHistoryExportRequest(format: 'csv'),
        );
  }
}
