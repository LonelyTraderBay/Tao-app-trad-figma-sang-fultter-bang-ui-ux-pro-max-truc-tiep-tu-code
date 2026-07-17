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
  testWidgets('VitChoicePill renders selected and disabled states', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitChoicePill(
              label: 'Bank transfer',
              selected: true,
              showSelectedIcon: true,
              onTap: () => taps++,
            ),
            const SizedBox(height: 8),
            VitChoicePill(
              label: 'Disabled option',
              selected: false,
              enabled: false,
              onTap: () => taps++,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Bank transfer'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    await tester.tap(find.text('Bank transfer'));
    await tester.tap(find.text('Disabled option'), warnIfMissed: false);
    await tester.pump();

    expect(taps, 1);
  });
}
