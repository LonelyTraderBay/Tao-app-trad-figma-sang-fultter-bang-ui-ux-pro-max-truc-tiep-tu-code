import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  testWidgets('showVitBottomSheet opens and returns a typed value', (
    tester,
  ) async {
    Future<String?>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  result = showVitBottomSheet<String>(
                    context: context,
                    builder: (sheetContext) {
                      return SafeArea(
                        top: false,
                        child: TextButton(
                          onPressed: () =>
                              Navigator.of(sheetContext).pop('selected'),
                          child: const Text('Choose value'),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Choose value'), findsOneWidget);

    await tester.tap(find.text('Choose value'));
    await tester.pumpAndSettle();

    expect(await result, 'selected');
    expect(find.text('Choose value'), findsNothing);
  });
}
