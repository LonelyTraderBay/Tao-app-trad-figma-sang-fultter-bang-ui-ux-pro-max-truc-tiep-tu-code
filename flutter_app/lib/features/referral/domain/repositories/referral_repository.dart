import 'package:vit_trade_flutter/features/referral/domain/entities/referral_entities.dart';

/// Data source contract for the Referral feature: read snapshots for the
/// home, history, rewards, rules, and friend-detail screens.
abstract interface class ReferralRepository {
  ReferralHomeSnapshot getHome();

  ReferralHistorySnapshot getHistory({
    ReferralFriendFilter filter = ReferralFriendFilter.all,
    ReferralHistorySort sort = ReferralHistorySort.date,
    String query = '',
  });

  ReferralRewardsSnapshot getRewards({
    ReferralRewardFilter filter = ReferralRewardFilter.all,
    ReferralRewardSort sort = ReferralRewardSort.date,
  });

  ReferralRulesSnapshot getRules();

  ReferralFriendDetailSnapshot getFriendDetail(String friendId);
}
