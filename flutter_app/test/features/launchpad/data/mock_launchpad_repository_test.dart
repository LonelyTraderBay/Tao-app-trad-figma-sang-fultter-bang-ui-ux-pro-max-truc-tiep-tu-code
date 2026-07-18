import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';

/// Smoke test for [MockLaunchpadRepository]: exercises every method on
/// [LaunchpadRepository] and asserts each call succeeds without throwing and
/// returns a plausible, correctly-typed result.
///
/// GD4-F4: every method is now `Future<T>` (ADR-001 read idiom) — tests
/// `await` with `loadDelay: Duration.zero`. See
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md.
void main() {
  const repository = MockLaunchpadRepository(loadDelay: Duration.zero);

  group('MockLaunchpadRepository smoke test', () {
    test('getHome returns a populated snapshot', () async {
      final snapshot = await repository.getHome();

      expect(snapshot, isA<LaunchpadHomeSnapshot>());
      expect(snapshot.projects, isNotEmpty);
      expect(snapshot.advancedTools, isNotEmpty);
      expect(snapshot.riskTools, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getDetail returns the matching project for a known id', () async {
      final snapshot = await repository.getDetail('proj1');

      expect(snapshot, isA<LaunchpadDetailSnapshot>());
      expect(snapshot.projectId, 'proj1');
      expect(snapshot.project, isNotNull);
      expect(snapshot.project?.id, 'proj1');
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getDetail does not throw for an unknown id and falls back to a '
        'null project', () async {
      final snapshot = await repository.getDetail('does-not-exist');

      expect(snapshot, isA<LaunchpadDetailSnapshot>());
      expect(snapshot.project, isNull);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getPortfolio returns a populated snapshot', () async {
      final snapshot = await repository.getPortfolio();

      expect(snapshot, isA<LaunchpadPortfolioSnapshot>());
      expect(snapshot.subscriptions, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getReceipt returns the matching subscription for a known id',
      () async {
        final snapshot = await repository.getReceipt('sub1');

        expect(snapshot, isA<LaunchpadReceiptSnapshot>());
        expect(snapshot.subscriptionId, 'sub1');
        expect(snapshot.subscription, isNotNull);
        expect(snapshot.subscription?.id, 'sub1');
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test('getReceipt does not throw for an unknown id and falls back to a '
        'null subscription', () async {
      final snapshot = await repository.getReceipt('does-not-exist');

      expect(snapshot, isA<LaunchpadReceiptSnapshot>());
      expect(snapshot.subscription, isNull);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getPerformance returns a populated snapshot', () async {
      final snapshot = await repository.getPerformance();

      expect(snapshot, isA<LaunchpadPerformanceSnapshot>());
      expect(snapshot.projects, isNotEmpty);
      expect(snapshot.chartPoints, isNotEmpty);
      expect(snapshot.summary.totalProjects, greaterThan(0));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getStaking returns a populated snapshot', () async {
      final snapshot = await repository.getStaking();

      expect(snapshot, isA<LaunchpadStakingSnapshot>());
      expect(snapshot.pools, isNotEmpty);
      expect(snapshot.positions, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getBatchClaim returns a populated snapshot', () async {
      final snapshot = await repository.getBatchClaim();

      expect(snapshot, isA<LaunchpadBatchClaimSnapshot>());
      expect(snapshot.positions, isNotEmpty);
      expect(snapshot.summary.chains, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getClaimReceipt returns the matching receipt for a known position id',
      () async {
        final snapshot = await repository.getClaimReceipt('sp1');

        expect(snapshot, isA<LaunchpadClaimReceiptSnapshot>());
        expect(snapshot.positionId, 'sp1');
        expect(snapshot.receipt.positionId, 'sp1');
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test('getClaimReceipt does not throw for an unknown position id and '
        'falls back to the first receipt', () async {
      final snapshot = await repository.getClaimReceipt('does-not-exist');

      expect(snapshot, isA<LaunchpadClaimReceiptSnapshot>());
      expect(snapshot.positionId, 'does-not-exist');
      expect(snapshot.receipt, isNotNull);
    });

    test('getIdoBridge returns the matching project for a known id', () async {
      final snapshot = await repository.getIdoBridge('proj1');

      expect(snapshot, isA<LaunchpadIdoBridgeSnapshot>());
      expect(snapshot.projectId, 'proj1');
      expect(snapshot.project, isNotNull);
      expect(snapshot.sourceNetworks, isNotEmpty);
      expect(snapshot.routes, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getIdoBridge does not throw for an unknown id and falls back to a '
        'null project', () async {
      final snapshot = await repository.getIdoBridge('does-not-exist');

      expect(snapshot, isA<LaunchpadIdoBridgeSnapshot>());
      expect(snapshot.project, isNull);
    });

    test('getBridgeCompare returns a populated snapshot', () async {
      final snapshot = await repository.getBridgeCompare();

      expect(snapshot, isA<LaunchpadBridgeCompareSnapshot>());
      expect(snapshot.comparison.routes, isNotEmpty);
      expect(snapshot.sortOptions, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getNotifSound returns a populated snapshot', () async {
      final snapshot = await repository.getNotifSound();

      expect(snapshot, isA<LaunchpadNotifSoundSnapshot>());
      expect(snapshot.categories, isNotEmpty);
      expect(snapshot.soundTypes, isNotEmpty);
      expect(snapshot.masterEnabled, isTrue);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getEventLog returns a populated snapshot', () async {
      final snapshot = await repository.getEventLog();

      expect(snapshot, isA<LaunchpadEventLogSnapshot>());
      expect(snapshot.events, isNotEmpty);
      expect(snapshot.exportFormats, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getAbiDiff returns a populated snapshot for a known contract id',
      () async {
        final snapshot = await repository.getAbiDiff('contract001');

        expect(snapshot, isA<LaunchpadAbiDiffSnapshot>());
        expect(snapshot.contractId, 'contract001');
        expect(snapshot.diff.entries, isNotEmpty);
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test(
      'getAbiDiff falls back to a default contract id for an empty id',
      () async {
        final snapshot = await repository.getAbiDiff('');

        expect(snapshot.contractId, 'contract001');
      },
    );

    test('getAddressBook returns a populated snapshot', () async {
      final snapshot = await repository.getAddressBook();

      expect(snapshot, isA<LaunchpadAddressBookSnapshot>());
      expect(snapshot.addresses, isNotEmpty);
      expect(snapshot.chainFilters, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getWebhooks returns a populated snapshot', () async {
      final snapshot = await repository.getWebhooks();

      expect(snapshot, isA<LaunchpadWebhooksSnapshot>());
      expect(snapshot.subscriptions, isNotEmpty);
      expect(snapshot.deliveries, isNotEmpty);
      expect(snapshot.eventTypes, isNotEmpty);
      expect(snapshot.tabs, hasLength(2));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getGasTracker returns a populated snapshot', () async {
      final snapshot = await repository.getGasTracker();

      expect(snapshot, isA<LaunchpadGasTrackerSnapshot>());
      expect(snapshot.prices, isNotEmpty);
      expect(snapshot.estimates, isNotEmpty);
      expect(snapshot.alerts, isNotEmpty);
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getRebalance returns a populated snapshot', () async {
      final snapshot = await repository.getRebalance();

      expect(snapshot, isA<LaunchpadRebalanceSnapshot>());
      expect(snapshot.assets, isNotEmpty);
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.defaultStrategyId, 'moderate');
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getMultisig returns a populated snapshot', () async {
      final snapshot = await repository.getMultisig();

      expect(snapshot, isA<LaunchpadMultisigSnapshot>());
      expect(snapshot.safes, isNotEmpty);
      expect(snapshot.transactions, isNotEmpty);
      expect(snapshot.defaultSafeAddress, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getSwapAggregator returns a populated snapshot', () async {
      final snapshot = await repository.getSwapAggregator();

      expect(snapshot, isA<LaunchpadSwapAggregatorSnapshot>());
      expect(snapshot.dexQuotes, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.fromToken, 'USDT');
      expect(snapshot.toToken, 'ARB');
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getLimitOrders returns a populated snapshot', () async {
      final snapshot = await repository.getLimitOrders();

      expect(snapshot, isA<LaunchpadLimitOrdersSnapshot>());
      expect(snapshot.orders, isNotEmpty);
      expect(snapshot.filled24h, greaterThanOrEqualTo(0));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getDcaBuilder returns a populated snapshot', () async {
      final snapshot = await repository.getDcaBuilder();

      expect(snapshot, isA<LaunchpadDcaBuilderSnapshot>());
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.executions, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getRiskAnalytics returns a populated snapshot', () async {
      final snapshot = await repository.getRiskAnalytics();

      expect(snapshot, isA<LaunchpadRiskAnalyticsSnapshot>());
      expect(snapshot.comparisonProjects, isNotEmpty);
      expect(snapshot.auditReports, isNotEmpty);
      expect(snapshot.resources, isNotEmpty);
      expect(snapshot.metrics, hasLength(6));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getBridgeOrder returns a populated snapshot for a tx id', () async {
      final snapshot = await repository.getBridgeOrder('tx001');

      expect(snapshot, isA<LaunchpadBridgeOrderSnapshot>());
      expect(snapshot.txId, 'tx001');
      expect(snapshot.order, isNotNull);
      expect(snapshot.events, isNotEmpty);
      expect(snapshot.highRiskContractId, isNotNull);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getContract returns the matching project for a known id', () async {
      final snapshot = await repository.getContract('proj1');

      expect(snapshot, isA<LaunchpadContractSnapshot>());
      expect(snapshot.projectId, 'proj1');
      expect(snapshot.project, isNotNull);
      expect(snapshot.networks, isNotEmpty);
      expect(snapshot.functions, isNotEmpty);
      expect(snapshot.simulations, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getContract does not throw for an unknown id and falls back to a '
        'null project', () async {
      final snapshot = await repository.getContract('does-not-exist');

      expect(snapshot, isA<LaunchpadContractSnapshot>());
      expect(snapshot.project, isNull);
    });
  });
}
