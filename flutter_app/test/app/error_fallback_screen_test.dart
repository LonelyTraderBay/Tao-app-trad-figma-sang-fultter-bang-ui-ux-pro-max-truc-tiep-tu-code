import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/error_fallback_screen.dart';

void main() {
  testWidgets('VitErrorFallbackScreen renders brand fallback copy', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: VitErrorFallbackScreen()));

    expect(find.text('Đã xảy ra lỗi'), findsOneWidget);
    expect(
      find.text('Vui lòng thử lại hoặc quay lại màn trước.'),
      findsOneWidget,
    );
  });
}
