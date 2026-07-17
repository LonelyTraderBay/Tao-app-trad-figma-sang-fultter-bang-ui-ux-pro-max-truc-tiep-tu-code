import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_top_header_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';

void main() {
  testWidgets('renders canonical icon, tooltip, badge, and tap target', (
    WidgetTester tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        VitHeaderActionButton(
          type: VitHeaderActionType.notifications,
          badgeCount: 107,
          onPressed: () => taps += 1,
        ),
      ),
    );

    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byTooltip('Thông báo'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Thông báo' &&
            widget.properties.button == true &&
            widget.properties.enabled == true,
      ),
      findsOneWidget,
    );
    expect(find.text('99+'), findsOneWidget);
    // A11Y-2: the tappable footprint is expanded to the 44dp minimum tap
    // target while the visible button box (Ink) keeps its original size.
    expect(
      tester.getSize(find.byType(VitHeaderActionButton)),
      const Size(
        AppTopHeaderTokens.minTapTarget,
        AppTopHeaderTokens.minTapTarget,
      ),
    );
    expect(
      tester.getSize(
        find.descendant(
          of: find.byType(VitHeaderActionButton),
          matching: find.byType(Ink),
        ),
      ),
      const Size(AppTopHeaderTokens.buttonSize, AppTopHeaderTokens.buttonSize),
    );

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('uses action item factory and compact size', (
    WidgetTester tester,
  ) async {
    const actionKey = Key('header-export-action');

    await tester.pumpWidget(
      _wrap(
        VitHeaderActionButton.fromItem(
          VitHeaderActionItem(
            key: actionKey,
            type: VitHeaderActionType.export,
            tooltip: 'Xuất CSV',
            size: VitHeaderActionSize.sm,
            onPressed: _noop,
          ),
        ),
      ),
    );

    expect(find.byKey(actionKey), findsOneWidget);
    expect(find.byIcon(Icons.download_rounded), findsOneWidget);
    expect(find.byTooltip('Xuất CSV'), findsOneWidget);
    // A11Y-2: same tap-target-vs-visual-size split as the default size case.
    expect(
      tester.getSize(find.byKey(actionKey)),
      const Size(
        AppTopHeaderTokens.minTapTarget,
        AppTopHeaderTokens.minTapTarget,
      ),
    );
    expect(
      tester.getSize(
        find.descendant(of: find.byKey(actionKey), matching: find.byType(Ink)),
      ),
      const Size(
        AppTopHeaderTokens.compactButtonSize,
        AppTopHeaderTokens.compactButtonSize,
      ),
    );
  });

  testWidgets('applies default tone and disabled state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitHeaderActionButton(
              type: VitHeaderActionType.favoriteOn,
              onPressed: _noop,
            ),
            SizedBox(width: 8),
            VitHeaderActionButton(
              type: VitHeaderActionType.search,
              onPressed: null,
            ),
          ],
        ),
      ),
    );

    final favoriteIcon = tester.widget<Icon>(find.byIcon(Icons.star_rounded));
    final searchIcon = tester.widget<Icon>(find.byIcon(Icons.search_rounded));

    expect(favoriteIcon.color, AppColors.warn);
    expect(searchIcon.color, AppColors.text3);
  });
}

void _noop() {}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}
