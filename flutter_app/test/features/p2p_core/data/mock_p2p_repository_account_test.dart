import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';

/// Direct smoke test for [MockP2PRepository]: kyc/identity/security,
/// limits/compliance, market/dashboard and blacklist/notification/settings/
/// guide getters.
///
/// Split from mock_p2p_repository_test.dart (Wave 6 behavior-group split,
/// zero test-behavior changes) — see mock_p2p_repository_orders_test.dart
/// for home/express intake, order lifecycle and dispute getters, and
/// mock_p2p_repository_merchant_test.dart for ad/merchant, payment method,
/// insurance and escrow/wallet getters.
///
/// The mock repository has ~68 getter methods but until now was only ever
/// exercised indirectly through page/controller tests (each touching 1-2
/// methods). This file calls every method on the [P2PRepository] interface
/// once, asserting the call does not throw and returns a plausible,
/// well-formed snapshot. ID arguments reuse the literal values already
/// proven to work in the corresponding page tests (see
/// `test/features/p2p_core/p2p_*_page_test.dart` and `p2p_controller_test.dart`).
void main() {
  const repository = MockP2PRepository(loadDelay: Duration.zero);

  group('MockP2PRepository smoke test', () {
    group('kyc / identity / security getters', () {
      test('getKycRequirements returns populated tiers', () async {
        final snapshot = await repository.getKycRequirements();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.tiers, isNotEmpty);
      });

      test('getKycStatus returns populated steps', () async {
        final snapshot = await repository.getKycStatus();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.steps, isNotEmpty);
      });

      test(
        'getIdentityVerification returns document types and guidelines',
        () async {
          final snapshot = await repository.getIdentityVerification();
          expect(snapshot.endpoint, isNotEmpty);
          expect(snapshot.documentTypes, isNotEmpty);
          expect(snapshot.guidelines, isNotEmpty);
          expect(snapshot.securityNotes, isNotEmpty);
        },
      );

      test('getAddressProof returns document types and requirements', () async {
        final snapshot = await repository.getAddressProof();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.documentTypes, isNotEmpty);
        expect(snapshot.requirements, isNotEmpty);
      });

      test('getSelfieVerification returns liveness actions', () async {
        final snapshot = await repository.getSelfieVerification();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.guidelines, isNotEmpty);
        expect(snapshot.livenessActions, isNotEmpty);
      });

      test('getVideoVerification returns time slots', () async {
        final snapshot = await repository.getVideoVerification();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.preparationItems, isNotEmpty);
        expect(snapshot.timeSlots, isNotEmpty);
      });

      test('getSecurityCenter returns features and recent events', () async {
        final snapshot = await repository.getSecurityCenter();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.features, isNotEmpty);
        expect(snapshot.quickActions, isNotEmpty);
        expect(snapshot.recentEvents, isNotEmpty);
      });

      test('getTwoFactorSettings returns methods and thresholds', () async {
        final snapshot = await repository.getTwoFactorSettings();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.methods, isNotEmpty);
        expect(snapshot.thresholds, isNotEmpty);
      });

      test('getDeviceManagement returns trusted devices', () async {
        final snapshot = await repository.getDeviceManagement();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.devices, isNotEmpty);
      });

      test('getAntiPhishingCode returns examples and warnings', () async {
        final snapshot = await repository.getAntiPhishingCode();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.benefits, isNotEmpty);
        expect(snapshot.examples, isNotEmpty);
        expect(snapshot.warnings, isNotEmpty);
      });

      test('getLoginHistory returns login events', () async {
        final snapshot = await repository.getLoginHistory();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.events, isNotEmpty);
      });

      test('getSuspiciousActivity returns alerts', () async {
        final snapshot = await repository.getSuspiciousActivity();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.alerts, isNotEmpty);
      });

      test('getE2EInfo returns info items and steps', () async {
        final snapshot = await repository.getE2EInfo();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.infoItems, isNotEmpty);
        expect(snapshot.steps, isNotEmpty);
      });

      test('getFraudPrevention returns scam patterns and checklist', () async {
        final snapshot = await repository.getFraudPrevention();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.patterns, isNotEmpty);
        expect(snapshot.checklist, isNotEmpty);
        expect(snapshot.emergencyActions, isNotEmpty);
      });
    });

    group('limits / compliance getters', () {
      test('getLimitTracker returns usages and breakdown', () async {
        final snapshot = await repository.getLimitTracker();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.usages, isNotEmpty);
        expect(snapshot.breakdown, isNotEmpty);
      });

      test('getTransactionLimits returns usage/detail items', () async {
        final snapshot = await repository.getTransactionLimits();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.usageItems, isNotEmpty);
        expect(snapshot.detailItems, isNotEmpty);
        expect(snapshot.infoBullets, isNotEmpty);
      });

      test('getComplianceOverview returns populated items', () async {
        final snapshot = await repository.getComplianceOverview();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.items, isNotEmpty);
      });

      test('getAmlScreening returns populated checks', () async {
        final snapshot = await repository.getAmlScreening();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.checks, isNotEmpty);
      });

      test('getSourceOfFunds returns populated sources', () async {
        final snapshot = await repository.getSourceOfFunds();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.sources, isNotEmpty);
      });

      test('getLargeTransactionJustification returns purposes', () async {
        final snapshot = await repository.getLargeTransactionJustification();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.purposes, isNotEmpty);
      });

      test('getRiskAssessment returns populated risk factors', () async {
        final snapshot = await repository.getRiskAssessment();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.factors, isNotEmpty);
      });

      test('getTaxReporting returns years, jurisdictions, documents', () async {
        final snapshot = await repository.getTaxReporting();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.years, isNotEmpty);
        expect(snapshot.jurisdictions, isNotEmpty);
        expect(snapshot.documents, isNotEmpty);
      });
    });

    group('market / dashboard getters', () {
      test('getOrderBook returns markets, bids and asks', () async {
        final snapshot = await repository.getOrderBook();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.markets, isNotEmpty);
        expect(snapshot.bids, isNotEmpty);
        expect(snapshot.asks, isNotEmpty);
      });

      test('getDashboard returns populated series/activity data', () async {
        final snapshot = await repository.getDashboard();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.filters, isNotEmpty);
        expect(snapshot.weeklyVolume, isNotEmpty);
        expect(snapshot.monthlyOrders, isNotEmpty);
        expect(snapshot.assetDistribution, isNotEmpty);
        expect(snapshot.platformComparisons, isNotEmpty);
        expect(snapshot.topMerchants, isNotEmpty);
        expect(snapshot.recentActivity, isNotEmpty);
        expect(snapshot.quickActions, isNotEmpty);
      });

      test('getAchievements returns achievements and categories', () async {
        final snapshot = await repository.getAchievements();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.achievements, isNotEmpty);
        expect(snapshot.categories, isNotEmpty);
      });
    });

    group('blacklist / notification / settings / guide getters', () {
      test('getBlacklistAdd returns populated reasons', () async {
        final snapshot = await repository.getBlacklistAdd();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.reasons, isNotEmpty);
      });

      test('getBlacklist returns reasons and entries', () async {
        final snapshot = await repository.getBlacklist();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.reasons, isNotEmpty);
        expect(snapshot.entries, isNotEmpty);
      });

      test('getNotificationSettings returns populated settings', () async {
        final snapshot = await repository.getNotificationSettings();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.settings, isNotEmpty);
      });

      test('getSettings returns option lists and toggles', () async {
        final snapshot = await repository.getSettings();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.assetOptions, isNotEmpty);
        expect(snapshot.currencyOptions, isNotEmpty);
        expect(snapshot.paymentWindows, isNotEmpty);
        expect(snapshot.notificationToggles, isNotEmpty);
        expect(snapshot.privacyToggles, isNotEmpty);
        expect(snapshot.securityToggles, isNotEmpty);
      });

      test('getGuide returns tabs, faq, steps, tips and videos', () async {
        final snapshot = await repository.getGuide();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.tabs, isNotEmpty);
        expect(snapshot.faqItems, isNotEmpty);
        expect(snapshot.buySteps, isNotEmpty);
        expect(snapshot.sellSteps, isNotEmpty);
        expect(snapshot.safetyTips, isNotEmpty);
        expect(snapshot.videos, isNotEmpty);
      });
    });
  });
}
