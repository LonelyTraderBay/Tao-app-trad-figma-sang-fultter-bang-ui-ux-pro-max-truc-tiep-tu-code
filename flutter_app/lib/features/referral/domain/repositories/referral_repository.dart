import 'package:vit_trade_flutter/features/referral/domain/entities/referral_entities.dart';

/// Data source contract for the Referral feature: read snapshots for the
/// home, history, rewards, rules, and friend-detail screens.
abstract interface class ReferralRepository {
  Future<ReferralHomeSnapshot> getHome();

  Future<ReferralHistorySnapshot> getHistory({
    ReferralFriendFilter filter = ReferralFriendFilter.all,
    ReferralHistorySort sort = ReferralHistorySort.date,
    String query = '',
  });

  Future<ReferralRewardsSnapshot> getRewards({
    ReferralRewardFilter filter = ReferralRewardFilter.all,
    ReferralRewardSort sort = ReferralRewardSort.date,
  });

  Future<ReferralRulesSnapshot> getRules();

  Future<ReferralFriendDetailSnapshot> getFriendDetail(String friendId);
}
