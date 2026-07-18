import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_tax_report_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/tax_report_entities.dart';

/// Direct smoke test for [MockTaxReportRepository]: exercises the single
/// method on [TaxReportRepository] (getCenter) and pins the fixture and
/// derived-aggregate literals from
/// lib/features/cross_module/data/repositories/mock_tax_report_repository.dart,
/// which test/features/cross_module/mock_tax_report_repository_test.dart
/// only asserts the shape of (greaterThan(0)/hasLength).
void main() {
  const repository = MockTaxReportRepository(loadDelay: Duration.zero);

  group('MockTaxReportRepository smoke test', () {
    test('getCenter pins the endpoint and activity/report/jurisdiction '
        'fixture', () async {
      final snapshot = await repository.getCenter();

      expect(snapshot, isA<TaxReportSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/cross-module/tax-reports');
      expect(
        snapshot.exportEndpoint,
        '/api/mobile/cross-module/tax-reports/exports',
      );
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.activities, hasLength(6));

      final arena = snapshot.activities.last;
      expect(arena.module, TaxActivityModuleId.arena);
      expect(arena.taxable, isFalse);

      expect(snapshot.reports, hasLength(3));
      expect(snapshot.reports.first.id, 'r1');
      expect(snapshot.reports.first.totalGainLoss, 5955);

      expect(snapshot.jurisdictions, hasLength(6));
      expect(snapshot.jurisdictions.first.id, 'us');
    });

    test('getCenter pins the derived aggregate stats', () async {
      final snapshot = await repository.getCenter();

      expect(snapshot.taxableActivities, hasLength(4));
      expect(snapshot.totalGainLoss, 5955);
      expect(snapshot.totalTransactions, 449);
      expect(snapshot.taxableModules, 4);
    });
  });
}
