import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpDashboard(WidgetTester tester, double width) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitTwoColumnTabletDashboard(
            primaryChildren: [Text('Primary content')],
            secondaryChildren: [Text('Secondary content')],
          ),
        ),
      ),
    );
  }

  testWidgets(
    'below twoColumnMinWidth renders the single-column fallback with both '
    'primary and secondary children present',
    (tester) async {
      await pumpDashboard(tester, 700);

      expect(find.byType(Row), findsNothing);
      expect(find.text('Primary content'), findsOneWidget);
      expect(find.text('Secondary content'), findsOneWidget);
    },
  );

  testWidgets('at/above twoColumnMinWidth renders a two-column Row with the '
      'secondary column framed in a VitCard and the primary column not', (
    tester,
  ) async {
    await pumpDashboard(tester, 1000);

    expect(find.byType(Row), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('Secondary content'),
        matching: find.byType(VitCard),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.text('Primary content'),
        matching: find.byType(VitCard),
      ),
      findsNothing,
    );
  });

  testWidgets(
    'at the two-column width, the dashboard lays out without overflow',
    (tester) async {
      await pumpDashboard(tester, 1000);

      expect(tester.takeException(), isNull);
    },
  );
}
