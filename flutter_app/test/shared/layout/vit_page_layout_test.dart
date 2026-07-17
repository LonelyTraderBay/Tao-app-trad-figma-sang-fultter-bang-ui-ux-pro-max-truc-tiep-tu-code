import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

void main() {
  testWidgets(
    'semanticIdentifier maps to Semantics.identifier, not the announced '
    'label (A11Y-1)',
    (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: VitPageLayout(
            semanticLabel: 'Đăng nhập',
            semanticIdentifier: 'SC-007',
            child: Text('body'),
          ),
        ),
      );

      final finder = find.bySemanticsLabel(RegExp('Đăng nhập'));
      expect(finder, findsOneWidget);
      final semantics = tester.getSemantics(finder);
      expect(semantics.identifier, 'SC-007');
      // The identifier is not announced — a screen reader speaks the label.
      expect(semantics.label, isNot(contains('SC-007')));

      handle.dispose();
    },
  );

  testWidgets('semanticIdentifier is optional', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      const MaterialApp(
        home: VitPageLayout(semanticLabel: 'Đăng nhập', child: Text('body')),
      ),
    );

    final finder = find.bySemanticsLabel(RegExp('Đăng nhập'));
    expect(finder, findsOneWidget);
    final semantics = tester.getSemantics(finder);
    expect(semantics.identifier, '');

    handle.dispose();
  });
}
