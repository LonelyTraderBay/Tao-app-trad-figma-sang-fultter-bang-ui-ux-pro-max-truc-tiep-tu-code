enum SmartAlertsScreenState { loading, empty, error, offline }

enum SmartAlertTab { active, history, settings }

enum SmartAlertModuleId { trading, p2p, predictions, arena, dca, wallet }

enum SmartAlertStatus { active, paused, triggered }

final class SmartAlertsSnapshot {
  const SmartAlertsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.alerts,
    required this.history,
    required this.channels,
    required this.templates,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<SmartAlertTabDraft> tabs;
  final List<SmartAlertDraft> alerts;
  final List<SmartAlertHistoryDraft> history;
  final List<SmartAlertChannelDraft> channels;
  final List<SmartAlertTemplateDraft> templates;
  final String contractNotes;
  final Set<SmartAlertsScreenState> supportedStates;

  int get activeCount =>
      alerts.where((alert) => alert.status == SmartAlertStatus.active).length;

  int get totalTriggers =>
      alerts.fold(0, (sum, alert) => sum + alert.triggerCount);

  int get moduleCount => alerts.map((alert) => alert.module).toSet().length;
}

final class SmartAlertTabDraft {
  const SmartAlertTabDraft({required this.tab, required this.label});

  final SmartAlertTab tab;
  final String label;
}

final class SmartAlertDraft {
  const SmartAlertDraft({
    required this.id,
    required this.module,
    required this.moduleName,
    required this.type,
    required this.condition,
    required this.action,
    required this.status,
    required this.triggerCount,
    this.lastTriggeredLabel,
  });

  final String id;
  final SmartAlertModuleId module;
  final String moduleName;
  final String type;
  final String condition;
  final String action;
  final SmartAlertStatus status;
  final int triggerCount;
  final String? lastTriggeredLabel;
}

final class SmartAlertHistoryDraft {
  const SmartAlertHistoryDraft({
    required this.id,
    required this.alertName,
    required this.moduleName,
    required this.triggeredAtLabel,
    required this.action,
  });

  final String id;
  final String alertName;
  final String moduleName;
  final String triggeredAtLabel;
  final String action;
}

final class SmartAlertChannelDraft {
  const SmartAlertChannelDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.enabled,
  });

  final String id;
  final String label;
  final String description;
  final bool enabled;
}

final class SmartAlertTemplateDraft {
  const SmartAlertTemplateDraft({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.popularity,
  });

  final String id;
  final String category;
  final String name;
  final String description;
  final int popularity;
}
