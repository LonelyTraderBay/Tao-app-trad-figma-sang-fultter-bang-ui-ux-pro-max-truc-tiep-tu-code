import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/rewards/data/repositories/mock_rewards_repository.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/controllers/rewards_controller.dart';

void main() {
  group('RewardsController', () {
    test('exposes rewards hub through repository contract', () async {
      final controller = const RewardsController(
        MockRewardsRepository(loadDelay: Duration.zero),
      );

      final snapshot = await controller.getHub();

      expect(snapshot.endpoint, '/api/mobile/rewards/rewards');
      expect(snapshot.summary.currentPoints, 2220);
      expect(snapshot.tasks, isNotEmpty);
      expect(snapshot.disclaimer, contains('khong phai tai san tai chinh'));
      expect(snapshot.supportedStates, contains(RewardsScreenState.offline));
    });
  });
}
