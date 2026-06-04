import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_app_shell.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

void main() {
  testWidgets('header is visible at the top', (WidgetTester tester) async {
    await tester.pumpWidget(_scaffoldHarness());

    expect(find.text('Auto Header'), findsOneWidget);
    expect(_headerHeight(tester), greaterThan(0));
  });

  testWidgets('header hides on downward scroll', (WidgetTester tester) async {
    await tester.pumpWidget(_scaffoldHarness());

    await tester.drag(find.byKey(_scrollKey), const Offset(0, -320));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(_headerHeight(tester), 0);
  });

  testWidgets('header returns on upward scroll', (WidgetTester tester) async {
    await tester.pumpWidget(_scaffoldHarness());

    await tester.drag(find.byKey(_scrollKey), const Offset(0, -320));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));
    expect(_headerHeight(tester), 0);

    await tester.drag(find.byKey(_scrollKey), const Offset(0, 160));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(_headerHeight(tester), greaterThan(0));
  });

  testWidgets('header returns when scroll position is near top', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_scaffoldHarness());

    await tester.drag(find.byKey(_scrollKey), const Offset(0, -320));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));
    expect(_headerHeight(tester), 0);

    await tester.drag(find.byKey(_scrollKey), const Offset(0, 1000));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(_headerHeight(tester), greaterThan(0));
  });

  testWidgets('back button and trailing actions remain tappable', (
    WidgetTester tester,
  ) async {
    var backTaps = 0;
    var actionTaps = 0;

    await tester.pumpWidget(
      _scaffoldHarness(
        onBack: () => backTaps += 1,
        onAction: () => actionTaps += 1,
      ),
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.tap(find.byKey(_trailingActionKey));

    expect(backTaps, 1);
    expect(actionTaps, 1);
  });

  for (final size in const [Size(360, 800), Size(440, 956)]) {
    testWidgets(
      'content clears the bottom nav at ${size.width}x${size.height}',
      (WidgetTester tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          _scaffoldHarness(
            useShell: true,
            renderMode: ShellRenderMode.visualQa,
            bottomInset: DeviceMetrics.bottomChrome,
          ),
        );

        await tester.scrollUntilVisible(
          find.byKey(_lastItemKey),
          500,
          scrollable: find.byType(Scrollable),
        );
        await Scrollable.ensureVisible(
          tester.element(find.byKey(_lastItemKey)),
          alignment: 1,
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 220));

        final lastItemBottom = tester
            .getBottomLeft(find.byKey(_lastItemKey))
            .dy;
        final bottomNavTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;

        expect(
          lastItemBottom <= bottomNavTop + 0.1,
          isTrue,
          reason: 'Last content row should stop above the bottom nav.',
        );
      },
    );
  }
}

const _scrollKey = Key('vit_auto_hide_scroll_test');
const _trailingActionKey = Key('vit_auto_hide_trailing_action_test');
const _lastItemKey = Key('vit_auto_hide_last_item_test');

double _headerHeight(WidgetTester tester) {
  return tester
      .getSize(find.byKey(VitAutoHideHeaderScaffold.headerHostKey))
      .height;
}

Widget _scaffoldHarness({
  VoidCallback? onBack,
  VoidCallback? onAction,
  bool useShell = false,
  ShellRenderMode renderMode = ShellRenderMode.native,
  double bottomInset = 0,
}) {
  final page = VitPageLayout(
    variant: VitPageVariant.flush,
    child: VitAutoHideHeaderScaffold(
      semanticLabel: 'Auto hide header test',
      bottomInset: bottomInset,
      header: VitHeader(
        title: 'Auto Header',
        subtitle: 'Scroll aware',
        showBack: true,
        onBack: onBack ?? _noop,
        trailing: IconButton(
          key: _trailingActionKey,
          onPressed: onAction,
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ),
      child: SingleChildScrollView(
        key: _scrollKey,
        child: Column(
          children: [
            for (var index = 0; index < 40; index++)
              SizedBox(
                key: index == 39 ? _lastItemKey : null,
                height: 64,
                child: Text('Row $index'),
              ),
          ],
        ),
      ),
    ),
  );

  final home = useShell
      ? VitAppShell(renderMode: renderMode, showBottomNav: true, child: page)
      : page;

  return MaterialApp(home: home);
}

void _noop() {}
