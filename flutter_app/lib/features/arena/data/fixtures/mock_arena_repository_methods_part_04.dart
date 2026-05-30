part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryMethodsPart04 on _MockArenaRepositoryBase {
  @override
  VerifiedChallengesSnapshot getVerifiedChallenges() {
    return const VerifiedChallengesSnapshot(
      endpoint: '/api/mobile/arena/arena-verified',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      title: 'Verified Challenges',
      subtitle:
          'Release-gated local preview for higher-trust Arena challenges. Compliance review and KYC gate are still required before user availability.',
      statusLabel: 'Release-gated Preview',
      infoTitle: 'Preview scope',
      features: [
        VerifiedChallengeFeatureDraft(
          label:
              'Challenge Ã„â€˜Ã†Â°Ã¡Â»Â£c verify bÃ¡Â»Å¸i hÃ¡Â»â€¡ thÃ¡Â»â€˜ng Oracle',
          kind: VerifiedChallengeFeatureKind.oracle,
        ),
        VerifiedChallengeFeatureDraft(
          label: 'Points pool policy with release review gate',
          kind: VerifiedChallengeFeatureKind.escrow,
        ),
        VerifiedChallengeFeatureDraft(
          label: 'Leaderboard riÃƒÂªng cho verified players',
          kind: VerifiedChallengeFeatureKind.leaderboard,
        ),
        VerifiedChallengeFeatureDraft(
          label: 'Creator badges vÃƒÂ  trust score nÃƒÂ¢ng cao',
          kind: VerifiedChallengeFeatureKind.trust,
        ),
      ],
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaPointsSnapshot getArenaPoints() {
    return const ArenaPointsSnapshot(
      endpoint: '/api/mobile/arena/arena-points',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      summary: ArenaPointsSummaryDraft(
        bonusPointsClaimed: '3,500',
        currentBalance: 2220,
        lockedBalance: 450,
        rank: 142,
        topPercent: 5,
        claimedCount: 5,
        pendingCount: 3,
        pendingBonusPoints: '550',
        pendingPoints: 130,
        expiringCount: 8,
        completionLabel: '5/24 Ã‚Â· 21%',
        tierLabel: 'BÃ¡ÂºÂ¡c',
      ),
      categories: [
        ArenaPointsCategoryDraft(
          id: 'daily',
          label: 'HÃ¡ÂºÂ±ng ngÃƒÂ y',
          done: 2,
          total: 5,
          pending: 2,
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaPointsCategoryDraft(
          id: 'weekly',
          label: 'HÃ¡ÂºÂ±ng tuÃ¡ÂºÂ§n',
          done: 0,
          total: 5,
          pending: 0,
          kind: ArenaRewardAccentKind.weekly,
        ),
        ArenaPointsCategoryDraft(
          id: 'flash',
          label: 'Flash',
          done: 0,
          total: 3,
          pending: 0,
          kind: ArenaRewardAccentKind.flash,
        ),
        ArenaPointsCategoryDraft(
          id: 'learn',
          label: 'HÃ¡Â»Âc',
          done: 1,
          total: 4,
          pending: 1,
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaPointsCategoryDraft(
          id: 'achievement',
          label: 'ThÃƒÂ nh tÃ¡Â»Â±u',
          done: 4,
          total: 4,
          pending: 0,
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaPointsCategoryDraft(
          id: 'arena',
          label: 'Arena',
          done: 1,
          total: 3,
          pending: 0,
          kind: ArenaRewardAccentKind.arena,
        ),
      ],
      checkIns: [
        ArenaDailyCheckInDraft(
          day: 1,
          label: 'N1',
          reward: '+10',
          claimed: true,
          today: false,
        ),
        ArenaDailyCheckInDraft(
          day: 2,
          label: 'N2',
          reward: '+15',
          claimed: true,
          today: false,
        ),
        ArenaDailyCheckInDraft(
          day: 3,
          label: 'N3',
          reward: '+20',
          claimed: true,
          today: false,
        ),
        ArenaDailyCheckInDraft(
          day: 4,
          label: 'N4',
          reward: '+25',
          claimed: true,
          today: false,
        ),
        ArenaDailyCheckInDraft(
          day: 5,
          label: 'HÃƒÂ´m nay',
          reward: '+30',
          claimed: false,
          today: true,
        ),
        ArenaDailyCheckInDraft(
          day: 6,
          label: 'N6',
          reward: '+40',
          claimed: false,
          today: false,
        ),
        ArenaDailyCheckInDraft(
          day: 7,
          label: 'N7',
          reward: '+100',
          claimed: false,
          today: false,
        ),
      ],
      filters: [
        'TÃ¡ÂºÂ¥t cÃ¡ÂºÂ£',
        'Flash',
        'HÃ¡Â»Âc',
        'HÃ¡ÂºÂ±ng ngÃƒÂ y',
        'P2P',
        'Arena',
      ],
      tasks: [
        ArenaRewardTaskDraft(
          id: 'task-volume',
          title: 'Volume tuÃ¡ÂºÂ§n \$10K',
          subtitle:
              'Ã„ÂÃ¡ÂºÂ¡t khÃ¡Â»â€˜i lÃ†Â°Ã¡Â»Â£ng giao dÃ¡Â»â€¹ch \$10,000 trong tuÃ¡ÂºÂ§n',
          filter: 'HÃ¡ÂºÂ±ng ngÃƒÂ y',
          status: ArenaRewardTaskStatus.active,
          progress: .58,
          rewardLabel: '+120 Arena Points',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-limit',
          title: 'Giao dÃ¡Â»â€¹ch 10 cÃ¡ÂºÂ·p khÃƒÂ¡c nhau',
          subtitle:
              'Giao dÃ¡Â»â€¹ch ÃƒÂ­t nhÃ¡ÂºÂ¥t 10 cÃ¡ÂºÂ·p coin khÃƒÂ¡c nhau',
          filter: 'HÃ¡ÂºÂ±ng ngÃƒÂ y',
          status: ArenaRewardTaskStatus.active,
          progress: .68,
          rewardLabel: '+140 Arena Points',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-referral',
          title: 'MÃ¡Â»Âi bÃ¡ÂºÂ¡n bÃƒÂ¨',
          subtitle:
              'MÃ¡Â»Âi 3 bÃ¡ÂºÂ¡n bÃƒÂ¨ Ã„â€˜Ã„Æ’ng kÃƒÂ½ VitTrade tuÃ¡ÂºÂ§n nÃƒÂ y',
          filter: 'TÃ¡ÂºÂ¥t cÃ¡ÂºÂ£',
          status: ArenaRewardTaskStatus.active,
          progress: .33,
          rewardLabel: '+260 Arena Points',
          kind: ArenaRewardAccentKind.referral,
        ),
        ArenaRewardTaskDraft(
          id: 'task-streak',
          title: 'Streak 7 ngÃƒÂ y',
          subtitle:
              'Ã„ÂÃ„Æ’ng nhÃ¡ÂºÂ­p 7 ngÃƒÂ y liÃƒÂªn tiÃ¡ÂºÂ¿p Ã„â€˜Ã¡Â»Æ’ nhÃ¡ÂºÂ­n bonus',
          filter: 'HÃ¡ÂºÂ±ng ngÃƒÂ y',
          status: ArenaRewardTaskStatus.active,
          progress: .71,
          rewardLabel: '+180 Arena Points',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-spot',
          title: 'Giao dÃ¡Â»â€¹ch 5 lÃ¡Â»â€¡nh Spot',
          subtitle:
              'HoÃƒÂ n thÃƒÂ nh 5 lÃ¡Â»â€¡nh giao dÃ¡Â»â€¹ch Spot trong ngÃƒÂ y',
          filter: 'HÃ¡ÂºÂ±ng ngÃƒÂ y',
          status: ArenaRewardTaskStatus.active,
          progress: .40,
          rewardLabel: '+70 Arena Points',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-flash-muc',
          title: 'Flash: Mua BTC hÃƒÂ´m nay',
          subtitle:
              'Mua tÃ¡Â»â€˜i thiÃ¡Â»Æ’u 0.01 BTC trong 4 giÃ¡Â»Â tÃ¡Â»â€ºi',
          filter: 'Flash',
          status: ArenaRewardTaskStatus.active,
          progress: .0,
          rewardLabel: '+150 Arena Points',
          kind: ArenaRewardAccentKind.flash,
        ),
        ArenaRewardTaskDraft(
          id: 'task-flash-p2p',
          title: 'Flash 3 lÃ¡Â»â€¡nh P2P liÃƒÂªn tiÃ¡ÂºÂ¿p',
          subtitle: 'HoÃƒÂ n thÃƒÂ nh 3 lÃ¡Â»â€¡nh P2P trong 6 giÃ¡Â»Â',
          filter: 'Flash',
          status: ArenaRewardTaskStatus.active,
          progress: .33,
          rewardLabel: '+320 Arena Points',
          kind: ArenaRewardAccentKind.flash,
        ),
        ArenaRewardTaskDraft(
          id: 'task-flash-volume',
          title: 'Flash: Volume 50K nhanh',
          subtitle: 'Ã„ÂÃ¡ÂºÂ¡t \$50,000 volume trong 8 giÃ¡Â»Â tÃ¡Â»â€ºi',
          filter: 'Flash',
          status: ArenaRewardTaskStatus.active,
          progress: .82,
          rewardLabel: '+240 Arena Points',
          kind: ArenaRewardAccentKind.flash,
        ),
        ArenaRewardTaskDraft(
          id: 'task-checkin',
          title: 'Ã„ÂÃ„Æ’ng nhÃ¡ÂºÂ­p hÃ¡ÂºÂ±ng ngÃƒÂ y',
          subtitle:
              'Ã„ÂÃ„Æ’ng nhÃ¡ÂºÂ­p mÃ¡Â»â€”i ngÃƒÂ y Ã„â€˜Ã¡Â»Æ’ nhÃ¡ÂºÂ­n thÃ†Â°Ã¡Â»Å¸ng Ã„â€˜Ã¡Â»Âu',
          filter: 'HÃ¡ÂºÂ±ng ngÃƒÂ y',
          status: ArenaRewardTaskStatus.completed,
          progress: 1,
          rewardLabel: '+40 Arena Points',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-p2p',
          title: 'Giao dÃ¡Â»â€¹ch P2P',
          subtitle: 'HoÃƒÂ n thÃƒÂ nh 1 giao dÃ¡Â»â€¹ch P2P trong ngÃƒÂ y',
          filter: 'P2P',
          status: ArenaRewardTaskStatus.completed,
          progress: 1,
          rewardLabel: '+60 Arena Points',
          kind: ArenaRewardAccentKind.p2p,
        ),
        ArenaRewardTaskDraft(
          id: 'task-quiz',
          title: 'Quiz: Blockchain cÃ†Â¡ bÃ¡ÂºÂ£n',
          subtitle:
              'TrÃ¡ÂºÂ£ lÃ¡Â»Âi Ã„â€˜ÃƒÂºng 5 cÃƒÂ¢u hÃ¡Â»Âi vÃ¡Â»Â blockchain',
          filter: 'HÃ¡Â»Âc',
          status: ArenaRewardTaskStatus.completed,
          progress: 1,
          rewardLabel: '+80 Arena Points',
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaRewardTaskDraft(
          id: 'task-trust',
          title: 'HoÃƒÂ n tÃ¡ÂºÂ¥t trust checklist',
          subtitle:
              'BÃ¡ÂºÂ­t cÃƒÂ¡c bÃ†Â°Ã¡Â»â€ºc an toÃƒÂ n cÃ¡Â»â„¢ng Ã„â€˜Ã¡Â»â€œng trong Open Arena',
          filter: 'Arena',
          status: ArenaRewardTaskStatus.active,
          progress: .75,
          rewardLabel: '+220 Arena Points',
          kind: ArenaRewardAccentKind.neutral,
        ),
        ArenaRewardTaskDraft(
          id: 'task-mode',
          title: 'TÃ¡ÂºÂ¡o mode mÃ¡Â»â€ºi',
          subtitle:
              'TÃ¡ÂºÂ¡o 1 mode mÃ¡Â»â€ºi vÃƒÂ  cÃƒÂ³ ÃƒÂ­t nhÃ¡ÂºÂ¥t 4 ngÃ†Â°Ã¡Â»Âi clone',
          filter: 'Arena',
          status: ArenaRewardTaskStatus.active,
          progress: .40,
          rewardLabel: '+200 pts',
          kind: ArenaRewardAccentKind.arena,
        ),
        ArenaRewardTaskDraft(
          id: 'task-thang3',
          title: 'ThÃ¡ÂºÂ¯ng 3 challenge',
          subtitle: 'ThÃ¡ÂºÂ¯ng 3 challenge bÃ¡ÂºÂ¥t kÃ¡Â»Â³',
          filter: 'Arena',
          status: ArenaRewardTaskStatus.active,
          progress: .67,
          rewardLabel: '+300 pts',
          kind: ArenaRewardAccentKind.arena,
        ),
        ArenaRewardTaskDraft(
          id: 'task-defi',
          title: 'BÃƒÂ i hÃ¡Â»Âc DeFi lÃƒÂ  gÃƒÂ¬?',
          subtitle: 'Xem video 3 phÃƒÂºt vÃƒÂ  trÃ¡ÂºÂ£ lÃ¡Â»Âi quiz',
          filter: 'HÃ¡Â»Âc',
          status: ArenaRewardTaskStatus.active,
          progress: .50,
          rewardLabel: '+90 Arena Points',
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaRewardTaskDraft(
          id: 'task-an-toan',
          title: 'Quiz: An toÃƒÂ n P2P',
          subtitle: 'HoÃƒÂ n thÃƒÂ nh bÃƒÂ i kiÃ¡Â»Æ’m tra an toÃƒÂ n P2P',
          filter: 'HÃ¡Â»Âc',
          status: ArenaRewardTaskStatus.active,
          progress: .60,
          rewardLabel: '+90 Arena Points',
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaRewardTaskDraft(
          id: 'task-risk',
          title: 'BÃƒÂ i hÃ¡Â»Âc: Staking & Yield',
          subtitle:
              'TÃƒÂ¬m hiÃ¡Â»Æ’u cÃƒÂ¡ch Ã„â€˜ÃƒÂ¡nh giÃƒÂ¡ rÃ¡Â»Â§i ro staking',
          filter: 'HÃ¡Â»Âc',
          status: ArenaRewardTaskStatus.active,
          progress: .50,
          rewardLabel: '+90 Arena Points',
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaRewardTaskDraft(
          id: 'task-share',
          title: 'Chia sÃ¡ÂºÂ» kÃ¡ÂºÂ¿t quÃ¡ÂºÂ£ giao dÃ¡Â»â€¹ch',
          subtitle:
              'Share 1 kÃ¡ÂºÂ¿t quÃ¡ÂºÂ£ giao dÃ¡Â»â€¹ch lÃƒÂªn mÃ¡ÂºÂ¡ng xÃƒÂ£ hÃ¡Â»â„¢i',
          filter: 'TÃ¡ÂºÂ¥t cÃ¡ÂºÂ£',
          status: ArenaRewardTaskStatus.active,
          progress: .67,
          rewardLabel: '+70 Arena Points',
          kind: ArenaRewardAccentKind.neutral,
        ),
        ArenaRewardTaskDraft(
          id: 'task-danh-gia',
          title: 'Ã„ÂÃƒÂ¡nh giÃƒÂ¡ ngÃ†Â°Ã¡Â»Âi bÃƒÂ¡n P2P',
          subtitle:
              'Ã„ÂÃ¡Â»Æ’ lÃ¡ÂºÂ¡i Ã„â€˜ÃƒÂ¡nh giÃƒÂ¡ cho 3 ngÃ†Â°Ã¡Â»Âi bÃƒÂ¡n P2P',
          filter: 'P2P',
          status: ArenaRewardTaskStatus.active,
          progress: .67,
          rewardLabel: '+80 Arena Points',
          kind: ArenaRewardAccentKind.p2p,
        ),
        ArenaRewardTaskDraft(
          id: 'task-first',
          title: 'Giao dÃ¡Â»â€¹ch Ã„â€˜Ã¡ÂºÂ§u tiÃƒÂªn',
          subtitle:
              'ThÃ¡Â»Â±c hiÃ¡Â»â€¡n giao dÃ¡Â»â€¹ch Ã„â€˜Ã¡ÂºÂ§u tiÃƒÂªn trÃƒÂªn VitTrade',
          filter: 'TÃ¡ÂºÂ¥t cÃ¡ÂºÂ£',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Ã„ÂÃƒÂ£ nhÃ¡ÂºÂ­n',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaRewardTaskDraft(
          id: 'task-deposit',
          title: 'NÃ¡ÂºÂ¡p tiÃ¡Â»Ân lÃ¡ÂºÂ§n Ã„â€˜Ã¡ÂºÂ§u',
          subtitle:
              'NÃ¡ÂºÂ¡p tÃ¡Â»â€˜i thiÃ¡Â»Æ’u \$100 lÃ¡ÂºÂ§n Ã„â€˜Ã¡ÂºÂ§u tiÃƒÂªn',
          filter: 'TÃ¡ÂºÂ¥t cÃ¡ÂºÂ£',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Ã„ÂÃƒÂ£ nhÃ¡ÂºÂ­n',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaRewardTaskDraft(
          id: 'task-2fa',
          title: 'BÃ¡ÂºÂ­t 2FA',
          subtitle:
              'KÃƒÂ­ch hoÃ¡ÂºÂ¡t xÃƒÂ¡c thÃ¡Â»Â±c 2 lÃ¡Â»â€ºp cho tÃƒÂ i khoÃ¡ÂºÂ£n',
          filter: 'TÃ¡ÂºÂ¥t cÃ¡ÂºÂ£',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Ã„ÂÃƒÂ£ nhÃ¡ÂºÂ­n',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaRewardTaskDraft(
          id: 'task-kyc',
          title: 'KYC Level 2',
          subtitle: 'HoÃƒÂ n tÃ¡ÂºÂ¥t xÃƒÂ¡c minh danh tÃƒÂ­nh cÃ¡ÂºÂ¥p 2',
          filter: 'TÃ¡ÂºÂ¥t cÃ¡ÂºÂ£',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Ã„ÂÃƒÂ£ nhÃ¡ÂºÂ­n',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaRewardTaskDraft(
          id: 'task-join',
          title: 'Tham gia challenge',
          subtitle: 'Tham gia ÃƒÂ­t nhÃ¡ÂºÂ¥t 1 challenge trong tuÃ¡ÂºÂ§n',
          filter: 'Arena',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Ã„ÂÃƒÂ£ nhÃ¡ÂºÂ­n',
          kind: ArenaRewardAccentKind.arena,
        ),
      ],
      bonusRows: [
        ArenaBonusRowDraft(
          title: 'VÃƒÂ²ng quay may mÃ¡ÂºÂ¯n',
          subtitle: '1 lÃ†Â°Ã¡Â»Â£t quay miÃ¡Â»â€¦n phÃƒÂ­ hÃƒÂ´m nay',
          rewardLabel: '1 lÃ†Â°Ã¡Â»Â£t',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaBonusRowDraft(
          title: 'Mystery Box',
          subtitle:
              'MÃ¡Â»Å¸ hÃ¡Â»â„¢p khi hoÃƒÂ n thÃƒÂ nh 5 nhiÃ¡Â»â€¡m vÃ¡Â»Â¥',
          rewardLabel: 'CÃƒÂ³ thÃ¡Â»Æ’ mÃ¡Â»Å¸',
          kind: ArenaRewardAccentKind.flash,
        ),
        ArenaBonusRowDraft(
          title: 'Combo multiplier',
          subtitle:
              'HoÃƒÂ n thÃƒÂ nh nhiÃ¡Â»â€¡m vÃ¡Â»Â¥ liÃƒÂªn tiÃ¡ÂºÂ¿p Ã„â€˜Ã¡Â»Æ’ tÃ„Æ’ng thÃ†Â°Ã¡Â»Å¸ng',
          rewardLabel: 'x1.5',
          kind: ArenaRewardAccentKind.arena,
        ),
      ],
      leaderboard: [
        ArenaPointsLeaderboardDraft(
          rank: 1,
          name: 'CryptoWhale',
          pointsLabel: '15.9K',
        ),
        ArenaPointsLeaderboardDraft(
          rank: 2,
          name: 'PredictorPro',
          pointsLabel: '15.1K',
        ),
        ArenaPointsLeaderboardDraft(
          rank: 3,
          name: 'ArenaKing',
          pointsLabel: '12.8K',
        ),
      ],
      disclaimer:
          'Arena Points stay inside Open Arena; not a trading account or prediction performance. No off-platform agreements.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
