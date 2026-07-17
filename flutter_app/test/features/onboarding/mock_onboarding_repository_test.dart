import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/onboarding/data/repositories/mock_onboarding_repository.dart';
import 'package:vit_trade_flutter/features/onboarding/domain/entities/onboarding_entities.dart';

/// Smoke test for [MockOnboardingRepository]: exercises the sole method on
/// [OnboardingRepository] and asserts the call succeeds without throwing and
/// returns a plausible, fully-populated snapshot.
void main() {
  const repository = MockOnboardingRepository();

  group('MockOnboardingRepository smoke test', () {
    test('getFlow returns a populated snapshot', () {
      final snapshot = repository.getFlow();

      expect(snapshot, isA<OnboardingSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/onboarding/onboarding');
      expect(snapshot.screenState, OnboardingScreenState.ready);
      expect(snapshot.actionDraft, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.homeRoute, isNotEmpty);
      expect(
        snapshot.supportedStates,
        containsAll(<OnboardingScreenState>[
          OnboardingScreenState.loading,
          OnboardingScreenState.error,
          OnboardingScreenState.offline,
          OnboardingScreenState.ready,
        ]),
      );
    });

    test('getFlow does not throw and is safe to call repeatedly', () {
      late final OnboardingSnapshot snapshot;

      expect(() => snapshot = repository.getFlow(), returnsNormally);
      expect(snapshot, isA<OnboardingSnapshot>());
    });

    test('getFlow steps cover the full onboarding sequence in order', () {
      final snapshot = repository.getFlow();

      expect(snapshot.steps, hasLength(6));
      expect(snapshot.steps.first, OnboardingStepDraft.welcome);
      expect(snapshot.steps.last, OnboardingStepDraft.complete);
    });

    test('getFlow welcome draft is populated with intro copy and features', () {
      final welcome = repository.getFlow().welcome;

      expect(welcome, isA<OnboardingWelcomeDraft>());
      expect(welcome.skipLabel, isNotEmpty);
      expect(welcome.title, isNotEmpty);
      expect(welcome.subtitle, isNotEmpty);
      expect(welcome.ctaLabel, isNotEmpty);
      expect(welcome.helperText, isNotEmpty);
      expect(welcome.features, hasLength(3));
      expect(welcome.features.first, isA<OnboardingFeatureDraft>());
    });

    test('getFlow modules cover every top-level product area', () {
      final modules = repository.getFlow().modules;

      expect(modules, hasLength(5));
      expect(modules.map((module) => module.id), contains('trading'));
      expect(modules.map((module) => module.id), contains('arena'));
      expect(modules.first, isA<OnboardingModuleDraft>());
      expect(modules.first.features, isNotEmpty);
    });

    test(
      'getFlow boundaries distinguish value-based and points-only areas',
      () {
        final boundaries = repository.getFlow().boundaries;

        expect(boundaries, hasLength(2));
        expect(boundaries.first, isA<OnboardingBoundaryDraft>());
        expect(boundaries.last.title, 'Open Arena');
        expect(boundaries.last.examples, isNotEmpty);
        expect(repository.getFlow().separationRules, isNotEmpty);
      },
    );

    test('getFlow trust pillars and commitments are populated', () {
      final snapshot = repository.getFlow();

      expect(snapshot.trustPillars, isNotEmpty);
      expect(snapshot.trustPillars.first, isA<OnboardingTrustDraft>());
      expect(snapshot.commitments, isNotEmpty);
    });

    test('getFlow goals include the arena challenges disclosure', () {
      final goals = repository.getFlow().goals;

      expect(goals, hasLength(6));
      expect(goals.first, isA<OnboardingGoalDraft>());

      final arenaGoal = goals.firstWhere(
        (goal) => goal.id == OnboardingUserGoalDraft.arenaChallenges,
      );
      expect(arenaGoal.disclosure, isNotNull);
      expect(arenaGoal.disclosure, contains('Arena Points'));
    });

    test('getFlow recommendations cover every user goal', () {
      final snapshot = repository.getFlow();

      expect(snapshot.recommendations, hasLength(snapshot.goals.length));
      for (final goal in snapshot.goals) {
        final recommendation = snapshot.recommendations[goal.id];

        expect(
          recommendation,
          isA<OnboardingRecommendationDraft>(),
          reason: 'missing recommendation for ${goal.id}',
        );
        expect(recommendation!.title, isNotEmpty);
        expect(recommendation.description, isNotEmpty);
        expect(recommendation.route, isNotEmpty);
      }
    });
  });
}
