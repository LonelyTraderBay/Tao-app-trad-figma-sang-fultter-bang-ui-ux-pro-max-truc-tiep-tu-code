import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

/// Direct smoke test for [MockP2PRepository]: home/express intake and the
/// order lifecycle (order detail, timeline, rate, cancel, proof, chat, my
/// orders) and dispute getters.
///
/// Split from mock_p2p_repository_test.dart (Wave 6 behavior-group split,
/// zero test-behavior changes) — see mock_p2p_repository_merchant_test.dart
/// for ad/merchant, payment method, insurance and escrow/wallet getters, and
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
    group('home / express getters', () {
      test(
        'getHome, getExpress, getExpressConfirm return plausible data',
        () async {
          final home = await repository.getHome();
          expect(home.endpoint, isNotEmpty);
          expect(home.assets, isNotEmpty);
          expect(home.ads, isNotEmpty);

          final express = await repository.getExpress();
          expect(express.endpoint, isNotEmpty);
          expect(express.assets, isNotEmpty);
          expect(express.ads, isNotEmpty);

          final expressConfirm = await repository.getExpressConfirm(
            adId: 'ad001',
          );
          expect(expressConfirm.endpoint, isNotEmpty);
          expect(expressConfirm.supportedStates, isNotEmpty);
        },
      );
    });

    group('order lifecycle getters', () {
      test('getOrder returns a populated order snapshot', () async {
        final snapshot = await repository.getOrder('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.order.id, 'p2p001');
        expect(snapshot.paymentFields, isNotEmpty);
        expect(snapshot.timeline, isNotEmpty);
        expect(snapshot.quickActions, isNotEmpty);
      });

      test('getOrderTimeline returns populated timeline events', () async {
        final snapshot = await repository.getOrderTimeline('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.events, isNotEmpty);
      });

      test('getOrderRate returns quick tags', () async {
        final snapshot = await repository.getOrderRate('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.quickTags, isNotEmpty);
      });

      test('getOrderCancel returns cancel reasons', () async {
        final snapshot = await repository.getOrderCancel('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.reasons, isNotEmpty);
      });

      test('getOrderProof returns tips', () async {
        final snapshot = await repository.getOrderProof('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.tips, isNotEmpty);
      });

      test('getChat returns messages and quick replies', () async {
        final snapshot = await repository.getChat('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.messages, isNotEmpty);
        expect(snapshot.quickReplies, isNotEmpty);
      });

      test('getMyOrders returns populated tabs and orders', () async {
        final snapshot = await repository.getMyOrders();
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.tabs, isNotEmpty);
        expect(snapshot.orders, isNotEmpty);
      });
    });

    group('dispute getters', () {
      test('getDisputeDetail returns levels, evidence, timeline', () async {
        final snapshot = await repository.getDisputeDetail('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.levels, isNotEmpty);
        expect(snapshot.evidence, isNotEmpty);
        expect(snapshot.timeline, isNotEmpty);
        expect(snapshot.supportMessages, isNotEmpty);
      });

      test('getDisputeEvidence returns documents', () async {
        final snapshot = await repository.getDisputeEvidence('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.documents, isNotEmpty);
      });

      test('getDisputeResolution returns a plausible snapshot', () async {
        final snapshot = await repository.getDisputeResolution('sample');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      });

      test('getDisputeOpen returns reasons', () async {
        final snapshot = await repository.getDisputeOpen('p2p001');
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.reasons, isNotEmpty);
      });

      test(
        'getDisputes returns populated dispute list and guide steps',
        () async {
          final snapshot = await repository.getDisputes();
          expect(snapshot.endpoint, isNotEmpty);
          expect(snapshot.disputes, isNotEmpty);
          expect(snapshot.guideSteps, isNotEmpty);
        },
      );
    });
  });
}
