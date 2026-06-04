import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';

part 'trading_bots_page_part_01.dart';
part 'trading_bots_page_part_02.dart';
part 'trading_bots_page_part_03.dart';
part 'trading_bots_page_part_04.dart';

const _botPrimary = AppColors.primary;
const _botPrimaryDark = AppColors.primaryDark;
const _panelBackground = AppColors.surface;
const _chipBackground = AppColors.surface2;

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
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 34 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-059 TradingBotsPage',
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(
              key: TradingBotsPage.contentKey,
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: _TradingBotsHeader(
                      onBack: () => goBackOrFallback(
                        context,
                        fallbackPath: AppRoutePaths.trade,
                        mode: BackNavigationMode.historyThenFallback,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.divider,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BotsHero(bots: _bots),
                        const SizedBox(height: 16),
                        _BotsTabs(
                          active: _tab,
                          botCount: _bots.length,
                          onChanged: (tab) => setState(() => _tab = tab),
                        ),
                        const SizedBox(height: 16),
                        if (_tab == _TradingBotsTab.myBots)
                          _MyBotsTab(
                            bots: _bots,
                            onToggle: _toggleBot,
                            onDelete: _deleteBot,
                            onAdd: () => setState(
                              () => _tab = _TradingBotsTab.strategies,
                            ),
                          )
                        else
                          _StrategiesTab(
                            strategies: snapshot.strategies,
                            onCreate: _openCreateSheet,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showSuccess)
            Positioned(
              left: 20,
              right: 20,
              top: mode.usesVisualQaFrame ? 80 : 24,
              child: _SuccessToast(
                onClose: () => setState(() => _showSuccess = false),
              ),
            ),
        ],
      ),
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

  Future<void> _openCreateSheet(TradeBotStrategy strategy) async {
    final created = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
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
