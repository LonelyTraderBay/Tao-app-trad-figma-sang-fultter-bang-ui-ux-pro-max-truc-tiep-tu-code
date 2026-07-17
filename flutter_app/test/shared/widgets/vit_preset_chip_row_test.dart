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
  testWidgets('VitPresetChipRow.percentBalance renders and taps', (
    tester,
  ) async {
    int? tapped;

    await tester.pumpWidget(
      _wrap(
        VitPresetChipRow.percentBalance(
          onTap: (value) => tapped = value,
          keyFor: (value) => Key('pct_$value'),
        ),
      ),
    );

    expect(find.text('25%'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);

    await tester.tap(find.text('50%'));
    await tester.pump();

    expect(tapped, 50);
  });

  testWidgets('VitPresetChipRow highlights selectedValue', (tester) async {
    await tester.pumpWidget(
      _wrap(
        VitPresetChipRow.percentBalance(
          selectedValue: 75,
          onTap: (_) {},
          keyFor: (value) => Key('pct_$value'),
        ),
      ),
    );

    final selectedPill = tester.widget<VitChoicePill>(
      find.byWidgetPredicate(
        (widget) => widget is VitChoicePill && widget.label == '75%',
      ),
    );
    expect(selectedPill.selected, isTrue);
  });

  testWidgets('VitPresetChipRow has no VitCard ancestor', (tester) async {
    await tester.pumpWidget(
      _wrap(
        VitPresetChipRow.percentBalance(
          onTap: (_) {},
          keyFor: (value) => Key('pct_$value'),
        ),
      ),
    );

    expect(
      find.ancestor(
        of: find.byType(VitPresetChipRow<int>),
        matching: find.byType(VitCard),
      ),
      findsNothing,
    );
  });
}
