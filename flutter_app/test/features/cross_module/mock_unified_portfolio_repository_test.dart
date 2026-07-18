import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_unified_portfolio_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';

/// Smoke test for [MockUnifiedPortfolioRepository]: exercises
/// [MockUnifiedPortfolioRepository.getDashboard] and asserts the call
/// succeeds without throwing and returns a plausible, non-empty result.
void main() {
  const repository = MockUnifiedPortfolioRepository(loadDelay: Duration.zero);

  group('MockUnifiedPortfolioRepository smoke test', () {
    test('getDashboard returns a populated snapshot', () async {
      final snapshot = await repository.getDashboard();

      expect(snapshot, isA<UnifiedPortfolioSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.modules, hasLength(6));
      expect(snapshot.modules.first.id, UnifiedPortfolioModuleId.wallet);
      expect(snapshot.history, hasLength(6));
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getDashboard derived stats can be computed without throwing',
      () async {
        final snapshot = await repository.getDashboard();

        expect(snapshot.financialModules, isNotEmpty);
        expect(snapshot.totalValue, greaterThan(0));
        expect(snapshot.totalPositions, greaterThan(0));
        expect(snapshot.activeModules, greaterThan(0));
      },
    );

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
