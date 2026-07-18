import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/referral/data/repositories/mock_referral_repository.dart';
import 'package:vit_trade_flutter/features/referral/presentation/controllers/referral_controller.dart';

void main() {
  group('ReferralController', () {
    test('exposes referral snapshots through repository contract', () {
      final controller = const ReferralController(MockReferralRepository());

      final home = controller.getHome();
      final filtered = controller.getHistory(
        filter: ReferralFriendFilter.pendingKyc,
      );
      final rewards = controller.getRewards(
        filter: ReferralRewardFilter.kycBonus,
      );

      expect(home.endpoint, '/api/mobile/referral/referral');
      expect(home.stats.totalFriends, 8);
      expect(filtered.friends.every((friend) => friend.canRemindKyc), isTrue);
      expect(
        rewards.records.every(
          (record) => record.type == ReferralRewardType.kycBonus,
        ),
        isTrue,
      );
      expect(home.supportedStates, contains(ReferralScreenState.offline));
    });
  });
}
