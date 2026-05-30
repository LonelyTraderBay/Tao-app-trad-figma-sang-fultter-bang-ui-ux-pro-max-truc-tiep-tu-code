part of 'p2p_entities.dart';

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

final class P2PSecurityCenterSnapshot {
  const P2PSecurityCenterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.score,
    required this.maxScore,
    required this.scoreLabel,
    required this.scoreSubtitle,
    required this.scoreBody,
    required this.features,
    required this.quickActions,
    required this.recentEvents,
    required this.parentRoute,
    required this.settingsRoute,
    required this.loginHistoryRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int score;
  final int maxScore;
  final String scoreLabel;
  final String scoreSubtitle;
  final String scoreBody;
  final List<P2PSecurityFeatureDraft> features;
  final List<P2PSecurityQuickActionDraft> quickActions;
  final List<P2PSecurityEventDraft> recentEvents;
  final String parentRoute;
  final String settingsRoute;
  final String loginHistoryRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PSecurityFeatureDraft {
  const P2PSecurityFeatureDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.status,
    required this.scoreDelta,
    required this.route,
  });

  final String id;
  final String label;
  final String iconKey;
  final P2PSecurityStatus status;
  final int scoreDelta;
  final String route;
}

final class P2PSecurityQuickActionDraft {
  const P2PSecurityQuickActionDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.colorKey,
    required this.route,
  });

  final String id;
  final String label;
  final String iconKey;
  final String colorKey;
  final String route;
}

final class P2PSecurityEventDraft {
  const P2PSecurityEventDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.time,
    required this.iconKey,
    required this.severity,
  });

  final String id;
  final String label;
  final String description;
  final String time;
  final String iconKey;
  final P2PSecurityEventSeverity severity;
}

final class P2PTwoFactorSettingsSnapshot {
  const P2PTwoFactorSettingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methods,
    required this.thresholds,
    required this.recommendation,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PTwoFactorMethodDraft> methods;
  final List<P2PTransactionThresholdDraft> thresholds;
  final String recommendation;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PTwoFactorMethodDraft {
  const P2PTwoFactorMethodDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.colorKey,
    required this.enabled,
    required this.isPrimary,
    required this.setupRequired,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final String colorKey;
  final bool enabled;
  final bool isPrimary;
  final bool setupRequired;

  P2PTwoFactorMethodDraft copyWith({
    bool? enabled,
    bool? isPrimary,
    bool? setupRequired,
  }) {
    return P2PTwoFactorMethodDraft(
      id: id,
      label: label,
      description: description,
      iconKey: iconKey,
      colorKey: colorKey,
      enabled: enabled ?? this.enabled,
      isPrimary: isPrimary ?? this.isPrimary,
      setupRequired: setupRequired ?? this.setupRequired,
    );
  }
}

final class P2PTransactionThresholdDraft {
  const P2PTransactionThresholdDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.valueLabel,
    required this.enabled,
    required this.editable,
  });

  final String id;
  final String label;
  final String description;
  final String valueLabel;
  final bool enabled;
  final bool editable;

  P2PTransactionThresholdDraft copyWith({bool? enabled}) {
    return P2PTransactionThresholdDraft(
      id: id,
      label: label,
      description: description,
      valueLabel: valueLabel,
      enabled: enabled ?? this.enabled,
      editable: editable,
    );
  }
}

final class P2PDeviceManagementSnapshot {
  const P2PDeviceManagementSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.devices,
    required this.infoTitle,
    required this.infoBody,
    required this.securityTips,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PTrustedDeviceDraft> devices;
  final String infoTitle;
  final String infoBody;
  final List<String> securityTips;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  List<P2PTrustedDeviceDraft> get trustedDevices =>
      devices.where((device) => device.isTrusted).toList(growable: false);

  List<P2PTrustedDeviceDraft> get untrustedDevices =>
      devices.where((device) => !device.isTrusted).toList(growable: false);
}

final class P2PTrustedDeviceDraft {
  const P2PTrustedDeviceDraft({
    required this.id,
    required this.name,
    required this.type,
    required this.os,
    required this.browser,
    required this.location,
    required this.ip,
    required this.lastActive,
    required this.firstSeen,
    required this.isCurrent,
    required this.isTrusted,
    required this.fingerprint,
  });

  final String id;
  final String name;
  final String type;
  final String os;
  final String browser;
  final String location;
  final String ip;
  final String lastActive;
  final String firstSeen;
  final bool isCurrent;
  final bool isTrusted;
  final String fingerprint;

  P2PTrustedDeviceDraft copyWith({bool? isTrusted}) {
    return P2PTrustedDeviceDraft(
      id: id,
      name: name,
      type: type,
      os: os,
      browser: browser,
      location: location,
      ip: ip,
      lastActive: lastActive,
      firstSeen: firstSeen,
      isCurrent: isCurrent,
      isTrusted: isTrusted ?? this.isTrusted,
      fingerprint: fingerprint,
    );
  }
}
