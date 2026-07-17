/// UI state the onboarding flow supports rendering.
enum OnboardingScreenState {
  loading,
  empty,
  error,
  offline,
  ready,
  submitting,
  success,
}

/// One step in the multi-step onboarding flow.
enum OnboardingStepDraft {
  welcome,
  modules,
  boundaries,
  trust,
  goals,
  complete,
}

/// A selectable user goal on the onboarding goals step, driving the final
/// recommendation.
enum OnboardingUserGoalDraft {
  tradeCrypto,
  saveRegularly,
  p2pExchange,
  predictEvents,
  arenaChallenges,
  earnRewards,
}

/// Data for the full onboarding flow: welcome copy, module/boundary/trust
/// explainers, selectable [goals], and goal-based recommendations.
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

/// Copy and highlighted [features] for the onboarding welcome step.
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

/// One highlighted feature callout on the onboarding welcome step.
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

/// One product module explainer card on the onboarding modules step.
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

/// One product-boundary explainer card (e.g. Prediction Markets vs. Arena
/// points) on the onboarding boundaries step.
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

/// One trust/safety pillar explainer card on the onboarding trust step.
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

/// One selectable goal option on the onboarding goals step.
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

/// A suggested next step (title/description/route) shown for one selected
/// [OnboardingUserGoalDraft] at the end of onboarding.
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
