import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

/// Repository-layer smoke test for [MockArenaRepository] under the
/// `test/features/<feature>/data/` convention (see
/// `test/features/p2p/data/mock_p2p_repository_orders_test.dart`).
///
/// Every method on [ArenaRepository] already gets an isA<>/isNotEmpty smoke
/// pass in the sibling `test/features/arena/mock_arena_repository_test.dart`.
/// This file complements that coverage by pinning concrete, hand-verified
/// values from `lib/features/arena/data/fixtures/arena_*_repository_methods.dart`
/// so a silent fixture edit shows up as a failing assertion. All methods on
/// [ArenaRepository] return `Future<T>` (GD4 async contract) — every test
/// awaits its call.
///
/// Split by behavior group (mirrors the production `_MockArenaRepository*
/// Methods` mixin split): this file covers the internal flow-map,
/// production-readiness, cross-module prediction bridge, and connected
/// ecosystem/guide surfaces. See
/// `mock_arena_repository_home_discovery_test.dart` and
/// `mock_arena_repository_points_social_test.dart` for the remaining
/// method groups.
///
/// Product boundary: the bridge fixture explicitly enumerates what may
/// *not* cross the Prediction<->Arena boundary (wallet balance, PnL, open
/// orders, payout value, order receipt, points conversion, shared
/// settlement) — this file pins that boundary list rather than
/// re-deriving it, so a regression that quietly removes an entry fails
/// loudly here.
void main() {
  const repository = MockArenaRepository(loadDelay: Duration.zero);

  group('MockArenaRepository ecosystem data smoke test', () {
    test('getArenaFlowMap pins the stats, route, and QA item counts', () async {
      final snapshot = await repository.getArenaFlowMap();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-flow-map');
      expect(snapshot.stats, hasLength(4));
      expect(snapshot.routes, hasLength(10));
      expect(snapshot.routes.first.path, '/arena');
      expect(snapshot.groups, hasLength(5));
      expect(snapshot.components, hasLength(4));
      expect(snapshot.qaItems, hasLength(8));
      expect(
        snapshot.disclaimer,
        'Arena Points stay inside Open Arena; not a trading account or '
        'prediction performance. No off-platform agreements.',
      );
    });

    test(
      'getArenaProductionReady pins the canonical screen/flow counts',
      () async {
        final snapshot = await repository.getArenaProductionReady();

        expect(snapshot.endpoint, '/api/mobile/arena/arena-production');
        expect(snapshot.canonicalScreens, hasLength(7));
        expect(snapshot.canonicalScreens.first.name, 'ArenaHomePage');
        expect(snapshot.supportingScreens, hasLength(7));
        expect(snapshot.flows, hasLength(3));
        expect(snapshot.components, hasLength(4));
        expect(snapshot.qaItems, hasLength(7));
      },
    );

    test('getArenaPredictionBridge pins the allowed/not-allowed cross-module '
        'boundary lists', () async {
      final snapshot = await repository.getArenaPredictionBridge();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-bridge');
      expect(snapshot.principles, hasLength(6));
      expect(snapshot.allowedItems, hasLength(6));
      expect(snapshot.allowedItems.every((item) => item.allowed), isTrue);
      expect(snapshot.notAllowedItems, hasLength(7));
      expect(
        snapshot.notAllowedItems.map((item) => item.label),
        containsAll(<String>[
          'Wallet balance',
          'PnL',
          'Open orders',
          'Payout value',
          'Order receipt',
          'Points conversion',
          'Shared settlement',
        ]),
      );
      expect(snapshot.notAllowedItems.every((item) => !item.allowed), isTrue);
    });

    test('getConnectedEcosystemProduction pins the canonical screen/route '
        'registry counts', () async {
      final snapshot = await repository.getConnectedEcosystemProduction();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-ecosystem');
      expect(snapshot.canonicalScreens, hasLength(9));
      expect(snapshot.canonicalScreens.first.name, 'HomePage_vFinal_Connected');
      expect(snapshot.bridgeStates, hasLength(8));
      expect(snapshot.routeRegistry, hasLength(9));
    });

    test(
      'getArenaGuide pins the hero copy and create/join step counts',
      () async {
        final snapshot = await repository.getArenaGuide();

        expect(snapshot.endpoint, '/api/mobile/arena/arena-guide');
        expect(snapshot.heroTitle, 'Tạo challenge đầu tiên trong 5 phút');
        expect(snapshot.createSteps, hasLength(6));
        expect(snapshot.joinSteps, hasLength(4));
        expect(snapshot.faqs, hasLength(6));
        expect(snapshot.faqs.first.question, 'Arena Points là gì?');
      },
    );
  });
}
