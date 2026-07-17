import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  testWidgets('showVitPreviewConfirmSheet returns true on confirm', (
    tester,
  ) async {
    Future<bool>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  result = showVitPreviewConfirmSheet(
                    context: context,
                    title: 'Preview title',
                    confirmKey: const Key('preview_confirm'),
                    cancelKey: const Key('preview_cancel'),
                    items: const [
                      VitFinancialSafetyItem(label: 'Amount', value: '\$10.00'),
                    ],
                  );
                },
                child: const Text('Open preview'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open preview'));
    await tester.pumpAndSettle();

    expect(find.text('Preview title'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
    expect(find.byKey(const Key('preview_confirm')), findsOneWidget);
    expect(find.byKey(const Key('preview_cancel')), findsOneWidget);

    await tester.tap(find.byKey(const Key('preview_confirm')));
    await tester.pumpAndSettle();

    expect(await result, isTrue);
    expect(find.text('Preview title'), findsNothing);
  });
}
