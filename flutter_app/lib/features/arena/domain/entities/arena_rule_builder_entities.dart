part of 'arena_entities.dart';

/// Options and suggestions for the smart challenge-rule builder wizard.
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

/// A single selectable option in the smart rule builder.
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

/// Preset rule templates and demo flows for the rule preset library screen.
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

/// A single selectable section in the preset library.
final class ArenaPresetSectionDraft {
  const ArenaPresetSectionDraft({required this.id, required this.label});

  final String id;
  final String label;
}

/// A single domain-specific pack of preset rule options.
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

/// A single suggested rule phrase in the preset library.
final class ArenaPresetSuggestionDraft {
  const ArenaPresetSuggestionDraft({required this.text, required this.type});

  final String text;
  final String type;
}

/// A single grouped dropdown of preset options.
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

/// A single worked example showing how a preset generates a rule.
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

/// Options and suggestions for the challenge governance/rules wizard.
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

/// A single selectable privacy option for a challenge.
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

/// A single suggested governance action in the rules wizard.
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
