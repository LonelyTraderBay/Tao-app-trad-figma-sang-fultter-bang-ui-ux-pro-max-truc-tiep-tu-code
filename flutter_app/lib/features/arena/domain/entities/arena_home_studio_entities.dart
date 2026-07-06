part of 'arena_entities.dart';

enum ArenaScreenState { loading, empty, error, offline }

enum ArenaChallengeState { open, full, live, pendingResult, resolved, canceled }

enum ArenaTemplateKind {
  prediction,
  closestGuess,
  teamBattle,
  bracket,
  vote,
  proof,
}

final class ArenaHomeSnapshot {
  const ArenaHomeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.templates,
    required this.featuredModes,
    required this.liveRooms,
    required this.creators,
    required this.trustSignals,
    required this.pendingNotifications,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaTemplateDraft> templates;
  final List<ArenaModeDraft> featuredModes;
  final List<ArenaChallengeDraft> liveRooms;
  final List<ArenaCreatorDraft> creators;
  final List<ArenaTrustSignalDraft> trustSignals;
  final int pendingNotifications;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaTemplateDraft {
  const ArenaTemplateDraft({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.tags,
  });

  final String id;
  final ArenaTemplateKind kind;
  final String title;
  final String description;
  final List<String> tags;
}

final class ArenaStudioSnapshot {
  const ArenaStudioSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.steps,
    required this.templates,
    required this.platformFeePct,
    required this.secondaryActions,
    required this.trustSignals,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaStudioStepDraft> steps;
  final List<ArenaStudioTemplateDraft> templates;
  final int platformFeePct;
  final List<String> secondaryActions;
  final List<ArenaTrustSignalDraft> trustSignals;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaStudioStepDraft {
  const ArenaStudioStepDraft({required this.index, required this.label});

  final int index;
  final String label;
}

final class ArenaStudioTemplateDraft {
  const ArenaStudioTemplateDraft({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.formatTags,
    required this.complexity,
    this.verifiedOnly = false,
  });

  final String id;
  final ArenaTemplateKind kind;
  final String title;
  final String description;
  final List<String> formatTags;
  final String complexity;
  final bool verifiedOnly;
}

final class ArenaChallengeDraft {
  const ArenaChallengeDraft({
    required this.id,
    required this.title,
    required this.format,
    required this.slotsFilled,
    required this.slotsTotal,
    required this.entryPoints,
    required this.prizePool,
    required this.state,
  });

  final String id;
  final String title;
  final String format;
  final int slotsFilled;
  final int slotsTotal;
  final int entryPoints;
  final int prizePool;
  final ArenaChallengeState state;
}

final class ArenaModeDraft {
  const ArenaModeDraft({
    required this.id,
    required this.title,
    required this.creatorName,
    required this.cloneCount,
    required this.activeChallenges,
    required this.fairPlay,
    this.description = '',
    this.completionRate = 0,
    this.tags = const [],
    this.templateId = '',
  });

  final String id;
  final String title;
  final String creatorName;
  final int cloneCount;
  final int activeChallenges;
  final bool fairPlay;
  final String description;
  final int completionRate;
  final List<String> tags;
  final String templateId;
}

final class ArenaCreatorDraft {
  const ArenaCreatorDraft({
    required this.id,
    required this.name,
    required this.modesCreated,
    required this.totalChallenges,
    required this.trustScore,
    required this.fairPlay,
  });

  final String id;
  final String name;
  final int modesCreated;
  final int totalChallenges;
  final int trustScore;
  final bool fairPlay;
}

final class ArenaTrustSignalDraft {
  const ArenaTrustSignalDraft({required this.label, required this.value});

  final String label;
  final String value;
}
