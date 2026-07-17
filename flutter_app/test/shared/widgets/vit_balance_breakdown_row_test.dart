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
  testWidgets('VitBalanceBreakdownRow renders items and dispatches taps', (
    tester,
  ) async {
    final routes = <String>[];

    await tester.pumpWidget(
      _wrap(
        VitBalanceBreakdownRow(
          onNavigate: routes.add,
          items: const [
            VitBalanceBreakdownItem(
              label: 'Spot',
              value: '\$100',
              icon: Icons.swap_horiz_rounded,
              tooltip: 'Spot wallet',
              route: '/wallet',
            ),
            VitBalanceBreakdownItem(
              label: 'Earn',
              value: '••••',
              icon: Icons.savings_outlined,
              tooltip: 'Earn wallet',
              route: '/earn',
            ),
          ],
        ),
      ),
    );

    expect(find.text('Spot'), findsOneWidget);
    expect(find.text('\$100'), findsOneWidget);
    expect(find.text('••••'), findsOneWidget);

    await tester.tap(find.text('Earn'));
    expect(routes, ['/earn']);
  });
}
