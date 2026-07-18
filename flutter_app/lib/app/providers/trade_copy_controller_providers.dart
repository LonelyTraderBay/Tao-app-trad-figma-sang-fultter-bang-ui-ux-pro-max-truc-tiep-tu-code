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
//
// GD4-F3: `TradeCopyTradingRepository` is now `Future<T>` throughout (see
// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md). Pure-read
// snapshot providers below are `FutureProvider`/`FutureProvider.family`
// (mục 4). Controller providers that used to call the repository directly
// inside their own declaration are split into a 2-step "provider trung
// gian" (mục 3): a `FutureProvider` snapshot, then a
// `Provider<AsyncValue<XController>>` that `.whenData()`s over it (khuôn
// STATE-S25, same as wallet's `withdrawControllerProvider`). The controller
// classes themselves stay sync (mục 6 — no `AsyncNotifier`); only their
// `submit()`/`save()`/`submitCopyAction()` action methods now return
// `Future<T>` because the repository methods they forward to do.

typedef TradeCopyConfirmationControllerRequest = ({
  String providerId,
  List<String> acceptedConsentIds,
});
typedef TradeCopyConfigurationControllerRequest = ({
  String providerId,
  TradeCopyConfigurationDraft draft,
});

final tradeCopyTradingProvider = FutureProvider<TradeCopyTradingSnapshot>(
  (ref) => ref.watch(tradeCopyTradingRepositoryProvider).getCopyTrading(),
);

final tradePreCopyAssessmentProvider =
    FutureProvider.family<TradePreCopyAssessmentSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getPreCopyAssessment(providerId: providerId),
    );

final tradeCopyProviderDetailProvider =
    FutureProvider.family<TradeCopyProviderDetailSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getCopyProviderDetail(providerId: providerId),
    );

final tradeProviderLeaderboardProvider =
    FutureProvider<TradeProviderLeaderboardSnapshot>(
      (ref) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getProviderLeaderboard(),
    );

final tradeProviderComparisonProvider =
    FutureProvider<TradeProviderComparisonSnapshot>(
      (ref) =>
          ref.watch(tradeCopyTradingRepositoryProvider).getProviderComparison(),
    );

final tradeProviderGovernanceProvider =
    FutureProvider<TradeProviderGovernanceSnapshot>(
      (ref) =>
          ref.watch(tradeCopyTradingRepositoryProvider).getProviderGovernance(),
    );

final tradePortfolioRiskAnalysisProvider =
    FutureProvider<TradePortfolioRiskAnalysisSnapshot>(
      (ref) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getPortfolioRiskAnalysis(),
    );

final tradeCopyConfigurationProvider =
    FutureProvider.family<TradeCopyConfigurationSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getCopyConfiguration(providerId: providerId),
    );

// GD4-F3 mục 3: các provider trung gian dưới đây thay cho việc trang gọi
// `ref.watch(tradeCopyTradingRepositoryProvider).getX(...)` trực tiếp bên
// trong `build()` — trang giờ `ref.watch(tradeXProvider)` rồi `.when()`.

final tradeTraderProfileProvider =
    FutureProvider.family<TradeTraderProfileSnapshot, String>(
      (ref, traderId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getTraderProfile(traderId: traderId),
    );

final tradeCopyPerformanceProvider =
    FutureProvider.family<TradeCopyPerformanceSnapshot, String>(
      (ref, copyId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getCopyPerformance(copyId: copyId),
    );

final tradePerformanceAttributionProvider =
    FutureProvider.family<TradePerformanceAttributionSnapshot, String>(
      (ref, copyId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getPerformanceAttribution(copyId: copyId),
    );

final tradeCopyAuditLogProvider =
    FutureProvider.family<TradeCopyAuditLogSnapshot, String>(
      (ref, copyId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getCopyAuditLog(copyId: copyId),
    );

final tradeCopyCardDemoProvider = FutureProvider<TradeCopyCardDemoSnapshot>(
  (ref) => ref.watch(tradeCopyTradingRepositoryProvider).getCopyCardDemo(),
);

final tradeCopyEducationProvider = FutureProvider<TradeCopyEducationSnapshot>(
  (ref) => ref.watch(tradeCopyTradingRepositoryProvider).getCopyEducation(),
);

final tradeCopyNotificationsProvider =
    FutureProvider<TradeCopyNotificationsSnapshot>(
      (ref) =>
          ref.watch(tradeCopyTradingRepositoryProvider).getCopyNotifications(),
    );

final tradeSafetyEducationProvider =
    FutureProvider<TradeSafetyEducationSnapshot>(
      (ref) =>
          ref.watch(tradeCopyTradingRepositoryProvider).getSafetyEducation(),
    );

final tradeDisputeResolutionProvider =
    FutureProvider<TradeDisputeResolutionSnapshot>(
      (ref) =>
          ref.watch(tradeCopyTradingRepositoryProvider).getDisputeResolution(),
    );

final tradeCopySafetyCenterProvider =
    FutureProvider<TradeCopySafetyCenterSnapshot>(
      (ref) =>
          ref.watch(tradeCopyTradingRepositoryProvider).getCopySafetyCenter(),
    );

// GD4-F3 mục 3, bước A: provider trung gian cho mỗi controller GHI từng
// gọi repo trực tiếp trong khai báo cũ.

final tradeActiveCopiesSnapshotProvider =
    FutureProvider<TradeActiveCopiesSnapshot>(
      (ref) => ref.watch(tradeCopyTradingRepositoryProvider).getActiveCopies(),
    );

final tradeCopySettingsSnapshotProvider =
    FutureProvider<TradeCopySettingsSnapshot>(
      (ref) => ref.watch(tradeCopyTradingRepositoryProvider).getCopySettings(),
    );

final tradeProviderApplicationSnapshotProvider =
    FutureProvider<TradeProviderApplicationSnapshot>(
      (ref) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getProviderApplication(),
    );

final tradeCopyConfirmationSnapshotProvider =
    FutureProvider.family<TradeCopyConfirmationSnapshot, String>(
      (ref, providerId) => ref
          .watch(tradeCopyTradingRepositoryProvider)
          .getCopyConfirmation(providerId: providerId),
    );

/// `getCopyConfiguration` + `previewCopyConfiguration` cùng cần cho
/// [tradeCopyConfigurationControllerProvider] — gộp cả hai vào 1
/// `FutureProvider.family` trung gian (await tuần tự, tái dùng cache của
/// [tradeCopyConfigurationProvider] qua `.future`) rồi mới bọc `AsyncValue`
/// ở bước B, tránh 2 lớp skeleton lồng nhau cho 2 fetch phụ thuộc tuần tự
/// (GD4-Async-Playbook.md mục 5).
final tradeCopyConfigurationControllerSnapshotProvider =
    FutureProvider.family<
      ({
        TradeCopyConfigurationSnapshot snapshot,
        TradeCopyConfigurationPreview preview,
      }),
      TradeCopyConfigurationControllerRequest
    >((ref, request) async {
      final snapshot = await ref.watch(
        tradeCopyConfigurationProvider(request.providerId).future,
      );
      final preview = await ref
          .watch(tradeCopyTradingRepositoryProvider)
          .previewCopyConfiguration(request.draft);
      return (snapshot: snapshot, preview: preview);
    });

// GD4-F3 mục 3, bước B: bọc AsyncValue thay vì unwrap bằng `requireValue`
// (khuôn STATE-S25 — xem home_controller_providers.dart / wallet's
// withdrawControllerProvider). Consumer widget tự `.when()` loading/error/
// data.

final tradeActiveCopiesControllerProvider =
    Provider<AsyncValue<TradeActiveCopiesController>>((ref) {
      final repository = ref.watch(tradeCopyTradingRepositoryProvider);
      return ref
          .watch(tradeActiveCopiesSnapshotProvider)
          .whenData(
            (snapshot) => TradeActiveCopiesController(
              repository: repository,
              state: TradeActiveCopiesViewState(snapshot: snapshot),
            ),
          );
    });

final tradeCopySettingsControllerProvider =
    Provider<AsyncValue<TradeCopySettingsController>>((ref) {
      final repository = ref.watch(tradeCopyTradingRepositoryProvider);
      return ref
          .watch(tradeCopySettingsSnapshotProvider)
          .whenData(
            (snapshot) => TradeCopySettingsController(
              repository: repository,
              state: TradeCopySettingsViewState(snapshot: snapshot),
            ),
          );
    });

final tradeProviderApplicationControllerProvider =
    Provider<AsyncValue<TradeProviderApplicationController>>((ref) {
      final repository = ref.watch(tradeCopyTradingRepositoryProvider);
      return ref
          .watch(tradeProviderApplicationSnapshotProvider)
          .whenData(
            (snapshot) => TradeProviderApplicationController(
              repository: repository,
              state: TradeProviderApplicationViewState(snapshot: snapshot),
            ),
          );
    });

final tradeCopyConfirmationControllerProvider =
    Provider.family<
      AsyncValue<TradeCopyConfirmationController>,
      TradeCopyConfirmationControllerRequest
    >((ref, request) {
      final repository = ref.watch(tradeCopyTradingRepositoryProvider);
      return ref
          .watch(tradeCopyConfirmationSnapshotProvider(request.providerId))
          .whenData(
            (snapshot) => TradeCopyConfirmationController(
              repository: repository,
              state: TradeCopyConfirmationViewState(
                snapshot: snapshot,
                acceptedConsentIds: Set.unmodifiable(
                  request.acceptedConsentIds,
                ),
              ),
            ),
          );
    });

final tradeCopyConfigurationControllerProvider =
    Provider.family<
      AsyncValue<TradeCopyConfigurationController>,
      TradeCopyConfigurationControllerRequest
    >((ref, request) {
      return ref
          .watch(tradeCopyConfigurationControllerSnapshotProvider(request))
          .whenData(
            (result) => TradeCopyConfigurationController(
              state: TradeCopyConfigurationViewState(
                snapshot: result.snapshot,
                draft: request.draft,
                preview: result.preview,
              ),
            ),
          );
    });
