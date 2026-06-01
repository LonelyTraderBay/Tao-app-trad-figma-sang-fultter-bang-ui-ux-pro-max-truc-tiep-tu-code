import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

void main() {
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
}
