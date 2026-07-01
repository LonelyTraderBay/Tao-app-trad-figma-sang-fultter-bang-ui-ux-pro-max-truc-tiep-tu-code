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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/bot_history_page_sections.dart';
part '../widgets/bot_history_page_common.dart';

const _historyBackground = AppColors.bg;
const _historyPrimary = AppColors.primary;
const _historyGreen = AppColors.buy;
const _historyRed = AppColors.sell;
const double _historyFramedScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _historyNativeScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;

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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance = tradeScrollBottomInset(
        context,
        shellRenderMode: mode,
      );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-123 BotHistoryPage',
      child: Material(
        color: _historyBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Trade History',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
            actions: [
              VitHeaderActionItem(
                type: VitHeaderActionType.export,
                onPressed: _handleExport,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: BotHistoryPage.contentKey,
                  bottomInset: scrollEndClearance,
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _StatsCard(
                        totalTrades: filteredTrades.length,
                        totalPnL: totalPnL,
                        totalFees: totalFees,
                      ),
                      const _SearchBox(),
                      _FilterTabs(
                        filter: _filter,
                        trades: snapshot.trades,
                        onChanged: (filter) => setState(() => _filter = filter),
                      ),
                      VitSectionHeader(
                        title: 'Trades (${filteredTrades.length})',
                        variant: VitSectionHeaderVariant.accentBar,
                        accentColor: _historyPrimary,
                        density: VitDensity.compact,
                      ),
                      if (filteredTrades.isEmpty)
                        const _EmptyHistory()
                      else
                        for (final trade in filteredTrades)
                          _TradeCard(trade: trade),
                      _ExportNote(onTap: _handleExport),
                      const VitCard(
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
