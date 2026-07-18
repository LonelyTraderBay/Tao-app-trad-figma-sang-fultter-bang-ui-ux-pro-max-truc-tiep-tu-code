import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/enterprise_states/data/repositories/mock_enterprise_states_repository.dart';
import 'package:vit_trade_flutter/features/enterprise_states/domain/entities/enterprise_states_entities.dart';
import 'package:vit_trade_flutter/features/enterprise_states/domain/repositories/enterprise_states_repository.dart';

/// Smoke test for [MockEnterpriseStatesRepository]: exercises every method
/// on [EnterpriseStatesRepository] and asserts each call succeeds without
/// throwing and returns a plausible, non-empty result.
void main() {
  const repository = MockEnterpriseStatesRepository(loadDelay: Duration.zero);

  group('MockEnterpriseStatesRepository smoke test', () {
    test('getReference returns a populated snapshot', () async {
      final snapshot = await repository.getReference();

      expect(snapshot, isA<EnterpriseStatesSnapshot>());
      expect(
        snapshot.endpoint,
        '/api/mobile/enterprise-states/enterprise-states',
      );
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.subtitle, isNotEmpty);
      expect(snapshot.backRoute, '/home');
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.previewStates, hasLength(5));
      expect(snapshot.banners, isNotEmpty);
      expect(snapshot.marketRoute, isNotEmpty);
      expect(snapshot.kycRoute, isNotEmpty);
      expect(snapshot.securityRoute, isNotEmpty);
      expect(snapshot.loginRoute, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(
        snapshot.supportedStates,
        containsAll([
          EnterpriseStatesScreenState.loading,
          EnterpriseStatesScreenState.empty,
          EnterpriseStatesScreenState.error,
          EnterpriseStatesScreenState.offline,
        ]),
      );
    });

    test('getReference does not throw across repeated calls', () async {
      await repository.getReference();
      await repository.getReference();
    });
  });
}
