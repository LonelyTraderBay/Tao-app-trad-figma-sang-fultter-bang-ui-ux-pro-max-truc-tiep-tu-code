import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_top_header_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';

void main() {
  testWidgets('renders canonical action list with badge and taps', (
    WidgetTester tester,
  ) async {
    var searchTaps = 0;
    var notificationTaps = 0;

    await tester.pumpWidget(
      _wrap(
        VitHeader(
          title: 'Markets',
          actions: [
            VitHeaderActionItem(
              type: VitHeaderActionType.search,
              onPressed: () => searchTaps += 1,
            ),
            VitHeaderActionItem(
              type: VitHeaderActionType.notifications,
              badgeCount: 3,
              onPressed: () => notificationTaps += 1,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Markets'), findsOneWidget);
    expect(find.byType(VitHeaderActionButton), findsNWidgets(2));
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pump();

    expect(searchTaps, 1);
    expect(notificationTaps, 1);
  });

  testWidgets('maps legacy action API to canonical button', (
    WidgetTester tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        VitHeader(
          title: 'Alerts',
          action: VitHeaderAction.bell,
          badgeCount: 8,
          onAction: () => taps += 1,
        ),
      ),
    );

    expect(find.byType(VitHeaderActionButton), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.text('8'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('uses canonical back action button', (WidgetTester tester) async {
    var backTaps = 0;

    await tester.pumpWidget(
      _wrap(
        VitHeader(title: 'Detail', showBack: true, onBack: () => backTaps += 1),
      ),
    );

    expect(find.byType(VitHeaderActionButton), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pump();

    expect(backTaps, 1);
  });

  testWidgets('uses top header token metrics for detail header', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const VitHeader(
          title: 'Very long detail title that should stay stable',
          subtitle: 'Subtitle',
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(VitHeader)).height,
      greaterThanOrEqualTo(AppTopHeaderTokens.detailMinHeight),
    );

    final title = tester.widget<Text>(
      find.text('Very long detail title that should stay stable'),
    );
    expect(title.style?.fontSize, AppTopHeaderTokens.detailTitleSize);

    final subtitle = tester.widget<Text>(find.text('Subtitle'));
    expect(subtitle.style?.fontSize, AppTopHeaderTokens.subtitleSize);
  });

  testWidgets('long title and subtitle remain stable at 360px', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    const title =
        'Extremely long withdrawal confirmation header for enterprise review';
    const subtitle =
        'Very long route context that should never push actions off screen';

    await tester.pumpWidget(
      _wrap(
        const VitHeader(
          title: title,
          subtitle: subtitle,
          showBack: true,
          onBack: _noop,
          actions: [
            VitHeaderActionItem(
              type: VitHeaderActionType.share,
              onPressed: _noop,
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(VitHeader)).width, 360);
    expect(find.byType(VitHeaderActionButton), findsNWidgets(2));

    final titleText = tester.widget<Text>(find.text(title));
    final subtitleText = tester.widget<Text>(find.text(subtitle));
    expect(titleText.overflow, TextOverflow.ellipsis);
    expect(subtitleText.overflow, TextOverflow.ellipsis);
  });

  testWidgets('title badge clamps to 99+ without changing header height', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const VitHeader(title: 'Inbox', badgeCount: 7)),
    );
    final heightWithSingleDigitBadge = tester
        .getSize(find.byType(VitHeader))
        .height;

    await tester.pumpWidget(
      _wrap(const VitHeader(title: 'Inbox', badgeCount: 120)),
    );

    expect(find.text('99+'), findsOneWidget);
    expect(
      tester.getSize(find.byType(VitHeader)).height,
      heightWithSingleDigitBadge,
    );
  });

  testWidgets('rejects visible back without callback', (
    WidgetTester tester,
  ) async {
    final previousErrorBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (_) => const SizedBox.shrink();

    Object? exception;
    try {
      await tester.pumpWidget(
        _wrap(const VitHeader(title: 'Unsafe detail', showBack: true)),
      );
      exception = tester.takeException();
    } finally {
      ErrorWidget.builder = previousErrorBuilder;
    }

    expect(exception, isAssertionError);
  });

  testWidgets('transparent header removes surface border', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const VitHeader(title: 'Overlay', transparent: true)),
    );

    final surface = tester.widget<DecoratedBox>(
      find.byType(DecoratedBox).first,
    );
    final decoration = surface.decoration as BoxDecoration;
    expect(decoration.color, AppTopHeaderTokens.transparentSurfaceColor);
    expect(decoration.border, isNull);
  });
}

void _noop() {}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Column(
        children: [
          child,
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    ),
  );
}
