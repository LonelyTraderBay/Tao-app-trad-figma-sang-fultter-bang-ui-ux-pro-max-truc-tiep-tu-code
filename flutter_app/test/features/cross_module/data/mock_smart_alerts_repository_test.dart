import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_smart_alerts_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/smart_alerts_entities.dart';

/// Direct smoke test for [MockSmartAlertsRepository]: exercises the single
/// method on [SmartAlertsRepository] (getCenter) and pins the fixture and
/// derived-aggregate literals from
/// lib/features/cross_module/data/repositories/mock_smart_alerts_repository.dart,
/// which test/features/cross_module/mock_smart_alerts_repository_test.dart
/// only asserts the shape of (greaterThan(0)/hasLength).
void main() {
  const repository = MockSmartAlertsRepository();

  group('MockSmartAlertsRepository smoke test', () {
    test('getCenter pins the endpoint and alert/history/channel fixture', () {
      final snapshot = repository.getCenter();

      expect(snapshot, isA<SmartAlertsSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/cross-module/smart-alerts');
      expect(snapshot.backRoute, '/home');
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.alerts, hasLength(7));
      expect(snapshot.alerts.first.id, 'a1');
      expect(snapshot.alerts.last.status, SmartAlertStatus.paused);

      expect(snapshot.history, hasLength(3));
      expect(snapshot.history.first.id, 'h1');

      expect(snapshot.channels, hasLength(3));
      expect(snapshot.channels.last.enabled, isFalse);

      expect(snapshot.templates, hasLength(7));
      expect(snapshot.templates.first.id, 't1');
    });

    test('getCenter pins the derived aggregate stats', () {
      final snapshot = repository.getCenter();

      expect(snapshot.activeCount, 6);
      expect(snapshot.totalTriggers, 36);
      expect(snapshot.moduleCount, 6);
    });
  });
}
