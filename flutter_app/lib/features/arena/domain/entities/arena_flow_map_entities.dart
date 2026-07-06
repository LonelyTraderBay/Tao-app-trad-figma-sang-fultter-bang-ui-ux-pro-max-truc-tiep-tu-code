part of 'arena_entities.dart';

final class ArenaFlowMapSnapshot {
  const ArenaFlowMapSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.stats,
    required this.routes,
    required this.groups,
    required this.components,
    required this.handoffNotes,
    required this.qaItems,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaFlowStatDraft> stats;
  final List<ArenaFlowRouteDraft> routes;
  final List<ArenaFlowGroupDraft> groups;
  final List<ArenaFlowComponentDraft> components;
  final List<ArenaFlowNoteDraft> handoffNotes;
  final List<ArenaFlowQaDraft> qaItems;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaFlowStatDraft {
  const ArenaFlowStatDraft({
    required this.value,
    required this.label,
    required this.kind,
  });

  final String value;
  final String label;
  final ArenaFlowKind kind;
}

final class ArenaFlowRouteDraft {
  const ArenaFlowRouteDraft({
    required this.path,
    required this.page,
    required this.status,
  });

  final String path;
  final String page;
  final String status;
}

final class ArenaFlowGroupDraft {
  const ArenaFlowGroupDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.nodes,
    required this.connectionNote,
  });

  final String id;
  final String title;
  final String subtitle;
  final ArenaFlowKind kind;
  final List<ArenaFlowNodeDraft> nodes;
  final String connectionNote;
}

final class ArenaFlowNodeDraft {
  const ArenaFlowNodeDraft({
    required this.label,
    required this.sublabel,
    required this.kind,
    this.route,
    this.stateLabel,
  });

  final String label;
  final String sublabel;
  final ArenaFlowKind kind;
  final String? route;
  final String? stateLabel;
}

final class ArenaFlowComponentDraft {
  const ArenaFlowComponentDraft({
    required this.file,
    required this.description,
    required this.exports,
  });

  final String file;
  final String description;
  final List<String> exports;
}

final class ArenaFlowNoteDraft {
  const ArenaFlowNoteDraft({
    required this.title,
    required this.detail,
    required this.kind,
  });

  final String title;
  final String detail;
  final ArenaFlowKind kind;
}

final class ArenaFlowQaDraft {
  const ArenaFlowQaDraft({
    required this.id,
    required this.category,
    required this.label,
  });

  final String id;
  final String category;
  final String label;
}

enum ArenaFlowKind {
  core,
  discovery,
  creator,
  participant,
  owner,
  points,
  verified,
  safety,
  neutral,
}
