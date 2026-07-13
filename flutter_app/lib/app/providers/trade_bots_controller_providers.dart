import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade_bots/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/controllers/trade_bots_controller_models.dart';

export 'package:vit_trade_flutter/features/trade_bots/data/providers/trade_repository_provider.dart';

// Trading-bots domain controller providers (trade_bots extraction, Batch 1
// of Phase 3 of the trade module split; controllers wired in Batch 4).
// Re-exports [tradingBotsRepositoryProvider] and
// [tradeBotAnalyticsRepositoryProvider] above so other `app/providers/*`
// files depend on this app-layer facade instead of reaching into
// `features/trade_bots/data/` directly. Batch 4 moved every bot-specific
// controller provider out of `trade_controller_providers.dart` into this
// file, rewiring each from the old cross-domain union
// `tradeRepositoryProvider` to the narrow `tradingBotsRepositoryProvider`,
// mirroring the trade_copy Batch 4 pattern.

final tradeBotEmergencyStopControllerProvider =
    Provider<TradeBotEmergencyStopController>((ref) {
      final repository = ref.watch(tradingBotsRepositoryProvider);
      return TradeBotEmergencyStopController(
        repository: repository,
        state: TradeBotEmergencyStopViewState(
          snapshot: repository.getBotEmergencyStop(),
        ),
      );
    });

final tradeBotSecuritySettingsControllerProvider =
    Provider<TradeBotSecuritySettingsController>((ref) {
      final repository = ref.watch(tradingBotsRepositoryProvider);
      return TradeBotSecuritySettingsController(
        repository: repository,
        state: TradeBotSecuritySettingsViewState(
          snapshot: repository.getBotSecuritySettings(),
        ),
      );
    });

final tradeBotSuitabilityControllerProvider =
    Provider<TradeBotSuitabilityController>((ref) {
      return TradeBotSuitabilityController(
        state: TradeBotSuitabilityViewState(
          snapshot: ref
              .watch(tradingBotsRepositoryProvider)
              .getBotSuitabilityAssessment(),
        ),
      );
    });

final tradeBotsControllerProvider =
    NotifierProvider<TradeBotsController, TradeBotsViewState>(
      TradeBotsController.new,
    );

/// Owns [TradeBotsViewState] reactively so pages read a single source of
/// truth instead of forking the bot list into local `setState`. The mock
/// repository is stateless (`submitBotAction`/`createTradingBot` return a
/// fixed demo result, see `trading_bots_page_test.dart`'s "SC-059 bot
/// actions stay local"), so the optimistic list edits below are applied
/// here rather than by re-fetching — they replace the page-local `_bots`
/// override that used to silently desync from this provider on rebuild.
final class TradeBotsController extends Notifier<TradeBotsViewState> {
  @override
  TradeBotsViewState build() {
    return TradeBotsViewState(
      snapshot: ref.watch(tradingBotsRepositoryProvider).getTradingBots(),
    );
  }

  TradeBotActionResult submitAction({
    required String botId,
    required String action,
  }) {
    final result = ref
        .read(tradingBotsRepositoryProvider)
        .submitBotAction(TradeBotActionRequest(botId: botId, action: action));
    _applyBotAction(botId: botId, action: action);
    return result;
  }

  TradeBotCreateResult createBot(TradeBotCreateRequest request) {
    return ref.read(tradingBotsRepositoryProvider).createTradingBot(request);
  }

  String? botActionValidationMessage({
    required String botId,
    required String action,
  }) => state.botActionValidationMessage(botId: botId, action: action);

  String? createValidationMessage(TradeBotCreateRequest request) =>
      state.createValidationMessage(request);

  void _applyBotAction({required String botId, required String action}) {
    switch (action) {
      case 'delete':
        state = state.copyWith(
          snapshot: state.snapshot.copyWith(
            activeBots: state.snapshot.activeBots
                .where((bot) => bot.id != botId)
                .toList(growable: false),
          ),
        );
      case 'toggle':
        state = state.copyWith(
          snapshot: state.snapshot.copyWith(
            activeBots: [
              for (final bot in state.snapshot.activeBots)
                bot.id == botId
                    ? bot.copyWith(
                        status: bot.status == TradeBotStatus.running
                            ? TradeBotStatus.paused
                            : TradeBotStatus.running,
                      )
                    : bot,
            ],
          ),
        );
    }
  }
}
