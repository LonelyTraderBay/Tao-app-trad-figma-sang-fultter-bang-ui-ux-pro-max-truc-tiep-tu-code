import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/controllers/trade_copy_controller_models.dart';

void main() {
  test('Trade copy confirmation controller gates required consent', () async {
    final repository = const MockTradeCopyTradingRepository(
      loadDelay: Duration.zero,
    );
    final snapshot = await repository.getCopyConfirmation(
      providerId: 'provider001',
    );
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
      'Chấp nhận toàn bộ xác nhận phù hợp và rủi ro bắt buộc trước.',
    );
    final result = await controller.submit();
    expect(result.status, 'pending_cooling_off');
    expect(result.coolingOffHours, 24);
  });

  test(
    'Trade copy controllers own copy, settings, and provider intents',
    () async {
      final repository = const MockTradeCopyTradingRepository(
        loadDelay: Duration.zero,
      );
      final activeCopies = await repository.getActiveCopies();
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
      final activeCopyResult = await activeController.submitCopyAction(
        providerId: 'provider001',
        action: 'stop',
      );
      expect(activeCopyResult.status, isNotEmpty);
      final settings = await repository.getCopySettings();
      final settingsController = TradeCopySettingsController(
        repository: repository,
        state: TradeCopySettingsViewState(snapshot: settings),
      );
      expect(
        settingsController.saveValidationMessage(settings.settings),
        isNull,
      );
      final saveResult = await settingsController.save(settings.settings);
      expect(saveResult.status, 'saved');
      final providerApplication = await repository.getProviderApplication();
      final providerController = TradeProviderApplicationController(
        repository: repository,
        state: TradeProviderApplicationViewState(snapshot: providerApplication),
      );
      expect(
        providerController.validationMessage(providerApplication.defaultDraft),
        'Complete identity verification before applying as provider.',
      );
      final submitResult = await providerController.submit(
        providerApplication.defaultDraft,
      );
      expect(submitResult.applicationId, isNotEmpty);
      final copyConfiguration = await repository.getCopyConfiguration(
        providerId: 'provider001',
      );
      final copyConfigDraft = copyConfiguration.defaultDraft;
      final copyConfigController = TradeCopyConfigurationController(
        state: TradeCopyConfigurationViewState(
          snapshot: copyConfiguration,
          draft: copyConfigDraft,
          preview: await repository.previewCopyConfiguration(copyConfigDraft),
        ),
      );
      expect(copyConfigController.canContinue, isTrue);
      expect(copyConfigController.validationMessage(), isNull);
      expect(
        TradeCopyConfigurationController(
          state: TradeCopyConfigurationViewState(
            snapshot: copyConfiguration,
            draft: copyConfigDraft.copyWith(copyCapital: 0),
            preview: await repository.previewCopyConfiguration(
              copyConfigDraft.copyWith(copyCapital: 0),
            ),
          ),
        ).validationMessage(),
        'Nhập số tiền sao chép hợp lệ trước khi xem trước.',
      );
    },
  );
}
