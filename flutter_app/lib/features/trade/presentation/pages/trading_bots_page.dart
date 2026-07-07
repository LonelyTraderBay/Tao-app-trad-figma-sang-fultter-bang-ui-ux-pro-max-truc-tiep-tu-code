import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part 'trading_bots_page_part_01.dart';
part 'trading_bots_page_part_02.dart';
part 'trading_bots_page_part_03.dart';
part 'trading_bots_page_part_04.dart';

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
  late List<TradeBot> _bots;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _bots = List.of(
      ref.read(tradeBotsControllerProvider).state.snapshot.activeBots,
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeBotsControllerProvider).state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    return Stack(
      children: [
        VitTradeHubScaffold(
          title: 'Trading Bots',
          subtitle: 'Tự động hóa giao dịch theo chiến lược',
          semanticLabel: 'SC-059 TradingBotsPage',
          contentKey: TradingBotsPage.contentKey,
          backKey: TradingBotsPage.backKey,
          shellRenderMode: widget.shellRenderMode,
          onBack: () => goBackOrFallback(
            context,
            fallbackPath: AppRoutePaths.trade,
            mode: BackNavigationMode.historyThenFallback,
          ),
          children: [
            _BotsHero(bots: _bots),
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
              botCount: _bots.length,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            if (_tab == _TradingBotsTab.myBots)
              _MyBotsTab(
                bots: _bots,
                onToggle: _toggleBot,
                onDelete: _confirmDeleteBot,
                onAdd: () => setState(() => _tab = _TradingBotsTab.strategies),
              )
            else
              _StrategiesTab(
                strategies: snapshot.strategies,
                onCreate: _openCreateSheet,
              ),
            const _RiskDisclaimer(),
          ],
        ),
        if (_showSuccess)
          Positioned(
            left: AppSpacing.contentPad,
            right: AppSpacing.contentPad,
            top: mode.usesVisualQaFrame ? AppSpacing.buttonHero : AppSpacing.x5,
            child: _SuccessToast(
              onClose: () => setState(() => _showSuccess = false),
            ),
          ),
      ],
    );
  }

  void _toggleBot(String botId) {
    setState(() {
      _bots = [
        for (final bot in _bots)
          if (bot.id == botId)
            bot.copyWith(
              status: bot.status == TradeBotStatus.running
                  ? TradeBotStatus.paused
                  : TradeBotStatus.running,
            )
          else
            bot,
      ];
    });
    ref
        .read(tradeBotsControllerProvider)
        .submitAction(botId: botId, action: 'toggle');
  }

  void _deleteBot(String botId) {
    setState(() => _bots = _bots.where((bot) => bot.id != botId).toList());
    ref
        .read(tradeBotsControllerProvider)
        .submitAction(botId: botId, action: 'delete');
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
    ref
        .read(tradeBotsControllerProvider)
        .createBot(
          TradeBotCreateRequest(
            strategyId: strategy.id,
            params: {
              for (final param in strategy.params)
                param.key: param.defaultValue,
            },
          ),
        );
    setState(() => _showSuccess = true);
  }
}
