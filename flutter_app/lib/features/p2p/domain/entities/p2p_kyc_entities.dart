part of 'p2p_entities.dart';

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

final class P2PKycStatusSnapshot {
  const P2PKycStatusSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.tier,
    required this.tierName,
    required this.overallStatus,
    required this.submittedAt,
    required this.steps,
    required this.infoBody,
    required this.supportTitle,
    required this.supportBody,
    required this.parentRoute,
    required this.supportRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int tier;
  final String tierName;
  final P2PKycVerificationStatus overallStatus;
  final String submittedAt;
  final List<P2PKycStatusStepDraft> steps;
  final String infoBody;
  final String supportTitle;
  final String supportBody;
  final String parentRoute;
  final String supportRoute;
  final String emptyTitle;
  final String contractNotes;

  int get completedSteps =>
      steps.where((step) => step.status == P2PKycStepStatus.completed).length;

  int get totalSteps => steps.length;

  double get progress => totalSteps == 0 ? 0 : completedSteps / totalSteps;

  String get progressLabel => '$completedSteps/$totalSteps bước';

  String get statusLabel => switch (overallStatus) {
    P2PKycVerificationStatus.approved => 'Đã duyệt',
    P2PKycVerificationStatus.pending => 'Đang xử lý',
    P2PKycVerificationStatus.rejected => 'Từ chối',
    P2PKycVerificationStatus.incomplete => 'Chưa hoàn tất',
  };
}

final class P2PKycStatusStepDraft {
  const P2PKycStatusStepDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.status,
    this.completedAt,
    this.rejectedReason,
    this.rejectedDetails,
    this.estimatedTime,
    this.actionLabel,
    this.actionRoute,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final P2PKycStepStatus status;
  final String? completedAt;
  final String? rejectedReason;
  final String? rejectedDetails;
  final String? estimatedTime;
  final String? actionLabel;
  final String? actionRoute;

  bool get hasAction => actionLabel != null && actionRoute != null;

  String get statusLabel => switch (status) {
    P2PKycStepStatus.completed => 'Hoàn thành',
    P2PKycStepStatus.processing => 'Đang xử lý',
    P2PKycStepStatus.pending => 'Chờ xử lý',
    P2PKycStepStatus.waiting => 'Chưa bắt đầu',
    P2PKycStepStatus.rejected => 'Từ chối',
  };
}

final class P2PIdentityVerificationSnapshot {
  const P2PIdentityVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.documentTypes,
    required this.guidelines,
    required this.securityNotes,
    required this.parentRoute,
    required this.nextRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final List<P2PIdentityDocumentTypeDraft> documentTypes;
  final List<String> guidelines;
  final List<String> securityNotes;
  final String parentRoute;
  final String nextRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PIdentityDocumentTypeDraft {
  const P2PIdentityDocumentTypeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
}

final class P2PAddressProofSnapshot {
  const P2PAddressProofSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.documentTypes,
    required this.requirements,
    required this.securityNotes,
    required this.extractedName,
    required this.extractedAddress,
    required this.extractedDate,
    required this.parentRoute,
    required this.submitRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final List<P2PAddressDocumentTypeDraft> documentTypes;
  final List<String> requirements;
  final List<String> securityNotes;
  final String extractedName;
  final String extractedAddress;
  final String extractedDate;
  final String parentRoute;
  final String submitRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PAddressDocumentTypeDraft {
  const P2PAddressDocumentTypeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.examples,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final List<String> examples;
}

final class P2PSelfieVerificationSnapshot {
  const P2PSelfieVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.sampleTitle,
    required this.sampleBody,
    required this.guidelines,
    required this.tips,
    required this.livenessActions,
    required this.matchScore,
    required this.livenessScore,
    required this.parentRoute,
    required this.statusRoute,
    required this.supportRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final String sampleTitle;
  final String sampleBody;
  final List<String> guidelines;
  final List<String> tips;
  final List<P2PSelfieLivenessActionDraft> livenessActions;
  final String matchScore;
  final String livenessScore;
  final String parentRoute;
  final String statusRoute;
  final String supportRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PSelfieLivenessActionDraft {
  const P2PSelfieLivenessActionDraft({
    required this.id,
    required this.label,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String iconKey;
}

final class P2PVideoVerificationSnapshot {
  const P2PVideoVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.preparationItems,
    required this.timeSlots,
    required this.parentRoute,
    required this.statusRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final List<String> preparationItems;
  final List<P2PVideoTimeSlotDraft> timeSlots;
  final String parentRoute;
  final String statusRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PVideoTimeSlotDraft {
  const P2PVideoTimeSlotDraft({
    required this.id,
    required this.date,
    required this.time,
    required this.available,
  });

  final String id;
  final String date;
  final String time;
  final bool available;
}

enum P2PKycTierStatus { locked, available, current, pending }

enum P2PKycVerificationStatus { approved, pending, rejected, incomplete }

enum P2PKycStepStatus { completed, pending, rejected, waiting, processing }
