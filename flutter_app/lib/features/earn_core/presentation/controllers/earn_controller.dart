import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';

export 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
export 'package:vit_trade_flutter/features/earn_core/domain/repositories/earn_repository.dart';

final class SavingsViewState {
  const SavingsViewState({required this.snapshot});

  final SavingsSnapshot snapshot;

  bool get hasProducts => snapshot.products.isNotEmpty;
  bool get hasPositions => snapshot.positions.isNotEmpty;
}

final class SavingsController {
  const SavingsController({required this.state});

  final SavingsViewState state;

  List<SavingsProductDraft> productsByType(SavingsProductType? type) {
    if (type == null) return state.snapshot.products;
    return state.snapshot.products
        .where((product) => product.type == type)
        .toList(growable: false);
  }

  SavingsPositionDraft? positionById(String positionId) {
    for (final position in state.snapshot.positions) {
      if (position.id == positionId) return position;
    }
    return null;
  }
}

final class SavingsRedeemViewState {
  const SavingsRedeemViewState({required this.snapshot});

  final SavingsRedeemSnapshot snapshot;

  SavingsPositionDraft? get position => snapshot.position;
  bool get canPreview => snapshot.position != null;
  String get backRoute => snapshot.backRoute;
}

final class SavingsRedeemPreview {
  const SavingsRedeemPreview({
    required this.product,
    required this.asset,
    required this.amount,
    required this.earned,
    required this.nextStep,
  });

  final String product;
  final String asset;
  final String amount;
  final String earned;
  final String nextStep;
}

final class SavingsRedeemController {
  const SavingsRedeemController({required this.state});

  final SavingsRedeemViewState state;

  SavingsRedeemPreview? buildPreview() {
    final position = state.position;
    if (position == null) return null;
    return SavingsRedeemPreview(
      product: position.product,
      asset: position.asset,
      amount: position.amount,
      earned: position.earned,
      nextStep: state.snapshot.receiptRoute,
    );
  }
}

final class SavingsRiskAssessmentViewState {
  const SavingsRiskAssessmentViewState({required this.snapshot});

  final SavingsRiskAssessmentSnapshot snapshot;

  bool get hasQuestions => snapshot.questions.isNotEmpty;
}

final class SavingsRiskAssessmentController {
  const SavingsRiskAssessmentController({required this.state});

  final SavingsRiskAssessmentViewState state;

  int score(Map<String, int> answers) {
    return answers.values.fold(0, (sum, value) => sum + value);
  }

  bool isComplete(Map<String, int> answers) {
    return state.snapshot.questions.every(
      (question) => answers.containsKey(question.id),
    );
  }

  SavingsRiskProfileResultDraft resultForAnswers(Map<String, int> answers) {
    return resultForScore(score(answers));
  }

  SavingsRiskProfileResultDraft resultForScore(int score) {
    return state.snapshot.results.firstWhere(
      (result) => score >= result.minScore && score <= result.maxScore,
      orElse: () => state.snapshot.results.last,
    );
  }
}

final class StakingRiskAssessmentViewState {
  const StakingRiskAssessmentViewState({required this.snapshot});

  final StakingRiskAssessmentSnapshot snapshot;

  int get maxScore => snapshot.questions.length * 3;
}

final class StakingRiskAssessmentController {
  const StakingRiskAssessmentController({required this.state});

  final StakingRiskAssessmentViewState state;

  int score(Map<String, int> answers) {
    return answers.values.fold(0, (sum, value) => sum + value);
  }

  bool isComplete(Map<String, int> answers) {
    return state.snapshot.questions.every(
      (question) => answers.containsKey(question.id),
    );
  }

  StakingRiskProfileResultDraft resultForAnswers(Map<String, int> answers) {
    return resultForScore(score(answers));
  }

  StakingRiskProfileResultDraft resultForScore(int score) {
    return state.snapshot.results.firstWhere(
      (result) => score >= result.minScore && score <= result.maxScore,
      orElse: () => state.snapshot.results.last,
    );
  }
}

final class StakingSuitabilityViewState {
  const StakingSuitabilityViewState({required this.snapshot});

  final StakingSuitabilityAssessmentSnapshot snapshot;
}

final class StakingSuitabilityController {
  const StakingSuitabilityController({required this.state});

  final StakingSuitabilityViewState state;

  bool isAnswered(
    StakingSuitabilityQuestionDraft question, {
    required Map<String, int> answers,
    required Map<int, int> quizAnswers,
  }) {
    if (question.type == StakingSuitabilityQuestionType.quiz) {
      return quizAnswers.length == question.quizQuestions.length;
    }
    return answers.containsKey(question.id);
  }

  int score({
    required Map<String, int> answers,
    required Map<int, int> quizAnswers,
  }) {
    var total = 0;
    for (final question in state.snapshot.questions) {
      final answer = answers[question.id];
      if (question.type == StakingSuitabilityQuestionType.single &&
          answer != null &&
          answer >= 0 &&
          answer < question.options.length) {
        total += question.options[answer].weight;
      } else if (question.type == StakingSuitabilityQuestionType.slider &&
          answer != null) {
        total += answer * (question.weight ?? 1);
      } else if (question.type == StakingSuitabilityQuestionType.quiz) {
        for (var i = 0; i < question.quizQuestions.length; i += 1) {
          if (quizAnswers[i] == question.quizQuestions[i].correctIndex) {
            total += question.weight ?? 1;
          }
        }
      }
    }
    return total.clamp(0, 100).toInt();
  }

  StakingSuitabilityProfileDraft profileForScore(int score) {
    return state.snapshot.profiles.firstWhere(
      (profile) => score >= profile.minScore && score <= profile.maxScore,
      orElse: () => state.snapshot.profiles.last,
    );
  }
}

final class StakingEmergencyActionsViewState {
  const StakingEmergencyActionsViewState({required this.snapshot});

  final StakingEmergencyActionsSnapshot snapshot;
}

final class StakingEmergencyActionsController {
  const StakingEmergencyActionsController({required this.state});

  final StakingEmergencyActionsViewState state;

  StakingEmergencySheetDraft? sheetForAction(
    StakingEmergencyActionDraft action,
  ) {
    return switch (action.id) {
      'pause' => state.snapshot.pauseSheet,
      'withdraw' => state.snapshot.withdrawSheet,
      _ => null,
    };
  }
}
