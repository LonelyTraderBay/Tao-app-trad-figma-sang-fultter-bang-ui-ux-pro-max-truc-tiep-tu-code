part of 'p2p_entities.dart';

/// Insurance fund overview: balance, claims, coverage tier, and fund health for the insurance screen.
final class P2PInsuranceFundSnapshot {
  const P2PInsuranceFundSnapshot({
    required this.endpoint,
    required this.legacyEndpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalFund,
    required this.activeClaims,
    required this.totalContributed,
    required this.totalPaid,
    required this.userCoveragePct,
    required this.tierName,
    required this.contributionRate,
    required this.outstandingClaimsAmount,
    required this.solvencyRatio,
    required this.healthStatus,
    required this.lastAuditDate,
    required this.auditorName,
    required this.nextAuditDate,
    required this.maxClaimPerPeriod,
    required this.approvalRate,
    required this.avgResolutionHours,
    required this.eligibilityItems,
    required this.coverageTiers,
    required this.notificationPrefs,
    required this.claims,
    required this.chartPoints,
    required this.certificateRoute,
    required this.contributionHistoryRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String legacyEndpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int totalFund;
  final int activeClaims;
  final int totalContributed;
  final int totalPaid;
  final int userCoveragePct;
  final String tierName;
  final String contributionRate;
  final int outstandingClaimsAmount;
  final double solvencyRatio;
  final String healthStatus;
  final String lastAuditDate;
  final String auditorName;
  final String nextAuditDate;
  final int maxClaimPerPeriod;
  final double approvalRate;
  final int avgResolutionHours;
  final List<P2PInsuranceEligibilityItemDraft> eligibilityItems;
  final List<P2PInsuranceCoverageTierDraft> coverageTiers;
  final List<P2PInsuranceNotificationPrefDraft> notificationPrefs;
  final List<P2PInsuranceClaimDraft> claims;
  final List<P2PInsuranceChartPointDraft> chartPoints;
  final String certificateRoute;
  final String contributionHistoryRoute;
  final String emptyTitle;
  final String contractNotes;
}

/// A single eligibility requirement row shown on the insurance fund screen.
final class P2PInsuranceEligibilityItemDraft {
  const P2PInsuranceEligibilityItemDraft({
    required this.label,
    this.value,
    this.highlight = false,
  });

  final String label;
  final String? value;
  final bool highlight;
}

/// A single coverage tier and its benefits on the insurance fund screen.
final class P2PInsuranceCoverageTierDraft {
  const P2PInsuranceCoverageTierDraft({
    required this.name,
    required this.coveragePct,
    this.bonus,
    this.highlight = false,
  });

  final String name;
  final String coveragePct;
  final String? bonus;
  final bool highlight;
}

/// A single notification preference toggle for insurance fund updates.
final class P2PInsuranceNotificationPrefDraft {
  const P2PInsuranceNotificationPrefDraft({
    required this.key,
    required this.label,
    required this.description,
    required this.enabled,
  });

  final String key;
  final String label;
  final String description;
  final bool enabled;
}

/// Lifecycle status of an insurance claim.
enum P2PInsuranceClaimStatus { pending, reviewing, approved, rejected, paid }

/// A single insurance claim as listed on the insurance fund screen.
final class P2PInsuranceClaimDraft {
  const P2PInsuranceClaimDraft({
    required this.id,
    required this.claimCode,
    required this.orderId,
    required this.reason,
    required this.amount,
    required this.status,
    required this.submittedAt,
    this.paidAmount,
  });

  final String id;
  final String claimCode;
  final String orderId;
  final String reason;
  final int amount;
  final int? paidAmount;
  final P2PInsuranceClaimStatus status;
  final String submittedAt;
}

/// One day's balance/inflow/outflow point in the insurance fund chart.
final class P2PInsuranceChartPointDraft {
  const P2PInsuranceChartPointDraft({
    required this.day,
    required this.balance,
    required this.inflow,
    required this.outflow,
  });

  final String day;
  final int balance;
  final int inflow;
  final int outflow;
}

/// Insurance certificate details for a user, including coverage limits and SLA terms.
final class P2PInsuranceCertificateSnapshot {
  const P2PInsuranceCertificateSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.certId,
    required this.holderName,
    required this.holderId,
    required this.tierName,
    required this.coveragePct,
    required this.maxCoveragePerClaim,
    required this.maxCoveragePer30Days,
    required this.contributionRate,
    required this.issueDate,
    required this.validUntil,
    required this.totalContributed,
    required this.totalTransactions,
    required this.claimWindowDays,
    required this.reviewSla,
    required this.payoutSla,
    required this.auditor,
    required this.lastAuditDate,
    required this.coveredCases,
    required this.exclusions,
    required this.disclosure,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String certId;
  final String holderName;
  final String holderId;
  final String tierName;
  final int coveragePct;
  final int maxCoveragePerClaim;
  final int maxCoveragePer30Days;
  final String contributionRate;
  final String issueDate;
  final String validUntil;
  final int totalContributed;
  final int totalTransactions;
  final int claimWindowDays;
  final String reviewSla;
  final String payoutSla;
  final String auditor;
  final String lastAuditDate;
  final List<String> coveredCases;
  final List<String> exclusions;
  final String disclosure;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  String get shareText =>
      'Chứng nhận bảo hiểm: $certId - Tier $tierName ($coveragePct%)';

  String get exportText =>
      '''
CHỨNG NHẬN BẢO HIỂM GIAO DỊCH P2P
P2P Trading Insurance Certificate

Mã chứng nhận: $certId
Ngày cấp: $issueDate
Hiệu lực đến: $validUntil

Người được bảo hiểm: $holderName
Mã người dùng: $holderId
Tier: $tierName

Tỷ lệ bảo hiểm: $coveragePct% giá trị giao dịch
Hạn mức/claim: $maxCoveragePerClaim VND
Hạn mức/30 ngày: $maxCoveragePer30Days VND
Cửa sổ claim: $claimWindowDays ngày sau sự cố
Phí đóng góp: $contributionRate mỗi giao dịch

Xem xét claim: Trong $reviewSla
Chi trả: Trong $payoutSla sau khi duyệt
Kiểm toán: $auditor
Kiểm toán gần nhất: $lastAuditDate

Tổng đóng góp: $totalContributed VND
Tổng giao dịch: $totalTransactions

Phạm vi bảo vệ:
${coveredCases.map((item) => '- $item').join('\n')}

Không bao gồm:
${exclusions.map((item) => '- $item').join('\n')}
''';
}

/// A user's insurance score, contributing factors, and tier requirements.
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

/// A single factor contributing to a user's insurance score.
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

/// A quick action suggesting how to raise the insurance score.
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

/// A single insurance score tier and its requirements.
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

/// Insurance policy document content for the policy screen.
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

/// A single section of the insurance policy document.
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

/// A user's insurance fund contribution history.
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

/// A single insurance fund contribution tied to one order.
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

/// Contributions grouped into a single month for the contribution history screen.
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

/// Full detail of a single insurance claim, including benchmarks and reason breakdown.
final class P2PClaimDetailSnapshot {
  const P2PClaimDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.claim,
    required this.benchmarks,
    required this.reasonShares,
    required this.parentRoute,
    required this.orderRoute,
    required this.supportRoute,
    required this.emptyTitle,
    required this.contractNotes,
    this.highRiskContractId,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PClaimDetailDraft claim;
  final List<P2PClaimBenchmarkDraft> benchmarks;
  final List<P2PClaimReasonShareDraft> reasonShares;
  final String parentRoute;
  final String orderRoute;
  final String supportRoute;
  final String emptyTitle;
  final String contractNotes;
  final String? highRiskContractId;
}

/// A single insurance claim with its timeline, evidence, and reviewer notes.
final class P2PClaimDetailDraft {
  const P2PClaimDetailDraft({
    required this.id,
    required this.claimCode,
    required this.orderId,
    required this.orderNumber,
    required this.reason,
    required this.description,
    required this.amount,
    required this.currency,
    required this.status,
    required this.submittedAt,
    required this.estimatedReview,
    required this.coveragePct,
    required this.maxCoverage,
    required this.timeline,
    required this.evidence,
    required this.reviewerNotes,
    required this.notificationsEnabled,
    this.paidAmount,
  });

  final String id;
  final String claimCode;
  final String orderId;
  final String orderNumber;
  final String reason;
  final String description;
  final int amount;
  final int? paidAmount;
  final String currency;
  final P2PInsuranceClaimStatus status;
  final String submittedAt;
  final String estimatedReview;
  final int coveragePct;
  final int maxCoverage;
  final List<P2PClaimTimelineEventDraft> timeline;
  final List<P2PClaimEvidenceDraft> evidence;
  final List<P2PClaimReviewerNoteDraft> reviewerNotes;
  final bool notificationsEnabled;

  String get statusLabel => switch (status) {
    P2PInsuranceClaimStatus.pending => 'Chờ xử lý',
    P2PInsuranceClaimStatus.reviewing => 'Đang xem xét',
    P2PInsuranceClaimStatus.approved => 'Đã duyệt',
    P2PInsuranceClaimStatus.rejected => 'Từ chối',
    P2PInsuranceClaimStatus.paid => 'Đã chi trả',
  };
}

/// A single event in an insurance claim's review timeline.
final class P2PClaimTimelineEventDraft {
  const P2PClaimTimelineEventDraft({
    required this.id,
    required this.statusKey,
    required this.title,
    required this.description,
    required this.timestamp,
    this.actor,
  });

  final String id;
  final String statusKey;
  final String title;
  final String description;
  final String timestamp;
  final String? actor;
}

/// A single evidence file attached to an insurance claim.
final class P2PClaimEvidenceDraft {
  const P2PClaimEvidenceDraft({
    required this.id,
    required this.type,
    required this.name,
    required this.size,
    required this.uploadedAt,
  });

  final String id;
  final String type;
  final String name;
  final String size;
  final String uploadedAt;
}

/// A single reviewer note left on an insurance claim.
final class P2PClaimReviewerNoteDraft {
  const P2PClaimReviewerNoteDraft({
    required this.id,
    required this.author,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  final String id;
  final String author;
  final String role;
  final String content;
  final String timestamp;
}

/// A single benchmark metric comparing a claim against platform norms.
final class P2PClaimBenchmarkDraft {
  const P2PClaimBenchmarkDraft({
    required this.id,
    required this.title,
    required this.value,
    required this.caption,
    required this.comparison,
    required this.progress,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String value;
  final String caption;
  final String comparison;
  final double progress;
  final String toneKey;
}

/// Share of claims attributed to a single reason, used in claim analytics.
final class P2PClaimReasonShareDraft {
  const P2PClaimReasonShareDraft({
    required this.label,
    required this.percent,
    this.highlight = false,
  });

  final String label;
  final int percent;
  final bool highlight;
}
