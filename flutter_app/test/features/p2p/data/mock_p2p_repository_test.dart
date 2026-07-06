import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

/// Direct smoke test for [MockP2PRepository].
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
    group('home / express getters', () {
      test('getHome, getExpress, getExpressConfirm return plausible data', () {
        final home = repository.getHome();
        expect(home.endpoint, isNotEmpty);
        expect(home.assets, isNotEmpty);
        expect(home.ads, isNotEmpty);

        final express = repository.getExpress();
        expect(express.endpoint, isNotEmpty);
        expect(express.assets, isNotEmpty);
        expect(express.ads, isNotEmpty);

        final expressConfirm = repository.getExpressConfirm(adId: 'ad001');
        expect(expressConfirm.endpoint, isNotEmpty);
        expect(expressConfirm.supportedStates, isNotEmpty);
      });
    });

    group('order lifecycle getters', () {
      test('getOrder returns a populated order snapshot', () {
        final snapshot = repository.getOrder('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.order.id, 'p2p001');
        expect(snapshot.paymentFields, isNotEmpty);
        expect(snapshot.timeline, isNotEmpty);
        expect(snapshot.quickActions, isNotEmpty);
      });

      test('getOrderTimeline returns populated timeline events', () {
        final snapshot = repository.getOrderTimeline('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.events, isNotEmpty);
      });

      test('getOrderRate returns quick tags', () {
        final snapshot = repository.getOrderRate('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.quickTags, isNotEmpty);
      });

      test('getOrderCancel returns cancel reasons', () {
        final snapshot = repository.getOrderCancel('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.reasons, isNotEmpty);
      });

      test('getOrderProof returns tips', () {
        final snapshot = repository.getOrderProof('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.tips, isNotEmpty);
      });

      test('getChat returns messages and quick replies', () {
        final snapshot = repository.getChat('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.messages, isNotEmpty);
        expect(snapshot.quickReplies, isNotEmpty);
      });

      test('getMyOrders returns populated tabs and orders', () {
        final snapshot = repository.getMyOrders();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.tabs, isNotEmpty);
        expect(snapshot.orders, isNotEmpty);
      });
    });

    group('dispute getters', () {
      test('getDisputeDetail returns levels, evidence, timeline', () {
        final snapshot = repository.getDisputeDetail('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.levels, isNotEmpty);
        expect(snapshot.evidence, isNotEmpty);
        expect(snapshot.timeline, isNotEmpty);
        expect(snapshot.supportMessages, isNotEmpty);
      });

      test('getDisputeEvidence returns documents', () {
        final snapshot = repository.getDisputeEvidence('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.documents, isNotEmpty);
      });

      test('getDisputeResolution returns a plausible snapshot', () {
        final snapshot = repository.getDisputeResolution('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      });

      test('getDisputeOpen returns reasons', () {
        final snapshot = repository.getDisputeOpen('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.reasons, isNotEmpty);
      });

      test('getDisputes returns populated dispute list and guide steps', () {
        final snapshot = repository.getDisputes();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.disputes, isNotEmpty);
        expect(snapshot.guideSteps, isNotEmpty);
      });
    });

    group('ad / merchant getters', () {
      test('getAdAnalytics returns populated analytics breakdowns', () {
        final snapshot = repository.getAdAnalytics('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.dailyPerformance, isNotEmpty);
        expect(snapshot.hourlyHeatmap, isNotEmpty);
        expect(snapshot.paymentBreakdown, isNotEmpty);
        expect(snapshot.competitorComparison, isNotEmpty);
        expect(snapshot.optimizationTips, isNotEmpty);
      });

      test('getAdDetail returns a plausible snapshot', () {
        final snapshot = repository.getAdDetail('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      });

      test('getMyAds returns populated ads and quick links', () {
        final snapshot = repository.getMyAds();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.ads, isNotEmpty);
        expect(snapshot.quickLinks, isNotEmpty);
      });

      test('getCreateAd returns populated asset/currency options', () {
        final snapshot = repository.getCreateAd();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.assets, isNotEmpty);
        expect(snapshot.currencies, isNotEmpty);
        expect(snapshot.paymentOptions, isNotEmpty);
      });

      test('getMerchantApply returns benefits and requirements', () {
        final snapshot = repository.getMerchantApply();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.benefits, isNotEmpty);
        expect(snapshot.requirements, isNotEmpty);
        expect(snapshot.documents, isNotEmpty);
      });

      test('getMerchantProfile("mc001") returns populated ads and reviews', () {
        final snapshot = repository.getMerchantProfile('mc001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.merchantId, 'mc001');
        expect(snapshot.ads, isNotEmpty);
        expect(snapshot.reviews, isNotEmpty);
      });

      test('getReportMerchant("mc001") returns populated reasons', () {
        final snapshot = repository.getReportMerchant('mc001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.merchantId, 'mc001');
        expect(snapshot.reasons, isNotEmpty);
      });

      test('getTradingLevel returns populated levels', () {
        final snapshot = repository.getTradingLevel();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.levels, isNotEmpty);
      });

      test('getReviews returns received/given reviews', () {
        final snapshot = repository.getReviews();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.receivedReviews, isNotEmpty);
        expect(snapshot.givenReviews, isNotEmpty);
      });
    });

    group('payment method getters', () {
      test('getPaymentMethodAdd returns bank/e-wallet options', () {
        final snapshot = repository.getPaymentMethodAdd();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.bankOptions, isNotEmpty);
        expect(snapshot.ewalletOptions, isNotEmpty);
      });

      test('getPaymentMethodVerification("sample") returns methods', () {
        final snapshot = repository.getPaymentMethodVerification('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.methods, isNotEmpty);
        expect(snapshot.microDepositSteps, isNotEmpty);
      });

      test('getPaymentMethodOwnership("sample") returns documents', () {
        final snapshot = repository.getPaymentMethodOwnership('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.documents, isNotEmpty);
      });

      test('getPaymentMethodCoolingPeriod returns a plausible snapshot', () {
        final snapshot = repository.getPaymentMethodCoolingPeriod();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      });

      test('getPaymentMethodHistory returns transactions', () {
        final snapshot = repository.getPaymentMethodHistory();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.transactions, isNotEmpty);
      });

      test('getPaymentMethods returns populated method list', () {
        final snapshot = repository.getPaymentMethods();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.methods, isNotEmpty);
      });
    });

    group('insurance getters', () {
      test('getInsuranceFund returns eligibility/coverage/claims data', () {
        final snapshot = repository.getInsuranceFund();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.eligibilityItems, isNotEmpty);
        expect(snapshot.coverageTiers, isNotEmpty);
        expect(snapshot.claims, isNotEmpty);
        expect(snapshot.chartPoints, isNotEmpty);
      });

      test('getInsuranceCertificate returns covered cases', () {
        final snapshot = repository.getInsuranceCertificate();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.coveredCases, isNotEmpty);
        expect(snapshot.exclusions, isNotEmpty);
      });

      test('getInsuranceScore returns factors and tier requirements', () {
        final snapshot = repository.getInsuranceScore();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.factors, isNotEmpty);
        expect(snapshot.quickActions, isNotEmpty);
        expect(snapshot.tierRequirements, isNotEmpty);
      });

      test('getInsurancePolicy returns populated sections', () {
        final snapshot = repository.getInsurancePolicy();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.sections, isNotEmpty);
      });

      test('getContributionHistory returns contributions', () {
        final snapshot = repository.getContributionHistory();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.contributions, isNotEmpty);
      });

      test('getClaimDetail returns timeline, evidence, reviewer notes', () {
        final snapshot = repository.getClaimDetail('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.claim.timeline, isNotEmpty);
        expect(snapshot.claim.evidence, isNotEmpty);
        expect(snapshot.claim.reviewerNotes, isNotEmpty);
        expect(snapshot.benchmarks, isNotEmpty);
        expect(snapshot.reasonShares, isNotEmpty);
      });
    });

    group('escrow / wallet getters', () {
      test('getEscrowBalance returns populated asset balances', () {
        final snapshot = repository.getEscrowBalance();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.assets, isNotEmpty);
        expect(snapshot.helpBullets, isNotEmpty);
      });

      test('getEscrowDetail delegates to getOrder and returns signers', () {
        final snapshot = repository.getEscrowDetail('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.signers, isNotEmpty);
        expect(snapshot.timeline, isNotEmpty);
      });

      test('getWalletTransfer returns assets and balances', () {
        final snapshot = repository.getWalletTransfer();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.assets, isNotEmpty);
        expect(snapshot.balances, isNotEmpty);
      });

      test('getFundLockHistory returns populated records', () {
        final snapshot = repository.getFundLockHistory();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.records, isNotEmpty);
      });

      test('getWallet returns balances and transactions', () {
        final snapshot = repository.getWallet();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.balances, isNotEmpty);
        expect(snapshot.transactions, isNotEmpty);
      });
    });

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
