import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/launchpad/data/repositories/mock_launchpad_repository.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

void main() {
  group('LaunchpadController', () {
    test(
      'exposes core launchpad snapshots through repository contract',
      () async {
        const controller = LaunchpadController(
          MockLaunchpadRepository(loadDelay: Duration.zero),
        );

        final home = await controller.getHome();
        final detail = await controller.getDetail('vitx');
        final portfolio = await controller.getPortfolio();

        expect(home.endpoint, '/api/mobile/launchpad/launchpad');
        expect(home.projects, isNotEmpty);
        expect(detail.projectId, 'vitx');
        expect(portfolio.subscriptions, isNotEmpty);
        expect(home.supportedStates, contains(LaunchpadScreenState.offline));
      },
    );

    test('exposes advanced tool read models without data imports', () async {
      const controller = LaunchpadController(
        MockLaunchpadRepository(loadDelay: Duration.zero),
      );

      expect(
        (await controller.getBridgeCompare()).comparison.routes,
        isNotEmpty,
      );
      expect((await controller.getGasTracker()).prices, isNotEmpty);
      expect((await controller.getLimitOrders()).orders, isNotEmpty);
      expect((await controller.getRiskAnalytics()).metrics, isNotEmpty);
    });
  });
}
