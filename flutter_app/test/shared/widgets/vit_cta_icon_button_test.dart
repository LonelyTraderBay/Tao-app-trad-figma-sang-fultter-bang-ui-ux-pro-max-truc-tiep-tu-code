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
  testWidgets('VitCtaButton and VitIconButton expose action states', (
    tester,
  ) async {
    var ctaTaps = 0;
    var iconTaps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCtaButton(
              onPressed: () => ctaTaps++,
              leading: const Icon(Icons.add_rounded),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 8),
            VitIconButton(
              icon: Icons.search_rounded,
              tooltip: 'Search',
              onPressed: () => iconTaps++,
            ),
            const SizedBox(height: 8),
            const VitCtaButton(loading: true, child: Text('Loading')),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pump();

    expect(ctaTaps, 1);
    expect(iconTaps, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
