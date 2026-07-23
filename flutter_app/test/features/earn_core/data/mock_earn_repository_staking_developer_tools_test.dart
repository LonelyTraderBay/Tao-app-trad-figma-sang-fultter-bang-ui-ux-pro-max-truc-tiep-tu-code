import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';

/// Smoke test for the staking developer/operator tooling mocks: exercises
/// [MockStakingWebhooksRepository], [MockStakingDataExportRepository],
/// [MockStakingThirdPartyIntegrationsRepository],
/// [MockStakingDeveloperConsoleRepository],
/// [MockStakingAdvancedOrdersRepository], [MockStakingMultiChainRepository],
/// and [MockStakingInstitutionalRepository], asserting each call succeeds
/// without throwing and returns a plausible, non-empty result.
void main() {
  const webhooksRepo = MockStakingWebhooksRepository();
  const dataExportRepo = MockStakingDataExportRepository();
  const integrationsRepo = MockStakingThirdPartyIntegrationsRepository();
  const consoleRepo = MockStakingDeveloperConsoleRepository();
  const advancedOrdersRepo = MockStakingAdvancedOrdersRepository();
  const multiChainRepo = MockStakingMultiChainRepository();
  const institutionalRepo = MockStakingInstitutionalRepository();

  group('Earn staking developer tools mocks smoke test', () {
    test('getWebhooks returns a populated webhooks snapshot', () async {
      final snapshot = await webhooksRepo.getWebhooks();

      expect(snapshot, isA<StakingWebhooksSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'Webhooks');
      expect(snapshot.heroTitle, isNotEmpty);
      expect(snapshot.createLabel, isNotEmpty);
      expect(snapshot.webhooks, hasLength(3));
      expect(snapshot.availableEvents, hasLength(6));
      expect(snapshot.sheetTitle, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getDataExport returns a populated data export snapshot', () async {
      final snapshot = await dataExportRepo.getDataExport();

      expect(snapshot, isA<StakingDataExportSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'Data Export');
      expect(snapshot.quickExports, hasLength(4));
      expect(snapshot.formatOptions, containsAll(['CSV', 'JSON', 'PDF']));
      expect(snapshot.defaultFormat, 'CSV');
      expect(snapshot.exportLabel, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getIntegrations returns a populated third-party integrations '
        'snapshot', () async {
      final snapshot = await integrationsRepo.getIntegrations();

      expect(snapshot, isA<StakingThirdPartyIntegrationsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'Integrations');
      expect(snapshot.integrations, hasLength(6));
      expect(snapshot.apiTitle, isNotEmpty);
      expect(snapshot.apiDocsRoute, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getConsole returns a populated developer console snapshot', () async {
      final snapshot = await consoleRepo.getConsole();

      expect(snapshot, isA<StakingDeveloperConsoleSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'Developer Console');
      expect(snapshot.defaultTab, 'keys');
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.stats, hasLength(3));
      expect(snapshot.keysTitle, isNotEmpty);
      expect(snapshot.apiKeys, hasLength(2));
      expect(snapshot.createKeyLabel, isNotEmpty);
      expect(snapshot.recentRequests, hasLength(3));
      expect(snapshot.docs, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getAdvancedOrders returns a populated advanced orders snapshot',
      () async {
        final snapshot = await advancedOrdersRepo.getAdvancedOrders();

        expect(snapshot, isA<StakingAdvancedOrdersSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.title, 'Advanced Orders');
        expect(snapshot.activeOrders, hasLength(3));
        expect(snapshot.orderHistory, hasLength(2));
        expect(snapshot.statCards, hasLength(3));
        expect(snapshot.orderTypeOptions, hasLength(3));
        expect(snapshot.assetOptions, isNotEmpty);
        expect(snapshot.orderTypeWarnings, hasLength(3));
        expect(snapshot.howItWorks, hasLength(3));
        expect(snapshot.riskTitle, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test('getMultiChain returns a populated multi-chain snapshot', () async {
      final snapshot = await multiChainRepo.getMultiChain();

      expect(snapshot, isA<StakingMultiChainSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'Multi-Chain Portfolio');
      expect(snapshot.totalValue, greaterThan(0));
      expect(snapshot.avgApy, greaterThan(0));
      expect(snapshot.activeChains, 5);
      expect(snapshot.positions, hasLength(5));
      expect(snapshot.quickActions, isNotEmpty);
      expect(snapshot.benefits, isNotEmpty);
      expect(snapshot.technicalNote, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getInstitutional returns a populated institutional snapshot',
      () async {
        final snapshot = await institutionalRepo.getInstitutional();

        expect(snapshot, isA<StakingInstitutionalSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.title, 'Institutional Dashboard');
        expect(snapshot.stats, hasLength(3));
        expect(snapshot.pendingBatches, hasLength(2));
        expect(snapshot.executedBatches, hasLength(2));
        expect(snapshot.signers, hasLength(3));
        expect(snapshot.features, isNotEmpty);
        expect(snapshot.complianceTitle, isNotEmpty);
        expect(snapshot.operationTypes, isNotEmpty);
        expect(snapshot.csvFormatNote, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );
  });
}
