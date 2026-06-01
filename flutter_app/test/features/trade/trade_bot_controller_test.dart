import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

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

      final botsController = TradeBotsController(
        repository: repository,
        state: TradeBotsViewState(snapshot: repository.getTradingBots()),
      );

      expect(
        botsController.botActionValidationMessage(
          botId: 'bot001',
          action: 'toggle',
        ),
        isNull,
      );
      expect(
        botsController.submitAction(botId: 'bot001', action: 'toggle').action,
        'toggle',
      );
      expect(
        botsController.createValidationMessage(
          const TradeBotCreateRequest(
            strategyId: 'grid',
            params: {'pair': 'BTC/USDT'},
          ),
        ),
        isNull,
      );
      expect(
        botsController
            .createBot(
              const TradeBotCreateRequest(
                strategyId: 'grid',
                params: {'pair': 'BTC/USDT'},
              ),
            )
            .strategyId,
        'grid',
      );
    },
  );
}
