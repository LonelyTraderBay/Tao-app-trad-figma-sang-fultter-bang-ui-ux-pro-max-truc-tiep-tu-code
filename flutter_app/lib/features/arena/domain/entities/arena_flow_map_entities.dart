part of 'arena_entities.dart';

/// Route map and QA checklist documenting how Arena screens connect to the rest of the app.
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

/// A single summary statistic on the Arena flow map screen.
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

/// A single route entry documented on the Arena flow map.
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

/// A group of related flow nodes on the Arena flow map.
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

/// A single node (screen or state) on the Arena flow map.
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

/// A single shared component documented on the Arena flow map.
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

/// A single handoff note on the Arena flow map.
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

/// A single QA checklist item on the Arena flow map.
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

/// Category used to color-code nodes and stats on the Arena flow map.
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
