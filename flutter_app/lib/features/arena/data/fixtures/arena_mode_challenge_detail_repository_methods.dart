part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryModeChallengeDetailMethods
    on _MockArenaRepositoryBase {
  @override
  Future<ArenaModeDetailSnapshot> getArenaModeDetail(String modeId) async {
    await _simulateNetwork();
    const mode = ArenaModeDetailDraft(
      id: 'mode001',
      title: 'BTC Weekly Predict',
      description: 'Dự đoán giá BTC cuối tuần. Gần nhất thắng pool.',
      tags: ['Crypto', 'Weekly', 'Popular'],
      cloneCount: 234,
      activeChallenges: 5,
      completionRate: 92,
      fairPlay: true,
      disputeRiskLevel: 'low',
      reportRate: .01,
      repeatUsage: 5,
    );

    return const ArenaModeDetailSnapshot(
      endpoint: '/api/mobile/arena/arena-mode-mode001',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      mode: mode,
      template: ArenaTemplateDetailDraft(
        id: 'closest_guess',
        kind: ArenaTemplateKind.closestGuess,
        title: 'Closest Guess',
        complexity: 'Dễ',
        formatTags: ['Numeric', 'Range'],
      ),
      creator: ArenaModeCreatorDetailDraft(
        id: 'cr001',
        name: 'CryptoMaster_VN',
        trustScore: 95,
        fairPlayBadge: true,
        badge: 'Gold',
      ),
      ruleRows: [
        ArenaRuleSummaryRow(label: 'Formats', value: 'Numeric, Range'),
        ArenaRuleSummaryRow(
          label: 'Điều kiện thắng',
          value: 'Người đoán gần nhất với giá BTC thực tế sẽ thắng.',
        ),
        ArenaRuleSummaryRow(label: 'Chốt kết quả', value: 'API CoinGecko'),
        ArenaRuleSummaryRow(label: 'Thời lượng TB', value: '1 tuần'),
        ArenaRuleSummaryRow(label: 'Rủi ro tranh chấp', value: 'Thấp'),
      ],
      qualityMetrics: [
        ArenaQualityMetricDraft(
          label: 'Hoàn thành',
          value: '92%',
          description: 'Hoàn thành',
          status: VitArenaMetricStatus.success,
        ),
        ArenaQualityMetricDraft(
          label: 'Fair Play',
          value: 'Đạt',
          description: 'Fair Play',
          status: VitArenaMetricStatus.success,
        ),
        ArenaQualityMetricDraft(
          label: 'Tỷ lệ báo cáo',
          value: '1%',
          description: 'Tỷ lệ báo cáo',
          status: VitArenaMetricStatus.success,
        ),
        ArenaQualityMetricDraft(
          label: 'Dùng lại',
          value: '5 lần/người',
          description: 'Dùng lại',
          status: VitArenaMetricStatus.info,
        ),
      ],
      relatedRooms: [
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
      relatedModes: [],
      predictionContext: ArenaPredictionContextDraft(
        eventId: 'pred-1',
        title: 'Bitcoin reaches \$150K before July 2026?',
        outcomeName: 'Yes',
        probability: 34,
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
  Future<ArenaChallengeDetailSnapshot> getArenaChallengeDetail(
    String challengeId,
  ) async {
    await _simulateNetwork();
    return const ArenaChallengeDetailSnapshot(
      endpoint: '/api/mobile/arena/arena-challenge-ch003',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      challenge: ArenaChallengeDetailDraft(
        id: 'ch003',
        title: 'Altcoin Team Battle — SOL vs AVAX',
        description:
            '2 đội chọn coin, coin tăng nhiều nhất trong tuần -> team đó thắng pool.',
        modeId: 'mode002',
        modeName: 'Altcoin Battle Royale',
        state: ArenaChallengeState.live,
        statusLabel: 'Đang diễn ra',
        layoutLabel: 'NvN',
        privacyLabel: 'Công khai',
        entryPoints: 200,
        prizePool: 7200,
        netPrizePool: 6264,
        teamWinnerPool: 6264,
        slotsFilled: 40,
        slotsTotal: 40,
        fillPercent: 100,
        countdownLabel: 'Đã hết giờ',
        winCondition: 'Coin tăng giá nhiều nhất trong 7 ngày -> team đó thắng.',
        resolutionMethod: 'API CoinGecko - so sánh % thay đổi 7 ngày',
        evidenceRequirement: 'Không cần - tự động từ API',
        voidRule:
            'Void nếu 1 trong 2 coin bị delist trong thời gian challenge.',
        refundPolicy:
            'Nếu void -> hoàn 100% entry points. Không hoàn sau khi challenge bắt đầu.',
        platformFeePercent: 10,
        creatorCutPercent: 3,
        clarityScore: 80,
        trustRiskLabel: 'Rủi ro Trung bình',
        policyVersion: 'Policy v1.0',
      ),
      creator: ArenaChallengeCreatorDraft(
        id: 'cr002',
        name: 'ArenaKing',
        trustScore: 91,
        fairPlayBadge: true,
        role: 'Người tạo',
      ),
      teams: [
        ArenaTeamDraft(
          id: 'team_sol',
          name: 'Team SOL',
          accent: VitArenaTeamAccent.sol,
          members: [
            ArenaTeamMemberDraft(id: 'p201', name: 'ArenaKing', role: 'C'),
            ArenaTeamMemberDraft(id: 'p202', name: 'CryptoWhale', role: ''),
            ArenaTeamMemberDraft(id: 'p203', name: 'HODLer_VN', role: ''),
            ArenaTeamMemberDraft(id: 'p204', name: 'BlockchainBee', role: ''),
          ],
        ),
        ArenaTeamDraft(
          id: 'team_avax',
          name: 'Team AVAX',
          accent: VitArenaTeamAccent.avax,
          members: [
            ArenaTeamMemberDraft(id: 'p205', name: 'PredictorPro', role: 'C'),
            ArenaTeamMemberDraft(id: 'p206', name: 'TraderX', role: ''),
            ArenaTeamMemberDraft(id: 'p207', name: 'DeFiDragon', role: ''),
            ArenaTeamMemberDraft(id: 'p208', name: 'MoonRunner', role: ''),
          ],
        ),
      ],
      rewardTiers: [
        ArenaRewardTierDraft(label: 'Team thắng', value: '6.3K pts'),
      ],
      ruleRows: [
        ArenaRuleSummaryRow(
          label: 'Điều kiện thắng',
          value: 'Coin tăng giá nhiều nhất trong 7 ngày -> team đó thắng.',
        ),
        ArenaRuleSummaryRow(
          label: 'Chốt kết quả',
          value: 'API CoinGecko - so sánh % thay đổi 7 ngày',
        ),
        ArenaRuleSummaryRow(
          label: 'Bằng chứng',
          value: 'Không cần - tự động từ API',
        ),
        ArenaRuleSummaryRow(
          label: 'Hủy / Void',
          value: 'Void nếu 1 trong 2 coin bị delist trong thời gian challenge.',
        ),
      ],
      governanceRows: [
        ArenaRuleSummaryRow(
          label: 'Chốt kết quả',
          value: 'API CoinGecko - so sánh % thay đổi 7 ngày',
        ),
        ArenaRuleSummaryRow(label: 'Rủi ro', value: 'Trung bình'),
        ArenaRuleSummaryRow(
          label: 'Bằng chứng',
          value: 'Không cần - tự động từ API',
        ),
        ArenaRuleSummaryRow(
          label: 'Void rule',
          value: 'Void nếu 1 trong 2 coin bị delist trong thời gian challenge.',
        ),
        ArenaRuleSummaryRow(label: 'Quyền riêng tư', value: 'Công khai'),
      ],
      rules: [
        'Chia 2 đội: Team SOL và Team AVAX',
        'Coin nào tăng giá nhiều hơn trong 7 ngày -> team đó thắng',
        'Team thắng chia đều pool theo đóng góp points',
        'Kết quả từ CoinGecko API, tự động chốt',
        'Không hủy sau khi challenge bắt đầu',
      ],
      activity: [
        'Challenge bắt đầu với 40/40 người tham gia',
        'Points pool dat 7.2K pts',
        'CoinGecko API đang theo dõi SOL và AVAX',
      ],
      safetyRows: [
        ArenaRuleSummaryRow(
          label: 'Chốt kết quả',
          value: 'API CoinGecko - so sánh % thay đổi 7 ngày',
        ),
        ArenaRuleSummaryRow(
          label: 'Bằng chứng',
          value: 'Không cần - tự động từ API',
        ),
        ArenaRuleSummaryRow(label: 'Quyền riêng tư', value: 'Công khai'),
        ArenaRuleSummaryRow(
          label: 'Quy tắc hủy',
          value: 'Void nếu 1 trong 2 coin bị delist trong thời gian challenge.',
        ),
        ArenaRuleSummaryRow(label: 'Tin cậy creator', value: '91% ArenaKing'),
      ],
      predictionContext: ArenaPredictionContextDraft(
        eventId: 'pred-1',
        title: 'Bitcoin reaches \$150K before July 2026?',
        outcomeName: 'Yes',
        probability: 34,
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
  Future<ArenaJoinSnapshot> getArenaJoin(String challengeId) async {
    await _simulateNetwork();
    return const ArenaJoinSnapshot(
      endpoint: '/api/mobile/arena/arena-join-ch003',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      challenge: ArenaChallengeDetailDraft(
        id: 'ch003',
        title: 'Altcoin Team Battle — SOL vs AVAX',
        description:
            '2 đội chọn coin, coin tăng nhiều nhất trong tuần -> team đó thắng pool.',
        modeId: 'mode002',
        modeName: 'Altcoin Battle Royale',
        state: ArenaChallengeState.live,
        statusLabel: 'Đang diễn ra',
        layoutLabel: 'Team Battle',
        privacyLabel: 'Công khai',
        entryPoints: 200,
        prizePool: 7200,
        netPrizePool: 6264,
        teamWinnerPool: 6264,
        slotsFilled: 40,
        slotsTotal: 40,
        fillPercent: 100,
        countdownLabel: 'Đã hết hạn',
        winCondition: 'Coin tăng giá nhiều nhất trong 7 ngày -> team đó thắng.',
        resolutionMethod: 'API CoinGecko - so sánh % thay đổi 7 ngày',
        evidenceRequirement: 'Không cần - tự động từ API',
        voidRule:
            'Void nếu 1 trong 2 coin bị delist trong thời gian challenge.',
        refundPolicy:
            'Nếu hủy trước deadline, bạn được hoàn 50%. Arena Points không có giá trị tiền tệ.',
        platformFeePercent: 10,
        creatorCutPercent: 3,
        clarityScore: 80,
        trustRiskLabel: 'Rủi ro Trung bình',
        policyVersion: 'Policy v1.0',
      ),
      creator: ArenaChallengeCreatorDraft(
        id: 'cr002',
        name: 'ArenaKing',
        trustScore: 91,
        fairPlayBadge: true,
        role: 'Người tạo challenge',
      ),
      rules: [
        'Chia 2 đội: Team SOL và Team AVAX',
        'Coin nào tăng giá nhiều hơn trong 7 ngày -> team đó thắng',
        'Team thắng chia đều pool theo đóng góp points',
        'Kết quả từ CoinGecko API, tự động chốt',
        'Không hủy sau khi challenge bắt đầu',
      ],
      currentBalance: 2220,
      refundNotice:
          'Entry points sẽ bị trừ ngay khi tham gia. Nếu hủy trước deadline, bạn được hoàn 50%. Arena Points không có giá trị tiền tệ.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  Future<ArenaResolutionCenterSnapshot> getArenaResolutionCenter() async {
    await _simulateNetwork();
    return const ArenaResolutionCenterSnapshot(
      endpoint: '/api/mobile/arena/arena-resolution',
      actionDraft:
          'POST /p2p/disputes/:id/evidence|resolve; POST /arena/challenges|join|resolve|report where applicable',
      emptyTitle: 'Không tìm thấy',
      emptySubtitle: 'Challenge không tồn tại hoặc đã bị xoá',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
