import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('VitRiskDisclaimerNote renders message with distinct semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const VitRiskDisclaimerNote(
          message: 'Short note',
          semanticsLabel: 'Risk notice: short note',
        ),
      ),
    );

    expect(find.text('Short note'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(VitRiskDisclaimerNote)).label,
      contains('Risk notice: short note'),
    );
  });
}
