import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  testWidgets('VitHighRiskStatePanel renders every high-risk UI state', (
    tester,
  ) async {
    for (final state in VitHighRiskUiState.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VitHighRiskStatePanel(
              state: state,
              title: 'State ${state.name}',
              message: 'Shared high-risk state message',
              contractId: 'contract.${state.name}',
              onAction: () {},
            ),
          ),
        ),
      );

      expect(find.text('State ${state.name}'), findsOneWidget);
      expect(
        find.textContaining('Shared high-risk state message'),
        findsOneWidget,
      );
      if (state != VitHighRiskUiState.empty &&
          state != VitHighRiskUiState.error &&
          state != VitHighRiskUiState.offline) {
        expect(find.text('contract.${state.name}'), findsOneWidget);
      }
    }
  });
}
