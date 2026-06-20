import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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

  testWidgets('VitHighRiskStatePanel supports compact density', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Review network risk',
            message: 'Confirm fees, limits, and masked address before signing.',
            contractId: 'wallet.withdraw.compact',
            density: VitDensity.compact,
          ),
        ),
      ),
    );

    final panelPadding = tester.widget<Padding>(
      find.descendant(
        of: find.byType(DecoratedBox),
        matching: find.byType(Padding),
      ),
    );

    expect(
      panelPadding.padding,
      VitDensity.compact.cardPadding,
      reason: 'Compact high-risk panels must use the shared compact rhythm.',
    );
    expect(find.text('Review network risk'), findsOneWidget);
    expect(find.textContaining('Confirm fees, limits'), findsOneWidget);
    expect(find.text('wallet.withdraw.compact'), findsOneWidget);
  });

  testWidgets('VitFinancialSafetySummary keeps fee risk limit rows compact', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitFinancialSafetySummary(
            contractId: 'wallet.withdraw.preview',
            footer: 'Preview and confirmation are required before signing.',
            items: [
              VitFinancialSafetyItem(label: 'Fee', value: '0.0004 BTC'),
              VitFinancialSafetyItem(label: 'Risk', value: 'Address review'),
              VitFinancialSafetyItem(label: 'Limit', value: '2 BTC daily'),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(VitInfoRow), findsNWidgets(3));
    expect(find.text('Fee'), findsOneWidget);
    expect(find.text('0.0004 BTC'), findsOneWidget);
    expect(find.text('Risk'), findsOneWidget);
    expect(find.text('Address review'), findsOneWidget);
    expect(find.text('Limit'), findsOneWidget);
    expect(find.text('2 BTC daily'), findsOneWidget);
    expect(find.text('wallet.withdraw.preview'), findsOneWidget);
    expect(
      find.text('Preview and confirmation are required before signing.'),
      findsOneWidget,
    );

    final compactRows = tester.widgetList<ConstrainedBox>(
      find.byWidgetPredicate(
        (widget) =>
            widget is ConstrainedBox &&
            widget.constraints.minHeight == VitDensity.compact.controlHeight,
      ),
    );
    expect(
      compactRows.length,
      greaterThanOrEqualTo(3),
      reason: 'Financial safety rows must keep compact tap-safe height.',
    );
  });
}
