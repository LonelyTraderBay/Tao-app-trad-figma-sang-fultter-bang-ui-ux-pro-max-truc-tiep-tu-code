import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

/// Smoke test for the staking community/governance mocks: exercises
/// [MockStakingSocialFeedRepository], [MockStakingCommunityGovernanceRepository],
/// [MockStakingProposalsRepository], [MockStakingVotingRepository], and
/// [MockStakingForumRepository], asserting each call succeeds without
/// throwing and returns a plausible, non-empty result.
void main() {
  const socialFeedRepo = MockStakingSocialFeedRepository();
  const governanceRepo = MockStakingCommunityGovernanceRepository();
  const proposalsRepo = MockStakingProposalsRepository();
  const votingRepo = MockStakingVotingRepository();
  const forumRepo = MockStakingForumRepository();

  group('Earn staking community/governance mocks smoke test', () {
    test('getFeed returns a populated social feed snapshot', () async {
      final snapshot = await socialFeedRepo.getFeed();

      expect(snapshot, isA<StakingSocialFeedSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.tabs, isNotEmpty);
      expect(snapshot.defaultTabId, isNotEmpty);
      expect(snapshot.posts, isNotEmpty);
      expect(snapshot.stats, isNotEmpty);
      expect(snapshot.posts.first.id, 'p1');
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getGovernance returns a populated community governance snapshot',
      () async {
        final snapshot = await governanceRepo.getGovernance();

        expect(snapshot, isA<StakingCommunityGovernanceSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.title, isNotEmpty);
        expect(snapshot.proposalsRoute, isNotEmpty);
        expect(snapshot.forumRoute, isNotEmpty);
        expect(snapshot.stats, isNotEmpty);
        expect(
          snapshot.activeProposal,
          isA<StakingGovernanceActiveProposalDraft>(),
        );
        expect(snapshot.recentDecisions, isNotEmpty);
        expect(snapshot.governanceSteps, isNotEmpty);
        expect(snapshot.votingPower, isA<StakingGovernanceVotingPowerDraft>());
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test('getProposals returns a populated proposals snapshot', () async {
      final snapshot = await proposalsRepo.getProposals();

      expect(snapshot, isA<StakingProposalsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.createLabel, isNotEmpty);
      expect(snapshot.proposals, hasLength(3));
      expect(snapshot.proposals.first.id, 'prop001');
      expect(snapshot.proposals.first.votingRoute, '/earn/voting/prop001');
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getVoting returns a populated voting snapshot for the default '
        'proposal', () async {
      final snapshot = await votingRepo.getVoting();

      expect(snapshot, isA<StakingVotingSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/earn/earn-voting');
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.proposalTitle, isNotEmpty);
      expect(snapshot.results, isNotEmpty);
      expect(snapshot.options, isNotEmpty);
      expect(snapshot.votingPower, isNotEmpty);
      expect(snapshot.submitLabel, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getVoting scopes the endpoint to a supplied proposalId', () async {
      final snapshot = await votingRepo.getVoting(proposalId: 'prop003');

      expect(snapshot.endpoint, '/api/mobile/earn/earn-voting-prop003');
    });

    test('getVoting does not throw for an unrecognized proposalId', () async {
      // GD4 playbook mục 7: await trực tiếp thay vì `returnsNormally`.
      final snapshot = await votingRepo.getVoting(proposalId: 'does-not-exist');
      expect(snapshot.endpoint, contains('does-not-exist'));
      expect(snapshot.results, isNotEmpty);
    });

    test('getForum returns a populated forum snapshot', () async {
      final snapshot = await forumRepo.getForum();

      expect(snapshot, isA<StakingForumSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.heroTitle, isNotEmpty);
      expect(snapshot.categories, isNotEmpty);
      expect(snapshot.threads, isNotEmpty);
      expect(snapshot.createLabel, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });
  });
}
