part of 'p2p_entities.dart';

final class P2PReviewsSnapshot {
  const P2PReviewsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.receivedReviews,
    required this.givenReviews,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PReviewDraft> receivedReviews;
  final List<P2PReviewDraft> givenReviews;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PReviewDraft {
  const P2PReviewDraft({
    required this.id,
    required this.orderId,
    required this.fromUser,
    required this.fromUserId,
    required this.toUser,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.positive,
    this.reply,
  });

  final String id;
  final String orderId;
  final String fromUser;
  final String fromUserId;
  final String toUser;
  final String toUserId;
  final int rating;
  final String comment;
  final String createdAt;
  final bool positive;
  final String? reply;
}

final class P2PPaymentMethodAddSnapshot {
  const P2PPaymentMethodAddSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.bankOptions,
    required this.ewalletOptions,
    required this.defaultBankAccountHint,
    required this.defaultEwalletAccountHint,
    required this.ownerNameHint,
    required this.saveRoute,
    required this.securityNote,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<String> bankOptions;
  final List<String> ewalletOptions;
  final String defaultBankAccountHint;
  final String defaultEwalletAccountHint;
  final String ownerNameHint;
  final String saveRoute;
  final String securityNote;
  final String confirmTitle;
  final String confirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentMethodVerificationSnapshot {
  const P2PPaymentMethodVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methodId,
    required this.methods,
    required this.microDepositSteps,
    required this.warningNote,
    required this.saveRoute,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String methodId;
  final List<P2PPaymentVerificationMethodDraft> methods;
  final List<String> microDepositSteps;
  final String warningNote;
  final String saveRoute;
  final String confirmTitle;
  final String confirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentVerificationMethodDraft {
  const P2PPaymentVerificationMethodDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.duration,
    required this.iconKey,
    this.recommended = false,
  });

  final String id;
  final String label;
  final String description;
  final String duration;
  final String iconKey;
  final bool recommended;
}

final class P2PPaymentMethodOwnershipSnapshot {
  const P2PPaymentMethodOwnershipSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methodId,
    required this.documents,
    required this.saveRoute,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String methodId;
  final List<P2POwnershipDocumentDraft> documents;
  final String saveRoute;
  final String confirmTitle;
  final String confirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2POwnershipDocumentDraft {
  const P2POwnershipDocumentDraft({
    required this.id,
    required this.label,
    this.optional = false,
  });

  final String id;
  final String label;
  final bool optional;
}

final class P2PPaymentMethodCoolingPeriodSnapshot {
  const P2PPaymentMethodCoolingPeriodSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.addedAt,
    required this.availableAt,
    required this.hoursRemaining,
    required this.reason,
    required this.reasons,
    required this.waitTitle,
    required this.waitMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String addedAt;
  final String availableAt;
  final int hoursRemaining;
  final String reason;
  final List<String> reasons;
  final String waitTitle;
  final String waitMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentMethodHistorySnapshot {
  const P2PPaymentMethodHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalTransactions,
    required this.totalVolume,
    required this.successRate,
    required this.transactions,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int totalTransactions;
  final int totalVolume;
  final double successRate;
  final List<P2PPaymentHistoryTransactionDraft> transactions;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentHistoryTransactionDraft {
  const P2PPaymentHistoryTransactionDraft({
    required this.id,
    required this.orderId,
    required this.type,
    required this.amount,
    required this.status,
    required this.timestamp,
  });

  final String id;
  final String orderId;
  final P2PTradeType type;
  final int amount;
  final String status;
  final String timestamp;
}

final class P2PPaymentMethodsSnapshot {
  const P2PPaymentMethodsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methods,
    required this.addBankRoute,
    required this.addEwalletRoute,
    required this.securityNote,
    required this.deleteConfirmTitle,
    required this.deleteConfirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PPaymentListMethodDraft> methods;
  final String addBankRoute;
  final String addEwalletRoute;
  final String securityNote;
  final String deleteConfirmTitle;
  final String deleteConfirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

enum P2PPaymentListMethodType { bank, ewallet }

final class P2PPaymentListMethodDraft {
  const P2PPaymentListMethodDraft({
    required this.id,
    required this.type,
    required this.name,
    required this.accountNumber,
    required this.accountName,
    required this.isVerified,
    this.isDefault = false,
  });

  final String id;
  final P2PPaymentListMethodType type;
  final String name;
  final String accountNumber;
  final String accountName;
  final bool isVerified;
  final bool isDefault;

  P2PPaymentListMethodDraft copyWith({bool? isDefault}) {
    return P2PPaymentListMethodDraft(
      id: id,
      type: type,
      name: name,
      accountNumber: accountNumber,
      accountName: accountName,
      isVerified: isVerified,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

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

enum P2PInsuranceClaimStatus { pending, reviewing, approved, rejected, paid }

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
