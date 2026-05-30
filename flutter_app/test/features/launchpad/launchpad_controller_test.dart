import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/launchpad/data/repositories/mock_launchpad_repository.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

void main() {
  group('LaunchpadController', () {
    test('exposes core launchpad snapshots through repository contract', () {
      final controller = LaunchpadController(const MockLaunchpadRepository());

      final home = controller.getHome();
      final detail = controller.getDetail('vitx');
      final portfolio = controller.getPortfolio();

      expect(home.endpoint, '/api/mobile/launchpad/launchpad');
      expect(home.projects, isNotEmpty);
      expect(detail.projectId, 'vitx');
      expect(portfolio.subscriptions, isNotEmpty);
      expect(home.supportedStates, contains(LaunchpadScreenState.offline));
    });

    test('exposes advanced tool read models without data imports', () {
      final controller = LaunchpadController(const MockLaunchpadRepository());

      expect(controller.getBridgeCompare().comparison.routes, isNotEmpty);
      expect(controller.getGasTracker().prices, isNotEmpty);
      expect(controller.getLimitOrders().orders, isNotEmpty);
      expect(controller.getRiskAnalytics().metrics, isNotEmpty);
    });
  });
}
