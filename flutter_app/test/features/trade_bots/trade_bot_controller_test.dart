import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';

void main() {
  test(
    'Trade bot safety controllers own emergency, security, and suitability',
    () {
      final repository = const MockTradeRepository();
      final emergencyController = TradeBotEmergencyStopController(
        repository: repository,
        state: TradeBotEmergencyStopViewState(
          snapshot: repository.getBotEmergencyStop(),
        ),
      );

      expect(
        emergencyController.canSubmit(reasonId: 'drawdown', confirmed: true),
        isTrue,
      );
      expect(
        emergencyController.validationMessage(reasonId: null, confirmed: true),
        'Select an emergency-stop reason before confirmation.',
      );
      expect(
        emergencyController
            .submit(
              const TradeBotEmergencyStopDraft(
                reasonId: 'drawdown',
                closePositions: true,
                confirmed: true,
              ),
            )
            .status,
        isNotEmpty,
      );

      final securityController = TradeBotSecuritySettingsController(
        repository: repository,
        state: TradeBotSecuritySettingsViewState(
          snapshot: repository.getBotSecuritySettings(),
        ),
      );

      expect(securityController.saveValidationMessage(), isNull);
      expect(securityController.saveTwoFa(true).twoFaEnabled, isTrue);

      final suitability = repository.getBotSuitabilityAssessment();
      final answers = {
        for (final question in suitability.questions)
          question.id: question.options.last.id,
      };
      final suitabilityController = TradeBotSuitabilityController(
        state: TradeBotSuitabilityViewState(snapshot: suitability),
      );

      expect(suitabilityController.score(answers), greaterThan(0));
      expect(
        suitabilityController.completionPathFor(suitability.pass),
        suitability.completionPath,
      );
    },
  );

  test('TradeBotsController Notifier owns bot list mutations reactively', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final initial = container.read(tradeBotsControllerProvider);
    final botId = initial.snapshot.activeBots.first.id;
    final originalStatus = initial.snapshot.activeBots.first.status;

    expect(
      initial.botActionValidationMessage(botId: botId, action: 'toggle'),
      isNull,
    );

    final notifier = container.read(tradeBotsControllerProvider.notifier);
    final actionResult = notifier.submitAction(botId: botId, action: 'toggle');

    expect(actionResult.action, 'toggle');
    final afterToggle = container.read(tradeBotsControllerProvider);
    expect(
      afterToggle.snapshot.activeBots
          .firstWhere((bot) => bot.id == botId)
          .status,
      isNot(originalStatus),
    );

    notifier.submitAction(botId: botId, action: 'delete');
    final afterDelete = container.read(tradeBotsControllerProvider);
    expect(
      afterDelete.snapshot.activeBots.any((bot) => bot.id == botId),
      isFalse,
    );

    expect(
      notifier.createValidationMessage(
        const TradeBotCreateRequest(
          strategyId: 'grid',
          params: {'pair': 'BTC/USDT'},
        ),
      ),
      isNull,
    );
    expect(
      notifier
          .createBot(
            const TradeBotCreateRequest(
              strategyId: 'grid',
              params: {'pair': 'BTC/USDT'},
            ),
          )
          .strategyId,
      'grid',
    );
  });
}
