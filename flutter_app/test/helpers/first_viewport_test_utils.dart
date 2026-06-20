import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

@immutable
class VitFirstViewport {
  const VitFirstViewport(this.label, this.size);

  static const minimumPhone = VitFirstViewport(
    '360x800 minimum phone',
    Size(360, 800),
  );

  static const qaPhone = VitFirstViewport('440x956 QA phone', Size(440, 956));

  static const requiredPhones = [minimumPhone, qaPhone];

  final String label;
  final Size size;
}

void configureFirstViewport(
  WidgetTester tester,
  VitFirstViewport viewport, {
  double devicePixelRatio = 1,
}) {
  tester.view.devicePixelRatio = devicePixelRatio;
  tester.view.physicalSize = viewport.size * devicePixelRatio;

  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Rect firstViewportRect(WidgetTester tester) {
  return Offset.zero &
      (tester.view.physicalSize / tester.view.devicePixelRatio);
}

Finder firstViewportBottomNavFinder() {
  return find.byType(VitBottomNav);
}

double firstViewportBottomNavTop(
  WidgetTester tester, {
  Finder? bottomNavFinder,
}) {
  final finder = bottomNavFinder ?? firstViewportBottomNavFinder();
  expect(
    finder,
    findsOneWidget,
    reason: 'First-viewport checks require exactly one VitBottomNav.',
  );
  return tester.getRect(finder).top;
}

Rect firstViewportUsableRect(WidgetTester tester, {Finder? bottomNavFinder}) {
  final viewport = firstViewportRect(tester);
  final finder = bottomNavFinder ?? firstViewportBottomNavFinder();

  if (finder.evaluate().isEmpty) {
    return viewport;
  }

  final bottomNavTop = firstViewportBottomNavTop(
    tester,
    bottomNavFinder: finder,
  );
  return Rect.fromLTRB(
    viewport.left,
    viewport.top,
    viewport.right,
    math.max(viewport.top, math.min(viewport.bottom, bottomNavTop)),
  );
}

void expectFirstViewportVisible(
  WidgetTester tester,
  Finder finder, {
  Finder? bottomNavFinder,
  String? reason,
  String targetLabel = 'the target widget',
  double minVisibleHeight = 1,
}) {
  expect(finder, findsAtLeastNWidgets(1), reason: reason);

  final targetRect = tester.getRect(finder.first);
  final usableRect = firstViewportUsableRect(
    tester,
    bottomNavFinder: bottomNavFinder,
  );
  final visibleRect = targetRect.intersect(usableRect);

  expect(
    visibleRect.width > 0 && visibleRect.height >= minVisibleHeight,
    isTrue,
    reason:
        reason ?? 'Expected $targetLabel to be visible in the first viewport.',
  );
}

void expectRouteSemanticInFirstViewport(
  WidgetTester tester, {
  required String routeName,
  required String semanticLabel,
  Finder? bottomNavFinder,
  bool exact = true,
}) {
  final semantics = find.byWidgetPredicate((widget) {
    if (widget is! Semantics) {
      return false;
    }
    final label = widget.properties.label ?? '';
    return exact ? label == semanticLabel : label.contains(semanticLabel);
  }, description: '$routeName semantic label "$semanticLabel"');

  expectFirstViewportVisible(
    tester,
    semantics,
    bottomNavFinder: bottomNavFinder,
    reason:
        '$routeName must expose "$semanticLabel" inside the usable first '
        'viewport above the bottom navigation.',
  );
}

void expectActionableInFirstViewport(
  WidgetTester tester,
  Finder finder, {
  required String routeName,
  String actionLabel = 'the requested action',
  Finder? bottomNavFinder,
  double minVisibleHeight = 24,
}) {
  expectFirstViewportVisible(
    tester,
    finder,
    bottomNavFinder: bottomNavFinder,
    minVisibleHeight: minVisibleHeight,
    reason:
        '$routeName must expose $actionLabel as actionable content '
        'inside the usable first viewport.',
  );
}
