import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade_copy/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/controllers/trade_copy_controller_models.dart';

export 'package:vit_trade_flutter/features/trade_copy/data/providers/trade_repository_provider.dart';

// Copy-trading domain controller providers (trade_copy extraction, Batch 1
// of Phase 2 of the trade module split). Pages must not import
// `features/trade_copy/data/providers/` directly (architecture rule —
// presentation depends on `app/providers/*`, not feature data facades);
// this file re-exports [tradeCopyTradingRepositoryProvider] above. Batch 4
// moved every copy-trading-specific controller/read provider and typedef
// out of `trade_controller_providers.dart` into this file, rewiring each
// from the old cross-domain union `tradeRepositoryProvider` to the narrow
// [tradeCopyTradingRepositoryProvider].

typedef TradeCopyConfirmationControllerRequest = ({
  String providerId,
  List<String> acceptedConsentIds,
});
typedef TradeCopyConfigurationControllerRequest = ({
  String providerId,
  TradeCopyConfigurationDraft draft,
});

final tradeCopyTradingProvider = Provider<TradeCopyTradingSnapshot>(
  (ref) => ref.watch(tradeCopyTradingRepositoryProvider).getCopyTrading(),
);

final tradePreCopyAssessmentProvider =
    Provider.family<TradePreCopyAssessmentSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getPreCopyAssessment(providerId: providerId),
    );

final tradeCopyProviderDetailProvider =
    Provider.family<TradeCopyProviderDetailSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getCopyProviderDetail(providerId: providerId),
    );

final tradeProviderLeaderboardProvider =
    Provider<TradeProviderLeaderboardSnapshot>(
      (ref) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getProviderLeaderboard(),
    );

final tradeProviderComparisonProvider =
    Provider<TradeProviderComparisonSnapshot>(
      (ref) =>
          ref.watch(tradeCopyTradingRepositoryProvider).getProviderComparison(),
    );

final tradeProviderGovernanceProvider =
    Provider<TradeProviderGovernanceSnapshot>(
      (ref) =>
          ref.watch(tradeCopyTradingRepositoryProvider).getProviderGovernance(),
    );

final tradePortfolioRiskAnalysisProvider =
    Provider<TradePortfolioRiskAnalysisSnapshot>(
      (ref) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getPortfolioRiskAnalysis(),
    );

final tradeCopyConfigurationProvider =
    Provider.family<TradeCopyConfigurationSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getCopyConfiguration(providerId: providerId),
    );

final tradeActiveCopiesControllerProvider =
    Provider<TradeActiveCopiesController>((ref) {
      final repository = ref.watch(tradeCopyTradingRepositoryProvider);
      return TradeActiveCopiesController(
        repository: repository,
        state: TradeActiveCopiesViewState(
          snapshot: repository.getActiveCopies(),
        ),
      );
    });

final tradeCopySettingsControllerProvider =
    Provider<TradeCopySettingsController>((ref) {
      final repository = ref.watch(tradeCopyTradingRepositoryProvider);
      return TradeCopySettingsController(
        repository: repository,
        state: TradeCopySettingsViewState(
          snapshot: repository.getCopySettings(),
        ),
      );
    });

final tradeProviderApplicationControllerProvider =
    Provider<TradeProviderApplicationController>((ref) {
      final repository = ref.watch(tradeCopyTradingRepositoryProvider);
      return TradeProviderApplicationController(
        repository: repository,
        state: TradeProviderApplicationViewState(
          snapshot: repository.getProviderApplication(),
        ),
      );
    });

final tradeCopyConfirmationControllerProvider =
    Provider.family<
      TradeCopyConfirmationController,
      TradeCopyConfirmationControllerRequest
    >((ref, request) {
      final repository = ref.watch(tradeCopyTradingRepositoryProvider);
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

final tradeCopyConfigurationControllerProvider =
    Provider.family<
      TradeCopyConfigurationController,
      TradeCopyConfigurationControllerRequest
    >((ref, request) {
      final repository = ref.watch(tradeCopyTradingRepositoryProvider);
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
