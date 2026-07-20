import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_hub_hero.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../widgets/hub/trading_bots_page_my_bots_tab.dart';
part '../../widgets/hub/trading_bots_page_bot_card.dart';
part '../../widgets/hub/trading_bots_page_create_bot_sheet.dart';
part '../../widgets/hub/trading_bots_page_formatters.dart';

enum _TradingBotsTab { myBots, strategies }

class TradingBotsPage extends ConsumerStatefulWidget {
  const TradingBotsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc059_trading_bots_scroll_content');
  static const backKey = Key('sc059_back');
  static const addBotKey = Key('sc059_add_bot');
  static const sheetAgreeKey = Key('sc059_sheet_agree');
  static const sheetCreateKey = Key('sc059_sheet_create');

  static Key tabKey(String id) => Key('sc059_tab_$id');
  static Key botToggleKey(String botId) => Key('sc059_bot_toggle_$botId');
  static Key botSettingsKey(String botId) => Key('sc059_bot_settings_$botId');
  static Key botDeleteKey(String botId) => Key('sc059_bot_delete_$botId');
  static Key strategyCreateKey(String strategyId) =>
      Key('sc059_strategy_create_$strategyId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradingBotsPage> createState() => _TradingBotsPageState();
}

class _TradingBotsPageState extends ConsumerState<TradingBotsPage> {
  _TradingBotsTab _tab = _TradingBotsTab.myBots;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradingBotsSnapshotProvider);

    return VitTradeHubScaffold(
      title: 'Trading Bots',
      subtitle: 'Tự động hóa giao dịch theo chiến lược',
      semanticLabel: 'Bot giao dịch tự động',
      semanticIdentifier: 'SC-059',
      contentKey: TradingBotsPage.contentKey,
      backKey: TradingBotsPage.backKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được danh sách bot',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradingBotsSnapshotProvider),
          ),
        ],
        data: (_) {
          final snapshot = ref.watch(tradeBotsControllerProvider).snapshot;
          final bots = snapshot.activeBots;
          final runningBots = bots
              .where((bot) => bot.status == TradeBotStatus.running)
              .length;
          final totalProfit = bots.fold(0.0, (sum, bot) => sum + bot.profit);
          final profitColor = totalProfit >= 0 ? AppColors.buy : AppColors.sell;
          return [
            VitTradeHubHero(
              primaryLabel: 'Đang chạy',
              primaryValue: '$runningBots',
              primaryColor: AppColors.buy,
              secondaryLabel: 'Lãi/lỗ',
              secondaryValue: _formatSignedMoney(totalProfit),
              secondaryColor: profitColor,
            ),
            VitCtaButton(
              key: TradingBotsPage.addBotKey,
              onPressed: () =>
                  setState(() => _tab = _TradingBotsTab.strategies),
              height: AppSpacing.inputHeight,
              leading: const Icon(Icons.add_rounded),
              child: const Text('Khám phá chiến lược'),
            ),
            _BotsTabs(
              active: _tab,
              botCount: bots.length,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            if (_tab == _TradingBotsTab.myBots)
              _MyBotsTab(
                bots: bots,
                onToggle: _toggleBot,
                onDelete: _confirmDeleteBot,
                onAdd: () => setState(() => _tab = _TradingBotsTab.strategies),
              )
            else
              _StrategiesTab(
                strategies: snapshot.strategies,
                onCreate: _openCreateSheet,
              ),
            VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.tool,
              title: 'Rủi ro giao dịch tự động',
              message:
                  'Bot không đảm bảo lợi nhuận. Hiệu suất quá khứ không đại diện kết quả tương lai.',
              contractId: snapshot.highRiskContractId,
            ),
          ];
        },
      ),
    );
  }

  void _toggleBot(String botId) {
    unawaited(
      ref
          .read(tradeBotsControllerProvider.notifier)
          .submitAction(botId: botId, action: 'toggle'),
    );
  }

  void _deleteBot(String botId) {
    unawaited(
      ref
          .read(tradeBotsControllerProvider.notifier)
          .submitAction(botId: botId, action: 'delete'),
    );
  }

  Future<void> _confirmDeleteBot(String botId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa bot?'),
        content: const Text('Bot sẽ dừng hoạt động và bị xóa khỏi danh sách.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) _deleteBot(botId);
  }

  Future<void> _openCreateSheet(TradeBotStrategy strategy) async {
    final created = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CreateBotSheet(strategy: strategy),
    );
    if (created != true || !mounted) return;
    await ref
        .read(tradeBotsControllerProvider.notifier)
        .createBot(
          TradeBotCreateRequest(
            strategyId: strategy.id,
            params: {
              for (final param in strategy.params)
                param.key: param.defaultValue,
            },
          ),
        );
    if (!mounted) return;
    setState(() => _tab = _TradingBotsTab.myBots);
    await showVitNoticeSheet(
      context: context,
      title: 'Bot đã được khởi chạy!',
      message: 'Bot đang hoạt động và giao dịch tự động',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}
