part of 'arena_entities.dart';

final class ArenaSmartRulesSnapshot {
  const ArenaSmartRulesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.steps,
    required this.domains,
    required this.challengeTypes,
    required this.subjects,
    required this.actions,
    required this.metrics,
    required this.winTypes,
    required this.deadlineContexts,
    required this.tieRules,
    required this.voidRules,
    required this.resultDeadlines,
    required this.titleSuggestions,
    required this.defaultEndDate,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaStudioStepDraft> steps;
  final List<ArenaSmartOptionDraft> domains;
  final List<ArenaSmartOptionDraft> challengeTypes;
  final List<String> subjects;
  final List<String> actions;
  final List<String> metrics;
  final List<String> winTypes;
  final List<String> deadlineContexts;
  final List<String> tieRules;
  final List<String> voidRules;
  final List<String> resultDeadlines;
  final List<String> titleSuggestions;
  final String defaultEndDate;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaSmartOptionDraft {
  const ArenaSmartOptionDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class ArenaPresetLibrarySnapshot {
  const ArenaPresetLibrarySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.sections,
    required this.domainPacks,
    required this.suggestionsByDomain,
    required this.dropdownGroups,
    required this.demoFlows,
    required this.titleSuggestions,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaPresetSectionDraft> sections;
  final List<ArenaDomainPackDraft> domainPacks;
  final Map<String, List<ArenaPresetSuggestionDraft>> suggestionsByDomain;
  final List<ArenaPresetDropdownGroupDraft> dropdownGroups;
  final List<ArenaPresetDemoFlowDraft> demoFlows;
  final List<String> titleSuggestions;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaPresetSectionDraft {
  const ArenaPresetSectionDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class ArenaDomainPackDraft {
  const ArenaDomainPackDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.supportedTypes,
    required this.examples,
  });

  final String id;
  final String title;
  final String description;
  final List<String> supportedTypes;
  final List<String> examples;
}

final class ArenaPresetSuggestionDraft {
  const ArenaPresetSuggestionDraft({required this.text, required this.type});

  final String text;
  final String type;
}

final class ArenaPresetDropdownGroupDraft {
  const ArenaPresetDropdownGroupDraft({
    required this.label,
    required this.options,
    this.disabled = false,
  });

  final String label;
  final List<String> options;
  final bool disabled;
}

final class ArenaPresetDemoFlowDraft {
  const ArenaPresetDemoFlowDraft({
    required this.domainId,
    required this.domainLabel,
    required this.typeLabel,
    required this.suggestions,
    required this.generatedRule,
  });

  final String domainId;
  final String domainLabel;
  final String typeLabel;
  final List<String> suggestions;
  final String generatedRule;
}

final class ArenaGovernanceSnapshot {
  const ArenaGovernanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.steps,
    required this.privacyOptions,
    required this.domains,
    required this.challengeTypes,
    required this.subjects,
    required this.actions,
    required this.metrics,
    required this.winTypes,
    required this.deadlineContexts,
    required this.resolutionSources,
    required this.tieRules,
    required this.voidRules,
    required this.resultDeadlines,
    required this.suggestionActions,
    required this.defaultEndDate,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaStudioStepDraft> steps;
  final List<ArenaPrivacyOptionDraft> privacyOptions;
  final List<ArenaSmartOptionDraft> domains;
  final List<ArenaSmartOptionDraft> challengeTypes;
  final List<String> subjects;
  final List<String> actions;
  final List<String> metrics;
  final List<String> winTypes;
  final List<String> deadlineContexts;
  final List<String> resolutionSources;
  final List<String> tieRules;
  final List<String> voidRules;
  final List<String> resultDeadlines;
  final List<ArenaGovernanceSuggestionDraft> suggestionActions;
  final String defaultEndDate;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaPrivacyOptionDraft {
  const ArenaPrivacyOptionDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class ArenaGovernanceSuggestionDraft {
  const ArenaGovernanceSuggestionDraft({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}
