import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller_models.dart';

final tradeReadModelControllerProvider = Provider<TradeReadModelController>((
  ref,
) {
  return ref.watch(tradeRepositoryProvider);
});

typedef TradeOrderControllerRequest = ({String pairId, TradeOrderDraft draft});
typedef TradeCopyConfirmationControllerRequest = ({
  String providerId,
  List<String> acceptedConsentIds,
});
typedef TradeLeverageControllerRequest = ({String pairId, int leverage});
typedef TradeMarginControllerRequest = ({String pairId, bool pairRouteVariant});
typedef TradeCopyConfigurationControllerRequest = ({
  String providerId,
  TradeCopyConfigurationDraft draft,
});
typedef TradeFuturesOrderControllerRequest = ({
  String pairId,
  TradeFuturesOrderDraft draft,
});

final tradeScreenProvider = Provider.family<TradeScreenSnapshot, String>(
  (ref, pairId) => ref.watch(tradeRepositoryProvider).getTrade(pairId: pairId),
);

final tradeCopyTradingProvider = Provider<TradeCopyTradingSnapshot>(
  (ref) => ref.watch(tradeRepositoryProvider).getCopyTrading(),
);

final tradeCopyTradingV2Provider = Provider<TradeCopyTradingV2Snapshot>(
  (ref) => ref.watch(tradeRepositoryProvider).getCopyTradingV2(),
);

final tradePreCopyAssessmentProvider =
    Provider.family<TradePreCopyAssessmentSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeRepositoryProvider)
          .getPreCopyAssessment(providerId: providerId),
    );

final tradeCopyProviderDetailProvider =
    Provider.family<TradeCopyProviderDetailSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeRepositoryProvider)
          .getCopyProviderDetail(providerId: providerId),
    );

final tradeProviderLeaderboardProvider =
    Provider<TradeProviderLeaderboardSnapshot>(
      (ref) => ref.watch(tradeRepositoryProvider).getProviderLeaderboard(),
    );

final tradeProviderComparisonProvider =
    Provider<TradeProviderComparisonSnapshot>(
      (ref) => ref.watch(tradeRepositoryProvider).getProviderComparison(),
    );

final tradeProviderGovernanceProvider =
    Provider<TradeProviderGovernanceSnapshot>(
      (ref) => ref.watch(tradeRepositoryProvider).getProviderGovernance(),
    );

final tradePortfolioRiskAnalysisProvider =
    Provider<TradePortfolioRiskAnalysisSnapshot>(
      (ref) => ref.watch(tradeRepositoryProvider).getPortfolioRiskAnalysis(),
    );

final tradeRiskIndicatorExplainerProvider =
    Provider<TradeRiskIndicatorSnapshot>(
      (ref) => ref.watch(tradeRepositoryProvider).getRiskIndicatorExplainer(),
    );

final tradeCopyConfigurationProvider =
    Provider.family<TradeCopyConfigurationSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeRepositoryProvider)
          .getCopyConfiguration(providerId: providerId),
    );

final tradeFuturesProvider = Provider.family<TradeFuturesSnapshot, String>(
  (ref, pairId) =>
      ref.watch(tradeRepositoryProvider).getFutures(pairId: pairId),
);

final tradeOrdersHistoryControllerProvider =
    Provider<TradeOrdersHistoryController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeOrdersHistoryController(
        repository: repository,
        state: TradeOrdersHistoryViewState(
          snapshot: repository.getOrdersHistory(),
        ),
      );
    });

final tradeActiveCopiesControllerProvider =
    Provider<TradeActiveCopiesController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeActiveCopiesController(
        repository: repository,
        state: TradeActiveCopiesViewState(
          snapshot: repository.getActiveCopies(),
        ),
      );
    });

final tradeCopySettingsControllerProvider =
    Provider<TradeCopySettingsController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeCopySettingsController(
        repository: repository,
        state: TradeCopySettingsViewState(
          snapshot: repository.getCopySettings(),
        ),
      );
    });

final tradeProviderApplicationControllerProvider =
    Provider<TradeProviderApplicationController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeProviderApplicationController(
        repository: repository,
        state: TradeProviderApplicationViewState(
          snapshot: repository.getProviderApplication(),
        ),
      );
    });

final tradeRiskManagementControllerProvider =
    Provider<TradeRiskManagementController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeRiskManagementController(
        repository: repository,
        state: TradeRiskManagementViewState(
          snapshot: repository.getRiskManagement(),
        ),
      );
    });

final tradeAdvancedToolsControllerProvider =
    Provider<TradeAdvancedToolsController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeAdvancedToolsController(
        repository: repository,
        state: TradeAdvancedToolsViewState(
          snapshot: repository.getAdvancedTools(),
        ),
      );
    });

final tradeBotEmergencyStopControllerProvider =
    Provider<TradeBotEmergencyStopController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeBotEmergencyStopController(
        repository: repository,
        state: TradeBotEmergencyStopViewState(
          snapshot: repository.getBotEmergencyStop(),
        ),
      );
    });

final tradeBotSecuritySettingsControllerProvider =
    Provider<TradeBotSecuritySettingsController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
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
              .watch(tradeRepositoryProvider)
              .getBotSuitabilityAssessment(),
        ),
      );
    });

final tradeBotsControllerProvider = Provider<TradeBotsController>((ref) {
  final repository = ref.watch(tradeRepositoryProvider);
  return TradeBotsController(
    repository: repository,
    state: TradeBotsViewState(snapshot: repository.getTradingBots()),
  );
});

final tradeOrderControllerProvider =
    Provider.family<TradeOrderController, TradeOrderControllerRequest>((
      ref,
      request,
    ) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeOrderController(
        repository: repository,
        state: TradeOrderViewState(
          snapshot: repository.getTrade(pairId: request.pairId),
          draft: request.draft,
          preview: repository.previewOrder(request.draft),
        ),
      );
    });

final tradeCopyConfirmationControllerProvider =
    Provider.family<
      TradeCopyConfirmationController,
      TradeCopyConfirmationControllerRequest
    >((ref, request) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeCopyConfirmationController(
        repository: repository,
        state: TradeCopyConfirmationViewState(
          snapshot: repository.getCopyConfirmation(
            providerId: request.providerId,
          ),
          acceptedConsentIds: Set.unmodifiable(request.acceptedConsentIds),
        ),
      );
    });

final tradeLeverageControllerProvider =
    Provider.family<TradeLeverageController, TradeLeverageControllerRequest>((
      ref,
      request,
    ) {
      final repository = ref.watch(tradeRepositoryProvider);
      final snapshot = repository.getFuturesLeverage(pairId: request.pairId);
      final leverage = TradeLeverageController.sanitize(request.leverage);
      final leverageRequest = TradeFuturesLeverageRequest(
        pairId: request.pairId,
        leverage: leverage,
        exampleMargin: snapshot.exampleMargin,
      );
      return TradeLeverageController(
        repository: repository,
        state: TradeLeverageViewState(
          snapshot: snapshot,
          request: leverageRequest,
          preview: repository.previewFuturesLeverage(leverageRequest),
        ),
      );
    });

final tradeMarginControllerProvider =
    Provider.family<TradeMarginController, TradeMarginControllerRequest>((
      ref,
      request,
    ) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeMarginController(
        state: TradeMarginViewState(
          snapshot: repository.getMarginTrading(
            pairId: request.pairId,
            pairRouteVariant: request.pairRouteVariant,
          ),
        ),
      );
    });

final tradeCopyConfigurationControllerProvider =
    Provider.family<
      TradeCopyConfigurationController,
      TradeCopyConfigurationControllerRequest
    >((ref, request) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeCopyConfigurationController(
        state: TradeCopyConfigurationViewState(
          snapshot: repository.getCopyConfiguration(
            providerId: request.providerId,
          ),
          draft: request.draft,
          preview: repository.previewCopyConfiguration(request.draft),
        ),
      );
    });

final tradeFuturesOrderControllerProvider =
    Provider.family<
      TradeFuturesOrderController,
      TradeFuturesOrderControllerRequest
    >((ref, request) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeFuturesOrderController(
        repository: repository,
        state: TradeFuturesOrderViewState(
          snapshot: repository.getFutures(pairId: request.pairId),
          draft: request.draft,
          preview: repository.previewFuturesOrder(request.draft),
        ),
      );
    });
