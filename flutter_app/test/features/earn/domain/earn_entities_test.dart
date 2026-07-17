import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';

void main() {
  group('StakingProposalDraft', () {
    test('yesPercent/noPercent derive from yes and no votes', () {
      const proposal = StakingProposalDraft(
        id: 'prop-1',
        title: 'Raise APY cap',
        status: 'active',
        yesVotes: 75,
        noVotes: 25,
        quorum: 100,
        endsIn: '2d',
        category: 'parameter',
        votingRoute: '/earn/staking/governance/prop-1',
      );

      expect(proposal.totalVotes, 100);
      expect(proposal.yesPercent, 75);
      expect(proposal.noPercent, 25);
    });

    test('yesPercent is 0 (not NaN) when totalVotes is 0', () {
      const proposal = StakingProposalDraft(
        id: 'prop-2',
        title: 'No votes yet',
        status: 'active',
        yesVotes: 0,
        noVotes: 0,
        quorum: 100,
        endsIn: '5d',
        category: 'parameter',
        votingRoute: '/earn/staking/governance/prop-2',
      );

      expect(proposal.totalVotes, 0);
      expect(proposal.yesPercent, 0);
      // noPercent = 100 - yesPercent, so a 0-vote proposal still reports
      // 100% "no" — a display quirk, not a crash. Pinned so a future
      // refactor doesn't silently change this to NaN/0.
      expect(proposal.noPercent, 100);
    });
  });

  group('StakingValidatorHealthMonitorSnapshot', () {
    StakingValidatorHealthDraft validator({
      required String status,
      required double uptime,
    }) {
      return StakingValidatorHealthDraft(
        id: 'v-$status-$uptime',
        name: 'Validator $status',
        address: '0xabc',
        uptime: uptime,
        apr: 4.5,
        totalStakedEth: 1000,
        commission: 10,
        status: status,
        lastBlock: '100',
        missedBlocks: 0,
      );
    }

    test(
      'healthyCount/warningCount/averageUptime derive from the validator list',
      () {
        final snapshot = StakingValidatorHealthMonitorSnapshot(
          endpoint: '/api/staking/validators',
          actionDraft: 'draft',
          title: 'Validator health',
          backRoute: '/earn/staking',
          validators: [
            validator(status: 'healthy', uptime: 100),
            validator(status: 'healthy', uptime: 98),
            validator(status: 'warning', uptime: 80),
          ],
          uptimeHistory: const [],
          actionTitle: 'title',
          actionBody: 'body',
          actionLabel: 'label',
          footerNote: 'note',
          contractNotes: 'notes',
          supportedStates: const {EarnScreenState.loading},
        );

        expect(snapshot.healthyCount, 2);
        expect(snapshot.warningCount, 1);
        expect(snapshot.averageUptime, closeTo(92.66666, 0.001));
      },
    );

    test(
      'averageUptime on an empty validator list is NaN, not a thrown error '
      '(documents an existing edge case — 0/0 division, not exercised by '
      'production data today)',
      () {
        final snapshot = StakingValidatorHealthMonitorSnapshot(
          endpoint: '/api/staking/validators',
          actionDraft: 'draft',
          title: 'Validator health',
          backRoute: '/earn/staking',
          validators: const [],
          uptimeHistory: const [],
          actionTitle: 'title',
          actionBody: 'body',
          actionLabel: 'label',
          footerNote: 'note',
          contractNotes: 'notes',
          supportedStates: const {EarnScreenState.empty},
        );

        expect(snapshot.healthyCount, 0);
        expect(snapshot.warningCount, 0);
        expect(snapshot.averageUptime.isNaN, isTrue);
      },
    );
  });

  group('StakingAuditFindingsDraft', () {
    test('resolvedFindings sums critical/high/medium/low but not '
        'informational', () {
      const findings = StakingAuditFindingsDraft(
        critical: 1,
        high: 2,
        medium: 3,
        low: 4,
        informational: 100,
      );

      expect(findings.resolvedFindings, 10);
    });

    test('resolvedFindings is 0 when every severity is 0', () {
      const findings = StakingAuditFindingsDraft(
        critical: 0,
        high: 0,
        medium: 0,
        low: 0,
        informational: 0,
      );

      expect(findings.resolvedFindings, 0);
    });
  });
}
