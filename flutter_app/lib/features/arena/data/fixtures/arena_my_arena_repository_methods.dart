part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryMyArenaMethods on _MockArenaRepositoryBase {
  @override
  Future<MyArenaSnapshot> getMyArena() async {
    await _simulateNetwork();
    return const MyArenaSnapshot(
      endpoint: '/api/mobile/profile/profile-arena',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      stats: MyArenaStats(
        currentBalance: 2220,
        pointsEarned: 4520,
        pointsSpent: 2300,
        activeChallenges: 5,
        modesCreated: 2,
        creatorScore: 85,
        rank: 142,
        pendingNotifications: 3,
      ),
      myRooms: [
        ArenaChallengeDraft(
          id: 'ch001',
          title: 'BTC \$70K? - Tuần 9',
          format: 'Closest Guess',
          slotsFilled: 38,
          slotsTotal: 50,
          entryPoints: 100,
          prizePool: 3800,
          state: ArenaChallengeState.open,
        ),
        ArenaChallengeDraft(
          id: 'ch002',
          title: 'ETH Prediction Duel',
          format: 'Closest Guess',
          slotsFilled: 2,
          slotsTotal: 2,
          entryPoints: 200,
          prizePool: 400,
          state: ArenaChallengeState.full,
        ),
        ArenaChallengeDraft(
          id: 'ch003',
          title: 'Altcoin Team Battle - SOL vs AVAX',
          format: 'Team Battle',
          slotsFilled: 40,
          slotsTotal: 40,
          entryPoints: 200,
          prizePool: 7200,
          state: ArenaChallengeState.live,
        ),
      ],
      joinedChallenges: [
        ArenaChallengeDraft(
          id: 'ch003',
          title: 'Altcoin Team Battle - SOL vs AVAX',
          format: 'Team Battle',
          slotsFilled: 40,
          slotsTotal: 40,
          entryPoints: 200,
          prizePool: 7200,
          state: ArenaChallengeState.live,
        ),
        ArenaChallengeDraft(
          id: 'ch004',
          title: 'Fed Rate Predict - March',
          format: 'Prediction',
          slotsFilled: 67,
          slotsTotal: 100,
          entryPoints: 50,
          prizePool: 3350,
          state: ArenaChallengeState.pendingResult,
        ),
        ArenaChallengeDraft(
          id: 'ch001',
          title: 'BTC \$70K? - Tuần 9',
          format: 'Closest Guess',
          slotsFilled: 38,
          slotsTotal: 50,
          entryPoints: 100,
          prizePool: 3800,
          state: ArenaChallengeState.open,
        ),
      ],
      savedModes: [
        ArenaModeDraft(
          id: 'mode001',
          title: 'BTC Weekly Predict',
          creatorName: 'CryptoWhale',
          cloneCount: 124,
          activeChallenges: 18,
          fairPlay: true,
        ),
        ArenaModeDraft(
          id: 'mode002',
          title: 'Altcoin Battle Royale',
          creatorName: 'PredictorPro',
          cloneCount: 86,
          activeChallenges: 9,
          fairPlay: true,
        ),
        ArenaModeDraft(
          id: 'mode004',
          title: 'Crypto Trivia Cup',
          creatorName: 'QuizWizard',
          cloneCount: 51,
          activeChallenges: 6,
          fairPlay: false,
        ),
      ],
      drafts: [
        ArenaDraftChallenge(
          id: 'draft001',
          title: 'SOL vs DOT Prediction',
          format: 'Closest Guess',
          updatedAt: '27/02 14:30',
          entryPoints: 100,
        ),
        ArenaDraftChallenge(
          id: 'draft002',
          title: 'DeFi Quiz Night',
          format: 'Bracket',
          updatedAt: '25/02 18:00',
          entryPoints: 200,
        ),
      ],
      history: [
        ArenaChallengeDraft(
          id: 'ch005',
          title: 'Crypto Quiz Night #11',
          format: 'Bracket',
          slotsFilled: 16,
          slotsTotal: 16,
          entryPoints: 150,
          prizePool: 2400,
          state: ArenaChallengeState.resolved,
        ),
        ArenaChallengeDraft(
          id: 'ch007',
          title: 'NFT Floor Price Guess',
          format: 'Closest Guess',
          slotsFilled: 3,
          slotsTotal: 20,
          entryPoints: 80,
          prizePool: 0,
          state: ArenaChallengeState.canceled,
        ),
      ],
      rewardHistory: ArenaRewardHistory(
        totalReceipts: 12,
        averageReceiveRate: 142,
        largestReceipt: 2400,
        distribution: [
          ArenaRewardDistribution(label: 'Top 3', wins: 4, total: 8),
          ArenaRewardDistribution(label: 'Winner Takes All', wins: 2, total: 6),
          ArenaRewardDistribution(label: 'Chia đều', wins: 3, total: 5),
          ArenaRewardDistribution(label: 'Tỷ lệ theo điểm', wins: 1, total: 2),
          ArenaRewardDistribution(label: 'Top 5', wins: 2, total: 2),
        ],
      ),
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  Future<MyArenaSnapshot> getArenaMy() async {
    // Bẫy 18 (GD4 Playbook mục 9): getMyArena() đã tự _simulateNetwork() —
    // không lặp lại delay/error ở lớp ngoài.
    final snapshot = await getMyArena();
    return snapshot.copyWith(endpoint: '/api/mobile/arena/arena-my');
  }
}
