part of 'arena_entities.dart';

enum ConnectedEcosystemScreenStatus { vFinal, live, needsReview, archived }

enum ConnectedBridgeType { none, source, target, bidirectional }

enum ConnectedRuleSeverity { critical, high, medium }

enum ConnectedQaSeverity { must, should, may }

enum ArenaGuideTone { arena, info, success, warning, danger, accent, neutral }

enum ArenaGuideImpact { high, medium }

final class ConnectedEcosystemProductionSnapshot {
  const ConnectedEcosystemProductionSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.canonicalScreens,
    required this.bridgeStates,
    required this.connectedFlows,
    required this.sharedItems,
    required this.separateItems,
    required this.forbiddenPatterns,
    required this.routeRegistry,
    required this.componentRegistry,
    required this.bridgeRules,
    required this.qaChecklist,
    required this.footerDisclosure,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ConnectedScreenDraft> canonicalScreens;
  final List<ConnectedBridgeStateDraft> bridgeStates;
  final List<ConnectedFlowDraft> connectedFlows;
  final List<ConnectedRegistryItemDraft> sharedItems;
  final List<ConnectedRegistryItemDraft> separateItems;
  final List<ConnectedForbiddenPatternDraft> forbiddenPatterns;
  final List<ConnectedRouteEntryDraft> routeRegistry;
  final List<ConnectedComponentEntryDraft> componentRegistry;
  final List<ConnectedBridgeRuleDraft> bridgeRules;
  final List<ConnectedQaCheckDraft> qaChecklist;
  final String footerDisclosure;
  final Set<ArenaScreenState> supportedStates;
}

final class ConnectedScreenDraft {
  const ConnectedScreenDraft({
    required this.name,
    required this.route,
    required this.status,
    required this.source,
    required this.bridgeComponents,
    required this.notes,
  });

  final String name;
  final String route;
  final ConnectedEcosystemScreenStatus status;
  final String source;
  final List<String> bridgeComponents;
  final String notes;
}

final class ConnectedBridgeStateDraft {
  const ConnectedBridgeStateDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.tone,
    required this.affectedScreens,
    required this.behavior,
  });

  final String id;
  final String label;
  final String description;
  final ArenaBridgeTone tone;
  final List<String> affectedScreens;
  final String behavior;
}

final class ConnectedFlowDraft {
  const ConnectedFlowDraft({
    required this.id,
    required this.name,
    required this.tone,
    required this.steps,
  });

  final String id;
  final String name;
  final ArenaBridgeTone tone;
  final List<ConnectedFlowStepDraft> steps;
}

final class ConnectedFlowStepDraft {
  const ConnectedFlowStepDraft({
    required this.label,
    required this.route,
    required this.description,
    this.isBridge = false,
  });

  final String label;
  final String route;
  final String description;
  final bool isBridge;
}

final class ConnectedRegistryItemDraft {
  const ConnectedRegistryItemDraft({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

final class ConnectedForbiddenPatternDraft {
  const ConnectedForbiddenPatternDraft({
    required this.pattern,
    required this.reason,
    required this.severity,
  });

  final String pattern;
  final String reason;
  final ConnectedRuleSeverity severity;
}

final class ConnectedRouteEntryDraft {
  const ConnectedRouteEntryDraft({
    required this.route,
    required this.page,
    required this.bridgeType,
    required this.bridgeComponents,
  });

  final String route;
  final String page;
  final ConnectedBridgeType bridgeType;
  final List<String> bridgeComponents;
}

final class ConnectedComponentEntryDraft {
  const ConnectedComponentEntryDraft({
    required this.name,
    required this.file,
    required this.module,
    required this.usedIn,
    required this.disclosure,
  });

  final String name;
  final String file;
  final String module;
  final List<String> usedIn;
  final String disclosure;
}

final class ConnectedBridgeRuleDraft {
  const ConnectedBridgeRuleDraft({
    required this.field,
    required this.allowed,
    required this.reason,
  });

  final String field;
  final bool allowed;
  final String reason;
}

final class ConnectedQaCheckDraft {
  const ConnectedQaCheckDraft({
    required this.id,
    required this.category,
    required this.check,
    required this.severity,
  });

  final String id;
  final String category;
  final String check;
  final ConnectedQaSeverity severity;
}

final class ArenaGuideSnapshot {
  const ArenaGuideSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.createSteps,
    required this.joinSteps,
    required this.proTips,
    required this.safetyTips,
    required this.faqs,
    required this.examples,
    required this.keyConcepts,
    required this.checklist,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String heroTitle;
  final String heroSubtitle;
  final List<ArenaGuideStepDraft> createSteps;
  final List<ArenaGuideStepDraft> joinSteps;
  final List<ArenaGuideTipDraft> proTips;
  final List<ArenaGuideSafetyTipDraft> safetyTips;
  final List<ArenaGuideFaqDraft> faqs;
  final List<ArenaGuideExampleDraft> examples;
  final List<ArenaGuideConceptDraft> keyConcepts;
  final List<String> checklist;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaGuideStepDraft {
  const ArenaGuideStepDraft({
    required this.step,
    required this.iconKey,
    required this.title,
    required this.description,
    required this.tip,
    required this.tone,
  });

  final int step;
  final String iconKey;
  final String title;
  final String description;
  final String tip;
  final ArenaGuideTone tone;
}

final class ArenaGuideTipDraft {
  const ArenaGuideTipDraft({
    required this.iconKey,
    required this.title,
    required this.description,
    required this.category,
    required this.impact,
  });

  final String iconKey;
  final String title;
  final String description;
  final String category;
  final ArenaGuideImpact impact;
}

final class ArenaGuideSafetyTipDraft {
  const ArenaGuideSafetyTipDraft({
    required this.iconKey,
    required this.title,
    required this.description,
    required this.tone,
  });

  final String iconKey;
  final String title;
  final String description;
  final ArenaGuideTone tone;
}

final class ArenaGuideFaqDraft {
  const ArenaGuideFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class ArenaGuideExampleDraft {
  const ArenaGuideExampleDraft({
    required this.title,
    required this.template,
    required this.entryPoints,
    required this.format,
    required this.resolution,
    required this.rating,
    required this.tone,
    required this.reasons,
  });

  final String title;
  final String template;
  final int entryPoints;
  final String format;
  final String resolution;
  final String rating;
  final ArenaGuideTone tone;
  final List<String> reasons;
}

final class ArenaGuideConceptDraft {
  const ArenaGuideConceptDraft({required this.term, required this.definition});

  final String term;
  final String definition;
}
