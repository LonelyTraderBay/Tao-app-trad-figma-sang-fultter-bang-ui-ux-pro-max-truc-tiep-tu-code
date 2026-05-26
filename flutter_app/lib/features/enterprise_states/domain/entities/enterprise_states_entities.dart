enum EnterpriseStatesScreenState { loading, empty, error, offline }

enum EnterpriseStateSection { stateKit, applied, security }

enum EnterprisePreviewState { loading, empty, error, offline, gate }

enum EnterpriseBannerKind { info, warning, error }

final class EnterpriseStatesSnapshot {
  const EnterpriseStatesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tabs,
    required this.previewStates,
    required this.banners,
    required this.marketRoute,
    required this.kycRoute,
    required this.securityRoute,
    required this.loginRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<EnterpriseTabDraft> tabs;
  final List<EnterprisePreviewStateDraft> previewStates;
  final List<EnterpriseBannerDraft> banners;
  final String marketRoute;
  final String kycRoute;
  final String securityRoute;
  final String loginRoute;
  final String contractNotes;
  final Set<EnterpriseStatesScreenState> supportedStates;
}

final class EnterpriseTabDraft {
  const EnterpriseTabDraft({required this.section, required this.label});

  final EnterpriseStateSection section;
  final String label;
}

final class EnterprisePreviewStateDraft {
  const EnterprisePreviewStateDraft({
    required this.state,
    required this.label,
    required this.description,
  });

  final EnterprisePreviewState state;
  final String label;
  final String description;
}

final class EnterpriseBannerDraft {
  const EnterpriseBannerDraft({
    required this.kind,
    required this.title,
    this.detail,
  });

  final EnterpriseBannerKind kind;
  final String title;
  final String? detail;
}
