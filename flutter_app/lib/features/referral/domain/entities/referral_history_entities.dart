part of 'referral_entities.dart';

enum ReferralFriendFilter { all, activeTrader, kycDone, pendingKyc }

enum ReferralHistorySort { date, commission, volume }

enum ReferralFriendStatus { pendingKyc, kycDone, activeTrader, inactive }

final class ReferralHistorySnapshot {
  const ReferralHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.searchHint,
    required this.stats,
    required this.filters,
    required this.sortOptions,
    required this.friends,
    required this.filter,
    required this.sort,
    required this.query,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String searchHint;
  final ReferralStatsDraft stats;
  final List<ReferralFilterDraft> filters;
  final List<ReferralSortDraft> sortOptions;
  final List<ReferralFriendDraft> friends;
  final ReferralFriendFilter filter;
  final ReferralHistorySort sort;
  final String query;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}

final class ReferralStatsDraft {
  const ReferralStatsDraft({
    required this.totalFriends,
    required this.kycCompleted,
    required this.activeFriends,
  });

  final int totalFriends;
  final int kycCompleted;
  final int activeFriends;
}

final class ReferralFilterDraft {
  const ReferralFilterDraft({
    required this.filter,
    required this.label,
    required this.count,
  });

  final ReferralFriendFilter filter;
  final String label;
  final int count;
}

final class ReferralSortDraft {
  const ReferralSortDraft({required this.sort, required this.label});

  final ReferralHistorySort sort;
  final String label;
}

final class ReferralFriendDraft {
  const ReferralFriendDraft({
    required this.id,
    required this.initial,
    required this.name,
    required this.joinedDate,
    required this.status,
    required this.totalCommission,
    required this.totalVolume,
    required this.firstTradeDate,
    required this.route,
  });

  final String id;
  final String initial;
  final String name;
  final String joinedDate;
  final ReferralFriendStatus status;
  final double totalCommission;
  final double totalVolume;
  final String? firstTradeDate;
  final String route;

  bool get kycCompleted => status != ReferralFriendStatus.pendingKyc;
  bool get canRemindKyc => status == ReferralFriendStatus.pendingKyc;
}
