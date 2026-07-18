import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/controllers/p2p_controller.dart';

void main() {
  test(
    'P2P create ad controller validates publish preview and limits',
    () async {
      final snapshot = await const MockP2PRepository(
        loadDelay: Duration.zero,
      ).getCreateAd();
      final controller = P2PCreateAdController(
        state: P2PCreateAdViewState(snapshot: snapshot),
      );

      final preview = controller.preview(
        const P2PCreateAdDraft(
          adType: P2PTradeType.sell,
          asset: 'USDT',
          currency: 'VND',
          priceType: 'fixed',
          paymentWindow: 15,
          tradingHours: '24/7',
          requireKyc: false,
          requiredKycLevel: '1',
          selectedPayments: {'Vietcombank'},
          priceText: '25300',
          marginText: '',
          totalText: '100',
          minLimitText: '500000',
          maxLimitText: '50000000',
        ),
      );

      expect(preview.canPublish, isTrue);
      expect(preview.effectivePrice, 25300);
      expect(preview.priceDiffPercent, 0);
      expect(preview.totalAmountLabel, '100 USDT');
      expect(preview.paymentSummary, 'Vietcombank');
      expect(preview.limitSummary, contains('500000'));
      expect(preview.feeReviewLabel, contains('Xem xét phí'));
      expect(preview.riskReviewLabel, snapshot.warningNote);
      expect(preview.escrowReviewLabel, snapshot.escrowNote);

      expect(
        controller.publishBlockers(
          const P2PCreateAdDraft(
            adType: P2PTradeType.sell,
            asset: 'USDT',
            currency: 'VND',
            priceType: 'fixed',
            paymentWindow: 30,
            tradingHours: '24/7',
            requireKyc: false,
            requiredKycLevel: '1',
            selectedPayments: {},
            priceText: '',
            marginText: '',
            totalText: '',
            minLimitText: '',
            maxLimitText: '',
          ),
        ),
        ['Nhap gia', 'Nhap tong USDT', 'Chon phuong thuc thanh toan'],
      );

      expect(
        controller.publishBlockers(
          const P2PCreateAdDraft(
            adType: P2PTradeType.buy,
            asset: 'USDT',
            currency: 'VND',
            priceType: 'floating',
            paymentWindow: 15,
            tradingHours: '24/7',
            requireKyc: false,
            requiredKycLevel: '1',
            selectedPayments: {'Momo'},
            priceText: '',
            marginText: '',
            totalText: '50',
            minLimitText: '',
            maxLimitText: '',
          ),
        ),
        ['Nhap bien do gia'],
      );

      final floatingPreview = controller.preview(
        const P2PCreateAdDraft(
          adType: P2PTradeType.buy,
          asset: 'USDT',
          currency: 'VND',
          priceType: 'floating',
          paymentWindow: 15,
          tradingHours: '24/7',
          requireKyc: false,
          requiredKycLevel: '1',
          selectedPayments: {'Momo'},
          priceText: '',
          marginText: '0.5',
          totalText: '50',
          minLimitText: '',
          maxLimitText: '',
        ),
      );

      expect(floatingPreview.canPublish, isTrue);
      expect(floatingPreview.publishLabel, contains('MUA USDT'));
      expect(floatingPreview.priceDiffLabel, contains('0.50%'));

      expect(controller.toggledPayments({'Momo'}, 'Momo'), isEmpty);
      expect(controller.toggledPayments({'Momo'}, 'ZaloPay'), {
        'Momo',
        'ZaloPay',
      });
    },
  );

  test(
    'P2P payment method controller validates and previews high-risk add',
    () async {
      final snapshot = await const MockP2PRepository(
        loadDelay: Duration.zero,
      ).getPaymentMethodAdd();
      final controller = P2PPaymentMethodAddController(
        state: P2PPaymentMethodAddViewState(snapshot: snapshot),
      );

      expect(controller.optionsFor(bankType: true).first, 'Vietcombank');
      expect(controller.optionsFor(bankType: false).first, 'Momo');
      expect(
        controller.canPreview(
          selectedMethod: 'Vietcombank',
          account: '0071000123456',
          ownerName: 'NGUYEN VAN A',
        ),
        isTrue,
      );
      expect(
        controller.canPreview(
          selectedMethod: null,
          account: '0071000123456',
          ownerName: 'NGUYEN VAN A',
        ),
        isFalse,
      );
      expect(
        controller.validationMessage(
          selectedMethod: null,
          account: '0071000123456',
          ownerName: 'NGUYEN VAN A',
        ),
        'Select a payment method before preview.',
      );
      expect(
        P2PPaymentMethodAddController(
          state: P2PPaymentMethodAddViewState(
            snapshot: snapshot,
            status: P2PHighRiskFlowStatus.offline,
          ),
        ).validationMessage(
          selectedMethod: 'Vietcombank',
          account: '0071000123456',
          ownerName: 'NGUYEN VAN A',
        ),
        'Offline: reconnect before adding a payment method.',
      );
      expect(P2PHighRiskFlowStatus.confirming.isBusy, isTrue);
      expect(P2PHighRiskFlowStatus.preview.hasPreview, isTrue);
      expect(P2PHighRiskFlowStatus.validationError.isFailure, isTrue);

      final preview = controller.preview(
        selectedMethod: ' Vietcombank ',
        account: ' 0071000123456 ',
        ownerName: ' NGUYEN VAN A ',
      );

      expect(preview.method, 'Vietcombank');
      expect(preview.account, '0071000123456');
      expect(preview.maskedAccount, '007...3456');
      expect(preview.ownerName, 'NGUYEN VAN A');
      expect(preview.ownershipRiskMessage, contains('Xem xét quyền sở hữu'));
      expect(preview.limitMessage, contains('Limits:'));
      expect(preview.confirmTitle, 'Xác nhận thêm phương thức?');
      expect(preview.saveRoute, '/p2p/payment-methods');
    },
  );

  test('P2P risk controller exposes material review factors', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getRiskAssessment();
    final controller = P2PRiskAssessmentController(
      state: P2PRiskAssessmentViewState(snapshot: snapshot),
    );

    expect(controller.requiresReview, isTrue);
    expect(controller.materialFactors, hasLength(snapshot.factors.length));
    expect(controller.materialFactors.first.id, 'kyc');
  });

  test(
    'P2P payment edit controllers own ownership and cooling state',
    () async {
      final repository = const MockP2PRepository(loadDelay: Duration.zero);
      final ownership = P2PPaymentMethodOwnershipController(
        state: P2PPaymentMethodOwnershipViewState(
          snapshot: await repository.getPaymentMethodOwnership('sample'),
        ),
      );

      expect(ownership.requiredDocuments.map((document) => document.id), [
        'bank_card',
        'selfie_card',
      ]);
      expect(ownership.canSubmit({'bank_card'}), isFalse);
      expect(ownership.canSubmit({'bank_card', 'selfie_card'}), isTrue);

      final preview = ownership.submitPreview({'bank_card', 'selfie_card'});
      expect(preview.confirmTitle, ownership.state.snapshot.confirmTitle);
      expect(preview.saveRoute, '/p2p/payment-methods');
      expect(preview.requiredUploaded, 2);
      expect(preview.requiredTotal, 2);

      final cooling = P2PPaymentMethodCoolingPeriodController(
        state: P2PPaymentMethodCoolingPeriodViewState(
          snapshot: await repository.getPaymentMethodCoolingPeriod(),
        ),
      );

      expect(cooling.daysLeft, 7);
      expect(cooling.hoursLeft, 0);
      expect(cooling.remainingLabel, '7d 0h');
    },
  );

  test(
    'P2P dispute evidence controller owns upload and submit state',
    () async {
      final snapshot = await const MockP2PRepository(
        loadDelay: Duration.zero,
      ).getDisputeEvidence('sample');
      final controller = P2PDisputeEvidenceController(
        state: P2PDisputeEvidenceViewState(snapshot: snapshot),
      );

      final initialDocuments = controller.documents({});
      expect(
        initialDocuments.where((document) => document.uploaded),
        hasLength(2),
      );
      expect(controller.canSubmit({}), isTrue);
      expect(controller.validationMessage({}), isNull);
      expect(
        P2PDisputeEvidenceController(
          state: P2PDisputeEvidenceViewState(
            snapshot: snapshot,
            status: P2PHighRiskFlowStatus.offline,
          ),
        ).validationMessage({}),
        'Offline: reconnect before submitting dispute evidence.',
      );

      final completedDocuments = controller.documents({'transaction'});
      expect(
        completedDocuments.where((document) => document.uploaded),
        hasLength(3),
      );

      final preview = controller.submitPreview({'transaction'});
      expect(preview.disputeId, 'sample');
      expect(preview.uploadedCount, 3);
      expect(preview.totalCount, 3);
      expect(preview.auditMessage, contains('escrow'));
    },
  );

  test(
    'P2P order and express confirm controllers own confirmation intent',
    () async {
      final repository = const MockP2PRepository(loadDelay: Duration.zero);
      final orderController = P2POrderController(
        state: P2POrderViewState(snapshot: await repository.getOrder('p2p001')),
      );
      final paidPreview = orderController.paidPreview();

      expect(paidPreview.statusLabel, 'Đã thanh toán - Chờ xác nhận');
      expect(orderController.canMarkPaid(paymentProofReady: true), isTrue);
      expect(
        orderController.paidValidationMessage(paymentProofReady: false),
        'Review payment proof before confirming payment.',
      );
      expect(paidPreview.countdownLabel, '29:59');
      expect(paidPreview.auditMessage, contains('escrow'));

      final expressController = P2PExpressConfirmController(
        state: P2PExpressConfirmViewState(
          snapshot: await repository.getExpressConfirm(adId: 'ad001'),
        ),
      );

      expect(expressController.orderRouteId, 'p2p001');
      expect(expressController.validationMessage(acceptedReview: true), isNull);
      expect(
        P2PExpressConfirmController(
          state: P2PExpressConfirmViewState(
            snapshot: await repository.getExpressConfirm(adId: 'ad001'),
            status: P2PHighRiskFlowStatus.offline,
          ),
        ).validationMessage(acceptedReview: true),
        'Offline: reconnect before express confirmation.',
      );
      expect(expressController.confirmationTitle, 'Xác nhận mua nhanh');
    },
  );
}
