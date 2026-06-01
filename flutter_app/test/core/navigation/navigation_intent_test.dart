import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/navigation/navigation_intent.dart';

void main() {
  group('NavigationIntent', () {
    test('resolves static app route targets', () {
      const intent = AppRouteIntent('/wallet');

      expect(intent.resolve(), '/wallet');
    });

    test('resolves builder-backed app route targets', () {
      final intent = AppRouteBuilderIntent(() => '/pair/btcusdt');

      expect(intent.resolve(), '/pair/btcusdt');
    });
  });
}
