import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

void main() {
  ProviderContainer container() {
    final value = ProviderContainer();
    addTearDown(value.dispose);
    return value;
  }

  test('SavingsController filters products and resolves positions', () {
    final controller = container().read(savingsControllerProvider);
    final snapshot = controller.state.snapshot;

    expect(controller.state.hasProducts, isTrue);
    expect(
      controller.productsByType(null),
      hasLength(snapshot.products.length),
    );
    expect(
      controller.productsByType(SavingsProductType.flexible),
      everyElement(
        isA<SavingsProductDraft>().having(
          (product) => product.type,
          'type',
          SavingsProductType.flexible,
        ),
      ),
    );
    expect(controller.positionById(snapshot.positions.first.id), isNotNull);
    expect(controller.positionById('missing'), isNull);
  });

  test('SavingsRedeemController builds preview only for known positions', () {
    final value = container();
    final positionId = value
        .read(savingsControllerProvider)
        .state
        .snapshot
        .positions
        .first
        .id;

    final controller = value.read(savingsRedeemControllerProvider(positionId));
    final missing = value.read(savingsRedeemControllerProvider('missing'));

    expect(controller.state.canPreview, isTrue);
    expect(controller.buildPreview()!.nextStep, '/earn/savings/receipt');
    expect(missing.state.canPreview, isFalse);
    expect(missing.buildPreview(), isNull);
  });

  test('risk assessment controllers own score and result selection', () {
    final value = container();
    final savings = value.read(savingsRiskAssessmentControllerProvider);
    final savingsAnswers = {
      for (final question in savings.state.snapshot.questions)
        question.id: question.options.first.value,
    };
    final staking = value.read(stakingRiskAssessmentControllerProvider);
    final stakingAnswers = {
      for (final question in staking.state.snapshot.questions)
        question.id: question.options.first.value,
    };

    expect(savings.isComplete(savingsAnswers), isTrue);
    expect(savings.resultForAnswers(savingsAnswers).label, isNotEmpty);
    expect(staking.isComplete(stakingAnswers), isTrue);
    expect(staking.resultForAnswers(stakingAnswers).label, isNotEmpty);
    expect(staking.state.maxScore, staking.state.snapshot.questions.length * 3);
  });

  test('StakingSuitabilityController owns answer gates and profile state', () {
    final controller = container().read(stakingSuitabilityControllerProvider);
    final question = controller.state.snapshot.questions.first;

    expect(
      controller.isAnswered(question, answers: const {}, quizAnswers: const {}),
      isFalse,
    );
    expect(
      controller.isAnswered(
        question,
        answers: {question.id: 0},
        quizAnswers: const {},
      ),
      isTrue,
    );

    final score = controller.score(
      answers: {question.id: 0},
      quizAnswers: const {},
    );
    expect(controller.profileForScore(score).label, isNotEmpty);
  });

  test('StakingEmergencyActionsController maps actions to confirm sheets', () {
    final controller = container().read(
      stakingEmergencyActionsControllerProvider,
    );
    final pause = controller.state.snapshot.actions.firstWhere(
      (action) => action.id == 'pause',
    );
    final rebalance = controller.state.snapshot.actions.firstWhere(
      (action) => action.id == 'rebalance',
    );

    expect(
      controller.sheetForAction(pause),
      controller.state.snapshot.pauseSheet,
    );
    expect(controller.sheetForAction(rebalance), isNull);
  });
}
