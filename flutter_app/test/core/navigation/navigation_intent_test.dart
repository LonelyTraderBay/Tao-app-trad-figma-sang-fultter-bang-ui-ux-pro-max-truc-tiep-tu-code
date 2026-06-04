import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/navigation/navigation_intent_contract.dart';
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

    test('typed route contracts resolve and match dynamic route data', () {
      final contract = DynamicNavigationIntentContracts.findByRoute(
        '/p2p/order/\$orderId',
        module: 'p2p',
      );

      expect(contract, isNotNull);
      expect(contract, isA<NavigationIntent>());
      expect(contract!.resolve(), '/p2p/order/p2p001');
      expect(contract.matchesRoute('/p2p/order/p2p001'), isTrue);
      expect(contract.humanReadableLine, contains('P2P Trading'));
      expect(contract.humanReadableLine, contains('P2P order lifecycle'));
    });
  });
}
