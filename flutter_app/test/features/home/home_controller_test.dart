import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';

void main() {
  test(
    'Home controller exposes dashboard snapshot and sorted market views',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(homeControllerProvider);
      final snapshot = controller.state.snapshot;
      final quickActions = snapshot.quickActions;

      expect(quickActions, isNotEmpty);
      expect(snapshot.nextAction.routePath, '/wallet/withdraw/USDT');
      expect(snapshot.nextAction.stateLabel, 'Next');
      expect(
        snapshot.recentProducts.map((product) => product.routePath),
        equals([
          '/trade/btcusdt',
          '/p2p',
          '/earn/staking',
          '/trade/copy-trading',
        ]),
      );
      expect(
        quickActions.map((action) => action.routePath).take(12),
        equals([
          '/trade/btcusdt',
          '/trade/convert',
          '/wallet',
          '/p2p',
          '/dca',
          '/earn/staking',
          '/earn/savings',
          '/launchpad',
          '/markets/predictions',
          '/arena',
          '/rewards',
          '/support',
        ]),
      );
      expect(
        quickActions.map((action) => action.routePath).skip(12),
        equals([
          '/trade/margin',
          '/trade/bots',
          '/trade/copy-trading',
          '/topics',
          '/referral',
        ]),
      );
      expect(
        quickActions
            .take(12)
            .every((action) => action.stateLabel?.isNotEmpty ?? false),
        isTrue,
      );
      expect(
        quickActions.any((action) => action.routePath == '/support'),
        isTrue,
      );
      expect(controller.hotPairs.every((pair) => pair.isFavorite), isTrue);
      expect(controller.gainers.first.change24h, greaterThanOrEqualTo(0));
      expect(controller.losers.first.change24h, lessThanOrEqualTo(0));
      expect(controller.tabPairs('hot').first.id, controller.hotPairs.first.id);
      expect(
        controller.tabPairs('gainers').first.id,
        controller.gainers.first.id,
      );
      expect(
        controller.tabPairs('losers').first.id,
        controller.losers.first.id,
      );
    },
  );
}
