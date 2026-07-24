part of 'p2p_entities.dart';

/// Security score, enabled features, and recent activity for the security center screen.
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

/// A single security feature toggle contributing to the security score.
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

/// A single quick-action shortcut on the security center screen.
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

/// A single recent security event shown on the security center screen.
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

/// Two-factor authentication methods and transaction thresholds for the 2FA settings screen.
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

/// A single two-factor authentication method and its enabled state.
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

/// A single transaction-value threshold that triggers extra 2FA confirmation.
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

/// Trusted and untrusted devices for the device management screen.
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

/// A single device that has logged into the account.
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

/// A user's anti-phishing code, explainer, and email examples.
final class P2PAntiPhishingCodeSnapshot {
  const P2PAntiPhishingCodeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.hasCode,
    required this.currentCode,
    required this.statusTitle,
    required this.statusBody,
    required this.explainerTitle,
    required this.explainerBody,
    required this.benefits,
    required this.examples,
    required this.warningTitle,
    required this.warnings,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final bool hasCode;
  final String currentCode;
  final String statusTitle;
  final String statusBody;
  final String explainerTitle;
  final String explainerBody;
  final List<String> benefits;
  final List<P2PAntiPhishingExampleDraft> examples;
  final String warningTitle;
  final List<String> warnings;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

/// A single sample email used to illustrate legitimate vs. phishing messages.
final class P2PAntiPhishingExampleDraft {
  const P2PAntiPhishingExampleDraft({
    required this.id,
    required this.subject,
    required this.preview,
    required this.isLegit,
  });

  final String id;
  final String subject;
  final String preview;
  final bool isLegit;
}

/// Login event history and security tips for the login history screen.
final class P2PLoginHistorySnapshot {
  const P2PLoginHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.events,
    required this.warningBody,
    required this.infoTitle,
    required this.securityTips,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PLoginEventDraft> events;
  final String warningBody;
  final String infoTitle;
  final List<String> securityTips;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get successCount =>
      events.where((event) => event.status == 'success').length;

  int get riskEventCount => events.where((event) => event.isRiskEvent).length;
}

/// A single login event record.
final class P2PLoginEventDraft {
  const P2PLoginEventDraft({
    required this.id,
    required this.timestamp,
    required this.deviceType,
    required this.deviceName,
    required this.os,
    required this.browser,
    required this.city,
    required this.country,
    required this.ip,
    required this.status,
    required this.statusLabel,
    required this.method,
    required this.methodLabel,
    required this.isCurrent,
  });

  final String id;
  final String timestamp;
  final String deviceType;
  final String deviceName;
  final String os;
  final String browser;
  final String city;
  final String country;
  final String ip;
  final String status;
  final String statusLabel;
  final String method;
  final String methodLabel;
  final bool isCurrent;

  bool get isRiskEvent => status == 'suspicious' || status == 'failed';
}

/// Suspicious-activity alerts for the account security screen.
final class P2PSuspiciousActivitySnapshot {
  const P2PSuspiciousActivitySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.alerts,
    required this.summarySubtitle,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PSuspiciousAlertDraft> alerts;
  final String summarySubtitle;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get unreviewedCount => alerts.where((alert) => !alert.reviewed).length;
}

/// A single suspicious-activity alert and its review status.
final class P2PSuspiciousAlertDraft {
  const P2PSuspiciousAlertDraft({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.severity,
    required this.reviewed,
  });

  final String id;
  final String type;
  final String message;
  final String timestamp;
  final String severity;
  final bool reviewed;

  P2PSuspiciousAlertDraft copyWith({bool? reviewed}) {
    return P2PSuspiciousAlertDraft(
      id: id,
      type: type,
      message: message,
      timestamp: timestamp,
      severity: severity,
      reviewed: reviewed ?? this.reviewed,
    );
  }
}

/// Explainer content and fingerprint info for end-to-end chat encryption.
final class P2PE2EInfoSnapshot {
  const P2PE2EInfoSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.localLabel,
    required this.partnerLabel,
    required this.diagramCaption,
    required this.infoItems,
    required this.fingerprint,
    required this.fingerprintHint,
    required this.steps,
    required this.serverNote,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroSubtitle;
  final String localLabel;
  final String partnerLabel;
  final String diagramCaption;
  final List<P2PE2EInfoItemDraft> infoItems;
  final String fingerprint;
  final String fingerprintHint;
  final List<P2PE2EStepDraft> steps;
  final String serverNote;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

/// A single explainer item on the end-to-end encryption info screen.
final class P2PE2EInfoItemDraft {
  const P2PE2EInfoItemDraft({
    required this.id,
    required this.iconKey,
    required this.title,
    required this.description,
    required this.toneKey,
  });

  final String id;
  final String iconKey;
  final String title;
  final String description;
  final String toneKey;
}

/// A single step in the end-to-end encryption explainer.
final class P2PE2EStepDraft {
  const P2PE2EStepDraft({
    required this.id,
    required this.step,
    required this.title,
    required this.description,
  });

  final String id;
  final String step;
  final String title;
  final String description;
}

/// Scam patterns, safety checklist, and emergency actions for the fraud prevention screen.
final class P2PFraudPreventionSnapshot {
  const P2PFraudPreventionSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.patterns,
    required this.checklist,
    required this.emergencyActions,
    required this.disclosure,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PScamPatternDraft> patterns;
  final List<P2PSafetyChecklistItemDraft> checklist;
  final List<P2PFraudEmergencyActionDraft> emergencyActions;
  final String disclosure;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get checkedSafetyCount => checklist.where((item) => item.checked).length;

  int get safetyScore => (checkedSafetyCount / checklist.length * 100).round();
}

/// A single known scam pattern with red flags and prevention tips.
final class P2PScamPatternDraft {
  const P2PScamPatternDraft({
    required this.id,
    required this.title,
    required this.severity,
    required this.description,
    required this.howItWorks,
    required this.redFlags,
    required this.prevention,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String severity;
  final String description;
  final List<String> howItWorks;
  final List<String> redFlags;
  final List<String> prevention;
  final String iconKey;
}

/// A single item in the trade-safety checklist.
final class P2PSafetyChecklistItemDraft {
  const P2PSafetyChecklistItemDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.checked,
    required this.category,
  });

  final String id;
  final String label;
  final String description;
  final bool checked;
  final String category;

  P2PSafetyChecklistItemDraft copyWith({bool? checked}) {
    return P2PSafetyChecklistItemDraft(
      id: id,
      label: label,
      description: description,
      checked: checked ?? this.checked,
      category: category,
    );
  }
}

/// A single emergency action shortcut shown on the fraud prevention screen.
final class P2PFraudEmergencyActionDraft {
  const P2PFraudEmergencyActionDraft({
    required this.id,
    required this.label,
    required this.route,
    required this.toneKey,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final String toneKey;
  final String iconKey;
}

/// Enabled/warning/disabled state of a security feature.
enum P2PSecurityStatus { enabled, warning, disabled }

/// Severity level of a security event.
enum P2PSecurityEventSeverity { info, warning, critical }
