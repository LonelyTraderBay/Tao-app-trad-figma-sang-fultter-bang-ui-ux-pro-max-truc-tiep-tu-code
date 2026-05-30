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

      expect(controller.state.snapshot.quickActions, isNotEmpty);
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
