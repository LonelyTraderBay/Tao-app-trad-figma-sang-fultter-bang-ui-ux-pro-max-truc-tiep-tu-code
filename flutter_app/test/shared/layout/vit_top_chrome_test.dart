import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_top_header_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';

void main() {
  testWidgets('detail delegates to VitHeader baseline', (
    WidgetTester tester,
  ) async {
    var backTaps = 0;
    const backKey = Key('top_chrome_back');

    await tester.pumpWidget(
      _wrap(
        VitTopChrome(
          type: VitTopChromeType.detail,
          title: 'Order receipt',
          subtitle: 'Spot order',
          showBack: true,
          backKey: backKey,
          onBack: () => backTaps += 1,
          actions: const [
            VitHeaderActionItem(
              type: VitHeaderActionType.share,
              onPressed: _noop,
            ),
          ],
        ),
      ),
    );

    expect(find.byType(VitHeader), findsOneWidget);
    expect(find.text('Order receipt'), findsOneWidget);
    expect(find.text('Spot order'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
    expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    expect(find.byKey(backKey), findsOneWidget);

    await tester.tap(find.byKey(backKey));
    await tester.pump();

    expect(backTaps, 1);
  });

  testWidgets('root module keeps title and three actions inside 360px', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _wrap(
        const VitTopChrome(
          type: VitTopChromeType.rootModule,
          title: 'Markets and portfolio workspace',
          subtitle: 'Live overview',
          actions: [
            VitHeaderActionItem(
              type: VitHeaderActionType.overview,
              onPressed: _noop,
            ),
            VitHeaderActionItem(
              type: VitHeaderActionType.analytics,
              onPressed: _noop,
            ),
            VitHeaderActionItem(
              type: VitHeaderActionType.sectors,
              onPressed: _noop,
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(VitHeaderActionButton), findsNWidgets(3));
    expect(tester.getSize(find.byType(VitTopChrome)).width, 360);
    expect(
      tester.getSize(find.byType(VitTopChrome)).height,
      greaterThanOrEqualTo(AppTopHeaderTokens.rootMinHeight),
    );

    final title = tester.widget<Text>(
      find.text('Markets and portfolio workspace'),
    );
    expect(title.style?.fontSize, AppTextStyles.pageTitle.fontSize);
  });

  testWidgets('root module back requires an actionable callback', (
    WidgetTester tester,
  ) async {
    final previousErrorBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (_) => const SizedBox.shrink();

    Object? exception;
    try {
      await tester.pumpWidget(
        _wrap(
          const VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Wallet',
            showBack: true,
          ),
        ),
      );
      exception = tester.takeException();
    } finally {
      ErrorWidget.builder = previousErrorBuilder;
    }

    expect(exception, isAssertionError);
  });

  testWidgets('root module back callback remains tappable', (
    WidgetTester tester,
  ) async {
    var backTaps = 0;

    await tester.pumpWidget(
      _wrap(
        VitTopChrome(
          type: VitTopChromeType.rootModule,
          title: 'Wallet detail',
          showBack: true,
          onBack: () => backTaps += 1,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pump();

    expect(backTaps, 1);
  });

  testWidgets('instrument chrome keeps selector semantics and fixed rhythm', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        VitTopChrome(
          type: VitTopChromeType.instrument,
          leading: const VitHeaderActionButton(
            type: VitHeaderActionType.back,
            tone: VitHeaderActionTone.transparent,
            onPressed: _noop,
          ),
          body: Semantics(
            button: true,
            label: 'Select BTCUSDT',
            child: const Text('BTCUSDT'),
          ),
          trailing: const Text('67,543.21'),
        ),
      ),
    );

    expect(find.text('BTCUSDT'), findsOneWidget);
    expect(find.text('67,543.21'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.label == 'Select BTCUSDT',
      ),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.byType(VitTopChrome)).height,
      greaterThanOrEqualTo(AppTopHeaderTokens.instrumentMinHeight),
    );
  });

  testWidgets('public chrome constants mirror top header tokens', (
    WidgetTester tester,
  ) async {
    expect(VitTopChrome.detailMinHeight, AppTopHeaderTokens.detailMinHeight);
    expect(VitTopChrome.rootMinHeight, AppTopHeaderTokens.rootMinHeight);
    expect(
      VitTopChrome.instrumentMinHeight,
      AppTopHeaderTokens.instrumentMinHeight,
    );
    expect(VitTopChrome.actionGap, AppTopHeaderTokens.actionGap);
  });

  testWidgets('status slot renders below chrome when explicitly provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const VitTopChrome(
          type: VitTopChromeType.rootBrand,
          title: 'VitTrade',
          statusSlot: Text('Reconnecting'),
        ),
      ),
    );

    final titleTop = tester.getTopLeft(find.text('VitTrade')).dy;
    final statusTop = tester.getTopLeft(find.text('Reconnecting')).dy;
    expect(statusTop, greaterThan(titleTop));
  });
}

void _noop() {}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    ),
  );
}
