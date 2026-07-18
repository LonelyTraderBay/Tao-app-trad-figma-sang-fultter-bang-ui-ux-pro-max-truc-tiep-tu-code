import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_tax_report_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/tax_report_entities.dart';

/// Smoke test for [MockTaxReportRepository]: exercises
/// [MockTaxReportRepository.getCenter] and asserts the call succeeds
/// without throwing and returns a plausible, non-empty result.
void main() {
  const repository = MockTaxReportRepository(loadDelay: Duration.zero);

  group('MockTaxReportRepository smoke test', () {
    test('getCenter returns a populated snapshot', () async {
      final snapshot = await repository.getCenter();

      expect(snapshot, isA<TaxReportSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.exportEndpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.activities, hasLength(6));
      expect(snapshot.reports, hasLength(3));
      expect(snapshot.jurisdictions, hasLength(6));
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getCenter derived stats can be computed without throwing', () async {
      final snapshot = await repository.getCenter();

      expect(snapshot.taxableActivities, isNotEmpty);
      expect(snapshot.totalGainLoss, greaterThan(0));
      expect(snapshot.totalTransactions, greaterThan(0));
      expect(snapshot.taxableModules, greaterThan(0));
    });
  });
}
