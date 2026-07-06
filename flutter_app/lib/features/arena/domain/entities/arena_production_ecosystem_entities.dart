part of 'arena_entities.dart';

enum ArenaProductionScreenStatus { live, future, qaOnly, archived }

enum ArenaProductionScreenState {
  defaultView,
  loading,
  empty,
  error,
  offline,
  underReview,
  reported,
  hidden,
  resolved,
  canceled,
  expired,
}

final class ArenaProductionReadySnapshot {
  const ArenaProductionReadySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.canonicalScreens,
    required this.supportingScreens,
    required this.flows,
    required this.components,
    required this.dictionaries,
    required this.qaItems,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaProductionScreenDraft> canonicalScreens;
  final List<ArenaProductionScreenDraft> supportingScreens;
  final List<ArenaProductionFlowDraft> flows;
  final List<ArenaProductionComponentDraft> components;
  final List<ArenaProductionDictionaryDraft> dictionaries;
  final List<String> qaItems;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaProductionScreenDraft {
  const ArenaProductionScreenDraft({
    required this.name,
    required this.route,
    required this.status,
    required this.version,
    required this.states,
    required this.notes,
  });

  final String name;
  final String route;
  final ArenaProductionScreenStatus status;
  final String version;
  final List<ArenaProductionScreenState> states;
  final String notes;
}

final class ArenaProductionFlowDraft {
  const ArenaProductionFlowDraft({
    required this.id,
    required this.name,
    required this.steps,
  });

  final String id;
  final String name;
  final List<ArenaProductionFlowStepDraft> steps;
}

final class ArenaProductionFlowStepDraft {
  const ArenaProductionFlowStepDraft({
    required this.label,
    required this.route,
    required this.description,
  });

  final String label;
  final String route;
  final String description;
}

final class ArenaProductionComponentDraft {
  const ArenaProductionComponentDraft({
    required this.name,
    required this.file,
    required this.type,
    required this.description,
  });

  final String name;
  final String file;
  final String type;
  final String description;
}

final class ArenaProductionDictionaryDraft {
  const ArenaProductionDictionaryDraft({
    required this.category,
    required this.items,
  });

  final String category;
  final List<ArenaProductionDictionaryItemDraft> items;
}

final class ArenaProductionDictionaryItemDraft {
  const ArenaProductionDictionaryItemDraft({
    required this.code,
    required this.label,
    required this.description,
  });

  final String code;
  final String label;
  final String description;
}

enum ArenaBridgeTone {
  content,
  arena,
  prediction,
  disclosure,
  danger,
  blocked,
  neutral,
}

enum ArenaBridgeExampleStatus { correct, blocked }

final class ArenaPredictionBridgeSnapshot {
  const ArenaPredictionBridgeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.principles,
    required this.allowedItems,
    required this.notAllowedItems,
    required this.topics,
    required this.boundaryBanners,
    required this.badges,
    required this.infoRows,
    required this.bridgeComponents,
    required this.examples,
    required this.dualStats,
    required this.footerDisclosure,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaBridgePrincipleDraft> principles;
  final List<ArenaBridgeRuleDraft> allowedItems;
  final List<ArenaBridgeRuleDraft> notAllowedItems;
  final List<ArenaBridgeTopicDraft> topics;
  final List<ArenaBridgeBoundaryDraft> boundaryBanners;
  final List<ArenaBridgeBadgeDraft> badges;
  final List<ArenaBridgeInfoRowDraft> infoRows;
  final List<ArenaBridgeComponentDraft> bridgeComponents;
  final List<ArenaBridgeExampleDraft> examples;
  final ArenaBridgeDualStatsDraft dualStats;
  final String footerDisclosure;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaBridgePrincipleDraft {
  const ArenaBridgePrincipleDraft({
    required this.number,
    required this.title,
    required this.description,
    required this.tone,
  });

  final int number;
  final String title;
  final String description;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeRuleDraft {
  const ArenaBridgeRuleDraft({
    required this.label,
    required this.description,
    required this.allowed,
  });

  final String label;
  final String description;
  final bool allowed;
}

final class ArenaBridgeTopicDraft {
  const ArenaBridgeTopicDraft({
    required this.id,
    required this.label,
    required this.predictionUsage,
    required this.arenaUsage,
    required this.bridgeUsage,
    required this.tone,
  });

  final String id;
  final String label;
  final String predictionUsage;
  final String arenaUsage;
  final String bridgeUsage;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeBoundaryDraft {
  const ArenaBridgeBoundaryDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.tone,
  });

  final String id;
  final String title;
  final String description;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeBadgeDraft {
  const ArenaBridgeBadgeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.tone,
  });

  final String id;
  final String label;
  final String description;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeInfoRowDraft {
  const ArenaBridgeInfoRowDraft({required this.text, required this.tone});

  final String text;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeComponentDraft {
  const ArenaBridgeComponentDraft({
    required this.name,
    required this.badgeLabel,
    required this.description,
    required this.sampleTitle,
    required this.sampleMeta,
    required this.tone,
  });

  final String name;
  final String badgeLabel;
  final String description;
  final String sampleTitle;
  final String sampleMeta;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeExampleDraft {
  const ArenaBridgeExampleDraft({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    required this.frameTitle,
    required this.evidenceRows,
  });

  final String id;
  final ArenaBridgeExampleStatus status;
  final String title;
  final String description;
  final String frameTitle;
  final List<String> evidenceRows;
}

final class ArenaBridgeDualStatsDraft {
  const ArenaBridgeDualStatsDraft({
    required this.predictionPositions,
    required this.predictionPnlLabel,
    required this.predictionPnlPositive,
    required this.arenaPointsLabel,
    required this.arenaRooms,
  });

  final int predictionPositions;
  final String predictionPnlLabel;
  final bool predictionPnlPositive;
  final String arenaPointsLabel;
  final int arenaRooms;
}
