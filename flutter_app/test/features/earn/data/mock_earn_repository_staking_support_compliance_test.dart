import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

/// Smoke test for the staking support/compliance mocks: exercises
/// [MockStakingGuideRepository], [MockStakingFAQRepository],
/// [MockStakingNotificationsRepository],
/// [MockStakingRecommendationsRepository],
/// [MockStakingRegulatoryFrameworkRepository],
/// [MockStakingAuditReportsRepository], [MockStakingCustodyRepository], and
/// [MockStakingSuitabilityAssessmentRepository], asserting each call
/// succeeds without throwing and returns a plausible, non-empty result.
void main() {
  const guideRepo = MockStakingGuideRepository();
  const faqRepo = MockStakingFAQRepository();
  const notificationsRepo = MockStakingNotificationsRepository();
  const recommendationsRepo = MockStakingRecommendationsRepository();
  const frameworkRepo = MockStakingRegulatoryFrameworkRepository();
  const auditReportsRepo = MockStakingAuditReportsRepository();
  const custodyRepo = MockStakingCustodyRepository();
  const assessmentRepo = MockStakingSuitabilityAssessmentRepository();

  group('Earn staking support/compliance mocks smoke test', () {
    test('getGuide returns a populated guide snapshot', () {
      final snapshot = guideRepo.getGuide();

      expect(snapshot, isA<StakingGuideSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.heroTitle, isNotEmpty);
      expect(snapshot.tutorials, hasLength(3));
      expect(snapshot.tutorials.first.id, 'basic');
      expect(snapshot.quickTips, hasLength(6));
      expect(snapshot.mistakes, hasLength(4));
      expect(snapshot.ctaLabel, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getFAQ returns a populated FAQ snapshot', () {
      final snapshot = faqRepo.getFAQ();

      expect(snapshot, isA<StakingFAQSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'FAQ');
      expect(snapshot.searchPlaceholder, isNotEmpty);
      expect(snapshot.items, hasLength(20));
      expect(snapshot.items.first.id, 'g1');
      expect(snapshot.supportTitle, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getNotifications returns a populated notifications snapshot', () {
      final snapshot = notificationsRepo.getNotifications();

      expect(snapshot, isA<StakingNotificationsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'Thông báo');
      expect(snapshot.settings, hasLength(8));
      expect(snapshot.settings.first.id, 'maturity');
      expect(snapshot.channels, hasLength(3));
      expect(snapshot.history, hasLength(5));
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getRecommendations returns a populated recommendations snapshot', () {
      final snapshot = recommendationsRepo.getRecommendations();

      expect(snapshot, isA<StakingRecommendationsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.profile, isA<StakingRecommendationProfileDraft>());
      expect(snapshot.strategies, hasLength(3));
      expect(snapshot.strategies[1].id, 'balanced');
      expect(snapshot.strategies[1].recommended, isTrue);
      expect(snapshot.tips, hasLength(3));
      expect(snapshot.disclaimer, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getFramework returns a populated regulatory framework snapshot', () {
      final snapshot = frameworkRepo.getFramework();

      expect(snapshot, isA<StakingRegulatoryFrameworkSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'Regulatory Framework');
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.defaultTabId, 'licenses');
      expect(snapshot.licenses, hasLength(5));
      expect(snapshot.protectionSchemes, hasLength(3));
      expect(snapshot.complaintSteps, hasLength(3));
      expect(snapshot.authorityContacts, hasLength(3));
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getAuditReports returns a populated audit reports snapshot', () {
      final snapshot = auditReportsRepo.getAuditReports();

      expect(snapshot, isA<StakingAuditReportsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'Audit Reports');
      expect(snapshot.tabs, hasLength(4));
      expect(snapshot.defaultTabId, 'all');
      expect(snapshot.stats, hasLength(3));
      expect(snapshot.reports, hasLength(5));
      expect(snapshot.bugBounty, isA<StakingBugBountyDraft>());
      expect(snapshot.bugBounty.payouts, hasLength(4));
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getCustody returns a populated custody snapshot', () {
      final snapshot = custodyRepo.getCustody();

      expect(snapshot, isA<StakingCustodySnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, 'Custody & Segregation');
      expect(snapshot.custodian, isA<StakingCustodianDraft>());
      expect(snapshot.custodian.name, 'Fireblocks');
      expect(snapshot.segregation, hasLength(3));
      expect(snapshot.hotCold, hasLength(2));
      expect(snapshot.reconciliationLogs, hasLength(5));
      expect(snapshot.transparencyAddresses, hasLength(3));
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getAssessment returns a populated suitability assessment snapshot',
      () {
        final snapshot = assessmentRepo.getAssessment();

        expect(snapshot, isA<StakingSuitabilityAssessmentSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.title, 'Suitability Assessment');
        expect(snapshot.questions, hasLength(7));
        expect(snapshot.profiles, hasLength(3));
        expect(
          snapshot.profiles.first.level,
          StakingSuitabilityProfileLevel.conservative,
        );
        expect(snapshot.validUntil, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );
  });
}
