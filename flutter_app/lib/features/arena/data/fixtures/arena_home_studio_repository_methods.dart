part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryHomeStudioMethods on _MockArenaRepositoryBase {
  @override
  Future<ArenaHomeSnapshot> getArenaHome() async {
    await _simulateNetwork();
    return const ArenaHomeSnapshot(
      endpoint: '/api/mobile/arena/arena',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      templates: [
        ArenaTemplateDraft(
          id: 'prediction',
          kind: ArenaTemplateKind.prediction,
          title: 'Prediction',
          description: 'Dự đoán kết quả sự kiện, giá coin, hay bất kỳ điều gì',
          tags: ['Binary', 'Multi-choice'],
        ),
        ArenaTemplateDraft(
          id: 'closest_guess',
          kind: ArenaTemplateKind.closestGuess,
          title: 'Closest Guess',
          description: 'Đoán số gần nhất với kết quả thực tế sẽ thắng',
          tags: ['Numeric', 'Range'],
        ),
        ArenaTemplateDraft(
          id: 'team_battle',
          kind: ArenaTemplateKind.teamBattle,
          title: 'Team Battle',
          description: 'Chia đội và thi đấu theo nhóm, cộng điểm team',
          tags: ['2-Team', 'Multi-team'],
        ),
        ArenaTemplateDraft(
          id: 'bracket',
          kind: ArenaTemplateKind.bracket,
          title: 'Bracket',
          description: 'Giải đấu theo nhánh loại trực tiếp',
          tags: ['Single elim', 'Double elim'],
        ),
        ArenaTemplateDraft(
          id: 'community_vote',
          kind: ArenaTemplateKind.vote,
          title: 'Community Vote',
          description: 'Bình chọn cộng đồng, kết quả do đa số quyết định',
          tags: ['Poll', 'Ranked'],
        ),
        ArenaTemplateDraft(
          id: 'proof_challenge',
          kind: ArenaTemplateKind.proof,
          title: 'Proof Challenge',
          description: 'Hoàn thành thử thách với chứng cứ để xác nhận',
          tags: ['Photo', 'Screenshot'],
        ),
      ],
      featuredModes: [
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
        ArenaModeDraft(
          id: 'mode002',
          title: 'Altcoin Battle Royale',
          creatorName: 'ArenaKing',
          cloneCount: 156,
          activeChallenges: 9,
          fairPlay: true,
          completionRate: 87,
          tags: ['Crypto', 'Team'],
          templateId: 'team_battle',
        ),
        ArenaModeDraft(
          id: 'mode003',
          title: 'Community Macro Vote',
          creatorName: 'PredictorPro',
          cloneCount: 95,
          activeChallenges: 7,
          fairPlay: true,
          completionRate: 88,
          tags: ['Poll', 'Macro'],
          templateId: 'community_vote',
        ),
      ],
      liveRooms: [
        ArenaChallengeDraft(
          id: 'ch001',
          title: 'BTC \$70K? — Tuần 9',
          format: 'Closest Guess',
          slotsFilled: 38,
          slotsTotal: 50,
          entryPoints: 100,
          prizePool: 3800,
          state: ArenaChallengeState.open,
        ),
        ArenaChallengeDraft(
          id: 'ch003',
          title: 'Altcoin Battle — SOL vs AVAX vs MATIC',
          format: 'Team Battle',
          slotsFilled: 40,
          slotsTotal: 40,
          entryPoints: 200,
          prizePool: 7200,
          state: ArenaChallengeState.live,
        ),
        ArenaChallengeDraft(
          id: 'ch004',
          title: 'Fed Rate Predict — March 2026',
          format: 'Prediction',
          slotsFilled: 67,
          slotsTotal: 100,
          entryPoints: 50,
          prizePool: 3350,
          state: ArenaChallengeState.open,
        ),
        ArenaChallengeDraft(
          id: 'ch005',
          title: 'Crypto Quiz Night #12',
          format: 'Bracket',
          slotsFilled: 12,
          slotsTotal: 16,
          entryPoints: 150,
          prizePool: 2400,
          state: ArenaChallengeState.open,
        ),
        ArenaChallengeDraft(
          id: 'ch006',
          title: 'Coin thắng 3 — Community Vote',
          format: 'Community Vote',
          slotsFilled: 145,
          slotsTotal: 200,
          entryPoints: 30,
          prizePool: 4350,
          state: ArenaChallengeState.live,
        ),
      ],
      creators: [
        ArenaCreatorDraft(
          id: 'cr001',
          name: 'CryptoMaster_VN',
          modesCreated: 12,
          totalChallenges: 89,
          trustScore: 95,
          fairPlay: true,
        ),
        ArenaCreatorDraft(
          id: 'cr002',
          name: 'ArenaKing',
          modesCreated: 8,
          totalChallenges: 54,
          trustScore: 91,
          fairPlay: true,
        ),
        ArenaCreatorDraft(
          id: 'cr003',
          name: 'PredictorPro',
          modesCreated: 15,
          totalChallenges: 127,
          trustScore: 88,
          fairPlay: true,
        ),
      ],
      trustSignals: [
        ArenaTrustSignalDraft(label: 'Fair Play', value: 'active'),
        ArenaTrustSignalDraft(label: 'Points only', value: 'no wallet value'),
        ArenaTrustSignalDraft(label: 'Reports', value: 'moderated'),
      ],
      pendingNotifications: 3,
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  Future<ArenaStudioSnapshot> getArenaStudio() async {
    await _simulateNetwork();
    return const ArenaStudioSnapshot(
      endpoint: '/api/mobile/arena/arena-studio',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      platformFeePct: 10,
      steps: [
        ArenaStudioStepDraft(index: 1, label: 'Template'),
        ArenaStudioStepDraft(index: 2, label: 'Cấu trúc'),
        ArenaStudioStepDraft(index: 3, label: 'Luật chơi'),
        ArenaStudioStepDraft(index: 4, label: 'Kết quả'),
        ArenaStudioStepDraft(index: 5, label: 'Points'),
        ArenaStudioStepDraft(index: 6, label: 'Review'),
      ],
      templates: [
        ArenaStudioTemplateDraft(
          id: 'prediction',
          kind: ArenaTemplateKind.prediction,
          title: 'Prediction',
          description: 'Dự đoán kết quả sự kiện, giá coin, hay bất kỳ điều gì',
          formatTags: ['Binary', 'Multi-choice'],
          complexity: 'Trung bình',
        ),
        ArenaStudioTemplateDraft(
          id: 'closest_guess',
          kind: ArenaTemplateKind.closestGuess,
          title: 'Closest Guess',
          description: 'Đoán số gần nhất với kết quả thực tế sẽ thắng',
          formatTags: ['Numeric', 'Range'],
          complexity: 'Dễ',
        ),
        ArenaStudioTemplateDraft(
          id: 'team_battle',
          kind: ArenaTemplateKind.teamBattle,
          title: 'Team Battle',
          description: 'Chia đội và thi đấu theo nhóm, cộng điểm team',
          formatTags: ['2-Team', 'Multi-team'],
          complexity: 'Trung bình',
        ),
        ArenaStudioTemplateDraft(
          id: 'bracket',
          kind: ArenaTemplateKind.bracket,
          title: 'Bracket',
          description: 'Giải đấu theo nhánh loại trực tiếp',
          formatTags: ['Single elim', 'Double elim'],
          complexity: 'Nâng cao',
          verifiedOnly: true,
        ),
        ArenaStudioTemplateDraft(
          id: 'community_vote',
          kind: ArenaTemplateKind.vote,
          title: 'Community Vote',
          description: 'Bình chọn cộng đồng, kết quả do đa số quyết định',
          formatTags: ['Poll', 'Ranked'],
          complexity: 'Dễ',
        ),
        ArenaStudioTemplateDraft(
          id: 'proof_challenge',
          kind: ArenaTemplateKind.proof,
          title: 'Proof Challenge',
          description: 'Hoàn thành thử thách và gửi bằng chứng để xác nhận',
          formatTags: ['Photo', 'Video', 'Screenshot'],
          complexity: 'Trung bình',
        ),
      ],
      secondaryActions: ['Lưu', 'Xuất', 'Nhập'],
      trustSignals: [
        ArenaTrustSignalDraft(label: 'Scope', value: 'Arena Points only'),
        ArenaTrustSignalDraft(label: 'Fee', value: '10% tổng pool'),
        ArenaTrustSignalDraft(label: 'Boundary', value: 'no wallet value'),
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
