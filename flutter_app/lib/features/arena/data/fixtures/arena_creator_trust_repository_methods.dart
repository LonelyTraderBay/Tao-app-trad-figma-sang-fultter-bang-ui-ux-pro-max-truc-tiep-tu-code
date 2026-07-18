part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryCreatorTrustMethods on _MockArenaRepositoryBase {
  @override
  Future<ArenaBlockedUsersSnapshot> getArenaBlockedUsers() async {
    await _simulateNetwork();
    return const ArenaBlockedUsersSnapshot(
      endpoint: '/api/mobile/arena/arena-blocked',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      bannerTitle: 'Về tính năng chặn',
      bannerDescription:
          'Người bị chặn sẽ không thể thấy hoặc tương tác với bạn trong Open Arena. Bạn có thể bỏ chặn bất cứ lúc nào.',
      users: [
        ArenaBlockedUserDraft(
          id: 'blk001',
          name: 'SpamBot_X',
          reason: 'Spam tin nhắn quảng cáo trong chat',
          blockedAt: '2026-02-26',
          source: ArenaBlockedUserSource.manual,
        ),
        ArenaBlockedUserDraft(
          id: 'blk002',
          name: 'ToxicTrader',
          reason: 'Ngôn ngữ xúc phạm nghiêm trọng',
          blockedAt: '2026-02-15',
          source: ArenaBlockedUserSource.reportOutcome,
        ),
      ],
      emptyTitle: 'Chưa chặn ai',
      emptySubtitle:
          'Bạn chưa chặn người dùng nào trong Open Arena. Khi chặn, họ sẽ xuất hiện ở đây.',
      disclaimer:
          'Danh sách chặn chỉ áp dụng trong Open Arena. Đây là bề mặt điểm xã hội, không phải ví giao dịch hoặc PnL.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  Future<ArenaTrustBreakdownSnapshot> getArenaTrustBreakdown(
    String entityId,
  ) async {
    if (entityId != 'cr001') {
      await _simulateNetwork();
      return ArenaTrustBreakdownSnapshot(
        endpoint: '/api/mobile/arena/arena-trust-$entityId',
        actionDraft:
            'POST /arena/challenges|join|resolve|report where applicable',
        entityId: entityId,
        creator: null,
        metrics: const [],
        emptyTitle: 'Không tìm thấy',
        emptySubtitle: 'Creator không tồn tại',
        safetyTitle: 'Trust Score giúp bạn đánh giá',
        safetyDescription:
            'Kiểm tra trust score trước khi tham gia challenge giúp đảm bảo trải nghiệm an toàn.',
        disclaimer:
            'Trust Score chỉ là chỉ báo cộng đồng trong Open Arena, không phải PnL hoặc giá trị ví.',
        supportedStates: const {
          ArenaScreenState.loading,
          ArenaScreenState.empty,
          ArenaScreenState.error,
          ArenaScreenState.offline,
        },
      );
    }

    // Bẫy 18 (GD4 Playbook mục 9): getArenaCreator() đã tự
    // _simulateNetwork() — không lặp lại delay/error ở lớp ngoài.
    final profile = await getArenaCreator(entityId);
    return ArenaTrustBreakdownSnapshot(
      endpoint: '/api/mobile/arena/arena-trust-$entityId',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      entityId: entityId,
      creator: profile.creator,
      metrics: profile.trustMetrics,
      emptyTitle: 'Không tìm thấy',
      emptySubtitle: 'Creator không tồn tại',
      safetyTitle: 'Trust Score giúp bạn đánh giá',
      safetyDescription:
          'Kiểm tra trust score trước khi tham gia challenge giúp đảm bảo trải nghiệm an toàn.',
      disclaimer:
          'Trust Score chỉ là chỉ báo cộng đồng trong Open Arena, không phải PnL hoặc giá trị ví.',
      supportedStates: const {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  Future<ArenaCreatorProfileSnapshot> getArenaCreator(String creatorId) async {
    await _simulateNetwork();
    return const ArenaCreatorProfileSnapshot(
      endpoint: '/api/mobile/arena/arena-creator-cr001',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      creator: ArenaCreatorProfileDraft(
        id: 'cr001',
        name: 'CryptoMaster_VN',
        badge: 'Gold',
        level: 5,
        modesCreated: 12,
        completedRooms: 78,
        totalClones: 345,
        trustScore: 95,
        fairPlayBadge: true,
        bio:
            'Creator chuyên xây mode dự đoán crypto theo tuần, ưu tiên luật rõ ràng và pool điểm minh bạch.',
      ),
      trustMetrics: [
        ArenaCreatorTrustMetricDraft(
          label: 'Fair Play',
          value: '95%',
          kind: ArenaCreatorTrustMetricKind.fairPlay,
        ),
        ArenaCreatorTrustMetricDraft(
          label: 'Tỷ lệ tranh chấp',
          value: '2.0%',
          kind: ArenaCreatorTrustMetricKind.disputeRate,
        ),
        ArenaCreatorTrustMetricDraft(
          label: 'Hoàn thành',
          value: '96%',
          kind: ArenaCreatorTrustMetricKind.completion,
        ),
        ArenaCreatorTrustMetricDraft(
          label: 'Đánh giá CĐ',
          value: '4.8/5',
          kind: ArenaCreatorTrustMetricKind.communityRating,
        ),
      ],
      modes: [
        ArenaModeDraft(
          id: 'mode001',
          title: 'BTC Weekly Predict',
          creatorName: 'CryptoMaster_VN',
          cloneCount: 234,
          activeChallenges: 18,
          fairPlay: true,
          completionRate: 92,
          tags: ['Crypto', 'Weekly'],
          templateId: 'closest_guess',
        ),
      ],
      liveRooms: [],
      historyRooms: [],
      aboutRows: [
        ArenaRuleSummaryRow(label: 'Followers', value: '12.4K'),
        ArenaRuleSummaryRow(label: 'Tổng challenges', value: '89'),
        ArenaRuleSummaryRow(label: 'Tham gia từ', value: '2024'),
        ArenaRuleSummaryRow(label: 'Community Trust', value: '95%'),
      ],
      policyLabel: 'Chính sách creator',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  Future<ArenaLeaderboardSnapshot> getArenaLeaderboard() async {
    await _simulateNetwork();
    return const ArenaLeaderboardSnapshot(
      endpoint: '/api/mobile/arena/arena-leaderboard',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      myRank: ArenaLeaderboardMyRankDraft(
        rank: 142,
        pointsLabel: '4.5K pts',
        summary: '7 wins · 23 challenges',
      ),
      metricChips: [
        ArenaLeaderboardFilterDraft(
          id: 'fair_play',
          label: 'Fair Play',
          icon: ArenaLeaderboardIconKind.shield,
        ),
        ArenaLeaderboardFilterDraft(
          id: 'popularity',
          label: 'Popularity',
          icon: ArenaLeaderboardIconKind.trending,
        ),
        ArenaLeaderboardFilterDraft(
          id: 'win_rate',
          label: 'Win Rate',
          icon: ArenaLeaderboardIconKind.winRate,
        ),
        ArenaLeaderboardFilterDraft(
          id: 'activity',
          label: 'Activity',
          icon: ArenaLeaderboardIconKind.activity,
        ),
        ArenaLeaderboardFilterDraft(
          id: 'completion',
          label: 'Completion',
          icon: ArenaLeaderboardIconKind.completion,
        ),
      ],
      seasonFilters: [
        ArenaLeaderboardFilterDraft(
          id: 'today',
          label: 'Hôm nay',
          icon: ArenaLeaderboardIconKind.activity,
        ),
        ArenaLeaderboardFilterDraft(
          id: 'weekly',
          label: 'Tuần',
          icon: ArenaLeaderboardIconKind.activity,
        ),
        ArenaLeaderboardFilterDraft(
          id: 'monthly',
          label: 'Tháng',
          icon: ArenaLeaderboardIconKind.activity,
        ),
        ArenaLeaderboardFilterDraft(
          id: 'season',
          label: 'Mùa',
          icon: ArenaLeaderboardIconKind.activity,
        ),
      ],
      podium: [
        ArenaLeaderboardEntryDraft(
          rank: 1,
          name: 'CryptoMaster_VN',
          value: '95%',
          subtitle: '',
          icon: ArenaLeaderboardIconKind.player,
          creatorId: 'cr001',
          fairPlay: true,
        ),
        ArenaLeaderboardEntryDraft(
          rank: 2,
          name: 'QuizWizard',
          value: '91%',
          subtitle: '',
          icon: ArenaLeaderboardIconKind.magic,
          creatorId: 'cr005',
          fairPlay: true,
        ),
        ArenaLeaderboardEntryDraft(
          rank: 3,
          name: 'ArenaKing',
          value: '88%',
          subtitle: '',
          icon: ArenaLeaderboardIconKind.crown,
          creatorId: 'cr002',
          fairPlay: true,
        ),
      ],
      topCreators: [
        ArenaLeaderboardEntryDraft(
          rank: 4,
          name: 'PredictorPro',
          value: '84%',
          subtitle: 'Fair Play',
          icon: ArenaLeaderboardIconKind.target,
          creatorId: 'cr003',
          fairPlay: true,
        ),
        ArenaLeaderboardEntryDraft(
          rank: 5,
          name: 'GameMaker_HN',
          value: '82%',
          subtitle: '',
          icon: ArenaLeaderboardIconKind.game,
          creatorId: 'cr004',
        ),
      ],
      risingCreators: [
        ArenaLeaderboardEntryDraft(
          rank: 1,
          name: 'GameMaker_HN',
          value: 'Rising',
          subtitle: '6 modes · 4 rooms/tháng',
          icon: ArenaLeaderboardIconKind.game,
          creatorId: 'cr004',
          rising: true,
        ),
        ArenaLeaderboardEntryDraft(
          rank: 2,
          name: 'PredictorPro',
          value: 'Rising',
          subtitle: '15 modes · 7 rooms/tháng',
          icon: ArenaLeaderboardIconKind.target,
          creatorId: 'cr003',
          rising: true,
        ),
      ],
      disclaimer:
          'Bảng xếp hạng dựa trên chất lượng, sự công bằng và độ tin cậy — không nhấn mạnh số tiền. Arena Points không phải tài sản tài chính.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  Future<VerifiedChallengesSnapshot> getVerifiedChallenges() async {
    await _simulateNetwork();
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
          label: 'Challenge được verify bởi hệ thống Oracle',
          kind: VerifiedChallengeFeatureKind.oracle,
        ),
        VerifiedChallengeFeatureDraft(
          label: 'Points pool policy with release review gate',
          kind: VerifiedChallengeFeatureKind.escrow,
        ),
        VerifiedChallengeFeatureDraft(
          label: 'Leaderboard riêng cho verified players',
          kind: VerifiedChallengeFeatureKind.leaderboard,
        ),
        VerifiedChallengeFeatureDraft(
          label: 'Creator badges và trust score nâng cao',
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
}
