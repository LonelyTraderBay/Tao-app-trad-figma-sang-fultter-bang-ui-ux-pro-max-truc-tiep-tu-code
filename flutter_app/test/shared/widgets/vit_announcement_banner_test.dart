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
  testWidgets('VitAnnouncementBanner supports compact, dots, and dismiss', (
    tester,
  ) async {
    var dismissed = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitAnnouncementBanner(
              message: 'Campaign update',
              itemCount: 2,
              activeIndex: 1,
              onDismiss: () => dismissed++,
            ),
            const SizedBox(height: 8),
            const VitAnnouncementBanner(
              message: 'Compact update',
              itemCount: 2,
              variant: VitAnnouncementBannerVariant.compact,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Campaign update'), findsOneWidget);
    expect(find.text('Compact update'), findsOneWidget);
    expect(find.byType(VitCarouselDots), findsOneWidget);

    await tester.tap(find.byTooltip('Dismiss announcement'));
    await tester.pump();

    expect(dismissed, 1);
  });
}
