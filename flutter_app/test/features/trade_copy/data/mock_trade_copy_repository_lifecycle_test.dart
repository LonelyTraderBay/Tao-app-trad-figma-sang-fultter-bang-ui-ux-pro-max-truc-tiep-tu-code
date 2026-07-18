import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
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
/// `lib/features/trade_copy/data/fixtures/trade_copy_lifecycle_repository_*.dart`
/// so a silent fixture edit shows up as a failing assertion.
///
/// GD4-F3: every method is `Future<T>` — mock simulates network latency via
/// `loadDelay`; tests pass `Duration.zero` (see
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md).
///
/// Split by behavior group (mirrors the production repository's own
/// provider-discovery / configuration / lifecycle mixin split): this file
/// covers the copy-trading lifecycle and safety surfaces. See
/// `mock_trade_copy_repository_provider_discovery_test.dart` and
/// `mock_trade_copy_repository_configuration_test.dart` for the remaining
/// method groups.
///
/// High-risk flow: `getCopyTrading()` is the entry-stage screen binding
/// for `HighRiskFlowContractIds.tradeCopy` (see
/// `test/fixtures/high_risk_flow_binding.dart`), so this file pins the
/// exact `highRiskContractId` value per
/// `test/quality/high_risk_state_primitives_guardrail_test.dart`'s
/// allowlist expectations.
void main() {
  const repository = MockTradeCopyTradingRepository(loadDelay: Duration.zero);

  group('MockTradeCopyTradingRepository lifecycle data smoke test', () {
    test(
      'getCopyTrading pins the tradeCopy high-risk contract id and totals',
      () async {
        final snapshot = await repository.getCopyTrading();

        expect(snapshot.highRiskContractId, HighRiskFlowContractIds.tradeCopy);
        expect(snapshot.highRiskContractId, 'trade_copy');
        expect(snapshot.traders, hasLength(5));
        expect(snapshot.sortOptions, hasLength(4));
        expect(snapshot.totalCopiers, 11013);
        expect(snapshot.aumTrendPct, 12.3);
        expect(snapshot.riskWarningTitle, 'Cảnh báo rủi ro');
      },
    );

    test('getCopyCardDemo pins the metrics and variant/issue counts', () async {
      final snapshot = await repository.getCopyCardDemo();

      expect(snapshot.endpoint, '/api/mobile/demo/demo-copy-card');
      expect(snapshot.metrics.traders, 5);
      expect(snapshot.metrics.copiers, 11000);
      expect(snapshot.metrics.aumUsd, 19250000);
      expect(snapshot.variants, hasLength(3));
      expect(snapshot.variants.first.id, 'hero');
      expect(snapshot.issues, hasLength(7));
    });

    test(
      'getCopyEducation pins the tab/step/mode-guide/concept counts',
      () async {
        final snapshot = await repository.getCopyEducation();

        expect(snapshot.tabs, hasLength(5));
        expect(snapshot.defaultTab, 'how-it-works');
        expect(snapshot.steps, hasLength(4));
        expect(snapshot.copyModes, hasLength(3));
        expect(snapshot.copyModes.first.title, 'Mirror Copy');
        expect(snapshot.concepts, hasLength(4));
      },
    );

    test('getActiveCopies pins the portfolio totals and copy count', () async {
      final snapshot = await repository.getActiveCopies();

      expect(snapshot.portfolio.totalCapital, 10000);
      expect(snapshot.portfolio.totalValue, 10500);
      expect(snapshot.portfolio.totalPnl, 500);
      expect(snapshot.portfolio.activeCopies, 2);
      expect(snapshot.tabs, hasLength(4));
      expect(snapshot.defaultTab, 'all');
      expect(snapshot.copies, hasLength(3));
      expect(snapshot.copies.first.id, 'copy-1');
      expect(snapshot.copies.first.status, TradeActiveCopyStatus.active);
    });

    test(
      'getCopySettings pins the default copy ratio and stop/take-profit',
      () async {
        final snapshot = await repository.getCopySettings();

        expect(snapshot.settings.defaultCopyRatio, 50);
        expect(snapshot.settings.defaultStopLoss, 10);
        expect(snapshot.settings.defaultTakeProfit, 20);
        expect(snapshot.settings.maxCopiesActive, 5);
        expect(snapshot.settings.enableCircuitBreaker, isTrue);
      },
    );

    test(
      'getCopyNotifications pins the unread count and tab badge shape',
      () async {
        final snapshot = await repository.getCopyNotifications();

        expect(snapshot.notifications, hasLength(7));
        expect(snapshot.tabs, hasLength(6));
        expect(snapshot.tabs.first.id, 'all');
        expect(snapshot.tabs.first.badge, 3);
        expect(snapshot.notifications.where((n) => !n.read), hasLength(3));
      },
    );

    test('getSafetyEducation pins the scam/red-flag/tier counts', () async {
      final snapshot = await repository.getSafetyEducation();

      expect(snapshot.tabs, hasLength(4));
      expect(snapshot.defaultTabId, 'scams');
      expect(snapshot.scams, hasLength(5));
      expect(snapshot.redFlags, hasLength(8));
      expect(snapshot.verificationTiers, hasLength(3));
      expect(snapshot.reportReasons, hasLength(5));
    });

    test(
      'getDisputeResolution pins the active/history case counts and badges',
      () async {
        final snapshot = await repository.getDisputeResolution();

        expect(snapshot.tabs, hasLength(3));
        expect(snapshot.tabs[1].badgeCount, 1);
        expect(snapshot.tabs[2].badgeCount, 1);
        expect(snapshot.complaintTypes, hasLength(5));
        expect(snapshot.providers, hasLength(3));
        expect(snapshot.activeCases, hasLength(1));
        expect(snapshot.activeCases.first.id, 'case-001');
        expect(snapshot.resolvedCases, hasLength(1));
        expect(snapshot.resolvedCases.first.outcome, 'refund');
      },
    );

    test(
      'getCopySafetyCenter pins the verification-tier and tool counts',
      () async {
        final snapshot = await repository.getCopySafetyCenter();

        expect(snapshot.tabs, hasLength(5));
        expect(snapshot.defaultTabId, 'verification');
        expect(snapshot.verificationTiers, hasLength(3));
        expect(snapshot.trustMetrics, hasLength(4));
        expect(snapshot.prohibitedBehaviors, hasLength(7));
        expect(snapshot.followerResponsibilities, hasLength(6));
        expect(snapshot.reportingSteps, hasLength(4));
        expect(snapshot.safetyTools, hasLength(3));
        expect(snapshot.enforcementActions, hasLength(3));
      },
    );

    test(
      'patchCopySettings echoes the saved settings with status saved',
      () async {
        final snapshot = await repository.getCopySettings();
        final updated = snapshot.settings.copyWith(defaultCopyRatio: 60);
        final result = await repository.patchCopySettings(updated);

        expect(result.status, 'saved');
        expect(result.settings.defaultCopyRatio, 60);
      },
    );

    test('submitDisputeComplaint returns the fixed demo case id', () async {
      final result = await repository.submitDisputeComplaint(
        const TradeDisputeComplaintDraft(
          complaintType: 'execution_issue',
          providerId: 'trader-2',
          subject: 'Excessive slippage',
          description: 'Provider executed at a materially different price.',
        ),
      );

      expect(result.caseId, 'case-003');
      expect(result.status, 'submitted');
      expect(result.message, 'Complaint submitted successfully');
    });

    test(
      'submitCopyTradingAction echoes the requested provider/action',
      () async {
        final result = await repository.submitCopyTradingAction(
          const TradeCopyActionRequest(providerId: 'ct001', action: 'follow'),
        );

        expect(result.providerId, 'ct001');
        expect(result.action, 'follow');
        expect(result.status, 'accepted');
      },
    );
  });
}
