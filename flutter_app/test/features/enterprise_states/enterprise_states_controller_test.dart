import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/enterprise_states/data/repositories/mock_enterprise_states_repository.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/controllers/enterprise_states_controller.dart';

void main() {
  group('EnterpriseStatesController', () {
    test('exposes reference snapshot through repository contract', () {
      final controller = const EnterpriseStatesController(
        MockEnterpriseStatesRepository(),
      );

      final snapshot = controller.reference();

      expect(
        snapshot.endpoint,
        '/api/mobile/enterprise-states/enterprise-states',
      );
      expect(snapshot.tabs.map((tab) => tab.section), [
        EnterpriseStateSection.stateKit,
        EnterpriseStateSection.applied,
        EnterpriseStateSection.security,
      ]);
      expect(
        snapshot.previewStates.map((state) => state.state),
        contains(EnterprisePreviewState.gate),
      );
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
  });
}
