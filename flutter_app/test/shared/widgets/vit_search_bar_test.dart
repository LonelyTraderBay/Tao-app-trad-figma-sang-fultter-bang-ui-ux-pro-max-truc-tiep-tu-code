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
  testWidgets('VitSearchBar handles input, clear, and filter action', (
    tester,
  ) async {
    String query = '';
    var filters = 0;

    await tester.pumpWidget(
      _wrap(
        VitSearchBar(
          placeholder: 'Search assets',
          onChanged: (value) => query = value,
          onFilterTap: () => filters++,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'btc');
    await tester.pump();

    expect(query, 'btc');
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(query, '');

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pump();

    expect(filters, 1);
  });
}
