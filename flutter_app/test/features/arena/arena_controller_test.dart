import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

void main() {
  test('Arena join controller gates points-only acknowledgement state', () {
    final repository = const MockArenaRepository();
    final controller = ArenaJoinController(
      state: ArenaJoinViewState(snapshot: repository.getArenaJoin('ch003')),
    );

    expect(controller.canJoin(readRules: true, understandPoints: true), isTrue);
    expect(
      controller.validationMessage(readRules: false, understandPoints: true),
      'Review the rules before joining.',
    );
    expect(ArenaLocalFlowStatus.confirming.isBusy, isTrue);
    expect(ArenaLocalFlowStatus.preview.hasPreview, isTrue);
    expect(ArenaLocalFlowStatus.validationError.isFailure, isTrue);
    expect(
      ArenaJoinController(
        state: ArenaJoinViewState(
          snapshot: repository.getArenaJoin('ch003'),
          status: ArenaLocalFlowStatus.offline,
        ),
      ).validationMessage(readRules: true, understandPoints: true),
      'Offline: reconnect before joining with Arena Points.',
    );
  });

  test('Arena governance controller exposes action state boundary copy', () {
    final repository = const MockArenaRepository();
    final controller = ArenaGovernanceController(
      state: ArenaGovernanceViewState(
        snapshot: repository.getArenaGovernance(),
      ),
    );

    final state = controller.actionState(
      canProceed: false,
      nextAction: 'Add tie rule',
    );

    expect(state.canContinue, isFalse);
    expect(state.footerLabel, 'Add tie rule');
    expect(state.boundaryNote, contains('Arena Points'));
    expect(
      controller.validationMessage(canProceed: false),
      'Complete fair-play and Arena Points rule checks first.',
    );
    expect(controller.validationMessage(canProceed: true), isNull);
  });

  test('Arena report controller owns appeal review state', () {
    final repository = const MockArenaRepository();
    final controller = ArenaReportCaseController(
      state: ArenaReportCaseViewState(
        snapshot: repository.getArenaReportCase('rpt001'),
      ),
    );

    final ready = controller.reviewState(appealSubmitted: false);
    final submitted = controller.reviewState(appealSubmitted: true);

    expect(ready.canAppeal, isTrue);
    expect(controller.canAppeal(appealSubmitted: false), isTrue);
    expect(ready.description, contains('rule evidence'));
    expect(submitted.canAppeal, isFalse);
    expect(submitted.statusLabel, 'Review requested');
    expect(
      controller.appealValidationMessage(appealSubmitted: true),
      'Report review request is already recorded.',
    );
    expect(controller.relatedReportsExcludingCurrent().map((item) => item.id), [
      'rpt002',
      'rpt003',
    ]);
  });

  test('Arena challenge controller builds points-only review model', () {
    final repository = const MockArenaRepository();
    final controller = ArenaChallengeDetailController(
      state: ArenaChallengeDetailViewState(
        snapshot: repository.getArenaChallengeDetail('ch003'),
      ),
    );

    final review = controller.pointsReview();

    expect(review.entryPointsLabel, '200');
    expect(review.poolLabel, '7.2K');
    expect(review.netPoolLabel, isNotEmpty);
    expect(review.boundaryNote, contains('Arena Points only'));
  });
}
