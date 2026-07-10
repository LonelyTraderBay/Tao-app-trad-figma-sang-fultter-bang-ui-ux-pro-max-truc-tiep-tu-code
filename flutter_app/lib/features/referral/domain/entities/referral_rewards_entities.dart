part of 'referral_entities.dart';

enum ReferralRewardFilter { all, kycBonus, tradeCommission }

enum ReferralRewardSort { date, amount }

enum ReferralRewardType { kycBonus, tradeCommission }

enum ReferralRewardStatus { completed, pending }

final class ReferralRewardsSnapshot {
  const ReferralRewardsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.totalCommission,
    required this.pendingCommission,
    required this.kycBonusTotal,
    required this.tradeCommissionTotal,
    required this.thisMonthCommission,
    required this.tierName,
    required this.tierNameEn,
    required this.chartPoints,
    required this.filters,
    required this.sortOptions,
    required this.records,
    required this.filter,
    required this.sort,
    required this.completedCount,
    required this.pendingCount,
    required this.exportRanges,
    required this.disputeTypes,
    required this.disputes,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final double totalCommission;
  final double pendingCommission;
  final double kycBonusTotal;
  final double tradeCommissionTotal;
  final double thisMonthCommission;
  final String tierName;
  final String tierNameEn;
  final List<ReferralChartPointDraft> chartPoints;
  final List<ReferralRewardFilterDraft> filters;
  final List<ReferralRewardSortDraft> sortOptions;
  final List<ReferralRewardRecordDraft> records;
  final ReferralRewardFilter filter;
  final ReferralRewardSort sort;
  final int completedCount;
  final int pendingCount;
  final List<ReferralExportRangeDraft> exportRanges;
  final List<ReferralDisputeTypeDraft> disputeTypes;
  final List<ReferralDisputeDraft> disputes;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}

final class ReferralChartPointDraft {
  const ReferralChartPointDraft({
    required this.month,
    required this.commission,
  });

  final String month;
  final double commission;
}

final class ReferralRewardFilterDraft {
  const ReferralRewardFilterDraft({required this.filter, required this.label});

  final ReferralRewardFilter filter;
  final String label;
}

final class ReferralRewardSortDraft {
  const ReferralRewardSortDraft({required this.sort, required this.label});

  final ReferralRewardSort sort;
  final String label;
}

final class ReferralRewardRecordDraft {
  const ReferralRewardRecordDraft({
    required this.id,
    required this.friendName,
    required this.friendInitial,
    required this.type,
    required this.amount,
    required this.currency,
    required this.action,
    required this.date,
    required this.status,
  });

  final String id;
  final String friendName;
  final String friendInitial;
  final ReferralRewardType type;
  final double amount;
  final String currency;
  final String action;
  final String date;
  final ReferralRewardStatus status;
}

final class ReferralExportRangeDraft {
  const ReferralExportRangeDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class ReferralDisputeTypeDraft {
  const ReferralDisputeTypeDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class ReferralDisputeDraft {
  const ReferralDisputeDraft({
    required this.id,
    required this.typeId,
    required this.description,
    required this.statusLabel,
    required this.createdDate,
    required this.resolvedDate,
    required this.resolution,
  });

  final String id;
  final String typeId;
  final String description;
  final String statusLabel;
  final String createdDate;
  final String? resolvedDate;
  final String? resolution;
}
