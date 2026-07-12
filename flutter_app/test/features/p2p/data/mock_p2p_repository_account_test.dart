import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

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
/// `test/features/p2p/p2p_*_page_test.dart` and `p2p_controller_test.dart`).
void main() {
  const repository = MockP2PRepository();

  group('MockP2PRepository smoke test', () {
    group('kyc / identity / security getters', () {
      test('getKycRequirements returns populated tiers', () {
        final snapshot = repository.getKycRequirements();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.tiers, isNotEmpty);
      });

      test('getKycStatus returns populated steps', () {
        final snapshot = repository.getKycStatus();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.steps, isNotEmpty);
      });

      test('getIdentityVerification returns document types and guidelines', () {
        final snapshot = repository.getIdentityVerification();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.documentTypes, isNotEmpty);
        expect(snapshot.guidelines, isNotEmpty);
        expect(snapshot.securityNotes, isNotEmpty);
      });

      test('getAddressProof returns document types and requirements', () {
        final snapshot = repository.getAddressProof();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.documentTypes, isNotEmpty);
        expect(snapshot.requirements, isNotEmpty);
      });

      test('getSelfieVerification returns liveness actions', () {
        final snapshot = repository.getSelfieVerification();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.guidelines, isNotEmpty);
        expect(snapshot.livenessActions, isNotEmpty);
      });

      test('getVideoVerification returns time slots', () {
        final snapshot = repository.getVideoVerification();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.preparationItems, isNotEmpty);
        expect(snapshot.timeSlots, isNotEmpty);
      });

      test('getSecurityCenter returns features and recent events', () {
        final snapshot = repository.getSecurityCenter();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.features, isNotEmpty);
        expect(snapshot.quickActions, isNotEmpty);
        expect(snapshot.recentEvents, isNotEmpty);
      });

      test('getTwoFactorSettings returns methods and thresholds', () {
        final snapshot = repository.getTwoFactorSettings();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.methods, isNotEmpty);
        expect(snapshot.thresholds, isNotEmpty);
      });

      test('getDeviceManagement returns trusted devices', () {
        final snapshot = repository.getDeviceManagement();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.devices, isNotEmpty);
      });

      test('getAntiPhishingCode returns examples and warnings', () {
        final snapshot = repository.getAntiPhishingCode();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.benefits, isNotEmpty);
        expect(snapshot.examples, isNotEmpty);
        expect(snapshot.warnings, isNotEmpty);
      });

      test('getLoginHistory returns login events', () {
        final snapshot = repository.getLoginHistory();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.events, isNotEmpty);
      });

      test('getSuspiciousActivity returns alerts', () {
        final snapshot = repository.getSuspiciousActivity();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.alerts, isNotEmpty);
      });

      test('getE2EInfo returns info items and steps', () {
        final snapshot = repository.getE2EInfo();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.infoItems, isNotEmpty);
        expect(snapshot.steps, isNotEmpty);
      });

      test('getFraudPrevention returns scam patterns and checklist', () {
        final snapshot = repository.getFraudPrevention();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.patterns, isNotEmpty);
        expect(snapshot.checklist, isNotEmpty);
        expect(snapshot.emergencyActions, isNotEmpty);
      });
    });

    group('limits / compliance getters', () {
      test('getLimitTracker returns usages and breakdown', () {
        final snapshot = repository.getLimitTracker();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.usages, isNotEmpty);
        expect(snapshot.breakdown, isNotEmpty);
      });

      test('getTransactionLimits returns usage/detail items', () {
        final snapshot = repository.getTransactionLimits();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.usageItems, isNotEmpty);
        expect(snapshot.detailItems, isNotEmpty);
        expect(snapshot.infoBullets, isNotEmpty);
      });

      test('getComplianceOverview returns populated items', () {
        final snapshot = repository.getComplianceOverview();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.items, isNotEmpty);
      });

      test('getAmlScreening returns populated checks', () {
        final snapshot = repository.getAmlScreening();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.checks, isNotEmpty);
      });

      test('getSourceOfFunds returns populated sources', () {
        final snapshot = repository.getSourceOfFunds();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.sources, isNotEmpty);
      });

      test('getLargeTransactionJustification returns purposes', () {
        final snapshot = repository.getLargeTransactionJustification();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.purposes, isNotEmpty);
      });

      test('getRiskAssessment returns populated risk factors', () {
        final snapshot = repository.getRiskAssessment();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.factors, isNotEmpty);
      });

      test('getTaxReporting returns years, jurisdictions, documents', () {
        final snapshot = repository.getTaxReporting();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.years, isNotEmpty);
        expect(snapshot.jurisdictions, isNotEmpty);
        expect(snapshot.documents, isNotEmpty);
      });
    });

    group('market / dashboard getters', () {
      test('getOrderBook returns markets, bids and asks', () {
        final snapshot = repository.getOrderBook();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.markets, isNotEmpty);
        expect(snapshot.bids, isNotEmpty);
        expect(snapshot.asks, isNotEmpty);
      });

      test('getDashboard returns populated series/activity data', () {
        final snapshot = repository.getDashboard();
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

      test('getAchievements returns achievements and categories', () {
        final snapshot = repository.getAchievements();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.achievements, isNotEmpty);
        expect(snapshot.categories, isNotEmpty);
      });
    });

    group('blacklist / notification / settings / guide getters', () {
      test('getBlacklistAdd returns populated reasons', () {
        final snapshot = repository.getBlacklistAdd();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.reasons, isNotEmpty);
      });

      test('getBlacklist returns reasons and entries', () {
        final snapshot = repository.getBlacklist();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.reasons, isNotEmpty);
        expect(snapshot.entries, isNotEmpty);
      });

      test('getNotificationSettings returns populated settings', () {
        final snapshot = repository.getNotificationSettings();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.settings, isNotEmpty);
      });

      test('getSettings returns option lists and toggles', () {
        final snapshot = repository.getSettings();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.assetOptions, isNotEmpty);
        expect(snapshot.currencyOptions, isNotEmpty);
        expect(snapshot.paymentWindows, isNotEmpty);
        expect(snapshot.notificationToggles, isNotEmpty);
        expect(snapshot.privacyToggles, isNotEmpty);
        expect(snapshot.securityToggles, isNotEmpty);
      });

      test('getGuide returns tabs, faq, steps, tips and videos', () {
        final snapshot = repository.getGuide();
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
