import 'package:vit_trade_flutter/features/referral/domain/entities/referral_entities.dart';
import 'package:vit_trade_flutter/features/referral/domain/repositories/referral_repository.dart';

export 'package:vit_trade_flutter/features/referral/domain/entities/referral_entities.dart';
export 'package:vit_trade_flutter/features/referral/domain/repositories/referral_repository.dart';

final class ReferralController implements ReferralRepository {
  const ReferralController(this._repository);

  final ReferralRepository _repository;

  @override
  Future<ReferralHomeSnapshot> getHome() {
    return _repository.getHome();
  }

  @override
  Future<ReferralHistorySnapshot> getHistory({
    ReferralFriendFilter filter = ReferralFriendFilter.all,
    ReferralHistorySort sort = ReferralHistorySort.date,
    String query = '',
  }) {
    return _repository.getHistory(filter: filter, sort: sort, query: query);
  }

  @override
  Future<ReferralRewardsSnapshot> getRewards({
    ReferralRewardFilter filter = ReferralRewardFilter.all,
    ReferralRewardSort sort = ReferralRewardSort.date,
  }) {
    return _repository.getRewards(filter: filter, sort: sort);
  }

  @override
  Future<ReferralRulesSnapshot> getRules() {
    return _repository.getRules();
  }

  @override
  Future<ReferralFriendDetailSnapshot> getFriendDetail(String friendId) {
    return _repository.getFriendDetail(friendId);
  }
}
