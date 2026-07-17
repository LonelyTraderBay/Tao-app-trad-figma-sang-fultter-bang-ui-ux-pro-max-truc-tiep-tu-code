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
  testWidgets('VitCommunityRulesLink renders label and handles tap', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      _wrap(VitCommunityRulesLink(onTap: () => tapped = true)),
    );

    expect(find.text('Quy tắc cộng đồng'), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);

    await tester.tap(find.text('Quy tắc cộng đồng'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('VitCommunityRulesLink static mode does not crash', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const VitCommunityRulesLink(label: 'Quy tắc cộng đồng')),
    );

    expect(find.text('Quy tắc cộng đồng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('VitCommunityRulesLink uses ghost VitCard not CTA or inner', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(VitCommunityRulesLink(onTap: () {})));

    final linkFinder = find.byType(VitCommunityRulesLink);
    expect(linkFinder, findsOneWidget);

    expect(
      find.ancestor(
        of: find.text('Quy tắc cộng đồng'),
        matching: find.byType(VitCtaButton),
      ),
      findsNothing,
    );

    final cards = tester.widgetList<VitCard>(
      find.descendant(of: linkFinder, matching: find.byType(VitCard)),
    );

    expect(cards.length, 1);
    expect(cards.first.variant, VitCardVariant.ghost);
    expect(cards.first.variant, isNot(VitCardVariant.inner));
  });
}
