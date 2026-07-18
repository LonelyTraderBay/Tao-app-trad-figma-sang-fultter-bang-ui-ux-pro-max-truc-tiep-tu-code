import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

/// Smoke test for the core savings mocks: exercises [MockSavingsRepository],
/// [MockSavingsProductDetailRepository], [MockSavingsRedeemRepository],
/// [MockSavingsReceiptRepository], [MockSavingsPortfolioRepository],
/// [MockSavingsHistoryRepository], and [MockSavingsGoalsRepository],
/// asserting each call succeeds without throwing and returns a plausible,
/// non-empty result.
void main() {
  const savingsRepo = MockSavingsRepository();
  const productDetailRepo = MockSavingsProductDetailRepository();
  const redeemRepo = MockSavingsRedeemRepository();
  const receiptRepo = MockSavingsReceiptRepository();
  const portfolioRepo = MockSavingsPortfolioRepository();
  const historyRepo = MockSavingsHistoryRepository();
  const goalsRepo = MockSavingsGoalsRepository();

  group('Earn savings core mocks smoke test', () {
    test('getSavings returns a populated snapshot', () async {
      final snapshot = await savingsRepo.getSavings();

      expect(snapshot, isA<SavingsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.subtitle, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.portfolioRoute, isNotEmpty);
      expect(snapshot.guideRoute, isNotEmpty);
      expect(snapshot.exportRoute, isNotEmpty);
      expect(snapshot.productDetailRoute, isNotEmpty);
      expect(snapshot.totalDepositedUsd, isNotEmpty);
      expect(snapshot.gainLabel, isNotEmpty);
      expect(snapshot.insights, isNotEmpty);
      expect(snapshot.products, hasLength(7));
      expect(snapshot.products.first.id, 'sav001');
      expect(snapshot.positions, hasLength(3));
      expect(snapshot.positions.first.id, 'ms1');
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getProductDetail returns the matching product for a known id',
      () async {
        final snapshot = await productDetailRepo.getProductDetail(
          productId: 'sav001',
        );

        expect(snapshot, isA<SavingsProductDetailSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.title, isNotEmpty);
        expect(snapshot.backRoute, isNotEmpty);
        expect(snapshot.productId, 'sav001');
        expect(snapshot.product, isNotNull);
        expect(snapshot.product?.name, 'USDT Linh hoạt');
        expect(snapshot.notFoundMessage, isNotEmpty);
        expect(snapshot.contractNotes, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test('getProductDetail does not throw for an unknown id and falls back '
        'to a null product', () async {
      // GD4 playbook mục 7: repo giờ trả Future — await trực tiếp thay vì
      // bọc `returnsNormally` (await tự propagate lỗi nếu có, đạt cùng mục
      // đích "không throw").
      final snapshot = await productDetailRepo.getProductDetail(
        productId: 'does-not-exist',
      );
      expect(snapshot, isA<SavingsProductDetailSnapshot>());
      expect(snapshot.productId, 'does-not-exist');
      expect(snapshot.product, isNull);
      expect(snapshot.notFoundMessage, isNotEmpty);
    });

    test('getRedeem returns the matching position for a known id', () async {
      final snapshot = await redeemRepo.getRedeem(positionId: 'ms1');

      expect(snapshot, isA<SavingsRedeemSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.receiptRoute, isNotEmpty);
      expect(snapshot.positionId, 'ms1');
      expect(snapshot.position, isNotNull);
      expect(snapshot.position?.amount, '3500 USDT');
      expect(snapshot.notFoundMessage, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getRedeem does not throw for an unknown id and falls back to a '
        'null position', () async {
      // Bẫy 7 tương tự: await trực tiếp thay vì `returnsNormally`.
      final snapshot = await redeemRepo.getRedeem(positionId: 'does-not-exist');
      expect(snapshot, isA<SavingsRedeemSnapshot>());
      expect(snapshot.positionId, 'does-not-exist');
      expect(snapshot.position, isNull);
      expect(snapshot.notFoundMessage, isNotEmpty);
    });

    test('getReceipt returns the empty-state receipt snapshot', () async {
      final snapshot = await receiptRepo.getReceipt();

      expect(snapshot, isA<SavingsReceiptSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.earnRoute, isNotEmpty);
      expect(snapshot.receipt, isNull);
      expect(snapshot.emptyMessage, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getPortfolio returns a populated snapshot', () async {
      final snapshot = await portfolioRepo.getPortfolio();

      expect(snapshot, isA<SavingsPortfolioSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.savingsRoute, isNotEmpty);
      expect(snapshot.historyRoute, isNotEmpty);
      expect(snapshot.totalDepositedUsd, isNotEmpty);
      expect(snapshot.gainLabel, isNotEmpty);
      expect(snapshot.weightedApy, isNotEmpty);
      expect(snapshot.flexibleTotalUsd, isNotEmpty);
      expect(snapshot.lockedTotalUsd, isNotEmpty);
      expect(snapshot.activePositions, 3);
      expect(snapshot.maturingPositions, 1);
      expect(snapshot.positions, hasLength(4));
      expect(snapshot.positions.first.id, 'ms1');
      expect(snapshot.incomeProjections, hasLength(3));
      expect(snapshot.maturityEvents, hasLength(3));
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getHistory returns a populated snapshot', () async {
      final snapshot = await historyRepo.getHistory();

      expect(snapshot, isA<SavingsHistorySnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.receiptRoute, isNotEmpty);
      expect(snapshot.totalSubscribed, isNotEmpty);
      expect(snapshot.totalInterest, isNotEmpty);
      expect(snapshot.totalRedeemed, isNotEmpty);
      expect(snapshot.searchPlaceholder, isNotEmpty);
      expect(snapshot.transactions, isNotEmpty);
      expect(snapshot.transactions.first.id, 'stx12');
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getGoals returns a populated snapshot', () async {
      final snapshot = await goalsRepo.getGoals();

      expect(snapshot, isA<SavingsGoalsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.subtitle, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.goals, hasLength(3));
      expect(snapshot.goals.first.id, 'g1');
      expect(snapshot.templates, isNotEmpty);
      expect(snapshot.tips, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });
}
