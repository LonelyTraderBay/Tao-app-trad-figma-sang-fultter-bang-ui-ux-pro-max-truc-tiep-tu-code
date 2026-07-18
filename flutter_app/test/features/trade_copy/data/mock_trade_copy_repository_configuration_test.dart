import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';

/// Repository-layer smoke test for [MockTradeCopyTradingRepository] under
/// the `test/features/<feature>/data/` convention (see
/// `test/features/p2p/data/mock_p2p_repository_orders_test.dart`).
///
/// Every method on `TradeCopyTradingRepository` already gets an isA<>
/// smoke pass in the sibling
/// `test/features/trade_copy/mock_trade_copy_repository_test.dart`. This
/// file complements that coverage by pinning concrete, hand-verified
/// values from
/// `lib/features/trade_copy/data/fixtures/trade_copy_configuration_repository_*.dart`
/// so a silent fixture edit shows up as a failing assertion.
///
/// GD4-F3: every method is `Future<T>` — mock simulates network latency via
/// `loadDelay`; tests pass `Duration.zero` (see
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md).
///
/// Split by behavior group (mirrors the production repository's own
/// provider-discovery / configuration / lifecycle mixin split): this file
/// covers copy configuration, confirmation, performance/attribution, audit
/// log, and portfolio risk analysis. See
/// `mock_trade_copy_repository_provider_discovery_test.dart` for provider
/// discovery/application surfaces and
/// `mock_trade_copy_repository_lifecycle_test.dart` for lifecycle/safety
/// surfaces (including the `tradeCopy` high-risk contract id).
void main() {
  const repository = MockTradeCopyTradingRepository(loadDelay: Duration.zero);

  group('MockTradeCopyTradingRepository configuration data smoke test', () {
    test(
      'getCopyConfiguration pins the portfolio totals and default draft',
      () async {
        final snapshot = await repository.getCopyConfiguration(
          providerId: 'ct001',
        );

        expect(snapshot.providerId, 'ct001');
        expect(snapshot.provider?.id, 'ct001');
        expect(snapshot.totalPortfolio, 25000);
        expect(snapshot.currentCopyAllocation, 8000);
        expect(snapshot.availableCapital, 17000);
        expect(snapshot.defaultDraft.copyCapital, 5000);
        expect(
          snapshot.defaultDraft.copyMode,
          TradeCopyConfigurationMode.fixed,
        );
        expect(snapshot.defaultDraft.copyRatio, 50);
      },
    );

    test(
      'getCopyConfirmation pins the cooling-off window and consent count',
      () async {
        final snapshot = await repository.getCopyConfirmation(
          providerId: 'ct001',
        );

        expect(snapshot.providerId, 'ct001');
        expect(snapshot.coolingOffHours, 24);
        expect(snapshot.consentItems, hasLength(4));
        expect(snapshot.consentItems.every((item) => item.required), isTrue);
        expect(snapshot.scenarios, hasLength(3));
        expect(snapshot.scenarios.first.id, 'optimistic');
      },
    );

    test('getCopyPerformance pins the headline return/value figures', () async {
      final snapshot = await repository.getCopyPerformance(copyId: 'copy001');

      expect(snapshot.copyId, 'copy001');
      expect(snapshot.initialCapital, 5000);
      expect(snapshot.yourReturnPct, 13);
      expect(snapshot.providerReturnPct, 15.6);
      expect(snapshot.equityCurve, hasLength(30));
      expect(snapshot.slippageBuckets, hasLength(4));
      expect(snapshot.costAttribution, hasLength(4));
      expect(snapshot.tradeComparisons, hasLength(3));
      expect(snapshot.metrics, hasLength(4));
    });

    test(
      'getPerformanceAttribution pins the alpha/beta/rSquared figures',
      () async {
        final snapshot = await repository.getPerformanceAttribution(
          copyId: 'copy001',
        );

        expect(snapshot.copyId, 'copy001');
        expect(snapshot.totalReturnPct, 9.2);
        expect(snapshot.alphaPct, -4.1);
        expect(snapshot.beta, 1.15);
        expect(snapshot.rSquared, .72);
        expect(snapshot.returns, hasLength(30));
        expect(snapshot.drawdowns, hasLength(30));
        expect(snapshot.monteCarloPaths, hasLength(3));
        expect(snapshot.correlationPoints, hasLength(10));
      },
    );

    test(
      'getCopyAuditLog pins the tab badge counts and retention years',
      () async {
        final snapshot = await repository.getCopyAuditLog(copyId: 'copy001');

        expect(snapshot.copyId, 'copy001');
        expect(snapshot.tabs, hasLength(5));
        expect(snapshot.tabs.first.id, 'all');
        expect(snapshot.tabs.first.badge, 7);
        expect(snapshot.events, hasLength(7));
        expect(snapshot.exportFormats, hasLength(3));
        expect(snapshot.retentionYears, 5);
      },
    );

    test('getPortfolioRiskAnalysis pins the exposure/VaR figures', () async {
      final snapshot = await repository.getPortfolioRiskAnalysis();

      expect(snapshot.totalExposure, 8000);
      expect(snapshot.var95, -273);
      expect(snapshot.var99, -424);
      expect(snapshot.diversificationScore, 93);
      expect(snapshot.assetExposures, hasLength(6));
      expect(snapshot.assetExposures.first.asset, 'BTC');
      expect(snapshot.riskAlerts, hasLength(3));
      expect(snapshot.tabs, hasLength(4));
      expect(snapshot.scenarios, hasLength(5));
    });

    test('previewCopyConfiguration reports ready with no blocking errors for '
        'a valid draft', () async {
      final found = await repository.getCopyConfiguration(providerId: 'ct001');
      final preview = await repository.previewCopyConfiguration(
        found.defaultDraft,
      );

      expect(preview.providerId, 'ct001');
      expect(preview.status, 'ready');
      expect(preview.hasBlockingErrors, isFalse);
      expect(preview.feePreview.platformFee, 5);
    });

    test('submitCopyConfirmation pins the audit trail id format and pending '
        'cooling-off status', () async {
      final found = await repository.getCopyConfirmation(providerId: 'ct001');
      final result = await repository.submitCopyConfirmation(
        TradeCopyConfirmationRequest(
          providerId: 'ct001',
          configuration: found.configuration,
          acceptedConsentIds: found.consentItems
              .map((item) => item.id)
              .toList(),
        ),
      );

      expect(result.providerId, 'ct001');
      expect(result.status, 'pending_cooling_off');
      expect(result.auditTrailId, 'AUD-COPY-073-CT001');
      expect(result.coolingOffHours, 24);
      expect(result.activeCopiesPath, '/trade/copy-trading/active');
    });

    test(
      'submitCopyConfirmation blocks when a required consent is missing',
      () async {
        final result = await repository.submitCopyConfirmation(
          const TradeCopyConfirmationRequest(
            providerId: 'ct001',
            configuration: TradeCopyConfigurationDraft(
              providerId: 'ct001',
              copyCapital: 5000,
              copyMode: TradeCopyConfigurationMode.fixed,
              positionSizing: TradePositionSizingMethod.percentage,
              copyRatio: 50,
              useCustomStopLoss: false,
              customStopLoss: 10,
              useCustomTakeProfit: false,
              customTakeProfit: 20,
              useTrailingStop: false,
              trailingStopPercent: 5,
            ),
            acceptedConsentIds: [],
          ),
        );

        expect(result.status, 'blocked');
        expect(result.coolingOffHours, 0);
      },
    );

    test(
      'createCopyAuditExport pins the export id format and download url',
      () async {
        final result = await repository.createCopyAuditExport(
          const TradeCopyAuditExportRequest(
            copyId: 'copy001',
            format: 'csv',
            filterId: 'all',
            searchQuery: '',
          ),
        );

        expect(result.exportId, 'EXP-COPY-AUDIT-077-COPY001');
        expect(result.format, 'csv');
        expect(result.status, 'ready');
        expect(result.downloadUrl, '/exports/copy-audit-copy001.csv');
      },
    );
  });
}
