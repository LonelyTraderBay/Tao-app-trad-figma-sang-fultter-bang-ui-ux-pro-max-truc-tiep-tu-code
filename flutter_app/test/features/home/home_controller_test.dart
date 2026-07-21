import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';

void main() {
  test(
    'Home controller exposes dashboard snapshot and sorted market views',
    () async {
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const MockHomeRepository(loadDelay: Duration.zero),
          ),
        ],
      );
      addTearDown(container.dispose);

      // STATE-S25: đọc lúc snapshot còn loading KHÔNG ném StateError —
      // provider trả AsyncValue.loading thay vì requireValue nổ ngay.
      final whileLoading = container.read(homeControllerProvider);
      expect(whileLoading.isLoading, isTrue);
      expect(whileLoading.hasValue, isFalse);

      await container.read(homeSnapshotProvider.future);
      final controller = container.read(homeControllerProvider).requireValue;
      final snapshot = controller.state.snapshot;
      final quickActions = snapshot.quickActions;

      expect(quickActions, isNotEmpty);
      expect(snapshot.nextAction?.routePath, '/wallet/withdraw/USDT');
      expect(snapshot.nextAction?.stateLabel, 'Next');
      expect(
        snapshot.recentProducts.map((product) => product.routePath),
        equals(['/trade/btcusdt', '/p2p', '/earn', '/trade/copy-trading']),
      );
      expect(
        quickActions.map((action) => action.routePath),
        equals([
          '/trade/btcusdt',
          '/trade/convert',
          '/wallet',
          '/p2p',
          '/dca',
          '/earn',
          '/earn/savings',
          '/launchpad',
          '/rewards',
        ]),
      );
      expect(
        snapshot.productGroups.map((group) => group.id),
        equals(['trading', 'pro', 'yield', 'explore']),
      );
      expect(
        quickActions.every((action) => action.stateLabel?.isNotEmpty ?? false),
        isTrue,
      );
      expect(
        quickActions.any((action) => action.routePath == '/support'),
        isFalse,
      );
      expect(
        quickActions.any((action) => action.routePath == '/referral'),
        isFalse,
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
