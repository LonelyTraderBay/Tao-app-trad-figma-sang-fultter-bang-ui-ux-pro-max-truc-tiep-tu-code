import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
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
  testWidgets('VitCarouselDots renders active and inactive widths', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const VitCarouselDots(itemCount: 3, activeIndex: 1)),
    );

    final inactiveSize = tester.getSize(
      find.byKey(const ValueKey('vit_carousel_dot_0')),
    );
    final activeSize = tester.getSize(
      find.byKey(const ValueKey('vit_carousel_dot_1')),
    );

    expect(
      inactiveSize.width,
      SharedSpacingTokens.homeAnnouncementDotInactiveWidth,
    );
    expect(
      activeSize.width,
      SharedSpacingTokens.homeAnnouncementDotActiveWidth,
    );
    expect(find.bySemanticsLabel('Carousel page 2 of 3'), findsOneWidget);
  });

  testWidgets('VitCarouselDots supports keyed tap callbacks', (tester) async {
    var selectedIndex = -1;

    await tester.pumpWidget(
      _wrap(
        VitCarouselDots(
          itemCount: 3,
          activeIndex: 0,
          dotKeyBuilder: (index) => ValueKey('onboarding_dot_$index'),
          onDotTap: (index) => selectedIndex = index,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('onboarding_dot_2')));
    await tester.pump();

    expect(selectedIndex, 2);
    expect(find.bySemanticsLabel('Go to carousel page 3'), findsOneWidget);
  });
}
