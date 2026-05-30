import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

void main() {
  test('Trade order controller previews and submits a valid order intent', () {
    final repository = const MockTradeRepository();
    final snapshot = repository.getTrade();
    final draft = TradeOrderDraft(
      pairId: snapshot.pair.id,
      side: TradeOrderSide.buy,
      type: TradeOrderType.limit,
      price: snapshot.pair.price,
      amount: .01,
    );
    final controller = TradeOrderController(
      repository: repository,
      state: TradeOrderViewState(
        snapshot: snapshot,
        draft: draft,
        preview: repository.previewOrder(draft),
      ),
    );

    expect(controller.canSubmit, isTrue);
    expect(controller.validationMessage(), isNull);
    expect(TradeHighRiskFlowStatus.confirming.isBusy, isTrue);
    expect(TradeHighRiskFlowStatus.preview.hasPreview, isTrue);
    expect(TradeHighRiskFlowStatus.validationError.isFailure, isTrue);
    expect(controller.state.preview.total, greaterThan(0));
    expect(
      TradeOrderController(
        repository: repository,
        state: TradeOrderViewState(
          snapshot: snapshot,
          draft: TradeOrderDraft(
            pairId: snapshot.pair.id,
            side: TradeOrderSide.buy,
            type: TradeOrderType.limit,
            price: 0,
            amount: .01,
          ),
          preview: repository.previewOrder(
            TradeOrderDraft(
              pairId: snapshot.pair.id,
              side: TradeOrderSide.buy,
              type: TradeOrderType.limit,
              price: 0,
              amount: .01,
            ),
          ),
        ),
      ).validationMessage(),
      'Enter a valid order price before preview.',
    );
    expect(
      TradeOrderController(
        repository: repository,
        state: TradeOrderViewState(
          snapshot: snapshot,
          draft: draft,
          preview: repository.previewOrder(draft),
          status: TradeHighRiskFlowStatus.offline,
        ),
      ).validationMessage(),
      'Offline: reconnect before previewing this order.',
    );

    final receipt = controller.submit();

    expect(receipt.orderId, 'ORD-DEMO-048');
    expect(receipt.status, 'submitted');
  });

  test('Trade copy confirmation controller gates required consent', () {
    final repository = const MockTradeRepository();
    final snapshot = repository.getCopyConfirmation(providerId: 'provider001');
    final requiredConsentIds = {
      for (final item in snapshot.consentItems)
        if (item.required) item.id,
    };
    final controller = TradeCopyConfirmationController(
      repository: repository,
      state: TradeCopyConfirmationViewState(
        snapshot: snapshot,
        acceptedConsentIds: requiredConsentIds,
      ),
    );

    expect(controller.allRequiredAccepted, isTrue);
    expect(controller.canSubmit, isTrue);
    expect(controller.validationMessage(), isNull);
    expect(
      TradeCopyConfirmationController(
        repository: repository,
        state: TradeCopyConfirmationViewState(
          snapshot: snapshot,
          acceptedConsentIds: const {},
        ),
      ).validationMessage(),
      'Accept all required suitability and risk confirmations first.',
    );

    final result = controller.submit();

    expect(result.status, 'pending_cooling_off');
    expect(result.coolingOffHours, 24);
  });

  test(
    'Trade leverage controller clamps leverage and submits previewed risk',
    () {
      final repository = const MockTradeRepository();
      final snapshot = repository.getFuturesLeverage(pairId: 'btcusdt');
      final request = TradeFuturesLeverageRequest(
        pairId: 'btcusdt',
        leverage: 25,
        exampleMargin: snapshot.exampleMargin,
      );
      final controller = TradeLeverageController(
        repository: repository,
        state: TradeLeverageViewState(
          snapshot: snapshot,
          request: request,
          preview: repository.previewFuturesLeverage(request),
        ),
      );

      expect(controller.sanitizeLeverage(150), 100);
      expect(controller.sanitizeLeverage(0), 1);
      expect(controller.state.preview.showRiskTips, isTrue);
      expect(controller.canSubmit, isTrue);
      expect(controller.validationMessage(), isNull);
      expect(
        TradeLeverageController(
          repository: repository,
          state: TradeLeverageViewState(
            snapshot: snapshot,
            request: const TradeFuturesLeverageRequest(
              pairId: 'btcusdt',
              leverage: 101,
            ),
            preview: repository.previewFuturesLeverage(
              const TradeFuturesLeverageRequest(
                pairId: 'btcusdt',
                leverage: 100,
              ),
            ),
          ),
        ).validationMessage(),
        'Leverage must stay between 1x and 100x.',
      );

      final receipt = controller.submit();

      expect(receipt.pairId, 'btcusdt');
      expect(receipt.status, 'submitted');
    },
  );

  test(
    'Trade margin controller owns mode totals and max amount calculation',
    () {
      final repository = const MockTradeRepository();
      final snapshot = repository.getMarginTrading();
      final controller = TradeMarginController(
        state: TradeMarginViewState(snapshot: snapshot),
      );

      final positions = controller.positionsForMode(snapshot.defaultMode);

      expect(positions, isNotEmpty);
      expect(
        controller.totalPnlForMode(snapshot.defaultMode),
        positions.fold<double>(0, (total, item) => total + item.pnl),
      );
      expect(
        double.parse(
          controller.maxAmountFor(leverage: snapshot.defaultLeverage),
        ),
        greaterThan(0),
      );
      expect(
        controller.leverageValidationMessage(
          leverage: snapshot.defaultLeverage,
        ),
        isNull,
      );
      expect(
        controller.leverageValidationMessage(leverage: 0),
        'Leverage must stay between 1x and 100x.',
      );
    },
  );

  test('Trade copy controllers own copy, settings, and provider intents', () {
    final repository = const MockTradeRepository();
    final activeCopies = repository.getActiveCopies();
    final activeController = TradeActiveCopiesController(
      repository: repository,
      state: TradeActiveCopiesViewState(snapshot: activeCopies),
    );

    expect(activeController.hasRiskAlert(activeCopies.copies), isA<bool>());
    expect(
      activeController.actionValidationMessage(
        providerId: 'provider001',
        action: 'stop',
      ),
      isNull,
    );
    expect(
      activeController
          .submitCopyAction(providerId: 'provider001', action: 'stop')
          .status,
      isNotEmpty,
    );

    final settings = repository.getCopySettings();
    final settingsController = TradeCopySettingsController(
      repository: repository,
      state: TradeCopySettingsViewState(snapshot: settings),
    );

    expect(settingsController.saveValidationMessage(settings.settings), isNull);
    expect(settingsController.save(settings.settings).status, 'saved');

    final providerApplication = repository.getProviderApplication();
    final providerController = TradeProviderApplicationController(
      repository: repository,
      state: TradeProviderApplicationViewState(snapshot: providerApplication),
    );

    expect(
      providerController.validationMessage(providerApplication.defaultDraft),
      'Complete identity verification before applying as provider.',
    );
    expect(
      providerController.submit(providerApplication.defaultDraft).applicationId,
      isNotEmpty,
    );

    final copyConfiguration = repository.getCopyConfiguration(
      providerId: 'provider001',
    );
    final copyConfigDraft = copyConfiguration.defaultDraft;
    final copyConfigController = TradeCopyConfigurationController(
      state: TradeCopyConfigurationViewState(
        snapshot: copyConfiguration,
        draft: copyConfigDraft,
        preview: repository.previewCopyConfiguration(copyConfigDraft),
      ),
    );

    expect(copyConfigController.canContinue, isTrue);
    expect(copyConfigController.validationMessage(), isNull);
    expect(
      TradeCopyConfigurationController(
        state: TradeCopyConfigurationViewState(
          snapshot: copyConfiguration,
          draft: copyConfigDraft.copyWith(copyCapital: 0),
          preview: repository.previewCopyConfiguration(
            copyConfigDraft.copyWith(copyCapital: 0),
          ),
        ),
      ).validationMessage(),
      'Enter a valid copy amount before preview.',
    );
  });

  test('Trade futures, risk, and order controllers own submit intents', () {
    final repository = const MockTradeRepository();
    final futures = repository.getFutures(pairId: 'btcusdt');
    final futuresDraft = TradeFuturesOrderDraft(
      pairId: futures.pair.id,
      side: TradeFuturesSide.long,
      type: TradeFuturesOrderType.market,
      margin: 100,
      leverage: 10,
    );
    final futuresController = TradeFuturesOrderController(
      repository: repository,
      state: TradeFuturesOrderViewState(
        snapshot: futures,
        draft: futuresDraft,
        preview: repository.previewFuturesOrder(futuresDraft),
      ),
    );

    expect(futuresController.canSubmit, isTrue);
    expect(futuresController.validationMessage(), isNull);
    expect(futuresController.submit().status, 'submitted');

    final riskController = TradeRiskManagementController(
      repository: repository,
      state: TradeRiskManagementViewState(
        snapshot: repository.getRiskManagement(),
      ),
    );

    expect(
      riskController.ocoValidationMessage(
        const TradeOcoOrderDraft(
          symbol: 'BTC/USDT',
          side: TradeOrderSide.buy,
          quantity: .015,
          limitPrice: 69000,
          takeProfitPrice: 72000,
          stopPrice: 66000,
        ),
      ),
      isNull,
    );
    expect(
      riskController
          .submitOcoOrder(
            const TradeOcoOrderDraft(
              symbol: 'BTC/USDT',
              side: TradeOrderSide.buy,
              quantity: .015,
              limitPrice: 69000,
              takeProfitPrice: 72000,
              stopPrice: 66000,
            ),
          )
          .status,
      isNotEmpty,
    );
    expect(
      riskController
          .calculatePositionSize(
            const TradePositionSizeRequest(
              accountBalance: 50000,
              riskPct: 1,
              entryPrice: 69000,
              stopPrice: 67500,
            ),
          )
          .suggestedAmount,
      greaterThan(0),
    );
    expect(
      riskController.positionSizeValidationMessage(
        const TradePositionSizeRequest(
          accountBalance: 50000,
          riskPct: 1,
          entryPrice: 69000,
          stopPrice: 67500,
        ),
      ),
      isNull,
    );

    final ordersController = TradeOrdersHistoryController(
      repository: repository,
      state: TradeOrdersHistoryViewState(
        snapshot: repository.getOrdersHistory(),
      ),
    );

    expect(ordersController.cancelValidationMessage('ord001'), isNull);
    expect(ordersController.cancelOrder('ord001').action, 'cancel');
  });

  test('Trade advanced tools controller owns action and amendment intents', () {
    final repository = const MockTradeRepository();
    final controller = TradeAdvancedToolsController(
      repository: repository,
      state: TradeAdvancedToolsViewState(
        snapshot: repository.getAdvancedTools(),
      ),
    );

    expect(
      controller.actionValidationMessage(
        const TradeAdvancedToolActionRequest(
          toolId: 'bulk',
          action: 'cancel',
          orderIds: ['ord001', 'ord002'],
        ),
      ),
      isNull,
    );
    expect(
      controller
          .submitAction(
            const TradeAdvancedToolActionRequest(
              toolId: 'bulk',
              action: 'cancel',
              orderIds: ['ord001', 'ord002'],
            ),
          )
          .affectedCount,
      2,
    );
    expect(
      controller
          .amendOrder(
            const TradeOrderAmendmentRequest(
              orderId: 'ord001',
              newPrice: 69000,
              newAmount: .02,
            ),
          )
          .queuePositionPreserved,
      isTrue,
    );
    expect(
      controller.amendmentValidationMessage(
        const TradeOrderAmendmentRequest(
          orderId: 'ord001',
          newPrice: 69000,
          newAmount: .02,
        ),
      ),
      isNull,
    );
  });

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
