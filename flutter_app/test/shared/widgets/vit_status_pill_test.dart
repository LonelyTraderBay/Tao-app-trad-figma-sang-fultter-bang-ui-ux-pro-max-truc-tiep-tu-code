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
  testWidgets('VitStatusPill supports count overflow and tap', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        VitStatusPill(
          label: 'Queued',
          status: VitStatusPillStatus.warning,
          icon: Icons.schedule_rounded,
          count: 120,
          outline: true,
          onTap: () => taps++,
        ),
      ),
    );

    expect(find.text('Queued'), findsOneWidget);
    expect(find.text('99+'), findsOneWidget);
    expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);

    await tester.tap(find.text('Queued'));
    await tester.pump();

    expect(taps, 1);
  });
}
