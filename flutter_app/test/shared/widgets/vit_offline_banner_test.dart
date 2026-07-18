import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('VitBanner renders message-only banners unchanged', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const VitBanner(
          variant: VitBannerVariant.warning,
          message: 'Offline. Showing latest cached data.',
        ),
      ),
    );

    expect(find.text('Offline. Showing latest cached data.'), findsOneWidget);
    expect(find.byType(VitIconButton), findsNothing);
  });

  testWidgets('VitBanner renders a title above the message when provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const VitBanner(
          variant: VitBannerVariant.success,
          title: 'Bot đã được khởi chạy!',
          message: 'Bot đang hoạt động và giao dịch tự động',
        ),
      ),
    );

    expect(find.text('Bot đã được khởi chạy!'), findsOneWidget);
    expect(
      find.text('Bot đang hoạt động và giao dịch tự động'),
      findsOneWidget,
    );
  });

  testWidgets('VitBanner invokes onDismiss when the close button is tapped', (
    tester,
  ) async {
    var dismissed = false;

    await tester.pumpWidget(
      _wrap(
        VitBanner(
          variant: VitBannerVariant.success,
          message: 'Done',
          onDismiss: () => dismissed = true,
        ),
      ),
    );

    expect(find.byType(VitIconButton), findsOneWidget);
    await tester.tap(find.byType(VitIconButton));
    await tester.pump();

    expect(dismissed, isTrue);
  });

  testWidgets('VitBanner renders the optional action below the text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        VitBanner(
          variant: VitBannerVariant.info,
          message: 'Details',
          action: TextButton(onPressed: () {}, child: const Text('Retry')),
        ),
      ),
    );

    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('showVitNoticeSheet opens a sheet with title, message and CTA', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showVitNoticeSheet(
                      context: context,
                      title: 'Margin trading',
                      message: 'Your position has been updated.',
                    ),
                  );
                },
                child: const Text('Open notice'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open notice'));
    await tester.pumpAndSettle();

    expect(find.text('Margin trading'), findsOneWidget);
    expect(find.text('Your position has been updated.'), findsOneWidget);

    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.text('Margin trading'), findsNothing);
  });
}
