import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_smart_alerts_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/smart_alerts_entities.dart';

/// Smoke test for [MockSmartAlertsRepository]: exercises
/// [MockSmartAlertsRepository.getCenter] and asserts the call succeeds
/// without throwing and returns a plausible, non-empty result.
void main() {
  const repository = MockSmartAlertsRepository(loadDelay: Duration.zero);

  group('MockSmartAlertsRepository smoke test', () {
    test('getCenter returns a populated snapshot', () async {
      final snapshot = await repository.getCenter();

      expect(snapshot, isA<SmartAlertsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.alerts, hasLength(7));
      expect(snapshot.alerts.first.id, 'a1');
      expect(snapshot.history, hasLength(3));
      expect(snapshot.channels, hasLength(3));
      expect(snapshot.templates, hasLength(7));
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getCenter derived stats can be computed without throwing', () async {
      final snapshot = await repository.getCenter();

      expect(snapshot.activeCount, greaterThan(0));
      expect(snapshot.totalTriggers, greaterThan(0));
      expect(snapshot.moduleCount, greaterThan(0));
    });
  });
}
