import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/earn/data/providers/earn_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/earn/presentation/controllers/earn_controller.dart';

export 'package:vit_trade_flutter/features/earn/presentation/controllers/earn_controller.dart';
export 'package:vit_trade_flutter/features/earn/data/providers/earn_repository_provider.dart';

final savingsControllerProvider = Provider<SavingsController>((ref) {
  final snapshot = ref.watch(data.savingsRepositoryProvider).getSavings();
  return SavingsController(state: SavingsViewState(snapshot: snapshot));
});

final savingsRedeemControllerProvider =
    Provider.family<SavingsRedeemController, String>((ref, positionId) {
      final snapshot = ref
          .watch(data.savingsRedeemRepositoryProvider)
          .getRedeem(positionId: positionId);
      return SavingsRedeemController(
        state: SavingsRedeemViewState(snapshot: snapshot),
      );
    });

final savingsRiskAssessmentControllerProvider =
    Provider<SavingsRiskAssessmentController>((ref) {
      final snapshot = ref
          .watch(data.savingsRiskAssessmentRepositoryProvider)
          .getRiskAssessment();
      return SavingsRiskAssessmentController(
        state: SavingsRiskAssessmentViewState(snapshot: snapshot),
      );
    });

final stakingRiskAssessmentControllerProvider =
    Provider<StakingRiskAssessmentController>((ref) {
      final snapshot = ref
          .watch(data.stakingRiskAssessmentRepositoryProvider)
          .getRiskAssessment();
      return StakingRiskAssessmentController(
        state: StakingRiskAssessmentViewState(snapshot: snapshot),
      );
    });

final stakingSuitabilityControllerProvider =
    Provider<StakingSuitabilityController>((ref) {
      final snapshot = ref
          .watch(data.stakingSuitabilityAssessmentRepositoryProvider)
          .getAssessment();
      return StakingSuitabilityController(
        state: StakingSuitabilityViewState(snapshot: snapshot),
      );
    });

final stakingEmergencyActionsControllerProvider =
    Provider<StakingEmergencyActionsController>((ref) {
      final snapshot = ref
          .watch(data.stakingEmergencyActionsRepositoryProvider)
          .getEmergencyActions();
      return StakingEmergencyActionsController(
        state: StakingEmergencyActionsViewState(snapshot: snapshot),
      );
    });
