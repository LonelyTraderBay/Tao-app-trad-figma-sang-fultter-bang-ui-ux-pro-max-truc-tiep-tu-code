import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';

/// Smoke test for the Savings "tools" mock repositories: exercises every
/// method on SavingsGuideRepository, SavingsFAQRepository,
/// SavingsNotificationsRepository, SavingsRecommendationsRepository,
/// SavingsRiskAssessmentRepository, SavingsComparisonRepository,
/// AutoCompoundSettingsRepository, SavingsAnalyticsRepository,
/// SavingsAutoRebalanceRepository, SavingsNotificationPreferencesRepository,
/// SavingsDcaRepository, SavingsSmartSuggestionsRepository,
/// SavingsExportRepository, SavingsBacktestRepository,
/// SavingsAutoPilotRepository, SavingsLadderRepository, and
/// SavingsWhatIfRepository, and asserts each call succeeds without throwing
/// and returns a plausible, populated snapshot.
///
/// Note: unlike wallet, the Earn feature does not expose a single unified
/// `MockEarnRepository` — each interface is backed by its own
/// `Mock<Interface>Repository` class (see
/// `lib/features/earn_core/data/repositories/mock_earn_repository.dart` and its
/// descriptively-named `fixtures/mock_<interface>_repository.dart` files),
/// matching how `earn_repository_provider.dart` wires each interface
/// individually.
void main() {
  group('MockSavingsGuideRepository smoke test', () {
    const repository = MockSavingsGuideRepository();

    test('getGuide returns a populated snapshot', () async {
      final snapshot = await repository.getGuide();

      expect(snapshot, isA<SavingsGuideSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.tutorials, isNotEmpty);
      expect(snapshot.quickTips, isNotEmpty);
      expect(snapshot.terms, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsFAQRepository smoke test', () {
    const repository = MockSavingsFAQRepository();

    test('getFAQ returns a populated snapshot', () async {
      final snapshot = await repository.getFAQ();

      expect(snapshot, isA<SavingsFAQSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.categories, isNotEmpty);
      expect(snapshot.items, isNotEmpty);
      expect(snapshot.supportTitle, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsNotificationsRepository smoke test', () {
    const repository = MockSavingsNotificationsRepository();

    test('getNotifications returns a populated snapshot', () async {
      final snapshot = await repository.getNotifications();

      expect(snapshot, isA<SavingsNotificationsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.settings, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsRecommendationsRepository smoke test', () {
    const repository = MockSavingsRecommendationsRepository();

    test('getRecommendations returns a populated snapshot', () async {
      final snapshot = await repository.getRecommendations();

      expect(snapshot, isA<SavingsRecommendationsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.profile, isA<SavingsUserProfileDraft>());
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.insights, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsRiskAssessmentRepository smoke test', () {
    const repository = MockSavingsRiskAssessmentRepository();

    test('getRiskAssessment returns a populated snapshot', () async {
      final snapshot = await repository.getRiskAssessment();

      expect(snapshot, isA<SavingsRiskAssessmentSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.questions, isNotEmpty);
      expect(snapshot.results, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsComparisonRepository smoke test', () {
    const repository = MockSavingsComparisonRepository();

    test('getComparison returns a populated snapshot', () async {
      final snapshot = await repository.getComparison();

      expect(snapshot, isA<SavingsComparisonSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.maxCompare, greaterThan(0));
      expect(snapshot.products, isNotEmpty);
      expect(snapshot.details, isNotEmpty);
      expect(snapshot.details['sav001'], isNotNull);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockAutoCompoundSettingsRepository smoke test', () {
    const repository = MockAutoCompoundSettingsRepository();

    test('getSettings returns a populated snapshot', () async {
      final snapshot = await repository.getSettings();

      expect(snapshot, isA<AutoCompoundSettingsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.positions, isNotEmpty);
      expect(snapshot.frequencies, isNotEmpty);
      expect(snapshot.infoItems, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsAnalyticsRepository smoke test', () {
    const repository = MockSavingsAnalyticsRepository();

    test('getAnalytics returns a populated snapshot', () async {
      final snapshot = await repository.getAnalytics();

      expect(snapshot, isA<SavingsAnalyticsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.timeRanges, isNotEmpty);
      expect(snapshot.summary, isA<SavingsAnalyticsSummaryDraft>());
      expect(snapshot.yieldHistory, isNotEmpty);
      expect(snapshot.monthlyEarnings, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsAutoRebalanceRepository smoke test', () {
    const repository = MockSavingsAutoRebalanceRepository();

    test('getRebalance returns a populated snapshot', () async {
      final snapshot = await repository.getRebalance();

      expect(snapshot, isA<SavingsAutoRebalanceSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.totalPortfolio, greaterThan(0));
      expect(snapshot.positions, isNotEmpty);
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.driftHistory, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.settings, isA<SavingsRebalanceSettingsDraft>());
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsNotificationPreferencesRepository smoke test', () {
    const repository = MockSavingsNotificationPreferencesRepository();

    test('getPreferences returns a populated snapshot', () async {
      final snapshot = await repository.getPreferences();

      expect(snapshot, isA<SavingsNotificationPreferencesSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.alerts, isNotEmpty);
      expect(snapshot.productAlerts, isNotEmpty);
      expect(snapshot.channels, isNotEmpty);
      expect(snapshot.quietHours, isA<SavingsQuietHoursDraft>());
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsDcaRepository smoke test', () {
    const repository = MockSavingsDcaRepository();

    test('getDca returns a populated snapshot', () async {
      final snapshot = await repository.getDca();

      expect(snapshot, isA<SavingsDcaSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.plans, isNotEmpty);
      expect(snapshot.executions, isNotEmpty);
      expect(snapshot.products, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsSmartSuggestionsRepository smoke test', () {
    const repository = MockSavingsSmartSuggestionsRepository();

    test('getSuggestions returns a populated snapshot', () async {
      final snapshot = await repository.getSuggestions();

      expect(snapshot, isA<SavingsSmartSuggestionsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.filters, isNotEmpty);
      expect(snapshot.suggestions, isNotEmpty);
      expect(snapshot.trends, isNotEmpty);
      expect(snapshot.signals, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsExportRepository smoke test', () {
    const repository = MockSavingsExportRepository();

    test('getExport returns a populated snapshot', () async {
      final snapshot = await repository.getExport();

      expect(snapshot, isA<SavingsExportSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.reportTypes, isNotEmpty);
      expect(snapshot.formats, isNotEmpty);
      expect(snapshot.periods, isNotEmpty);
      expect(snapshot.scopes, isNotEmpty);
      expect(snapshot.options, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsBacktestRepository smoke test', () {
    const repository = MockSavingsBacktestRepository();

    test('getBacktest returns a populated snapshot', () async {
      final snapshot = await repository.getBacktest();

      expect(snapshot, isA<SavingsBacktestSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.quickAmounts, isNotEmpty);
      expect(snapshot.periods, isNotEmpty);
      expect(snapshot.presets, isNotEmpty);
      expect(snapshot.result, isA<SavingsBacktestResultDraft>());
      expect(snapshot.result.points, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsAutoPilotRepository smoke test', () {
    const repository = MockSavingsAutoPilotRepository();

    test('getAutoPilot returns a populated snapshot', () async {
      final snapshot = await repository.getAutoPilot();

      expect(snapshot, isA<SavingsAutoPilotSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.config, isA<SavingsAutoPilotConfigDraft>());
      expect(snapshot.modes, isNotEmpty);
      expect(snapshot.metrics, isNotEmpty);
      expect(snapshot.modules, isNotEmpty);
      expect(snapshot.actions, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsLadderRepository smoke test', () {
    const repository = MockSavingsLadderRepository();

    test('getLadder returns a populated snapshot', () async {
      final snapshot = await repository.getLadder();

      expect(snapshot, isA<SavingsLadderSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.quickAmounts, isNotEmpty);
      expect(snapshot.templates, isNotEmpty);
      expect(snapshot.availableProducts, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });

  group('MockSavingsWhatIfRepository smoke test', () {
    const repository = MockSavingsWhatIfRepository();

    test('getWhatIf returns a populated snapshot', () async {
      final snapshot = await repository.getWhatIf();

      expect(snapshot, isA<SavingsWhatIfSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.scenarios, isNotEmpty);
      expect(snapshot.portfolio, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });
}
