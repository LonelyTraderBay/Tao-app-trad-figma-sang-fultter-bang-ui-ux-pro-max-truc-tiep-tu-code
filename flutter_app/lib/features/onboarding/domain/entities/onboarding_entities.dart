enum OnboardingScreenState {
  loading,
  empty,
  error,
  offline,
  ready,
  submitting,
  success,
}

enum OnboardingStepDraft {
  welcome,
  modules,
  boundaries,
  trust,
  goals,
  complete,
}

enum OnboardingUserGoalDraft {
  tradeCrypto,
  saveRegularly,
  p2pExchange,
  predictEvents,
  arenaChallenges,
  earnRewards,
}

final class OnboardingSnapshot {
  const OnboardingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.contractNotes,
    required this.backRoute,
    required this.homeRoute,
    required this.steps,
    required this.welcome,
    required this.modules,
    required this.boundaries,
    required this.separationRules,
    required this.trustPillars,
    required this.commitments,
    required this.goals,
    required this.recommendations,
    this.screenState = OnboardingScreenState.ready,
  });

  final String endpoint;
  final String actionDraft;
  final List<OnboardingScreenState> supportedStates;
  final OnboardingScreenState screenState;
  final String contractNotes;
  final String backRoute;
  final String homeRoute;
  final List<OnboardingStepDraft> steps;
  final OnboardingWelcomeDraft welcome;
  final List<OnboardingModuleDraft> modules;
  final List<OnboardingBoundaryDraft> boundaries;
  final List<String> separationRules;
  final List<OnboardingTrustDraft> trustPillars;
  final List<String> commitments;
  final List<OnboardingGoalDraft> goals;
  final Map<OnboardingUserGoalDraft, OnboardingRecommendationDraft>
  recommendations;
}

final class OnboardingWelcomeDraft {
  const OnboardingWelcomeDraft({
    required this.skipLabel,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.ctaLabel,
    required this.helperText,
  });

  final String skipLabel;
  final String title;
  final String subtitle;
  final List<OnboardingFeatureDraft> features;
  final String ctaLabel;
  final String helperText;
}

final class OnboardingFeatureDraft {
  const OnboardingFeatureDraft({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}

final class OnboardingModuleDraft {
  const OnboardingModuleDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.features,
  });

  final String id;
  final String name;
  final String description;
  final List<String> features;
}

final class OnboardingBoundaryDraft {
  const OnboardingBoundaryDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.nature,
    required this.examples,
  });

  final String id;
  final String title;
  final String subtitle;
  final String nature;
  final List<String> examples;
}

final class OnboardingTrustDraft {
  const OnboardingTrustDraft({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}

final class OnboardingGoalDraft {
  const OnboardingGoalDraft({
    required this.id,
    required this.label,
    required this.description,
    this.disclosure,
  });

  final OnboardingUserGoalDraft id;
  final String label;
  final String description;
  final String? disclosure;
}

final class OnboardingRecommendationDraft {
  const OnboardingRecommendationDraft({
    required this.title,
    required this.description,
    required this.route,
  });

  final String title;
  final String description;
  final String route;
}
