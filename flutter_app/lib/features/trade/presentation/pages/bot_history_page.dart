import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/bot_history_page_sections.dart';
part '../widgets/bot_history_page_common.dart';

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
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotHistory();
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
      semanticLabel: 'SC-123 BotHistoryPage',
      contentKey: BotHistoryPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeBots),
      headerActions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.export,
          onPressed: _handleExport,
        ),
      ],
      children: [
        VitTradeSection(
          title: 'Summary',
          child: _StatsCard(
            totalTrades: filteredTrades.length,
            totalPnL: totalPnL,
            totalFees: totalFees,
          ),
        ),
        VitTradeSection(title: 'Search', child: const _SearchBox()),
        VitTradeSection(
          title: 'Filter',
          child: _FilterTabs(
            filter: _filter,
            trades: snapshot.trades,
            onChanged: (filter) => setState(() => _filter = filter),
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
        VitTradeSection(
          title: 'Đánh giá rủi ro',
          child: const VitCard(
            variant: VitCardVariant.inner,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'History export review',
              message:
                  'Trade filters, realized PnL, fee totals, export scope and receipt next step are reviewed before records are generated.',
              contractId: 'bot-history-export-review',
              density: VitDensity.compact,
            ),
          ),
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
        .read(tradeReadModelControllerProvider)
        .createBotHistoryExport(
          const TradeBotHistoryExportRequest(format: 'csv'),
        );
  }
}
