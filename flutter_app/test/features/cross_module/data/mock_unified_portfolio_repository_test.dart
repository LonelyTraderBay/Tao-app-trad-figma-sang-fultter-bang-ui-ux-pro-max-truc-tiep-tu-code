import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_unified_portfolio_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';

/// Direct smoke test for [MockUnifiedPortfolioRepository]: exercises the
/// single method on [UnifiedPortfolioRepository] (getDashboard) and pins the
/// fixture and derived-aggregate literals from
/// lib/features/cross_module/data/repositories/mock_unified_portfolio_repository.dart,
/// which
/// test/features/cross_module/mock_unified_portfolio_repository_test.dart
/// only asserts the shape of (greaterThan(0)/hasLength).
void main() {
  const repository = MockUnifiedPortfolioRepository(loadDelay: Duration.zero);

  group('MockUnifiedPortfolioRepository smoke test', () {
    test('getDashboard pins the endpoint and module/history fixture', () async {
      final snapshot = await repository.getDashboard();

      expect(snapshot, isA<UnifiedPortfolioSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/cross-module/unified-portfolio');
      expect(snapshot.backRoute, '/home');
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.modules, hasLength(6));

      final wallet = snapshot.modules.first;
      expect(wallet.id, UnifiedPortfolioModuleId.wallet);
      expect(wallet.value, 45280);
      expect(wallet.route, '/wallet');

      expect(snapshot.history, hasLength(6));
      expect(snapshot.history.first.label, 'Jan');
      expect(snapshot.history.last.label, 'Now');
    });

    test('getDashboard pins the derived aggregate stats', () async {
      final snapshot = await repository.getDashboard();

      expect(snapshot.financialModules, hasLength(5));
      expect(snapshot.totalValue, 102380);
      expect(snapshot.totalPnl, 2995);
      expect(snapshot.totalPositions, 36);
      expect(snapshot.activeModules, 6);
    });

    test('getDashboard keeps the Arena module points-only', () async {
      final snapshot = await repository.getDashboard();
      final arenaModule = snapshot.modules.firstWhere(
        (module) => module.id == UnifiedPortfolioModuleId.arena,
      );

      expect(arenaModule.pointsOnly, isTrue);
      expect(arenaModule.value, 0);
    });
  });
}
