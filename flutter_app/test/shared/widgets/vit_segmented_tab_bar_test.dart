import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
  testWidgets('VitSegmentedTabBar has no VitCard outer wrapper', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        VitSegmentedTabBar(
          activeKey: 'overview',
          onChanged: (_) {},
          tabs: const [
            VitTabItem(key: 'overview', label: 'Overview'),
            VitTabItem(key: 'history', label: 'History'),
          ],
        ),
      ),
    );

    expect(find.byType(VitSegmentedTabBar), findsOneWidget);
    expect(find.byType(VitCard), findsNothing);
    expect(
      find.ancestor(
        of: find.byType(VitSegmentedTabBar),
        matching: find.byType(VitCard),
      ),
      findsNothing,
    );
  });

  testWidgets('segment tab unselected pills use ghost border', (tester) async {
    await tester.pumpWidget(
      _wrap(
        VitSegmentedTabBar(
          activeKey: 'overview',
          onChanged: (_) {},
          tabs: const [
            VitTabItem(key: 'overview', label: 'Overview'),
            VitTabItem(key: 'history', label: 'History'),
          ],
        ),
      ),
    );

    final inactiveDecorations = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(VitSegmentedTabBar),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is DecoratedBox &&
                  widget.decoration is ShapeDecoration,
            ),
          ),
        )
        .map((box) => box.decoration as ShapeDecoration)
        .where((decoration) => decoration.color == AppColors.transparent)
        .toList();

    expect(inactiveDecorations, isNotEmpty);

    final inactiveShape =
        inactiveDecorations.first.shape as RoundedRectangleBorder;

    expect(inactiveShape.side.color, AppColors.portfolioBtnGhostBorder);
  });
}
