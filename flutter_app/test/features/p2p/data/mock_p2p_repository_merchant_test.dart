import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

/// Direct smoke test for [MockP2PRepository]: ad/merchant, payment method,
/// insurance and escrow/wallet getters.
///
/// Split from mock_p2p_repository_test.dart (Wave 6 behavior-group split,
/// zero test-behavior changes) — see mock_p2p_repository_orders_test.dart
/// for home/express intake, order lifecycle and dispute getters, and
/// mock_p2p_repository_account_test.dart for kyc/identity/security,
/// limits/compliance, market/dashboard and blacklist/notification/settings/
/// guide getters.
///
/// The mock repository has ~68 getter methods but until now was only ever
/// exercised indirectly through page/controller tests (each touching 1-2
/// methods). This file calls every method on the [P2PRepository] interface
/// once, asserting the call does not throw and returns a plausible,
/// well-formed snapshot. ID arguments reuse the literal values already
/// proven to work in the corresponding page tests (see
/// `test/features/p2p/p2p_*_page_test.dart` and `p2p_controller_test.dart`).
void main() {
  const repository = MockP2PRepository(loadDelay: Duration.zero);

  group('MockP2PRepository smoke test', () {
    group('ad / merchant getters', () {
      test('getAdAnalytics returns populated analytics breakdowns', () async {
        final snapshot = await repository.getAdAnalytics('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.dailyPerformance, isNotEmpty);
        expect(snapshot.hourlyHeatmap, isNotEmpty);
        expect(snapshot.paymentBreakdown, isNotEmpty);
        expect(snapshot.competitorComparison, isNotEmpty);
        expect(snapshot.optimizationTips, isNotEmpty);
      });

      test('getAdDetail returns a plausible snapshot', () async {
        final snapshot = await repository.getAdDetail('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      });

      test('getMyAds returns populated ads and quick links', () async {
        final snapshot = await repository.getMyAds();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.ads, isNotEmpty);
        expect(snapshot.quickLinks, isNotEmpty);
      });

      test('getCreateAd returns populated asset/currency options', () async {
        final snapshot = await repository.getCreateAd();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.assets, isNotEmpty);
        expect(snapshot.currencies, isNotEmpty);
        expect(snapshot.paymentOptions, isNotEmpty);
      });

      test('getMerchantApply returns benefits and requirements', () async {
        final snapshot = await repository.getMerchantApply();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.benefits, isNotEmpty);
        expect(snapshot.requirements, isNotEmpty);
        expect(snapshot.documents, isNotEmpty);
      });

      test(
        'getMerchantProfile("mc001") returns populated ads and reviews',
        () async {
          final snapshot = await repository.getMerchantProfile('mc001');
          expect(snapshot.endpoint, isNotEmpty);
          expect(snapshot.merchantId, 'mc001');
          expect(snapshot.ads, isNotEmpty);
          expect(snapshot.reviews, isNotEmpty);
        },
      );

      test('getReportMerchant("mc001") returns populated reasons', () async {
        final snapshot = await repository.getReportMerchant('mc001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.merchantId, 'mc001');
        expect(snapshot.reasons, isNotEmpty);
      });

      test('getTradingLevel returns populated levels', () async {
        final snapshot = await repository.getTradingLevel();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.levels, isNotEmpty);
      });

      test('getReviews returns received/given reviews', () async {
        final snapshot = await repository.getReviews();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.receivedReviews, isNotEmpty);
        expect(snapshot.givenReviews, isNotEmpty);
      });
    });

    group('payment method getters', () {
      test('getPaymentMethodAdd returns bank/e-wallet options', () async {
        final snapshot = await repository.getPaymentMethodAdd();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.bankOptions, isNotEmpty);
        expect(snapshot.ewalletOptions, isNotEmpty);
      });

      test('getPaymentMethodVerification("sample") returns methods', () async {
        final snapshot = await repository.getPaymentMethodVerification(
          'sample',
        );
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.methods, isNotEmpty);
        expect(snapshot.microDepositSteps, isNotEmpty);
      });

      test('getPaymentMethodOwnership("sample") returns documents', () async {
        final snapshot = await repository.getPaymentMethodOwnership('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.documents, isNotEmpty);
      });

      test(
        'getPaymentMethodCoolingPeriod returns a plausible snapshot',
        () async {
          final snapshot = await repository.getPaymentMethodCoolingPeriod();
          expect(snapshot.endpoint, isNotEmpty);
          expect(snapshot.supportedStates, isNotEmpty);
        },
      );

      test('getPaymentMethodHistory returns transactions', () async {
        final snapshot = await repository.getPaymentMethodHistory();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.transactions, isNotEmpty);
      });

      test('getPaymentMethods returns populated method list', () async {
        final snapshot = await repository.getPaymentMethods();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.methods, isNotEmpty);
      });
    });

    group('insurance getters', () {
      test(
        'getInsuranceFund returns eligibility/coverage/claims data',
        () async {
          final snapshot = await repository.getInsuranceFund();
          expect(snapshot.endpoint, isNotEmpty);
          expect(snapshot.eligibilityItems, isNotEmpty);
          expect(snapshot.coverageTiers, isNotEmpty);
          expect(snapshot.claims, isNotEmpty);
          expect(snapshot.chartPoints, isNotEmpty);
        },
      );

      test('getInsuranceCertificate returns covered cases', () async {
        final snapshot = await repository.getInsuranceCertificate();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.coveredCases, isNotEmpty);
        expect(snapshot.exclusions, isNotEmpty);
      });

      test('getInsuranceScore returns factors and tier requirements', () async {
        final snapshot = await repository.getInsuranceScore();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.factors, isNotEmpty);
        expect(snapshot.quickActions, isNotEmpty);
        expect(snapshot.tierRequirements, isNotEmpty);
      });

      test('getInsurancePolicy returns populated sections', () async {
        final snapshot = await repository.getInsurancePolicy();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.sections, isNotEmpty);
      });

      test('getContributionHistory returns contributions', () async {
        final snapshot = await repository.getContributionHistory();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.contributions, isNotEmpty);
      });

      test(
        'getClaimDetail returns timeline, evidence, reviewer notes',
        () async {
          final snapshot = await repository.getClaimDetail('sample');
          expect(snapshot.endpoint, isNotEmpty);
          expect(snapshot.claim.timeline, isNotEmpty);
          expect(snapshot.claim.evidence, isNotEmpty);
          expect(snapshot.claim.reviewerNotes, isNotEmpty);
          expect(snapshot.benchmarks, isNotEmpty);
          expect(snapshot.reasonShares, isNotEmpty);
        },
      );
    });

    group('escrow / wallet getters', () {
      test('getEscrowBalance returns populated asset balances', () async {
        final snapshot = await repository.getEscrowBalance();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.assets, isNotEmpty);
        expect(snapshot.helpBullets, isNotEmpty);
      });

      test(
        'getEscrowDetail delegates to getOrder and returns signers',
        () async {
          final snapshot = await repository.getEscrowDetail('p2p001');
          expect(snapshot.endpoint, isNotEmpty);
          expect(snapshot.signers, isNotEmpty);
          expect(snapshot.timeline, isNotEmpty);
        },
      );

      test('getWalletTransfer returns assets and balances', () async {
        final snapshot = await repository.getWalletTransfer();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.assets, isNotEmpty);
        expect(snapshot.balances, isNotEmpty);
      });

      test('getFundLockHistory returns populated records', () async {
        final snapshot = await repository.getFundLockHistory();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.records, isNotEmpty);
      });

      test('getWallet returns balances and transactions', () async {
        final snapshot = await repository.getWallet();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.balances, isNotEmpty);
        expect(snapshot.transactions, isNotEmpty);
      });
    });
  });
}
