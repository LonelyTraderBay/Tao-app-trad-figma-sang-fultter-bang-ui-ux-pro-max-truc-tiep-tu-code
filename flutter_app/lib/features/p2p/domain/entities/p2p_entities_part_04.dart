part of 'p2p_entities.dart';

final class P2PInsuranceScoreSnapshot {
  const P2PInsuranceScoreSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.overallScore,
    required this.maxScore,
    required this.grade,
    required this.gradeLabel,
    required this.gradeDescription,
    required this.currentTier,
    required this.factors,
    required this.quickActions,
    required this.tierRequirements,
    required this.disclosure,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int overallScore;
  final int maxScore;
  final String grade;
  final String gradeLabel;
  final String gradeDescription;
  final String currentTier;
  final List<P2PInsuranceScoreFactorDraft> factors;
  final List<P2PInsuranceScoreQuickActionDraft> quickActions;
  final List<P2PInsuranceScoreTierDraft> tierRequirements;
  final String disclosure;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get potentialGain =>
      factors.fold(0, (sum, factor) => sum + (factor.maxScore - factor.score));
}

final class P2PInsuranceScoreFactorDraft {
  const P2PInsuranceScoreFactorDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.score,
    required this.maxScore,
    required this.statusLabel,
    required this.toneKey,
    required this.iconKey,
    this.recommendation,
  });

  final String id;
  final String label;
  final String description;
  final int score;
  final int maxScore;
  final String statusLabel;
  final String toneKey;
  final String iconKey;
  final String? recommendation;
}

final class P2PInsuranceScoreQuickActionDraft {
  const P2PInsuranceScoreQuickActionDraft({
    required this.label,
    required this.gain,
    required this.toneKey,
    this.route,
  });

  final String label;
  final String gain;
  final String toneKey;
  final String? route;
}

final class P2PInsuranceScoreTierDraft {
  const P2PInsuranceScoreTierDraft({
    required this.name,
    required this.requiredScore,
    required this.coveragePct,
    required this.requirements,
    required this.isCurrent,
    required this.isUnlocked,
  });

  final String name;
  final int requiredScore;
  final String coveragePct;
  final List<String> requirements;
  final bool isCurrent;
  final bool isUnlocked;
}

final class P2PInsurancePolicySnapshot {
  const P2PInsurancePolicySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.version,
    required this.lastUpdated,
    required this.notice,
    required this.sections,
    required this.privacyNotice,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String version;
  final String lastUpdated;
  final String notice;
  final List<P2PInsurancePolicySectionDraft> sections;
  final String privacyNotice;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PInsurancePolicySectionDraft {
  const P2PInsurancePolicySectionDraft({
    required this.id,
    required this.title,
    required this.content,
  });

  final String id;
  final String title;
  final List<String> content;
}

final class P2PContributionHistorySnapshot {
  const P2PContributionHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.contributions,
    required this.contributionRateLabel,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PContributionDraft> contributions;
  final String contributionRateLabel;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get totalContributed => contributions.fold(
    0,
    (sum, contribution) => sum + contribution.contributionAmount,
  );

  int get totalTrades => contributions.length;

  int get averagePerTrade =>
      totalTrades == 0 ? 0 : (totalContributed / totalTrades).round();

  List<P2PContributionMonthDraft> get monthlyGroups {
    final grouped = <String, List<P2PContributionDraft>>{};
    for (final contribution in contributions) {
      grouped
          .putIfAbsent(contribution.monthKey, () => <P2PContributionDraft>[])
          .add(contribution);
    }

    final groups = grouped.entries.map((entry) {
      final total = entry.value.fold(
        0,
        (sum, contribution) => sum + contribution.contributionAmount,
      );
      return P2PContributionMonthDraft(
        month: entry.key,
        monthLabel: _monthLabel(entry.key),
        totalAmount: total,
        count: entry.value.length,
        contributions: entry.value,
      );
    }).toList()..sort((a, b) => b.month.compareTo(a.month));

    return groups;
  }
}

final class P2PContributionDraft {
  const P2PContributionDraft({
    required this.id,
    required this.date,
    required this.orderId,
    required this.orderAmount,
    required this.contributionAmount,
    required this.feeRate,
    required this.coin,
  });

  final String id;
  final String date;
  final String orderId;
  final int orderAmount;
  final int contributionAmount;
  final double feeRate;
  final String coin;

  String get monthKey => date.substring(0, 7);

  String get displayDate {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}

final class P2PContributionMonthDraft {
  const P2PContributionMonthDraft({
    required this.month,
    required this.monthLabel,
    required this.totalAmount,
    required this.count,
    required this.contributions,
  });

  final String month;
  final String monthLabel;
  final int totalAmount;
  final int count;
  final List<P2PContributionDraft> contributions;
}

final class P2PEscrowBalanceSnapshot {
  const P2PEscrowBalanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.selectedAsset,
    required this.assets,
    required this.ordersByAsset,
    required this.title,
    required this.subtitle,
    required this.infoTitle,
    required this.infoBody,
    required this.helpTitle,
    required this.helpBullets,
    required this.parentRoute,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String selectedAsset;
  final List<P2PEscrowAssetBalanceDraft> assets;
  final Map<String, List<P2PEscrowOrderDraft>> ordersByAsset;
  final String title;
  final String subtitle;
  final String infoTitle;
  final String infoBody;
  final String helpTitle;
  final List<String> helpBullets;
  final String parentRoute;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  List<P2PEscrowOrderDraft> ordersFor(String asset) =>
      ordersByAsset[asset] ?? const <P2PEscrowOrderDraft>[];

  P2PEscrowAssetBalanceDraft assetBalance(String asset) {
    return assets.firstWhere(
      (item) => item.asset == asset,
      orElse: () => assets.first,
    );
  }
}

final class P2PEscrowAssetBalanceDraft {
  const P2PEscrowAssetBalanceDraft({
    required this.asset,
    required this.totalAmount,
    required this.orderCount,
  });

  final String asset;
  final double totalAmount;
  final int orderCount;
}

final class P2PEscrowOrderDraft {
  const P2PEscrowOrderDraft({
    required this.id,
    required this.orderId,
    required this.type,
    required this.asset,
    required this.amount,
    required this.fiatAmount,
    required this.fiatCurrency,
    required this.counterparty,
    required this.status,
    required this.lockedAt,
    required this.estimatedRelease,
    this.warning,
  });

  final String id;
  final String orderId;
  final P2PEscrowOrderType type;
  final String asset;
  final double amount;
  final int fiatAmount;
  final String fiatCurrency;
  final String counterparty;
  final P2PEscrowOrderStatus status;
  final String lockedAt;
  final String estimatedRelease;
  final String? warning;

  String get canonicalOrderId => orderId.replaceFirst('#P2P-', '');

  String get typeLabel => switch (type) {
    P2PEscrowOrderType.buy => 'MUA',
    P2PEscrowOrderType.sell => 'BÁN',
  };

  String get statusLabel => switch (status) {
    P2PEscrowOrderStatus.pendingPayment => 'Chờ thanh toán',
    P2PEscrowOrderStatus.paid => 'Đã thanh toán',
    P2PEscrowOrderStatus.pendingRelease => 'Chờ release',
    P2PEscrowOrderStatus.dispute => 'Tranh chấp',
  };
}

final class P2PEscrowDetailSnapshot {
  const P2PEscrowDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.orderId,
    required this.order,
    required this.statusLabel,
    required this.statusToneKey,
    required this.escrowAddress,
    required this.explorerRoute,
    required this.signers,
    required this.timeline,
    required this.securityTitle,
    required this.securityBody,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String orderId;
  final P2POrderDetailDraft order;
  final String statusLabel;
  final String statusToneKey;
  final String escrowAddress;
  final String explorerRoute;
  final List<P2PEscrowSignerDraft> signers;
  final List<P2PEscrowTimelineEventDraft> timeline;
  final String securityTitle;
  final String securityBody;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get signedCount => signers.where((signer) => signer.hasSigned).length;

  int get signerCount => signers.length;

  String get maskedAddress => _maskAddress(escrowAddress);
}

final class P2PEscrowSignerDraft {
  const P2PEscrowSignerDraft({
    required this.id,
    required this.role,
    required this.label,
    required this.address,
    required this.hasSigned,
    this.signedAt,
  });

  final String id;
  final String role;
  final String label;
  final String address;
  final bool hasSigned;
  final String? signedAt;

  String get maskedAddress => _maskAddress(address);
}

final class P2PEscrowTimelineEventDraft {
  const P2PEscrowTimelineEventDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.time,
    required this.status,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String description;
  final String time;
  final P2POrderStepStatus status;
  final String iconKey;
}

final class P2PKycRequirementsSnapshot {
  const P2PKycRequirementsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.currentTier,
    required this.pendingTier,
    required this.tiers,
    required this.heroTitle,
    required this.heroBody,
    required this.noticeTitle,
    required this.noticeBody,
    required this.supportTitle,
    required this.supportBody,
    required this.verifyRouteBase,
    required this.supportRoute,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int currentTier;
  final int? pendingTier;
  final List<P2PKycTierDraft> tiers;
  final String heroTitle;
  final String heroBody;
  final String noticeTitle;
  final String noticeBody;
  final String supportTitle;
  final String supportBody;
  final String verifyRouteBase;
  final String supportRoute;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  String verifyRouteFor(int tierId) => '$verifyRouteBase?tier=$tierId';
}

final class P2PKycTierDraft {
  const P2PKycTierDraft({
    required this.id,
    required this.name,
    required this.badge,
    required this.toneKey,
    required this.iconKey,
    required this.requirements,
    required this.limits,
    required this.benefits,
    required this.verificationTime,
    required this.status,
  });

  final int id;
  final String name;
  final String badge;
  final String toneKey;
  final String iconKey;
  final List<P2PKycRequirementDraft> requirements;
  final P2PKycLimitsDraft limits;
  final List<String> benefits;
  final String verificationTime;
  final P2PKycTierStatus status;
}

final class P2PKycRequirementDraft {
  const P2PKycRequirementDraft({required this.label, required this.iconKey});

  final String label;
  final String iconKey;
}

final class P2PKycLimitsDraft {
  const P2PKycLimitsDraft({
    required this.dailyBuy,
    required this.dailySell,
    required this.monthlyVolume,
  });

  final int dailyBuy;
  final int dailySell;
  final int monthlyVolume;
}
