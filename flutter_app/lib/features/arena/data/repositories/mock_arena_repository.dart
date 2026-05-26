import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/features/arena/domain/repositories/arena_repository.dart';

final class MockArenaRepository implements ArenaRepository {
  const MockArenaRepository();

  @override
  ArenaHomeSnapshot getArenaHome() {
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
  ArenaStudioSnapshot getArenaStudio() {
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

  @override
  ArenaSmartRulesSnapshot getArenaSmartRules() {
    return const ArenaSmartRulesSnapshot(
      endpoint: '/api/mobile/arena/arena-studio-smart-rules',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      defaultEndDate: '2026-03-15',
      steps: [
        ArenaStudioStepDraft(index: 1, label: 'Template'),
        ArenaStudioStepDraft(index: 2, label: 'Cấu trúc'),
        ArenaStudioStepDraft(index: 3, label: 'Luật chơi'),
        ArenaStudioStepDraft(index: 4, label: 'Kết quả'),
        ArenaStudioStepDraft(index: 5, label: 'Points'),
        ArenaStudioStepDraft(index: 6, label: 'Review'),
      ],
      domains: [
        ArenaSmartOptionDraft(
          id: 'sports',
          label: 'Thể thao',
          description: 'Trận đấu, tỉ số, người ghi điểm.',
        ),
        ArenaSmartOptionDraft(
          id: 'esports',
          label: 'Esports / Game',
          description: 'Team, map, điểm số hoặc giải đấu.',
        ),
        ArenaSmartOptionDraft(
          id: 'crypto',
          label: 'Crypto / Markets',
          description: 'Giá, mốc thời gian, token hoặc sự kiện thị trường.',
        ),
        ArenaSmartOptionDraft(
          id: 'community',
          label: 'Cộng đồng / Sự kiện',
          description: 'Vote, đóng góp, hoàn thành thử thách.',
        ),
      ],
      challengeTypes: [
        ArenaSmartOptionDraft(
          id: 'yes_no',
          label: 'Yes / No',
          description: 'Kết quả chỉ có đúng hoặc sai',
        ),
        ArenaSmartOptionDraft(
          id: 'multi_choice',
          label: 'Multi-choice',
          description: 'Nhiều lựa chọn, 1 đáp án đúng',
        ),
        ArenaSmartOptionDraft(
          id: 'closest_guess',
          label: 'Closest Guess',
          description: 'Người đoán gần nhất thắng',
        ),
        ArenaSmartOptionDraft(
          id: 'highest_wins',
          label: 'Highest Wins',
          description: 'Điểm/giá trị cao nhất thắng',
        ),
        ArenaSmartOptionDraft(
          id: 'lowest_wins',
          label: 'Lowest Wins',
          description: 'Điểm/giá trị thấp nhất thắng',
        ),
        ArenaSmartOptionDraft(
          id: 'first_to_finish',
          label: 'First To Finish',
          description: 'Ai hoàn thành trước thắng',
        ),
        ArenaSmartOptionDraft(
          id: 'team_score',
          label: 'Team Score',
          description: 'Tổng điểm team quyết định',
        ),
        ArenaSmartOptionDraft(
          id: 'referee_decision',
          label: 'Referee Decision',
          description: 'Trọng tài quyết định kết quả',
        ),
        ArenaSmartOptionDraft(
          id: 'community_vote',
          label: 'Community Vote',
          description: 'Cộng đồng bình chọn kết quả',
        ),
        ArenaSmartOptionDraft(
          id: 'proof_challenge',
          label: 'Proof Challenge',
          description: 'Bằng chứng xác minh thắng/thua',
        ),
      ],
      subjects: ['Người chơi', 'Đội', 'Cá nhân', 'Tất cả'],
      actions: [
        'đoán gần đúng nhất',
        'đạt điểm cao nhất',
        'hoàn thành trước',
        'gửi bằng chứng hợp lệ',
      ],
      metrics: ['giá', 'điểm số', 'tỷ số', 'kết quả sự kiện'],
      winTypes: [
        'sẽ thắng',
        'sẽ được công nhận',
        'sẽ nhận toàn bộ pool',
        'sẽ chia pool',
      ],
      deadlineContexts: [
        'vào ngày kết thúc',
        'lúc 23:59 UTC',
        'khi có kết quả chính thức',
      ],
      tieRules: [
        'Chia đều pool',
        'Hoàn trả entry points',
        'Chơi lại (rematch)',
      ],
      voidRules: [
        'Không đủ bằng chứng -> hủy',
        'Sự kiện gốc bị hủy -> hủy',
        'Quá hạn chốt kết quả -> hủy',
      ],
      resultDeadlines: [
        '1 giờ sau kết thúc',
        '24 giờ sau kết thúc',
        '7 ngày sau kết thúc',
      ],
      titleSuggestions: [
        'ETH sẽ ở mức nào vào ngày X?',
        'Đội nào thắng trận này?',
        'Ai hoàn thành thử thách trước?',
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
  ArenaPresetLibrarySnapshot getArenaPresetLibrary() {
    return const ArenaPresetLibrarySnapshot(
      endpoint: '/api/mobile/arena/arena-studio-presets',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      sections: [
        ArenaPresetSectionDraft(id: 'domains', label: 'Domain Packs'),
        ArenaPresetSectionDraft(id: 'suggestions', label: 'Suggestions'),
        ArenaPresetSectionDraft(id: 'dropdowns', label: 'Dropdowns'),
        ArenaPresetSectionDraft(id: 'demo_flows', label: 'Demo Flows'),
        ArenaPresetSectionDraft(id: 'titles', label: 'Titles'),
      ],
      domainPacks: [
        ArenaDomainPackDraft(
          id: 'sports',
          title: 'Thể thao',
          description:
              'Bóng đá, bóng rổ, tennis, F1, MMA, Olympic - tất cả giải đấu thể thao.',
          supportedTypes: [
            'Yes / No',
            'Closest Guess',
            'Highest Wins',
            'Team Score',
            'Multi-choice',
            'Referee Decision',
          ],
          examples: [
            'Đội nào thắng trận chung kết?',
            'Tỷ số gần đúng nhất?',
            'Ai ghi bàn trước?',
          ],
        ),
        ArenaDomainPackDraft(
          id: 'esports',
          title: 'Esports / Game',
          description:
              'League of Legends, Valorant, CS2, PUBG Mobile, speedrun.',
          supportedTypes: [
            'Yes / No',
            'Highest Wins',
            'First To Finish',
            'Team Score',
            'Closest Guess',
            'Proof Challenge',
          ],
          examples: [
            'Team nào vô địch giải đấu?',
            'Ai đạt điểm cao nhất?',
            'Map nào được chọn nhiều nhất?',
          ],
        ),
        ArenaDomainPackDraft(
          id: 'crypto',
          title: 'Crypto / Markets',
          description:
              'Bitcoin, Ethereum, altcoins, DeFi, macro, cổ phiếu, chỉ số tài chính.',
          supportedTypes: [
            'Yes / No',
            'Closest Guess',
            'Highest Wins',
            'Lowest Wins',
            'Multi-choice',
          ],
          examples: [
            'BTC vượt mốc \$100K không?',
            'ETH ở mức nào tại thời điểm Y?',
            'Coin nào tăng mạnh hơn?',
          ],
        ),
        ArenaDomainPackDraft(
          id: 'tech',
          title: 'Công nghệ / AI',
          description:
              'Ra mắt sản phẩm, AI benchmark, ngôn ngữ lập trình, startup, gadget.',
          supportedTypes: [
            'Yes / No',
            'Multi-choice',
            'Closest Guess',
            'Highest Wins',
            'Community Vote',
          ],
          examples: [
            'Sản phẩm nào ra mắt đầu tiên?',
            'AI nào đạt benchmark cao nhất?',
            'Framework nào phổ biến nhất 2026?',
          ],
        ),
        ArenaDomainPackDraft(
          id: 'science',
          title: 'Khoa học / Học tập',
          description:
              'Thí nghiệm, kỳ thi, khóa học online, quiz, nghiên cứu, bài tập nhóm.',
          supportedTypes: [
            'Closest Guess',
            'Highest Wins',
            'Multi-choice',
            'First To Finish',
            'Team Score',
          ],
          examples: [
            'Kết quả gần đúng nhất?',
            'Ai trả lời đúng nhiều nhất?',
            'Nhóm nào đạt điểm cao hơn?',
          ],
        ),
        ArenaDomainPackDraft(
          id: 'health',
          title: 'Sức khỏe / Lifestyle',
          description: 'Fitness challenge, chạy bộ, giảm cân, thiền, streak.',
          supportedTypes: [
            'Highest Wins',
            'Lowest Wins',
            'First To Finish',
            'Closest Guess',
            'Proof Challenge',
          ],
          examples: [
            'Ai hoàn thành mục tiêu trước?',
            'Ai giữ streak dài hơn?',
            'Ai có số bước cao hơn?',
          ],
        ),
        ArenaDomainPackDraft(
          id: 'entertainment',
          title: 'Giải trí / Văn hóa',
          description:
              'Oscar, Grammy, phim, nhạc, game show, reality TV, sách, truyện.',
          supportedTypes: [
            'Yes / No',
            'Multi-choice',
            'Community Vote',
            'Closest Guess',
          ],
          examples: [
            'Phim nào đoạt giải Oscar?',
            'Bài hát nào đạt #1?',
            'Ai bị loại tiếp theo?',
          ],
        ),
        ArenaDomainPackDraft(
          id: 'work',
          title: 'Công việc / Năng suất',
          description:
              'Sprint KPI, task completion, bug fix, sales target, OKR, team challenge.',
          supportedTypes: [
            'First To Finish',
            'Highest Wins',
            'Team Score',
            'Closest Guess',
            'Proof Challenge',
          ],
          examples: [
            'Ai hoàn thành task trước?',
            'Team nào đạt KPI cao hơn?',
            'Ai close nhiều việc hơn?',
          ],
        ),
        ArenaDomainPackDraft(
          id: 'community',
          title: 'Cộng đồng / Sự kiện',
          description:
              'Meetup, hackathon, volunteer, fundraising, event, neighborhood.',
          supportedTypes: [
            'Yes / No',
            'Closest Guess',
            'Community Vote',
            'First To Finish',
            'Team Score',
          ],
          examples: [
            'Ai đến trước?',
            'Team nào hoàn thành checkpoint đủ?',
            'Kết quả vote nào thắng?',
          ],
        ),
        ArenaDomainPackDraft(
          id: 'other',
          title: 'Khác / Custom',
          description:
              'Mọi lĩnh vực khác: thời tiết, nấu ăn, thú cưng, du lịch, tùy ý sáng tạo.',
          supportedTypes: [
            'Yes / No',
            'Multi-choice',
            'Closest Guess',
            'Highest Wins',
            'Lowest Wins',
            'First To Finish',
            'Team Score',
            'Referee Decision',
            'Community Vote',
            'Proof Challenge',
          ],
          examples: ['Kết quả sẽ là gì?', 'Ai sẽ thắng?', 'Điều gì sẽ xảy ra?'],
        ),
      ],
      suggestionsByDomain: {
        'sports': [
          ArenaPresetSuggestionDraft(
            text: 'Đội nào thắng trận này?',
            type: 'Yes / No',
          ),
          ArenaPresetSuggestionDraft(
            text: 'Tỷ số gần đúng nhất?',
            type: 'Closest Guess',
          ),
          ArenaPresetSuggestionDraft(
            text: 'Ai ghi bàn đầu tiên?',
            type: 'Multi-choice',
          ),
        ],
        'crypto': [
          ArenaPresetSuggestionDraft(
            text: 'BTC vượt mốc \$100K trước tháng 6?',
            type: 'Yes / No',
          ),
          ArenaPresetSuggestionDraft(
            text: 'ETH ở mức nào vào ngày 25/03?',
            type: 'Closest Guess',
          ),
          ArenaPresetSuggestionDraft(
            text: 'Coin nào tăng mạnh nhất tuần?',
            type: 'Highest Wins',
          ),
        ],
        'community': [
          ArenaPresetSuggestionDraft(
            text: 'Bao nhiêu người tham dự event?',
            type: 'Closest Guess',
          ),
          ArenaPresetSuggestionDraft(
            text: 'Ai đóng góp nhiều nhất?',
            type: 'Highest Wins',
          ),
          ArenaPresetSuggestionDraft(
            text: 'Kết quả vote nào thắng?',
            type: 'Community Vote',
          ),
        ],
      },
      dropdownGroups: [
        ArenaPresetDropdownGroupDraft(
          label: 'Lĩnh vực',
          options: ['Thể thao', 'Crypto / Markets', 'Cộng đồng / Sự kiện'],
        ),
        ArenaPresetDropdownGroupDraft(
          label: 'Loại challenge',
          options: ['Yes / No', 'Closest Guess', 'Highest Wins'],
        ),
        ArenaPresetDropdownGroupDraft(
          label: 'Điều kiện thắng',
          options: [
            'Người đoán gần đúng nhất',
            'Điểm/giá trị cao nhất',
            'Hoàn thành trước',
          ],
        ),
        ArenaPresetDropdownGroupDraft(
          label: 'Nguồn kết quả',
          options: ['API dữ liệu', 'Creator nhập', 'Community Vote'],
        ),
        ArenaPresetDropdownGroupDraft(
          label: 'Demo disabled',
          options: [],
          disabled: true,
        ),
      ],
      demoFlows: [
        ArenaPresetDemoFlowDraft(
          domainId: 'sports',
          domainLabel: 'Thể thao',
          typeLabel: 'Closest Guess',
          suggestions: [
            'Tỷ số gần đúng nhất?',
            'Bao nhiêu thẻ vàng?',
            'Tổng bàn thắng?',
          ],
          generatedRule:
              'Người đoán gần đúng nhất tỷ số trận chung kết vào ngày kết thúc sẽ thắng.',
        ),
        ArenaPresetDemoFlowDraft(
          domainId: 'crypto',
          domainLabel: 'Crypto / Markets',
          typeLabel: 'Yes / No',
          suggestions: [
            'BTC vượt \$100K?',
            'ETH flippening?',
            'Fed giảm lãi suất?',
          ],
          generatedRule:
              'Nếu BTC vượt mốc \$100,000 trước 23:59 UTC ngày kết thúc thì Yes thắng.',
        ),
        ArenaPresetDemoFlowDraft(
          domainId: 'community',
          domainLabel: 'Cộng đồng / Sự kiện',
          typeLabel: 'Community Vote',
          suggestions: [
            'Kết quả vote nào thắng?',
            'Team nào hoàn thành checkpoint?',
            'Ai đến sớm nhất?',
          ],
          generatedRule:
              'Kết quả được chọn nhiều nhất trong vote cộng đồng sẽ thắng.',
        ),
      ],
      titleSuggestions: [
        'BTC Weekly Predict - Tuần 10',
        'Đội nào thắng trận này?',
        'Ai hoàn thành thử thách trước?',
        'Community Vote - Kết quả cuối tuần',
        'Sprint KPI Battle',
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
  ArenaGovernanceSnapshot getArenaGovernance() {
    return const ArenaGovernanceSnapshot(
      endpoint: '/api/mobile/arena/arena-studio-governance',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      defaultEndDate: '2026-03-15',
      steps: [
        ArenaStudioStepDraft(index: 1, label: 'Template'),
        ArenaStudioStepDraft(index: 2, label: 'Cấu trúc'),
        ArenaStudioStepDraft(index: 3, label: 'Luật chơi'),
        ArenaStudioStepDraft(index: 4, label: 'Kết quả'),
        ArenaStudioStepDraft(index: 5, label: 'Points'),
        ArenaStudioStepDraft(index: 6, label: 'Review'),
      ],
      privacyOptions: [
        ArenaPrivacyOptionDraft(
          id: 'public',
          label: 'Công khai',
          description: 'Yêu cầu rule đầy đủ để publish công khai.',
        ),
        ArenaPrivacyOptionDraft(
          id: 'private',
          label: 'Riêng tư',
          description: 'Invite-only, phù hợp rule chưa hoàn thiện.',
        ),
        ArenaPrivacyOptionDraft(
          id: 'unlisted',
          label: 'Unlisted',
          description: 'Không hiển thị discovery, chia sẻ bằng link.',
        ),
      ],
      domains: [
        ArenaSmartOptionDraft(
          id: 'sports',
          label: 'Thể thao',
          description: 'Trận đấu, tỉ số, người ghi điểm.',
        ),
        ArenaSmartOptionDraft(
          id: 'esports',
          label: 'Esports / Game',
          description: 'Team, map, điểm số hoặc giải đấu.',
        ),
        ArenaSmartOptionDraft(
          id: 'crypto',
          label: 'Crypto / Markets',
          description: 'Giá, mốc thời gian, token hoặc sự kiện thị trường.',
        ),
        ArenaSmartOptionDraft(
          id: 'tech',
          label: 'Công nghệ / AI',
          description: 'Sản phẩm, benchmark, startup hoặc gadget.',
        ),
        ArenaSmartOptionDraft(
          id: 'science',
          label: 'Khoa học / Học tập',
          description: 'Quiz, thí nghiệm, bài tập nhóm.',
        ),
        ArenaSmartOptionDraft(
          id: 'health',
          label: 'Sức khỏe / Lifestyle',
          description: 'Fitness, streak hoặc thử thách cá nhân.',
        ),
        ArenaSmartOptionDraft(
          id: 'entertainment',
          label: 'Giải trí / Văn hóa',
          description: 'Phim, nhạc, giải thưởng hoặc vote.',
        ),
        ArenaSmartOptionDraft(
          id: 'work',
          label: 'Công việc / Năng suất',
          description: 'Sprint KPI, task, bug fix hoặc OKR.',
        ),
        ArenaSmartOptionDraft(
          id: 'community',
          label: 'Cộng đồng / Sự kiện',
          description: 'Meetup, volunteer, fundraising.',
        ),
        ArenaSmartOptionDraft(
          id: 'other',
          label: 'Khác',
          description: 'Custom rule cần mô tả rõ hơn.',
        ),
      ],
      challengeTypes: [
        ArenaSmartOptionDraft(
          id: 'yes_no',
          label: 'Yes / No',
          description: 'Kết quả chỉ có đúng hoặc sai',
        ),
        ArenaSmartOptionDraft(
          id: 'multi_choice',
          label: 'Multi-choice',
          description: 'Nhiều lựa chọn, 1 đáp án đúng',
        ),
        ArenaSmartOptionDraft(
          id: 'closest_guess',
          label: 'Closest Guess',
          description: 'Người đoán gần nhất thắng',
        ),
        ArenaSmartOptionDraft(
          id: 'highest_wins',
          label: 'Highest Wins',
          description: 'Điểm/giá trị cao nhất thắng',
        ),
        ArenaSmartOptionDraft(
          id: 'lowest_wins',
          label: 'Lowest Wins',
          description: 'Điểm/giá trị thấp nhất thắng',
        ),
        ArenaSmartOptionDraft(
          id: 'first_to_finish',
          label: 'First To Finish',
          description: 'Ai hoàn thành trước thắng',
        ),
        ArenaSmartOptionDraft(
          id: 'team_score',
          label: 'Team Score',
          description: 'Tổng điểm team quyết định',
        ),
        ArenaSmartOptionDraft(
          id: 'referee_decision',
          label: 'Referee Decision',
          description: 'Trọng tài quyết định kết quả',
        ),
        ArenaSmartOptionDraft(
          id: 'community_vote',
          label: 'Community Vote',
          description: 'Cộng đồng bình chọn kết quả',
        ),
        ArenaSmartOptionDraft(
          id: 'proof_challenge',
          label: 'Proof Challenge',
          description: 'Bằng chứng xác minh thắng/thua',
        ),
      ],
      subjects: ['Người chơi', 'Đội', 'Cá nhân', 'Tất cả'],
      actions: [
        'đoán gần đúng nhất',
        'đạt điểm cao nhất',
        'đạt điểm thấp nhất',
        'hoàn thành trước',
        'đúng đáp án',
        'gửi bằng chứng hợp lệ',
      ],
      metrics: ['giá', 'điểm số', 'tỷ số', 'thời gian', 'số lượng'],
      winTypes: ['sẽ thắng', 'sẽ được công nhận', 'sẽ nhận toàn bộ pool'],
      deadlineContexts: [
        'vào ngày kết thúc',
        'lúc 23:59 UTC',
        'khi có kết quả chính thức',
      ],
      resolutionSources: [
        'API / Oracle tự động',
        'Creator nhập thủ công',
        'Trọng tài xác nhận',
        'Cộng đồng bình chọn',
        'Bằng chứng xác minh',
      ],
      tieRules: [
        'Chia đều pool',
        'Hoàn trả entry points',
        'Chơi lại (rematch)',
        'Trọng tài quyết định',
      ],
      voidRules: [
        'Không đủ bằng chứng -> hủy',
        'Sự kiện gốc bị hủy -> hủy',
        'Không đủ người tham gia -> hủy',
        'Quá hạn chốt kết quả -> hủy',
      ],
      resultDeadlines: [
        '1 giờ sau kết thúc',
        '6 giờ sau kết thúc',
        '24 giờ sau kết thúc',
        '7 ngày sau kết thúc',
      ],
      suggestionActions: [
        ArenaGovernanceSuggestionDraft(
          id: 'closest_guess',
          title: 'Chuyển sang Closest Guess',
          description: 'Người đoán gần đúng nhất thắng, đơn giản, rõ ràng',
        ),
        ArenaGovernanceSuggestionDraft(
          id: 'proof_challenge',
          title: 'Chuyển sang Proof Challenge',
          description: 'Yêu cầu bằng chứng, dễ xác minh kết quả',
        ),
        ArenaGovernanceSuggestionDraft(
          id: 'invite_only',
          title: 'Chuyển sang Invite Only',
          description: 'Giảm yêu cầu rule cho room riêng tư',
        ),
        ArenaGovernanceSuggestionDraft(
          id: 'add_rules',
          title: 'Bổ sung tie/void rules',
          description: 'Thêm luật hòa và hủy bỏ để tăng clarity',
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
  ArenaModeDetailSnapshot getArenaModeDetail(String modeId) {
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
  ArenaChallengeDetailSnapshot getArenaChallengeDetail(String challengeId) {
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
        'Prize pool đạt 7.2K pts',
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
  ArenaJoinSnapshot getArenaJoin(String challengeId) {
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
  ArenaResolutionCenterSnapshot getArenaResolutionCenter() {
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

  @override
  ArenaCreatorProfileSnapshot getArenaCreator(String creatorId) {
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
  ArenaLeaderboardSnapshot getArenaLeaderboard() {
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
  VerifiedChallengesSnapshot getVerifiedChallenges() {
    return const VerifiedChallengesSnapshot(
      endpoint: '/api/mobile/arena/arena-verified',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      title: 'Verified Challenges',
      subtitle:
          'Sẽ mở trong tương lai cho challenge xác thực cao hơn với cơ chế verify on-chain và prize pool lớn hơn.',
      statusLabel: 'Coming Soon',
      infoTitle: 'Điều gì sẽ khác?',
      features: [
        VerifiedChallengeFeatureDraft(
          label: 'Challenge được verify bởi hệ thống Oracle',
          kind: VerifiedChallengeFeatureKind.oracle,
        ),
        VerifiedChallengeFeatureDraft(
          label: 'Prize pool lớn hơn với cơ chế escrow',
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

  @override
  ArenaPointsSnapshot getArenaPoints() {
    return const ArenaPointsSnapshot(
      endpoint: '/api/mobile/arena/arena-points',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      summary: ArenaPointsSummaryDraft(
        usdtClaimed: '35.0',
        currentBalance: 2220,
        lockedBalance: 450,
        rank: 142,
        topPercent: 5,
        claimedCount: 5,
        pendingCount: 3,
        pendingUsdt: '5.5',
        pendingPoints: 130,
        expiringCount: 8,
        completionLabel: '5/24 · 21%',
        tierLabel: 'Bạc',
      ),
      categories: [
        ArenaPointsCategoryDraft(
          id: 'daily',
          label: 'Hằng ngày',
          done: 2,
          total: 5,
          pending: 2,
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaPointsCategoryDraft(
          id: 'weekly',
          label: 'Hằng tuần',
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
          label: 'Học',
          done: 1,
          total: 4,
          pending: 1,
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaPointsCategoryDraft(
          id: 'achievement',
          label: 'Thành tựu',
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
          label: 'Hôm nay',
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
      filters: ['Tất cả', 'Flash', 'Học', 'Hằng ngày', 'P2P', 'Arena'],
      tasks: [
        ArenaRewardTaskDraft(
          id: 'task-volume',
          title: 'Volume tuần \$10K',
          subtitle: 'Đạt khối lượng giao dịch \$10,000 trong tuần',
          filter: 'Hằng ngày',
          status: ArenaRewardTaskStatus.active,
          progress: .58,
          rewardLabel: '+5 USDT · +50 pts',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-limit',
          title: 'Giao dịch 10 cặp khác nhau',
          subtitle: 'Giao dịch ít nhất 10 cặp coin khác nhau',
          filter: 'Hằng ngày',
          status: ArenaRewardTaskStatus.active,
          progress: .68,
          rewardLabel: '+2 USDT · +100 pts',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-referral',
          title: 'Mời bạn bè',
          subtitle: 'Mời 3 bạn bè đăng ký VitTrade tuần này',
          filter: 'Tất cả',
          status: ArenaRewardTaskStatus.active,
          progress: .33,
          rewardLabel: '+15 USDT · +100 pts',
          kind: ArenaRewardAccentKind.referral,
        ),
        ArenaRewardTaskDraft(
          id: 'task-streak',
          title: 'Streak 7 ngày',
          subtitle: 'Đăng nhập 7 ngày liên tiếp để nhận bonus',
          filter: 'Hằng ngày',
          status: ArenaRewardTaskStatus.active,
          progress: .71,
          rewardLabel: '+5 USDT · +100 pts',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-spot',
          title: 'Giao dịch 5 lệnh Spot',
          subtitle: 'Hoàn thành 5 lệnh giao dịch Spot trong ngày',
          filter: 'Hằng ngày',
          status: ArenaRewardTaskStatus.active,
          progress: .40,
          rewardLabel: '+1 USDT · +50 pts',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-flash-muc',
          title: 'Flash: Mua BTC hôm nay',
          subtitle: 'Mua tối thiểu 0.01 BTC trong 4 giờ tới',
          filter: 'Flash',
          status: ArenaRewardTaskStatus.active,
          progress: .0,
          rewardLabel: '+3 USDT · +100 pts',
          kind: ArenaRewardAccentKind.flash,
        ),
        ArenaRewardTaskDraft(
          id: 'task-flash-p2p',
          title: 'Flash 3 lệnh P2P liên tiếp',
          subtitle: 'Hoàn thành 3 lệnh P2P trong 6 giờ',
          filter: 'Flash',
          status: ArenaRewardTaskStatus.active,
          progress: .33,
          rewardLabel: '+12 USDT · +200 pts',
          kind: ArenaRewardAccentKind.flash,
        ),
        ArenaRewardTaskDraft(
          id: 'task-flash-volume',
          title: 'Flash: Volume 50K nhanh',
          subtitle: 'Đạt \$50,000 volume trong 8 giờ tới',
          filter: 'Flash',
          status: ArenaRewardTaskStatus.active,
          progress: .82,
          rewardLabel: '+8 USDT · +150 pts',
          kind: ArenaRewardAccentKind.flash,
        ),
        ArenaRewardTaskDraft(
          id: 'task-checkin',
          title: 'Đăng nhập hằng ngày',
          subtitle: 'Đăng nhập mỗi ngày để nhận thưởng đều',
          filter: 'Hằng ngày',
          status: ArenaRewardTaskStatus.completed,
          progress: 1,
          rewardLabel: '+0.5 USDT · +30 pts',
          kind: ArenaRewardAccentKind.daily,
        ),
        ArenaRewardTaskDraft(
          id: 'task-p2p',
          title: 'Giao dịch P2P',
          subtitle: 'Hoàn thành 1 giao dịch P2P trong ngày',
          filter: 'P2P',
          status: ArenaRewardTaskStatus.completed,
          progress: 1,
          rewardLabel: '+1 USDT · +40 pts',
          kind: ArenaRewardAccentKind.p2p,
        ),
        ArenaRewardTaskDraft(
          id: 'task-quiz',
          title: 'Quiz: Blockchain cơ bản',
          subtitle: 'Trả lời đúng 5 câu hỏi về blockchain',
          filter: 'Học',
          status: ArenaRewardTaskStatus.completed,
          progress: 1,
          rewardLabel: '+2 USDT · +50 pts',
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaRewardTaskDraft(
          id: 'task-wallet',
          title: 'Gửi \$500 trong Wallet',
          subtitle: 'Duy trì tối thiểu \$500 trong 7 ngày',
          filter: 'Tất cả',
          status: ArenaRewardTaskStatus.active,
          progress: .75,
          rewardLabel: '+10 USDT · +200 pts',
          kind: ArenaRewardAccentKind.neutral,
        ),
        ArenaRewardTaskDraft(
          id: 'task-mode',
          title: 'Tạo mode mới',
          subtitle: 'Tạo 1 mode mới và có ít nhất 4 người clone',
          filter: 'Arena',
          status: ArenaRewardTaskStatus.active,
          progress: .40,
          rewardLabel: '+200 pts',
          kind: ArenaRewardAccentKind.arena,
        ),
        ArenaRewardTaskDraft(
          id: 'task-thang3',
          title: 'Thắng 3 challenge',
          subtitle: 'Thắng 3 challenge bất kỳ',
          filter: 'Arena',
          status: ArenaRewardTaskStatus.active,
          progress: .67,
          rewardLabel: '+300 pts',
          kind: ArenaRewardAccentKind.arena,
        ),
        ArenaRewardTaskDraft(
          id: 'task-defi',
          title: 'Bài học DeFi là gì?',
          subtitle: 'Xem video 3 phút và trả lời quiz',
          filter: 'Học',
          status: ArenaRewardTaskStatus.active,
          progress: .50,
          rewardLabel: '+1.5 USDT · +50 pts',
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaRewardTaskDraft(
          id: 'task-an-toan',
          title: 'Quiz: An toàn P2P',
          subtitle: 'Hoàn thành bài kiểm tra an toàn P2P',
          filter: 'Học',
          status: ArenaRewardTaskStatus.active,
          progress: .60,
          rewardLabel: '+1.5 USDT · +50 pts',
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaRewardTaskDraft(
          id: 'task-risk',
          title: 'Bài học: Staking & Yield',
          subtitle: 'Tìm hiểu cách đánh giá rủi ro staking',
          filter: 'Học',
          status: ArenaRewardTaskStatus.active,
          progress: .50,
          rewardLabel: '+1.5 USDT · +50 pts',
          kind: ArenaRewardAccentKind.learn,
        ),
        ArenaRewardTaskDraft(
          id: 'task-share',
          title: 'Chia sẻ kết quả giao dịch',
          subtitle: 'Share 1 kết quả giao dịch lên mạng xã hội',
          filter: 'Tất cả',
          status: ArenaRewardTaskStatus.active,
          progress: .67,
          rewardLabel: '+1.5 USDT · +25 pts',
          kind: ArenaRewardAccentKind.neutral,
        ),
        ArenaRewardTaskDraft(
          id: 'task-danh-gia',
          title: 'Đánh giá người bán P2P',
          subtitle: 'Để lại đánh giá cho 3 người bán P2P',
          filter: 'P2P',
          status: ArenaRewardTaskStatus.active,
          progress: .67,
          rewardLabel: '+1.5 USDT · +35 pts',
          kind: ArenaRewardAccentKind.p2p,
        ),
        ArenaRewardTaskDraft(
          id: 'task-first',
          title: 'Giao dịch đầu tiên',
          subtitle: 'Thực hiện giao dịch đầu tiên trên VitTrade',
          filter: 'Tất cả',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaRewardTaskDraft(
          id: 'task-deposit',
          title: 'Nạp tiền lần đầu',
          subtitle: 'Nạp tối thiểu \$100 lần đầu tiên',
          filter: 'Tất cả',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaRewardTaskDraft(
          id: 'task-2fa',
          title: 'Bật 2FA',
          subtitle: 'Kích hoạt xác thực 2 lớp cho tài khoản',
          filter: 'Tất cả',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaRewardTaskDraft(
          id: 'task-kyc',
          title: 'KYC Level 2',
          subtitle: 'Hoàn tất xác minh danh tính cấp 2',
          filter: 'Tất cả',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaRewardTaskDraft(
          id: 'task-join',
          title: 'Tham gia challenge',
          subtitle: 'Tham gia ít nhất 1 challenge trong tuần',
          filter: 'Arena',
          status: ArenaRewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: ArenaRewardAccentKind.arena,
        ),
      ],
      bonusRows: [
        ArenaBonusRowDraft(
          title: 'Vòng quay may mắn',
          subtitle: '1 lượt quay miễn phí hôm nay',
          rewardLabel: '1 lượt',
          kind: ArenaRewardAccentKind.achievement,
        ),
        ArenaBonusRowDraft(
          title: 'Mystery Box',
          subtitle: 'Mở hộp khi hoàn thành 5 nhiệm vụ',
          rewardLabel: 'Có thể mở',
          kind: ArenaRewardAccentKind.flash,
        ),
        ArenaBonusRowDraft(
          title: 'Combo multiplier',
          subtitle: 'Hoàn thành nhiệm vụ liên tiếp để tăng thưởng',
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
          'Phần thưởng và Arena Points dùng trong Open Arena, không phải ví giao dịch hoặc PnL. Không thỏa thuận giao dịch ngoài nền tảng.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaFlowMapSnapshot getArenaFlowMap() {
    return const ArenaFlowMapSnapshot(
      endpoint: '/api/mobile/arena/arena-flow-map',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      stats: [
        ArenaFlowStatDraft(
          value: '10',
          label: 'Pages',
          kind: ArenaFlowKind.discovery,
        ),
        ArenaFlowStatDraft(
          value: '10',
          label: 'Routes',
          kind: ArenaFlowKind.verified,
        ),
        ArenaFlowStatDraft(
          value: '4 files',
          label: 'Components',
          kind: ArenaFlowKind.participant,
        ),
        ArenaFlowStatDraft(
          value: '12+',
          label: 'States',
          kind: ArenaFlowKind.points,
        ),
      ],
      routes: [
        ArenaFlowRouteDraft(
          path: '/arena',
          page: 'ArenaHomePage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/studio',
          page: 'ArenaStudioPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/mode/:modeId',
          page: 'ArenaModeDetailPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/challenge/:challengeId',
          page: 'ArenaChallengeDetailPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/challenge/:id/join',
          page: 'ArenaJoinPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/creator/:creatorId',
          page: 'ArenaCreatorPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/leaderboard',
          page: 'ArenaLeaderboardPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/verified',
          page: 'VerifiedChallengesPage',
          status: 'Placeholder',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/points',
          page: 'ArenaPointsPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/profile/arena',
          page: 'MyArenaPage',
          status: 'Live',
        ),
      ],
      groups: [
        ArenaFlowGroupDraft(
          id: 'core',
          title: 'Core Entry Points',
          subtitle: '3 điểm vào chính từ bottom nav',
          kind: ArenaFlowKind.core,
          connectionNote:
              'Home quick action, Profile menu và Market banner đều dẫn vào Arena.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'HomePage_v2',
              sublabel: 'Tab Home',
              kind: ArenaFlowKind.core,
              route: '/',
            ),
            ArenaFlowNodeDraft(
              label: 'ProfilePage_v2',
              sublabel: 'Tab Profile',
              kind: ArenaFlowKind.verified,
              route: '/profile',
            ),
            ArenaFlowNodeDraft(
              label: 'MarketListPage_v2',
              sublabel: 'Tab Trade',
              kind: ArenaFlowKind.participant,
              route: '/trade',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaHomePage',
              sublabel: 'Hub chính',
              kind: ArenaFlowKind.points,
              route: '/arena',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'discovery',
          title: 'Discovery Flow',
          subtitle: 'Khám phá modes, challenges, creators',
          kind: ArenaFlowKind.discovery,
          connectionNote:
              'Arena Home mở Studio, Mode Detail, Challenge Detail, Creator, Leaderboard và Points.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'ArenaHomePage',
              sublabel: 'Hub chính',
              kind: ArenaFlowKind.points,
              route: '/arena',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaStudioPage',
              sublabel: 'Tạo challenge',
              kind: ArenaFlowKind.verified,
              route: '/arena/studio',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaModeDetailPage',
              sublabel: 'Chi tiết mode',
              kind: ArenaFlowKind.participant,
              route: '/arena/mode/mode001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaChallengeDetail',
              sublabel: 'Chi tiết challenge',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaCreatorPage',
              sublabel: 'Hồ sơ creator',
              kind: ArenaFlowKind.points,
              route: '/arena/creator/cr001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaLeaderboardPage',
              sublabel: 'Bảng xếp hạng',
              kind: ArenaFlowKind.safety,
              route: '/arena/leaderboard',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaPointsPage',
              sublabel: 'Kiếm Points',
              kind: ArenaFlowKind.points,
              route: '/arena/points',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'creator_flow',
          title: 'Creator Flow',
          subtitle: '6-step wizard -> publish -> challenge live',
          kind: ArenaFlowKind.creator,
          connectionNote:
              'Template, cấu trúc, luật chơi, kết quả, points và review dẫn tới publish.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'Step 1 - Template',
              sublabel: 'Chọn template',
              kind: ArenaFlowKind.verified,
              route: '/arena/studio',
            ),
            ArenaFlowNodeDraft(
              label: 'Step 2 - Cấu trúc',
              sublabel: 'Format, slots, join',
              kind: ArenaFlowKind.discovery,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 3 - Luật chơi',
              sublabel: 'Tên, rules, win condition',
              kind: ArenaFlowKind.points,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 4 - Kết quả',
              sublabel: 'Resolution method',
              kind: ArenaFlowKind.participant,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 5 - Points',
              sublabel: 'Entry, privacy, EV',
              kind: ArenaFlowKind.points,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 6 - Review',
              sublabel: 'Preview & publish',
              kind: ArenaFlowKind.verified,
            ),
            ArenaFlowNodeDraft(
              label: 'Publish',
              sublabel: 'Kiểm duyệt tự động',
              kind: ArenaFlowKind.participant,
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Open',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
              stateLabel: 'Đang mở',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'participant',
          title: 'Participant Flow',
          subtitle: 'Tham gia challenge -> live -> kết quả',
          kind: ArenaFlowKind.points,
          connectionNote:
              'Open detail, confirm join, live state, pending result và resolved state.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Open',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
              stateLabel: 'Đang mở',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaJoinPage',
              sublabel: 'Confirm join + rules',
              kind: ArenaFlowKind.participant,
              route: '/arena/join/ch003',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Live',
              kind: ArenaFlowKind.participant,
              stateLabel: 'Đang diễn ra',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Pending Result',
              kind: ArenaFlowKind.verified,
              stateLabel: 'Chờ kết quả',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Resolved',
              kind: ArenaFlowKind.points,
              stateLabel: 'Đã xử lý',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'owner',
          title: 'Owner Flow',
          subtitle: 'Quản lý phòng, modes đã tạo, prefill studio',
          kind: ArenaFlowKind.safety,
          connectionNote:
              'My Arena quản lý rooms, saved modes, drafts và mở lại studio prefill.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'MyArenaPage',
              sublabel: '5-tab management',
              kind: ArenaFlowKind.verified,
              route: '/profile/arena',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'Quản lý phòng',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
            ),
            ArenaFlowNodeDraft(
              label: 'ModeDetailPage',
              sublabel: 'Mode đã tạo/lưu',
              kind: ArenaFlowKind.participant,
              route: '/arena/mode/mode001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaCreatorPage',
              sublabel: 'Hồ sơ creator',
              kind: ArenaFlowKind.points,
              route: '/arena/creator/cr001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaStudioPage',
              sublabel: 'Prefilled từ mode',
              kind: ArenaFlowKind.verified,
              route: '/arena/studio',
            ),
          ],
        ),
      ],
      components: [
        ArenaFlowComponentDraft(
          file: 'ArenaChips.tsx',
          description:
              'Reusable chips & badges cho format, resolution, status, trust level',
          exports: ['FormatChip', 'ResolutionChip', 'StatusChip', 'TrustBadge'],
        ),
        ArenaFlowComponentDraft(
          file: 'ArenaModeration.tsx',
          description:
              'Moderation UI: report, block, rules, inline warning banners',
          exports: ['ReportDialog', 'BlockUserDialog', 'CommunityRulesDialog'],
        ),
        ArenaFlowComponentDraft(
          file: 'ArenaStates.tsx',
          description:
              'Loading/empty/error/offline states + content status banners',
          exports: [
            'ArenaLoadingSkeleton',
            'ArenaErrorState',
            'ArenaOfflineBanner',
          ],
        ),
        ArenaFlowComponentDraft(
          file: 'ArenaPageFooter.tsx',
          description:
              'Shared footer: rules dialog, disclaimer and offline detection',
          exports: ['ArenaPageFooter'],
        ),
      ],
      handoffNotes: [
        ArenaFlowNoteDraft(
          title: 'Open Arena = Points-only',
          detail:
              'Toàn bộ module Open Arena sử dụng Arena Points, không liên quan ví tài chính và không cash-out.',
          kind: ArenaFlowKind.points,
        ),
        ArenaFlowNoteDraft(
          title: 'Không liên quan Wallet tài chính',
          detail:
              'Arena Points tách biệt khỏi Spot Wallet và P2P Wallet; không có flow deposit/withdraw crypto cho Arena.',
          kind: ArenaFlowKind.discovery,
        ),
        ArenaFlowNoteDraft(
          title: 'Verified Challenges tách module riêng',
          detail:
              'Verified Challenges là placeholder future-ready, cần compliance review và KYC gate ở phase sau.',
          kind: ArenaFlowKind.safety,
        ),
        ArenaFlowNoteDraft(
          title: 'Không thêm item vào bottom nav',
          detail:
              'Arena truy cập qua Home quick action, Profile menu và Market banner; không chiếm slot bottom navigation.',
          kind: ArenaFlowKind.participant,
        ),
        ArenaFlowNoteDraft(
          title: 'Mọi challenge bắt buộc có đủ',
          detail:
              'Rules summary, resolution method, privacy setting và report/block functionality trước publish.',
          kind: ArenaFlowKind.verified,
        ),
        ArenaFlowNoteDraft(
          title: 'Moderation & Safety',
          detail:
              'Report, block, community rules và offline banner phải tích hợp trên các surface chính.',
          kind: ArenaFlowKind.safety,
        ),
      ],
      qaItems: [
        ArenaFlowQaDraft(
          id: 'qa01',
          category: 'Route Mapping',
          label: 'ArenaHomePage - hub chính',
        ),
        ArenaFlowQaDraft(
          id: 'qa02',
          category: 'Route Mapping',
          label: 'ArenaStudioPage - 6-step wizard',
        ),
        ArenaFlowQaDraft(
          id: 'qa03',
          category: 'Route Mapping',
          label: 'ArenaChallengeDetailPage - challenge/:challengeId',
        ),
        ArenaFlowQaDraft(
          id: 'qa04',
          category: 'Entry Points',
          label: 'Home quick action -> ArenaHomePage',
        ),
        ArenaFlowQaDraft(
          id: 'qa05',
          category: 'Entry Points',
          label: 'Profile menu -> MyArenaPage',
        ),
        ArenaFlowQaDraft(
          id: 'qa06',
          category: 'States Coverage',
          label: 'StatusChip states: open, live, pending, resolved',
        ),
        ArenaFlowQaDraft(
          id: 'qa07',
          category: 'Moderation',
          label: 'ReportDialog, BlockUserDialog, CommunityRulesDialog',
        ),
        ArenaFlowQaDraft(
          id: 'qa08',
          category: 'Verified Separation',
          label: 'VerifiedChallengesPage is placeholder only',
        ),
      ],
      disclaimer:
          'Arena Points chỉ dùng trong Open Arena, không phải ví giao dịch hoặc PnL. Không thỏa thuận giao dịch ngoài nền tảng.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaSafetyCenterSnapshot getArenaSafetyCenter() {
    return const ArenaSafetyCenterSnapshot(
      endpoint: '/api/mobile/arena/arena-safety',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      bannerTitle: 'Open Arena cam kết an toàn',
      bannerDescription:
          'Chúng tôi xây dựng môi trường lành mạnh, minh bạch và công bằng cho mọi người chơi.',
      communityRules: [
        ArenaSafetyRuleDraft(
          title: 'Tôn trọng kết quả',
          description: 'Không thao túng, gian lận hoặc từ chối kết quả hợp lệ.',
          kind: ArenaSafetyKind.respect,
        ),
        ArenaSafetyRuleDraft(
          title: 'Không giao dịch ngoài nền tảng',
          description: 'Mọi thỏa thuận phải diễn ra trong Open Arena.',
          kind: ArenaSafetyKind.offPlatform,
        ),
        ArenaSafetyRuleDraft(
          title: 'Ngôn ngữ văn minh',
          description:
              'Không xúc phạm, đe dọa, phân biệt đối xử người chơi khác.',
          kind: ArenaSafetyKind.civil,
        ),
        ArenaSafetyRuleDraft(
          title: 'Bảo vệ thông tin cá nhân',
          description:
              'Không chia sẻ thông tin nhạy cảm trong chat hoặc challenge.',
          kind: ArenaSafetyKind.privacy,
        ),
      ],
      bannedContent: [
        'Spam, quảng cáo, link lạ',
        'Nội dung lừa đảo hoặc scam',
        'Thao túng kết quả challenge',
        'Ngôn ngữ thù ghét, đe dọa',
        'Mạo danh người dùng khác',
        'Giao dịch tiền thật / tài sản ngoài Arena',
      ],
      reportActions: [
        ArenaSafetyRuleDraft(
          title: 'Báo cáo vi phạm',
          description:
              'Nhấn nút "Báo cáo" trên profile người dùng, challenge hoặc mode. Chọn lý do và gửi. Đội ngũ sẽ xem xét trong 24 - 48h.',
          kind: ArenaSafetyKind.report,
        ),
        ArenaSafetyRuleDraft(
          title: 'Chặn người dùng',
          description:
              'Nhấn "Chặn" trên profile người dùng. Sau khi chặn, bạn sẽ không thấy challenge hoặc tin nhắn từ người này. Có thể bỏ chặn bất cứ lúc nào.',
          kind: ArenaSafetyKind.block,
        ),
      ],
      violationProcess: [
        ArenaSafetyProcessDraft(
          step: 1,
          title: 'Gửi báo cáo',
          description:
              'Nhấn "Báo cáo" trên profile hoặc challenge và chọn lý do.',
        ),
        ArenaSafetyProcessDraft(
          step: 2,
          title: 'Tiếp nhận',
          description: 'Hệ thống xác nhận và ghi nhận báo cáo ngay lập tức.',
        ),
        ArenaSafetyProcessDraft(
          step: 3,
          title: 'Xem xét',
          description: 'Đội ngũ kiểm duyệt xem xét bằng chứng trong 24 - 48h.',
        ),
        ArenaSafetyProcessDraft(
          step: 4,
          title: 'Kết luận',
          description:
              'Thông báo kết quả qua mục "Báo cáo & chặn" trong profile.',
        ),
      ],
      resolution: ArenaSafetyInfoDraft(
        title: 'Kết quả challenge được chốt minh bạch',
        description:
            'Mỗi challenge có phương thức chốt riêng. Bạn luôn biết trước cách xác định kết quả.',
        kind: ArenaSafetyKind.resolution,
        items: [
          ArenaSafetyCheckDraft(
            text:
                'Bình chọn cộng đồng - Người tham gia bỏ phiếu. Kết quả theo đa số.',
            allowed: true,
          ),
          ArenaSafetyCheckDraft(
            text:
                'Trọng tài (Referee) - Một người được chỉ định xem xét bằng chứng và quyết định.',
            allowed: true,
          ),
          ArenaSafetyCheckDraft(
            text:
                'Tự động (Auto) - Hệ thống tự chốt dựa trên dữ liệu từ nguồn đáng tin cậy.',
            allowed: true,
          ),
        ],
      ),
      offPlatform: ArenaSafetyInfoDraft(
        title: 'Mọi thỏa thuận trong Arena',
        description:
            'Không trao đổi tiền thật, crypto hoặc tài sản ngoài Arena. Mọi challenge chỉ sử dụng Arena Points.',
        kind: ArenaSafetyKind.offPlatform,
        items: [
          ArenaSafetyCheckDraft(
            text: 'Không chuyển khoản ngân hàng cho challenge',
            allowed: false,
          ),
          ArenaSafetyCheckDraft(
            text: 'Không đổi Arena Points lấy tiền thật',
            allowed: false,
          ),
          ArenaSafetyCheckDraft(
            text: 'Báo cáo nếu bị dụ giao dịch ngoài',
            allowed: true,
          ),
        ],
      ),
      pointsDisclaimer: ArenaSafetyInfoDraft(
        title: 'Arena Points chỉ dùng trong Open Arena',
        description:
            'Arena Points là phần thưởng hoạt động, không phải tài sản tài chính, không có giá trị tiền tệ và không thể rút ra ngoài nền tảng.',
        kind: ArenaSafetyKind.points,
        items: [
          ArenaSafetyCheckDraft(
            text: 'Không mua bán Arena Points',
            allowed: false,
          ),
          ArenaSafetyCheckDraft(
            text: 'Không đổi sang tiền thật hoặc crypto',
            allowed: false,
          ),
          ArenaSafetyCheckDraft(
            text: 'Dùng để tham gia challenges và nhận thưởng',
            allowed: true,
          ),
          ArenaSafetyCheckDraft(
            text: 'Nhận miễn phí qua nhiệm vụ hằng ngày',
            allowed: true,
          ),
        ],
      ),
      quickLinks: [
        ArenaSafetyQuickLinkDraft(
          title: 'Danh sách người đã chặn',
          route: '/arena/blocked',
          kind: ArenaSafetyKind.block,
        ),
        ArenaSafetyQuickLinkDraft(
          title: 'Xem báo cáo của tôi',
          route: '/arena/my-reports',
          kind: ArenaSafetyKind.report,
        ),
      ],
      ctaLabel: 'Đã hiểu',
      footerLabel: 'Quy tắc cộng đồng',
      disclaimer:
          'Arena Points chỉ dùng trong Open Arena, không phải ví giao dịch hoặc PnL. Không giao dịch ngoài nền tảng.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaBlockedUsersSnapshot getArenaBlockedUsers() {
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
  ArenaTrustBreakdownSnapshot getArenaTrustBreakdown(String entityId) {
    if (entityId != 'cr001') {
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

    final profile = getArenaCreator(entityId);
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
  ArenaPointsLedgerSnapshot getArenaPointsLedger() {
    return const ArenaPointsLedgerSnapshot(
      endpoint: '/api/mobile/arena/arena-ledger',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      summary: ArenaPointsLedgerSummaryDraft(
        currentBalance: 2220,
        pointsEarned: 4520,
        pointsSpent: 2300,
      ),
      filters: [
        ArenaPointsLedgerFilterDraft(id: 'all', label: 'Tất cả'),
        ArenaPointsLedgerFilterDraft(id: 'earned', label: 'Nhận'),
        ArenaPointsLedgerFilterDraft(id: 'spent', label: 'Chi'),
        ArenaPointsLedgerFilterDraft(id: 'entry', label: 'Tham gia'),
        ArenaPointsLedgerFilterDraft(id: 'settlement', label: 'Kết toán'),
        ArenaPointsLedgerFilterDraft(id: 'refund', label: 'Hoàn điểm'),
        ArenaPointsLedgerFilterDraft(id: 'adjustment', label: 'Điều chỉnh'),
      ],
      entries: [
        ArenaPointsLedgerEntryDraft(
          id: 'le001',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 30,
          balanceBefore: 2190,
          balanceAfter: 2220,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '28/02 08:00',
          reasonCode: 'DAILY_CHECKIN',
          title: 'Check-in ngày 5',
          refId: 'REF-D20260228-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le002',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 50,
          balanceBefore: 2140,
          balanceAfter: 2190,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '27/02 23:59',
          reasonCode: 'TRADE_VOLUME',
          title: 'Đạt \$500 khối lượng Spot',
          refId: 'REF-V20260227-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le003',
          typeId: 'entry',
          typeLabel: 'Tham gia',
          amount: -100,
          balanceBefore: 2240,
          balanceAfter: 2140,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '27/02 14:00',
          reasonCode: 'CHALLENGE_ENTRY',
          title: 'BTC \$70K? — Tuần 9',
          refId: 'REF-E20260227-001',
          linkedChallengeId: 'ch001',
          linkedChallengeName: 'BTC \$70K? — Tuần 9',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le004',
          typeId: 'settlement',
          typeLabel: 'Kết toán',
          amount: 800,
          balanceBefore: 1440,
          balanceAfter: 2240,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '26/02 00:01',
          reasonCode: 'CHALLENGE_WIN',
          title: 'Crypto Quiz Night #11',
          refId: 'REF-S20260226-001',
          linkedChallengeId: 'ch005',
          linkedChallengeName: 'Crypto Quiz Night #11',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le005',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 25,
          balanceBefore: 1415,
          balanceAfter: 1440,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '26/02 08:00',
          reasonCode: 'DAILY_CHECKIN',
          title: 'Check-in ngày 4',
          refId: 'REF-D20260226-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le006',
          typeId: 'entry',
          typeLabel: 'Tham gia',
          amount: -200,
          balanceBefore: 1615,
          balanceAfter: 1415,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '25/02 10:00',
          reasonCode: 'CHALLENGE_ENTRY',
          title: 'SOL vs AVAX Battle',
          refId: 'REF-E20260225-001',
          linkedChallengeId: 'ch003',
          linkedChallengeName: 'SOL vs AVAX Battle',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le007',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 40,
          balanceBefore: 1575,
          balanceAfter: 1615,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '25/02 16:30',
          reasonCode: 'P2P_TASK',
          title: 'Giao dịch P2P hoàn tất',
          refId: 'REF-P20260225-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le008',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 100,
          balanceBefore: 1475,
          balanceAfter: 1575,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '24/02 12:00',
          reasonCode: 'REFERRAL',
          title: 'Mời bạn ArenaNewbie',
          refId: 'REF-R20260224-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le009',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 20,
          balanceBefore: 1455,
          balanceAfter: 1475,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '24/02 08:00',
          reasonCode: 'DAILY_CHECKIN',
          title: 'Check-in ngày 3',
          refId: 'REF-D20260224-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le010',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 200,
          balanceBefore: 1255,
          balanceAfter: 1455,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '23/02 18:00',
          reasonCode: 'MODE_MILESTONE',
          title: 'Mode đạt 5 clone',
          refId: 'REF-M20260223-001',
          linkedModeId: 'mode001',
          linkedModeName: 'BTC Weekly Predict',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le011',
          typeId: 'refund',
          typeLabel: 'Hoàn điểm',
          amount: 80,
          balanceBefore: 1175,
          balanceAfter: 1255,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '22/02 12:00',
          reasonCode: 'CHALLENGE_CANCEL',
          title: 'Hoàn 100% — không đủ người tham gia',
          refId: 'REF-RF20260222-001',
          linkedChallengeId: 'ch007',
          linkedChallengeName: 'NFT Floor Price Guess (đã hủy)',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le012',
          typeId: 'entry',
          typeLabel: 'Tham gia',
          amount: -80,
          balanceBefore: 1255,
          balanceAfter: 1175,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '20/02 09:00',
          reasonCode: 'CHALLENGE_ENTRY',
          title: 'NFT Floor Price Guess',
          refId: 'REF-E20260220-001',
          linkedChallengeId: 'ch007',
          linkedChallengeName: 'NFT Floor Price Guess',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le013',
          typeId: 'adjustment',
          typeLabel: 'Điều chỉnh',
          amount: 50,
          balanceBefore: 1205,
          balanceAfter: 1255,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '19/02 10:00',
          reasonCode: 'ADMIN_ADJUST',
          title: 'Điều chỉnh hệ thống — bù lỗi kỹ thuật',
          refId: 'REF-A20260219-001',
          linkedChallengeId: 'ch002',
          linkedChallengeName: 'ETH Merge Predict #3',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le014',
          typeId: 'settlement',
          typeLabel: 'Kết toán',
          amount: 0,
          balanceBefore: 1205,
          balanceAfter: 1205,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '18/02 22:00',
          reasonCode: 'CHALLENGE_LOSS',
          title: 'Không thắng — entry points đã trừ trước',
          refId: 'REF-S20260218-001',
          linkedChallengeId: 'ch002',
          linkedChallengeName: 'ETH Merge Predict #3',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le015',
          typeId: 'entry',
          typeLabel: 'Tham gia',
          amount: -50,
          balanceBefore: 1255,
          balanceAfter: 1205,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '15/02 14:00',
          reasonCode: 'CHALLENGE_ENTRY',
          title: 'Fed Rate Predict — March',
          refId: 'REF-E20260215-001',
          linkedChallengeId: 'ch004',
          linkedChallengeName: 'Fed Rate Predict — March',
        ),
      ],
      emptyTitle: 'Không tìm thấy bản ghi',
      emptySubtitle: 'Thử đổi bộ lọc hoặc từ khóa tìm kiếm.',
      disclaimer:
          'Mọi thay đổi Arena Points đều được ghi lại với mã tham chiếu duy nhất. Arena Points không phải tài sản tài chính và không có giá trị tiền tệ.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaPointsEntryDetailSnapshot getArenaPointsEntryDetail(String entryId) {
    for (final ledgerEntry in getArenaPointsLedger().entries) {
      if (ledgerEntry.id != entryId) continue;

      return ArenaPointsEntryDetailSnapshot(
        endpoint: '/api/mobile/arena/arena-ledger-entry-$entryId',
        actionDraft:
            'POST /arena/challenges|join|resolve|report where applicable',
        entryId: entryId,
        entry: ArenaPointsEntryDraft(
          id: ledgerEntry.id,
          amount: ledgerEntry.amount,
          typeLabel: ledgerEntry.typeLabel,
          typeKind: _ledgerEntryKind(ledgerEntry.typeId),
          statusLabel: ledgerEntry.statusLabel,
          statusKind: ledgerEntry.statusKind,
          note: ledgerEntry.title,
          reasonCode: ledgerEntry.reasonCode,
          time: ledgerEntry.time,
          balanceBefore: ledgerEntry.balanceBefore,
          balanceAfter: ledgerEntry.balanceAfter,
          refId: ledgerEntry.refId,
          linkedChallengeId: ledgerEntry.linkedChallengeId,
          linkedChallengeName: ledgerEntry.linkedChallengeName,
          linkedModeId: ledgerEntry.linkedModeId,
          linkedModeName: ledgerEntry.linkedModeName,
        ),
        emptyTitle: 'Không tìm thấy',
        emptySubtitle: 'Giao dịch điểm không tồn tại',
        disclaimer:
            'Arena Points chỉ dùng trong Open Arena, không phải ví giao dịch hoặc PnL.',
        supportedStates: const {
          ArenaScreenState.loading,
          ArenaScreenState.empty,
          ArenaScreenState.error,
          ArenaScreenState.offline,
        },
      );
    }

    if (entryId != 'entry-demo') {
      return ArenaPointsEntryDetailSnapshot(
        endpoint: '/api/mobile/arena/arena-ledger-entry-$entryId',
        actionDraft:
            'POST /arena/challenges|join|resolve|report where applicable',
        entryId: entryId,
        entry: null,
        emptyTitle: 'Không tìm thấy',
        emptySubtitle: 'Giao dịch điểm không tồn tại',
        disclaimer:
            'Arena Points chỉ dùng trong Open Arena, không phải ví giao dịch hoặc PnL.',
        supportedStates: const {
          ArenaScreenState.loading,
          ArenaScreenState.empty,
          ArenaScreenState.error,
          ArenaScreenState.offline,
        },
      );
    }

    return const ArenaPointsEntryDetailSnapshot(
      endpoint: '/api/mobile/arena/arena-ledger-entry-entry-demo',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      entryId: 'entry-demo',
      entry: ArenaPointsEntryDraft(
        id: 'entry-demo',
        amount: 240,
        typeLabel: 'Challenge reward',
        typeKind: ArenaPointsEntryKind.reward,
        statusLabel: 'Hoàn tất',
        statusKind: ArenaPointsEntryStatus.completed,
        note: 'Thưởng hoàn thành challenge BTC Weekly Predict',
        reasonCode: 'CHALLENGE_REWARD',
        time: '23/05/2026 · 21:18',
        balanceBefore: 1980,
        balanceAfter: 2220,
        refId: 'ARENA-LEDGER-20260523-ENTRY-DEMO',
        linkedChallengeId: 'ch003',
        linkedChallengeName: 'BTC \$70K? - Tuần 9',
        linkedModeId: 'mode001',
        linkedModeName: 'BTC Weekly Predict',
      ),
      emptyTitle: 'Không tìm thấy',
      emptySubtitle: 'Giao dịch điểm không tồn tại',
      disclaimer:
          'Arena Points chỉ dùng trong Open Arena, không phải ví giao dịch hoặc PnL.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  ArenaPointsEntryKind _ledgerEntryKind(String typeId) {
    return switch (typeId) {
      'entry' || 'spent' => ArenaPointsEntryKind.spend,
      'refund' => ArenaPointsEntryKind.refund,
      'adjustment' => ArenaPointsEntryKind.adjustment,
      _ => ArenaPointsEntryKind.reward,
    };
  }

  @override
  ArenaReportCaseSnapshot getArenaReportCase(String caseId) {
    final reports = _arenaReportCases;
    ArenaReportCaseDraft? reportCase;
    for (final report in reports) {
      if (report.id == caseId) {
        reportCase = report;
        break;
      }
    }

    return ArenaReportCaseSnapshot(
      endpoint: '/api/mobile/arena/arena-report-$caseId',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable; POST /exports',
      caseId: caseId,
      reportCase: reportCase,
      relatedReports: reports
          .where((report) => report.id != caseId)
          .take(2)
          .toList(growable: false),
      emptyTitle: 'Không tìm thấy',
      emptySubtitle: 'Báo cáo không tồn tại',
      disclaimer:
          'Báo cáo Open Arena chỉ áp dụng cho bề mặt điểm xã hội. Arena Points không có giá trị tiền tệ, không phải ví giao dịch hoặc PnL.',
      supportedStates: const {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  MyArenaReportsSnapshot getMyArenaReports() {
    const reports = _arenaReportCases;
    final submitted = _reportStatusCount(
      reports,
      ArenaReportCaseStatus.submitted,
    );
    final underReview = _reportStatusCount(
      reports,
      ArenaReportCaseStatus.underReview,
    );
    final actionTaken = _reportStatusCount(
      reports,
      ArenaReportCaseStatus.actionTaken,
    );
    final closed = _reportStatusCount(reports, ArenaReportCaseStatus.closed);
    final appealOpen = _reportStatusCount(
      reports,
      ArenaReportCaseStatus.appealOpen,
    );

    return MyArenaReportsSnapshot(
      endpoint: '/api/mobile/arena/arena-my-reports',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable; POST /exports',
      summary: MyArenaReportsSummaryDraft(
        total: reports.length,
        inReview: submitted + underReview,
        resolved: actionTaken + closed,
      ),
      filters: [
        MyArenaReportsFilterDraft(
          id: 'all',
          label: 'Tất cả',
          count: reports.length,
        ),
        MyArenaReportsFilterDraft(
          id: 'submitted',
          label: 'Đã gửi',
          count: submitted,
          status: ArenaReportCaseStatus.submitted,
        ),
        MyArenaReportsFilterDraft(
          id: 'under_review',
          label: 'Đang xem xét',
          count: underReview,
          status: ArenaReportCaseStatus.underReview,
        ),
        MyArenaReportsFilterDraft(
          id: 'action_taken',
          label: 'Đã xử lý',
          count: actionTaken,
          status: ArenaReportCaseStatus.actionTaken,
        ),
        MyArenaReportsFilterDraft(
          id: 'closed',
          label: 'Đã đóng',
          count: closed,
          status: ArenaReportCaseStatus.closed,
        ),
        MyArenaReportsFilterDraft(
          id: 'appeal_open',
          label: 'Khiếu nại',
          count: appealOpen,
          status: ArenaReportCaseStatus.appealOpen,
        ),
      ],
      reports: reports,
      bannerTitle: 'Về quy trình xử lý',
      bannerDescription:
          'Mỗi báo cáo được đội ngũ xem xét trong 24-72h. Bạn có thể theo dõi tiến trình ở đây.',
      emptyTitle: 'Chưa có báo cáo',
      emptySubtitle: 'Bạn chưa gửi báo cáo vi phạm nào trong Open Arena.',
      disclaimer:
          'Báo cáo Open Arena chỉ áp dụng cho bề mặt điểm xã hội. Không sử dụng ví, PnL hoặc giá trị tiền tệ.',
      supportedStates: const {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  static int _reportStatusCount(
    List<ArenaReportCaseDraft> reports,
    ArenaReportCaseStatus status,
  ) {
    return reports.where((report) => report.status == status).length;
  }

  static const List<ArenaReportCaseDraft> _arenaReportCases = [
    ArenaReportCaseDraft(
      id: 'rpt001',
      status: ArenaReportCaseStatus.actionTaken,
      reason: 'Thao túng kết quả',
      targetName: 'GameMaker_HN',
      targetType: ArenaReportTargetType.user,
      targetId: 'cr004',
      createdAt: '2026-02-20 14:30',
      updatedAt: '2026-02-24 10:00',
      timeline: [
        ArenaReportTimelineStepDraft(
          label: 'Bạn đã gửi báo cáo',
          date: '20/02 14:30',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Hệ thống đã tiếp nhận',
          date: '20/02 14:31',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Đang xem xét bằng chứng',
          date: '21/02 09:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Kết luận: Vi phạm xác nhận',
          date: '24/02 10:00',
          done: true,
        ),
      ],
      actionTaken: 'Tạm khóa tạo challenge 7 ngày. Cảnh cáo lần 1.',
      systemNote:
          'Người dùng đã sử dụng nhiều tài khoản để ảnh hưởng kết quả vote trong challenge ch006.',
      relatedChallengeId: 'ch006',
    ),
    ArenaReportCaseDraft(
      id: 'rpt002',
      status: ArenaReportCaseStatus.underReview,
      reason: 'Spam hoặc quảng cáo',
      targetName: 'SpamBot_X',
      targetType: ArenaReportTargetType.user,
      targetId: 'u_spam01',
      createdAt: '2026-02-26 18:00',
      updatedAt: '2026-02-27 09:00',
      timeline: [
        ArenaReportTimelineStepDraft(
          label: 'Bạn đã gửi báo cáo',
          date: '26/02 18:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Hệ thống đã tiếp nhận',
          date: '26/02 18:01',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Đang xem xét',
          date: '27/02 09:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(label: 'Kết luận', date: '', done: false),
      ],
      systemNote: 'Đang chờ đội ngũ xem xét nội dung chat.',
    ),
    ArenaReportCaseDraft(
      id: 'rpt003',
      status: ArenaReportCaseStatus.closed,
      reason: 'Ngôn ngữ xúc phạm',
      targetName: 'ToxicTrader',
      targetType: ArenaReportTargetType.user,
      targetId: 'u_toxic01',
      createdAt: '2026-02-10 11:00',
      updatedAt: '2026-02-15 16:00',
      timeline: [
        ArenaReportTimelineStepDraft(
          label: 'Bạn đã gửi báo cáo',
          date: '10/02 11:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Hệ thống đã tiếp nhận',
          date: '10/02 11:01',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Đang xem xét',
          date: '11/02 08:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Kết luận: Cấm vĩnh viễn',
          date: '15/02 16:00',
          done: true,
        ),
      ],
      actionTaken: 'Tài khoản bị cấm vĩnh viễn khỏi Open Arena.',
      systemNote:
          'Ngôn ngữ xúc phạm nghiêm trọng, lặp lại nhiều lần sau cảnh cáo.',
    ),
    ArenaReportCaseDraft(
      id: 'rpt004',
      status: ArenaReportCaseStatus.appealOpen,
      reason: 'Vi phạm luật chơi',
      targetName: 'ArenaKing',
      targetType: ArenaReportTargetType.challenge,
      targetId: 'ch003',
      createdAt: '2026-02-22 09:00',
      updatedAt: '2026-02-27 14:00',
      timeline: [
        ArenaReportTimelineStepDraft(
          label: 'Bạn đã gửi báo cáo',
          date: '22/02 09:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Hệ thống đã tiếp nhận',
          date: '22/02 09:01',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Đang xem xét',
          date: '23/02 10:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Kết luận: Không đủ bằng chứng',
          date: '25/02 11:00',
          done: true,
        ),
      ],
      actionTaken: 'Không có hành động - không đủ bằng chứng.',
      systemNote: 'Bạn đã mở khiếu nại. Đang chờ bổ sung bằng chứng.',
      relatedChallengeId: 'ch003',
    ),
  ];

  @override
  MyArenaSnapshot getMyArena() {
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
  MyArenaSnapshot getArenaMy() {
    return getMyArena().copyWith(endpoint: '/api/mobile/arena/arena-my');
  }

  @override
  ArenaProductionReadySnapshot getArenaProductionReady() {
    return const ArenaProductionReadySnapshot(
      endpoint: '/api/mobile/arena/arena-production',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      canonicalScreens: [
        ArenaProductionScreenDraft(
          name: 'ArenaHomePage',
          route: '/arena',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
            ArenaProductionScreenState.offline,
          ],
          notes:
              'Gọn hơn v4: bớt quick chips, giữ hero + templates + modes + rooms + creators.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaStudioPage',
          route: '/arena/studio',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.error,
            ArenaProductionScreenState.offline,
            ArenaProductionScreenState.underReview,
          ],
          notes:
              'PublishEligibilityPanel rõ hơn, GovernanceHintBanner ở mỗi step.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaChallengeDetailPage',
          route: '/arena/challenge/:challengeId',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
            ArenaProductionScreenState.offline,
            ArenaProductionScreenState.underReview,
            ArenaProductionScreenState.reported,
            ArenaProductionScreenState.hidden,
            ArenaProductionScreenState.resolved,
            ArenaProductionScreenState.canceled,
          ],
          notes:
              'Trust-first: tab mặc định là luật chơi, safety snapshot trước CTA.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaSafetyCenterPage',
          route: '/arena/safety',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.error,
          ],
          notes:
              'Trung tâm an toàn: chính sách, báo cáo, chặn users, quy tắc cộng đồng.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaResolutionCenterPage',
          route: '/arena/resolution',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
            ArenaProductionScreenState.resolved,
          ],
          notes:
              'Chốt kết quả: method-specific UI, evidence, timeline, receipt sheet.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaPointsLedgerPage',
          route: '/arena/ledger',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
          ],
          notes:
              'Full audit trail: filter chips, search, balance summary, tappable rows.',
        ),
        ArenaProductionScreenDraft(
          name: 'MyArenaPage',
          route: '/profile/arena',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
          ],
          notes:
              '3 mục riêng: challenges, modes, settings; links to reports + blocked users.',
        ),
      ],
      supportingScreens: [
        ArenaProductionScreenDraft(
          name: 'ArenaPointsPage',
          route: '/arena/points',
          status: ArenaProductionScreenStatus.live,
          version: 'v2',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
          ],
          notes: 'Points hub: tasks, history, ledger link.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaPointsEntryDetailPage',
          route: '/arena/ledger/entry/:entryId',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.empty,
          ],
          notes: 'Chi tiết giao dịch điểm: amount hero, balance, refId.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaJoinPage',
          route: '/arena/join/:id',
          status: ArenaProductionScreenStatus.live,
          version: 'v2',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.error,
          ],
          notes: 'Preview trước join: entry pts, checkboxes, fee.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaCreatorPage',
          route: '/arena/creator/:id',
          status: ArenaProductionScreenStatus.live,
          version: 'v2',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.empty,
          ],
          notes: 'Creator profile: modes, challenges, trust, report modal.',
        ),
        ArenaProductionScreenDraft(
          name: 'VerifiedChallengesPage',
          route: '/arena/verified',
          status: ArenaProductionScreenStatus.future,
          version: 'v1',
          states: [ArenaProductionScreenState.defaultView],
          notes: 'Placeholder: sẽ mở trong tương lai.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaFlowMapPage',
          route: '/arena/flow-map',
          status: ArenaProductionScreenStatus.qaOnly,
          version: 'v1',
          states: [ArenaProductionScreenState.defaultView],
          notes: 'Flow visualization cho dev/QA, không phải user-facing.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaProductionReadyPage',
          route: '/arena/production',
          status: ArenaProductionScreenStatus.qaOnly,
          version: 'v1',
          states: [ArenaProductionScreenState.defaultView],
          notes: 'Trang handoff dashboard này.',
        ),
      ],
      flows: [
        ArenaProductionFlowDraft(
          id: 'creator',
          name: 'Creator Flow',
          steps: [
            ArenaProductionFlowStepDraft(
              label: 'ArenaHome',
              route: '/arena',
              description: 'Tap tạo challenge.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'ArenaStudio',
              route: '/arena/studio',
              description: 'Template -> cấu trúc -> luật -> review.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description: 'Challenge created, share link.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'Resolution',
              route: '/arena/resolution',
              description: 'Khi hết hạn -> chốt kết quả.',
            ),
          ],
        ),
        ArenaProductionFlowDraft(
          id: 'moderation',
          name: 'Moderation Flow',
          steps: [
            ArenaProductionFlowStepDraft(
              label: 'ReportDialog',
              route: '/arena/challenge/:id',
              description: 'Chọn lý do và gửi báo cáo.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'MyArenaReports',
              route: '/arena/my-reports',
              description: 'Theo dõi các case đã gửi.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'ReportCase',
              route: '/arena/report/:caseId',
              description: 'Case detail, timeline, appeal.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'Safety Center',
              route: '/arena/safety',
              description: 'Community rules, blocked users.',
            ),
          ],
        ),
        ArenaProductionFlowDraft(
          id: 'points_audit',
          name: 'Points Audit Flow',
          steps: [
            ArenaProductionFlowStepDraft(
              label: 'ArenaPoints',
              route: '/arena/points',
              description: 'Balance overview, tasks, history.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'PointsLedger',
              route: '/arena/ledger',
              description: 'Full audit trail with filters.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'EntryDetail',
              route: '/arena/ledger/entry/:entryId',
              description: 'Amount, type, balance, refId.',
            ),
          ],
        ),
      ],
      components: [
        ArenaProductionComponentDraft(
          name: 'StatusChip',
          file: 'ArenaChips.tsx',
          type: 'chip',
          description: 'Challenge states: open, live, full, resolved, hidden.',
        ),
        ArenaProductionComponentDraft(
          name: 'ReportDialog',
          file: 'ArenaModeration.tsx',
          type: 'dialog',
          description: 'Report modal with reason options and text input.',
        ),
        ArenaProductionComponentDraft(
          name: 'ResultReceiptSheet',
          file: 'ArenaResultReceipt.tsx',
          type: 'sheet',
          description: 'Settlement receipt with pool and ledger refs.',
        ),
        ArenaProductionComponentDraft(
          name: 'PublishEligibilityPanel',
          file: 'ArenaStudioGovernance.tsx',
          type: 'card',
          description: 'Eligibility checks before publishing challenge.',
        ),
      ],
      dictionaries: [
        ArenaProductionDictionaryDraft(
          category: 'Resolution Methods',
          items: [
            ArenaProductionDictionaryItemDraft(
              code: 'auto',
              label: 'Tự động',
              description: 'Kết quả từ nguồn dữ liệu bên ngoài.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'mutual_confirm',
              label: 'Xác nhận 2 bên',
              description: 'Tất cả bên phải xác nhận kết quả.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'community_vote',
              label: 'Bình chọn cộng đồng',
              description: 'Bỏ phiếu với ngưỡng tối thiểu.',
            ),
          ],
        ),
        ArenaProductionDictionaryDraft(
          category: 'Ledger Reason Codes',
          items: [
            ArenaProductionDictionaryItemDraft(
              code: 'earned',
              label: 'Nhận',
              description: 'Points nhận được từ task, check-in hoặc thắng.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'entry',
              label: 'Tham gia',
              description: 'Khấu trừ khi join challenge.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'refund',
              label: 'Hoàn điểm',
              description: 'Hoàn khi challenge bị void hoặc cancel.',
            ),
          ],
        ),
      ],
      qaItems: [
        'Tap targets >= 44pt / 48dp',
        'Contrast >= 4.5:1 cho text thường',
        'Fee breakdown trước confirm Points',
        'Error, empty, loading states đầy đủ',
        'Không có dark patterns hoặc FOMO copy',
        'Arena Points disclaimer hiển thị rõ',
        'Routes DRY qua route config',
      ],
      disclaimer:
          'Trang này chỉ dành cho internal handoff. Không deploy lên production build. Open Arena = points-only, không phải tài sản tài chính.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaPredictionBridgeSnapshot getArenaPredictionBridge() {
    return const ArenaPredictionBridgeSnapshot(
      endpoint: '/api/mobile/arena/arena-bridge',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      principles: [
        ArenaBridgePrincipleDraft(
          number: 1,
          title: 'Connect by content, not by value',
          description:
              'Bridge chỉ qua topic/category/event title. Không bao giờ qua tiền, wallet, hoặc số dư.',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgePrincipleDraft(
          number: 2,
          title: 'Arena Points không phải tài sản tài chính',
          description:
              'Points chỉ là điểm xã hội. Không quy đổi, không rút, không trade.',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgePrincipleDraft(
          number: 3,
          title: 'Prediction Markets không chia sẻ wallet/số dư với Arena',
          description:
              'Wallet, balance, P/L của Prediction hoàn toàn tách biệt. Không hiển thị chéo.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgePrincipleDraft(
          number: 4,
          title: 'Mọi bridge đều phải có disclosure',
          description:
              'ModuleBoundaryBanner hoặc BoundaryInfoRow bắt buộc khi hiển thị content cross-module.',
          tone: ArenaBridgeTone.disclosure,
        ),
        ArenaBridgePrincipleDraft(
          number: 5,
          title: 'Không gộp leaderboard metrics',
          description:
              'Leaderboard Prediction khác Leaderboard Arena. Không tổng hợp, không so sánh.',
          tone: ArenaBridgeTone.danger,
        ),
        ArenaBridgePrincipleDraft(
          number: 6,
          title: 'Không gộp settlement / receipts / ledger',
          description:
              'ResultReceipt, Points Ledger, Order Receipt là 3 hệ thống riêng. Không merge.',
          tone: ArenaBridgeTone.blocked,
        ),
      ],
      allowedItems: [
        ArenaBridgeRuleDraft(
          label: 'Topic',
          description: 'Chủ đề chung: Crypto, Macro, Sports...',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Category',
          description: 'Phân loại event/mode',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Event title',
          description: 'Tên sự kiện prediction làm bối cảnh',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Source label',
          description: 'Label "Nguồn bối cảnh"',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'EventId context',
          description: 'Link đến event detail (read-only)',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Trust/Safety summary',
          description: 'Trust score, Fair Play badge',
          allowed: true,
        ),
      ],
      notAllowedItems: [
        ArenaBridgeRuleDraft(
          label: 'Wallet balance',
          description: 'Không hiển thị số dư ví ở module khác',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'PnL',
          description: 'Không hiển thị lãi/lỗ prediction ở Arena',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Open orders',
          description: 'Không hiển thị lệnh đang mở chéo module',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Payout value',
          description: 'Không hiển thị tiền thật ở Arena',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Order receipt',
          description: 'Không gộp receipt prediction + arena',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Points conversion',
          description: 'Không quy đổi Arena Points thành tiền',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Shared settlement',
          description: 'Không kết hợp settlement 2 module',
          allowed: false,
        ),
      ],
      topics: [
        ArenaBridgeTopicDraft(
          id: 'crypto',
          label: 'Crypto',
          predictionUsage: 'category filter, event tags',
          arenaUsage: 'mode tags, room filter',
          bridgeUsage: 'bridge matching key',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeTopicDraft(
          id: 'macro',
          label: 'Macro',
          predictionUsage: 'macro event grouping',
          arenaUsage: 'forecast challenge tags',
          bridgeUsage: 'topic-only context',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeTopicDraft(
          id: 'politics',
          label: 'Politics',
          predictionUsage: 'event category',
          arenaUsage: 'discussion mode tag',
          bridgeUsage: 'read-only context',
          tone: ArenaBridgeTone.danger,
        ),
        ArenaBridgeTopicDraft(
          id: 'sports',
          label: 'Sports',
          predictionUsage: 'match event tags',
          arenaUsage: 'friendly challenge tags',
          bridgeUsage: 'topic-only context',
          tone: ArenaBridgeTone.disclosure,
        ),
        ArenaBridgeTopicDraft(
          id: 'tech',
          label: 'Tech',
          predictionUsage: 'launch / adoption events',
          arenaUsage: 'creator mode tags',
          bridgeUsage: 'shared taxonomy',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeTopicDraft(
          id: 'ai',
          label: 'AI',
          predictionUsage: 'AI market events',
          arenaUsage: 'AI challenge tags',
          bridgeUsage: 'shared taxonomy',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeTopicDraft(
          id: 'culture',
          label: 'Culture',
          predictionUsage: 'culture event tags',
          arenaUsage: 'community challenge tags',
          bridgeUsage: 'content discovery',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeTopicDraft(
          id: 'community',
          label: 'Community',
          predictionUsage: 'community event tags',
          arenaUsage: 'creator discovery tags',
          bridgeUsage: 'safe discovery',
          tone: ArenaBridgeTone.disclosure,
        ),
      ],
      boundaryBanners: [
        ArenaBridgeBoundaryDraft(
          id: 'arena_points_only',
          title: 'Arena Points only',
          description:
              'Arena Points không phải tài sản tài chính. Không quy đổi, không rút được.',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'prediction_market',
          title: 'Prediction Markets',
          description:
              'Vị thế thực trên thị trường dự đoán, tách biệt hoàn toàn với Arena Points.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'market_context_only',
          title: 'Market context only',
          description:
              'Chỉ dùng làm bối cảnh tham khảo. Không ảnh hưởng vị thế hoặc số dư.',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'no_wallet_link',
          title: 'Không liên quan Wallet',
          description:
              'Module này không kết nối với ví hoặc số dư tài sản của bạn.',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'verified_future',
          title: 'Verified - Future',
          description: 'Tính năng Verified Challenges sẽ mở trong tương lai.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'risk_disclosure',
          title: 'Lưu ý rủi ro',
          description:
              'Prediction Markets có rủi ro. Arena Points không phải tiền thật.',
          tone: ArenaBridgeTone.danger,
        ),
      ],
      badges: [
        ArenaBridgeBadgeDraft(
          id: 'open_arena',
          label: 'Open Arena',
          description: 'Points-only challenge surface',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeBadgeDraft(
          id: 'prediction_markets',
          label: 'Prediction Markets',
          description: 'Value-based prediction surface',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeBadgeDraft(
          id: 'linked_context',
          label: 'Linked Context',
          description: 'Topic/event context only',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeBadgeDraft(
          id: 'future',
          label: 'Future',
          description: 'Not available in production yet',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeBadgeDraft(
          id: 'creator_mode',
          label: 'Creator Mode',
          description: 'Arena creator flow',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeBadgeDraft(
          id: 'event_context',
          label: 'Event Context',
          description: 'Read-only Prediction event context',
          tone: ArenaBridgeTone.content,
        ),
      ],
      infoRows: [
        ArenaBridgeInfoRowDraft(
          text: 'Arena Points không phải tài sản tài chính.',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeInfoRowDraft(
          text: 'Prediction Markets tách biệt hoàn toàn.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeInfoRowDraft(
          text: 'Module này không liên quan ví của bạn.',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeInfoRowDraft(
          text: 'Chỉ dùng làm bối cảnh tham khảo.',
          tone: ArenaBridgeTone.content,
        ),
      ],
      bridgeComponents: [
        ArenaBridgeComponentDraft(
          name: 'PredictionContextCard',
          badgeLabel: 'Event context',
          description:
              'Dùng trong Arena pages. Hiển thị bối cảnh thị trường prediction, không phải trading UI.',
          sampleTitle: 'BTC vượt 100,000 USD trước 31/03/2026?',
          sampleMeta: 'Yes · 72% probability · read-only context',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeComponentDraft(
          name: 'ArenaRelatedRoomCard',
          badgeLabel: 'Open Arena',
          description:
              'Dùng trong Prediction pages. Room card có trust badge, resolution, privacy.',
          sampleTitle: 'Fed Rate Predict - March 2026',
          sampleMeta: '50 pts · 67/100 slots · Fair Play 88',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeComponentDraft(
          name: 'DualModuleStatCard',
          badgeLabel: 'Linked context',
          description:
              'Dùng trên Profile. 2 khối stats tách biệt, không gộp số liệu.',
          sampleTitle: 'Prediction block + Arena block',
          sampleMeta: 'Tap từng block để mở module riêng',
          tone: ArenaBridgeTone.disclosure,
        ),
        ArenaBridgeComponentDraft(
          name: 'BridgeSourceBar',
          badgeLabel: 'Market context only',
          description:
              'Dùng trong Arena Studio khi user đến từ Prediction event. Có remove action.',
          sampleTitle: 'Nguồn bối cảnh: BTC vượt 100,000 USD?',
          sampleMeta: 'Topic Crypto · Event pred-1 · removable',
          tone: ArenaBridgeTone.content,
        ),
      ],
      examples: [
        ArenaBridgeExampleDraft(
          id: 'example_a',
          status: ArenaBridgeExampleStatus.correct,
          title: 'PredictionContextCard trong Arena Challenge',
          description:
              'Hiển thị bối cảnh prediction bên trong challenge detail với badge rõ ràng.',
          frameTitle: 'ArenaChallengeDetailPage',
          evidenceRows: [
            'Disclosure badge + microcopy bắt buộc.',
            'Không hiển thị order/PnL.',
          ],
        ),
        ArenaBridgeExampleDraft(
          id: 'example_b',
          status: ArenaBridgeExampleStatus.correct,
          title: 'ArenaRelatedRoomCard trong Prediction Event',
          description:
              'Hiển thị room Arena liên quan cùng topic, có Points-only badge.',
          frameTitle: 'PredictionEventDetailPage',
          evidenceRows: [
            'Trust badge + Points-only badge bắt buộc.',
            'Không hiển thị wallet balance.',
          ],
        ),
        ArenaBridgeExampleDraft(
          id: 'example_c',
          status: ArenaBridgeExampleStatus.correct,
          title: 'DualModuleStatCard trên Profile',
          description:
              '2 block tách biệt với boundary separator. Số liệu không gộp.',
          frameTitle: 'ProfilePage',
          evidenceRows: ['Mỗi block có badge riêng.', 'Tap mở module riêng.'],
        ),
        ArenaBridgeExampleDraft(
          id: 'example_d',
          status: ArenaBridgeExampleStatus.blocked,
          title: 'Gộp Points + PnL',
          description:
              'Anti-pattern tạo nhầm lẫn giữa tiền thật và điểm xã hội.',
          frameTitle: 'WRONG - MergedStatsCard',
          evidenceRows: [
            'Không gộp Points + PnL vào cùng 1 card.',
            'Không hiển thị tổng tài sản gộp 2 module.',
            'Không so sánh Points = tiền thật.',
          ],
        ),
      ],
      dualStats: ArenaBridgeDualStatsDraft(
        predictionPositions: 5,
        predictionPnlLabel: '+127.50 USD',
        predictionPnlPositive: true,
        arenaPointsLabel: '2,450 pts',
        arenaRooms: 3,
      ),
      footerDisclosure:
          'Foundation layer - boundary phải khóa trước khi nối flow. Open Arena = Points only. Prediction Markets = Real positions. Không bao giờ gộp.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ConnectedEcosystemProductionSnapshot getConnectedEcosystemProduction() {
    return const ConnectedEcosystemProductionSnapshot(
      endpoint: '/api/mobile/arena/arena-ecosystem',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      canonicalScreens: [
        ConnectedScreenDraft(
          name: 'HomePage_vFinal_Connected',
          route: '/',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['HomeDiscoverySection'],
          notes:
              'Discovery cards cho Predictions và Arena. Mỗi card có disclosure badge rõ module. Không merge metrics.',
        ),
        ConnectedScreenDraft(
          name: 'ProfilePage_vFinal_Connected',
          route: '/profile',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09A + 09B',
          bridgeComponents: ['ProfileModuleBlocks', 'DualModuleStatCard'],
          notes:
              'Dual surface tách biệt: Prediction Portfolio vs MyArena. Stats không bao giờ gộp.',
        ),
        ConnectedScreenDraft(
          name: 'MarketListPage_vFinal_Connected',
          route: '/markets',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['DiscoverMoreSection'],
          notes:
              'Khám phá thêm section cuối page. Safe bridge dẫn đến Predictions hoặc Arena, có disclosure.',
        ),
        ConnectedScreenDraft(
          name: 'PredictionsHomePage_vFinal_Connected',
          route: '/markets/predictions',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09A',
          bridgeComponents: ['TopicChipBar (shared taxonomy)'],
          notes:
              'Topic chips dùng shared taxonomy. Discovery card Arena ở cuối với badge Points only.',
        ),
        ConnectedScreenDraft(
          name: 'PredictionEventDetailPage_vFinal_Connected',
          route: '/markets/predictions/event/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B + 09C + 09D',
          bridgeComponents: [
            'ArenaRelatedRoomsSection',
            'ArenaBridgeConfirmSheet',
            'mapCategoryToTopic',
          ],
          notes:
              'Arena rooms bridge section + CTA tạo Arena từ event này, qua confirmation sheet trước khi mở Arena Studio.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaHomePage_vFinal_Connected',
          route: '/arena',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['PredictionInsightSection'],
          notes:
              'Prediction insight section ở cuối. Badge Market context only, không ảnh hưởng Arena Points.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaStudioPage_vFinal_Connected',
          route: '/arena/studio',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09D',
          bridgeComponents: [
            'BridgeSourceBar',
            'ModuleBoundaryBanner',
            'Bridge Safety Snapshot',
            'Linked Event rows',
          ],
          notes:
              'Khi mở từ Prediction: source bar top, suggest templates, prefill context, safety snapshot và linked event rows.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaModeDetailPage_vFinal_Connected',
          route: '/arena/mode/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09C',
          bridgeComponents: ['PredictionContextCard', 'mapArenaTagToTopic'],
          notes:
              'Mode có tags liên quan prediction topic hiển thị context card với CTA xem thị trường dự đoán.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaChallengeDetailPage_vFinal_Connected',
          route: '/arena/challenge/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09C + 09D',
          bridgeComponents: [
            'PredictionContextCard',
            'LinkedSourceCard',
            'ModuleBoundaryBanner',
            'BoundaryInfoRow',
            'Boundary sheet',
          ],
          notes:
              'Prediction context bridge + linked source card. Disclosure: kết quả room Arena không phải kết quả trade.',
        ),
      ],
      bridgeStates: [
        ConnectedBridgeStateDraft(
          id: 'linked_available',
          label: 'Linked context available',
          description:
              'Bridge context tồn tại và valid. Hiển thị bridge card + disclosure.',
          tone: ArenaBridgeTone.disclosure,
          affectedScreens: [
            'PredictionEventDetail',
            'ArenaStudio',
            'ArenaChallengeDetail',
            'ArenaModeDetail',
          ],
          behavior:
              'Show bridge card, context bar, related rooms/events. Disclosure badge luôn hiện.',
        ),
        ConnectedBridgeStateDraft(
          id: 'linked_unavailable',
          label: 'Linked context unavailable',
          description: 'Event hoặc room nguồn không còn tồn tại hoặc bị xoá.',
          tone: ArenaBridgeTone.blocked,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaStudio'],
          behavior:
              'Show fallback card, disable CTA xem event gốc, giữ room hoạt động bình thường.',
        ),
        ConnectedBridgeStateDraft(
          id: 'stale_context',
          label: 'Stale context',
          description: 'Context quá cũ hoặc event đã resolved/expired.',
          tone: ArenaBridgeTone.arena,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaStudio'],
          behavior:
              'Show warning chip Context cũ. CTA vẫn navigate đến event ở trạng thái resolved.',
        ),
        ConnectedBridgeStateDraft(
          id: 'no_arena_rooms',
          label: 'No related Arena rooms',
          description: 'Prediction event chưa có rooms Arena liên quan.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['PredictionEventDetail'],
          behavior:
              'Ẩn ArenaRelatedRoomsSection, vẫn giữ CTA tạo Arena từ event này.',
        ),
        ConnectedBridgeStateDraft(
          id: 'no_prediction_events',
          label: 'No related Prediction events',
          description:
              'Arena mode/challenge không có Prediction events match topic.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaModeDetail'],
          behavior:
              'Ẩn PredictionContextCard và link hiểu ranh giới. Room hoạt động bình thường.',
        ),
        ConnectedBridgeStateDraft(
          id: 'bridge_disabled',
          label: 'Bridge disabled',
          description:
              'Feature flag tắt bridge do maintenance hoặc chưa launch.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['All connected screens'],
          behavior:
              'Ẩn toàn bộ bridge sections, không hiện error hay empty state.',
        ),
        ConnectedBridgeStateDraft(
          id: 'context_removed',
          label: 'Context removed by user',
          description: 'User bấm bỏ liên kết trên BridgeSourceBar.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['ArenaStudio'],
          behavior:
              'Ẩn BridgeSourceBar, steps trở về trạng thái tạo room thường.',
        ),
        ConnectedBridgeStateDraft(
          id: 'verified_locked',
          label: 'Verified future locked',
          description: 'Bridge features chưa mở cho verified/future screens.',
          tone: ArenaBridgeTone.prediction,
          affectedScreens: ['VerifiedChallengesPage'],
          behavior: 'Hiện placeholder message, không navigate và không CTA.',
        ),
      ],
      connectedFlows: [
        ConnectedFlowDraft(
          id: 'prediction_to_arena',
          name: 'Prediction to Arena Studio',
          tone: ArenaBridgeTone.arena,
          steps: [
            ConnectedFlowStepDraft(
              label: 'Home',
              route: '/',
              description: 'Discovery section -> tap Predictions card.',
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionsHome',
              route: '/markets/predictions',
              description: 'Browse events, filter by topic.',
            ),
            ConnectedFlowStepDraft(
              label: 'EventDetail',
              route: '/markets/predictions/event/:id',
              description: 'Xem event, scroll đến Arena section.',
            ),
            ConnectedFlowStepDraft(
              label: 'ConfirmSheet',
              route: '/markets/predictions/event/:id',
              description:
                  'Tạo room Arena từ event này? Confirmation sheet có 3 disclosure bullets.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ArenaStudio',
              route: '/arena/studio',
              description:
                  'BridgeSourceBar top, suggested templates, prefill context.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description: 'Room created, linked source card hiện event gốc.',
              isBridge: true,
            ),
          ],
        ),
        ConnectedFlowDraft(
          id: 'arena_to_prediction',
          name: 'Arena to Prediction Market',
          tone: ArenaBridgeTone.content,
          steps: [
            ConnectedFlowStepDraft(
              label: 'ArenaHome',
              route: '/arena',
              description: 'Browse modes and rooms.',
            ),
            ConnectedFlowStepDraft(
              label: 'ModeDetail',
              route: '/arena/mode/:id',
              description:
                  'PredictionContextCard hiện khi mode có related topic.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description: 'Context card + sheet hiểu ranh giới.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionEvent',
              route: '/markets/predictions/event/:id',
              description: 'Navigate qua CTA xem thị trường dự đoán.',
              isBridge: true,
            ),
          ],
        ),
        ConnectedFlowDraft(
          id: 'profile_dual',
          name: 'Profile dual surfaces',
          tone: ArenaBridgeTone.prediction,
          steps: [
            ConnectedFlowStepDraft(
              label: 'Profile',
              route: '/profile',
              description: 'ProfileModuleBlocks: 2 cards tách biệt.',
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionPortfolio',
              route: '/markets/predictions/portfolio',
              description: 'Prediction card -> positions and P/L.',
            ),
            ConnectedFlowStepDraft(
              label: 'MyArena',
              route: '/profile/arena',
              description:
                  'Arena card -> Points, rooms, trust score, non-financial.',
              isBridge: true,
            ),
          ],
        ),
        ConnectedFlowDraft(
          id: 'market_discover',
          name: 'MarketList to Khám phá thêm',
          tone: ArenaBridgeTone.disclosure,
          steps: [
            ConnectedFlowStepDraft(
              label: 'MarketList',
              route: '/markets',
              description: 'Browse crypto, scroll đến cuối.',
            ),
            ConnectedFlowStepDraft(
              label: 'DiscoverMore',
              route: '/markets',
              description: 'Predictions card + Arena card.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'Choice: Predictions',
              route: '/markets/predictions',
              description: 'Tap Dự đoán thị trường -> PredictionsHome.',
            ),
            ConnectedFlowStepDraft(
              label: 'Choice: Arena',
              route: '/arena',
              description: 'Tap Open Arena -> ArenaHome.',
            ),
          ],
        ),
      ],
      sharedItems: [
        ConnectedRegistryItemDraft(
          name: 'Topic Taxonomy',
          description: '8 shared topics dùng chung cho Predictions và Arena.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Context Cards',
          description:
              'PredictionContextCard và ArenaRelatedRoomCard bridge by content, not value.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Discovery Cards',
          description:
              'HomeDiscoverySection và DiscoverMoreSection là entry points an toàn.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Profile Surface',
          description:
              'ProfileModuleBlocks đặt 2 blocks tách biệt trên cùng một profile page.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Bridge Disclosures',
          description:
              'ModuleBoundaryBanner, BoundaryInfoRow, ModuleLabelBadge dùng chung.',
        ),
      ],
      separateItems: [
        ConnectedRegistryItemDraft(
          name: 'Wallet',
          description: 'Prediction có real wallet. Arena không có wallet.',
        ),
        ConnectedRegistryItemDraft(
          name: 'PnL',
          description:
              'Prediction có profit/loss bằng tiền thật. Arena chỉ có net points change.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Points Ledger',
          description: 'Arena only. Prediction không dùng points system.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Order Receipts',
          description:
              'Prediction trade receipts khác Arena result receipt points-only.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Settlement',
          description:
              'Prediction settlement tách biệt với Arena points redistribution.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Leaderboard Metrics',
          description: 'Prediction ranking và Arena ranking không bao giờ gộp.',
        ),
      ],
      forbiddenPatterns: [
        ConnectedForbiddenPatternDraft(
          pattern: 'Points cạnh PnL',
          reason:
              'Arena Points là điểm chơi, PnL là tiền thật. Đặt cạnh nhau gây nhầm lẫn.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Merged leaderboard',
          reason: 'Gộp points Arena với PnL Prediction sai bản chất 2 module.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Wallet wording trong Arena',
          reason: 'Không dùng Ví, Số dư, Tài sản trong Arena bridge context.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Arena card thiếu disclosure',
          reason:
              'Mọi bridge card Arena phải có badge Points only hoặc Market context only.',
          severity: ConnectedRuleSeverity.high,
        ),
      ],
      routeRegistry: [
        ConnectedRouteEntryDraft(
          route: '/',
          page: 'HomePage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['HomeDiscoverySection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/profile',
          page: 'ProfilePage',
          bridgeType: ConnectedBridgeType.bidirectional,
          bridgeComponents: ['ProfileModuleBlocks'],
        ),
        ConnectedRouteEntryDraft(
          route: '/markets',
          page: 'MarketListPage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['DiscoverMoreSection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/markets/predictions',
          page: 'PredictionsHomePage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['TopicChipBar'],
        ),
        ConnectedRouteEntryDraft(
          route: '/markets/predictions/event/:id',
          page: 'PredictionEventDetailPage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['ArenaRelatedRoomsSection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena',
          page: 'ArenaHomePage',
          bridgeType: ConnectedBridgeType.target,
          bridgeComponents: ['PredictionInsightSection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena/studio',
          page: 'ArenaStudioPage',
          bridgeType: ConnectedBridgeType.target,
          bridgeComponents: ['BridgeSourceBar'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena/mode/:id',
          page: 'ArenaModeDetailPage',
          bridgeType: ConnectedBridgeType.target,
          bridgeComponents: ['PredictionContextCard'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena/challenge/:id',
          page: 'ArenaChallengeDetailPage',
          bridgeType: ConnectedBridgeType.bidirectional,
          bridgeComponents: ['PredictionContextCard', 'LinkedSourceCard'],
        ),
      ],
      componentRegistry: [
        ConnectedComponentEntryDraft(
          name: 'HomeDiscoverySection',
          file: 'ArenaPredictionBridges.tsx',
          module: '07D',
          usedIn: ['HomePage'],
          disclosure: 'Mỗi card có badge module.',
        ),
        ConnectedComponentEntryDraft(
          name: 'PredictionContextCard',
          file: 'ArenaPredictionBridges.tsx',
          module: '07D',
          usedIn: ['ArenaChallengeDetail', 'ArenaModeDetail'],
          disclosure: 'Market context only badge.',
        ),
        ConnectedComponentEntryDraft(
          name: 'BridgeSourceBar',
          file: 'ArenaPredictionFoundation.tsx',
          module: '09A',
          usedIn: ['ArenaStudio'],
          disclosure: 'Nguồn bối cảnh + remove action.',
        ),
        ConnectedComponentEntryDraft(
          name: 'DualModuleStatCard',
          file: 'ArenaPredictionFoundation.tsx',
          module: '09A',
          usedIn: ['ProfileModuleBlocks'],
          disclosure: 'Separate stat blocks.',
        ),
      ],
      bridgeRules: [
        ConnectedBridgeRuleDraft(
          field: 'eventId',
          allowed: true,
          reason: 'Identify prediction event nguồn, chỉ dùng để link back.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'topic',
          allowed: true,
          reason: 'Shared topic taxonomy. Neutral content classification.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'wallet balance',
          allowed: false,
          reason: 'Số dư ví là dữ liệu tài chính, không carry qua Arena.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'PnL',
          allowed: false,
          reason: 'Profit/loss là dữ liệu giao dịch thật, Arena chỉ có points.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'settlement records',
          allowed: false,
          reason: 'Arena chỉ settle points, không nhận settlement tài chính.',
        ),
      ],
      qaChecklist: [
        ConnectedQaCheckDraft(
          id: 'qa1',
          category: 'Disclosure',
          check: 'Mọi bridge card có disclosure badge.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa2',
          category: 'Boundary',
          check: 'Prediction và Arena stats tách biệt, không gộp.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa3',
          category: 'Navigation',
          check:
              'Prediction -> Arena flow có confirmation sheet trước navigate.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa4',
          category: 'State',
          check: 'Bridge disabled state ẩn sạch bridge sections.',
          severity: ConnectedQaSeverity.should,
        ),
      ],
      footerDisclosure:
          'Trang này dành cho PM / Designer / Dev / QA, không phải user-facing. Toàn bộ nội dung là handoff documentation cho hệ sinh thái kết nối giữa Open Arena (points-only) và Prediction Markets (real positions).',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaGuideSnapshot getArenaGuide() {
    return const ArenaGuideSnapshot(
      endpoint: '/api/mobile/arena/arena-guide',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      heroTitle: 'Tạo challenge đầu tiên trong 5 phút',
      heroSubtitle:
          'Chỉ 6 bước đơn giản - có gợi ý thông minh giúp bạn tạo challenge hấp dẫn',
      createSteps: [
        ArenaGuideStepDraft(
          step: 1,
          iconKey: 'layers',
          title: 'Chọn Template',
          description:
              'Chọn template phù hợp: Dự đoán, Thử thách, Cá cược bạn bè. Mỗi template có luật và cấu trúc sẵn giúp bạn bắt đầu nhanh.',
          tip: 'Bắt đầu với "Dự đoán giá" - đơn giản và phổ biến nhất.',
          tone: ArenaGuideTone.accent,
        ),
        ArenaGuideStepDraft(
          step: 2,
          iconKey: 'users',
          title: 'Thiết lập cấu trúc',
          description:
              'Chọn format: 1v1, team vs team hoặc Open Lobby. Cài đặt số người tham gia tối đa và kiểu tham gia.',
          tip: 'Open Lobby phù hợp khi bạn muốn nhiều người tham gia.',
          tone: ArenaGuideTone.info,
        ),
        ArenaGuideStepDraft(
          step: 3,
          iconKey: 'file',
          title: 'Viết luật chơi',
          description:
              'Đặt tên, mô tả rõ ràng, chọn điều kiện thắng, luật hòa và luật hủy. Luật càng rõ - tranh chấp càng ít.',
          tip: 'Dùng Smart Rule Builder để tạo luật chuyên nghiệp tự động.',
          tone: ArenaGuideTone.success,
        ),
        ArenaGuideStepDraft(
          step: 4,
          iconKey: 'target',
          title: 'Chọn cách xác nhận kết quả',
          description:
              'Auto, Mutual Confirm, Referee hoặc Community Vote. Chọn phương án phù hợp với loại challenge.',
          tip: 'Auto resolution ít tranh chấp nhất - ưu tiên khi có thể.',
          tone: ArenaGuideTone.warning,
        ),
        ArenaGuideStepDraft(
          step: 5,
          iconKey: 'gift',
          title: 'Cài đặt Points & Phần thưởng',
          description:
              'Đặt entry points, chọn kiểu chia pool điểm như Winner All, Top 3 hoặc chia đều. Xem trước pool dự kiến.',
          tip: 'Entry 50-200 pts thu hút nhiều người nhất theo thống kê.',
          tone: ArenaGuideTone.danger,
        ),
        ArenaGuideStepDraft(
          step: 6,
          iconKey: 'check',
          title: 'Review & Đăng',
          description:
              'Kiểm tra toàn bộ thông tin, preview trước khi publish. Hệ thống sẽ kiểm tra Rule Clarity Score và đưa gợi ý.',
          tip: 'Rule Clarity Score >= 80% - challenge ít bị tranh chấp.',
          tone: ArenaGuideTone.arena,
        ),
      ],
      joinSteps: [
        ArenaGuideStepDraft(
          step: 1,
          iconKey: 'search',
          title: 'Tìm challenge phù hợp',
          description:
              'Duyệt phòng đang mở, lọc theo category, format, entry points hoặc tìm kiếm theo tên.',
          tip: 'Lọc theo Fair Play để chơi an toàn hơn.',
          tone: ArenaGuideTone.info,
        ),
        ArenaGuideStepDraft(
          step: 2,
          iconKey: 'eye',
          title: 'Xem chi tiết & luật chơi',
          description:
              'Đọc kỹ luật, điều kiện thắng và cách xác nhận kết quả. Kiểm tra Trust Score của creator.',
          tip: 'Creator có Trust >= 85% thường tạo challenge chất lượng.',
          tone: ArenaGuideTone.accent,
        ),
        ArenaGuideStepDraft(
          step: 3,
          iconKey: 'zap',
          title: 'Tham gia bằng Arena Points',
          description:
              'Xác nhận entry points và chọn vị trí hoặc đội nếu có. Points được khóa trong pool đến khi có kết quả.',
          tip: 'Points được khóa an toàn - không ai rút trước kết quả.',
          tone: ArenaGuideTone.warning,
        ),
        ArenaGuideStepDraft(
          step: 4,
          iconKey: 'trophy',
          title: 'Chờ kết quả & nhận points',
          description:
              'Kết quả tự xác nhận hoặc cần vote. Nếu thắng, Arena Points được cộng theo luật pool đã công bố.',
          tip: 'Theo dõi timeline trực tiếp trên trang challenge.',
          tone: ArenaGuideTone.success,
        ),
      ],
      proTips: [
        ArenaGuideTipDraft(
          iconKey: 'target',
          title: 'Đặt tên hấp dẫn, rõ ràng',
          description:
              'Tên tốt: "BTC phá 100K trước 30/6?" - ngắn, rõ chủ đề, có deadline. Tránh tiêu đề mơ hồ.',
          category: 'naming',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'file',
          title: 'Viết luật chơi chi tiết',
          description:
              'Nêu rõ nguồn dữ liệu, điều kiện thắng, cách xử lý hòa hoặc hủy. Smart Rule Builder giúp chuẩn hóa luật.',
          category: 'rules',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'points',
          title: 'Entry points vừa phải',
          description:
              'Entry 50-200 pts thu hút nhiều người và giảm áp lực cho người mới. Entry cao chỉ nên dùng khi creator đã có uy tín.',
          category: 'points',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'clock',
          title: 'Thời hạn hợp lý',
          description:
              'Challenge 1-7 ngày hoạt động tốt nhất. Quá ngắn thì ít người kịp join, quá dài thì giảm hứng thú.',
          category: 'timing',
          impact: ArenaGuideImpact.medium,
        ),
        ArenaGuideTipDraft(
          iconKey: 'tag',
          title: 'Gắn tag đúng category',
          description:
              'Tag chính xác giúp challenge xuất hiện đúng đối tượng. Crypto, Sports, Tech - chọn theo nội dung.',
          category: 'discovery',
          impact: ArenaGuideImpact.medium,
        ),
        ArenaGuideTipDraft(
          iconKey: 'shield',
          title: 'Bật Fair Play badge',
          description:
              'Lưu challenge thành Mode và xây dựng Trust Score. Badge giúp người tham gia hiểu tiêu chuẩn an toàn.',
          category: 'trust',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'auto',
          title: 'Ưu tiên Auto Resolution',
          description:
              'Kết quả tự động giúp giảm tranh chấp. Dùng nguồn dữ liệu uy tín nếu loại challenge cho phép.',
          category: 'resolution',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'trophy',
          title: 'Phân thưởng dễ hiểu',
          description:
              'Top 3 hoặc Top 5 phù hợp khi có nhiều người. Winner Takes All chỉ nên dùng cho 1v1 hoặc nhóm nhỏ.',
          category: 'rewards',
          impact: ArenaGuideImpact.medium,
        ),
      ],
      safetyTips: [
        ArenaGuideSafetyTipDraft(
          iconKey: 'shield',
          title: 'Points, không phải tiền thật',
          description:
              'Arena chỉ dùng Arena Points - không liên quan đến tài sản crypto hay fiat.',
          tone: ArenaGuideTone.info,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'lock',
          title: 'Pool điểm được khóa an toàn',
          description:
              'Entry points được khóa trong pool đến khi challenge kết thúc và có kết quả. Creator không thể rút riêng.',
          tone: ArenaGuideTone.accent,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'warning',
          title: 'Đọc kỹ luật trước khi join',
          description:
              'Luôn đọc hết luật chơi, điều kiện thắng thua và cách xác nhận kết quả trước khi tham gia.',
          tone: ArenaGuideTone.warning,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'eye',
          title: 'Kiểm tra Trust Score creator',
          description:
              'Ưu tiên challenge từ creator có Trust Score cao và Fair Play badge. Xem lịch sử tranh chấp khi cần.',
          tone: ArenaGuideTone.success,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'report',
          title: 'Báo cáo nếu nghi ngờ',
          description:
              'Thấy challenge bất thường? Báo cáo để đội ngũ kiểm tra trong 24h và bảo vệ cộng đồng.',
          tone: ArenaGuideTone.danger,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'file',
          title: 'Tranh chấp có quy trình rõ ràng',
          description:
              'Resolution Center cho phép gửi bằng chứng, theo dõi timeline và nhận kết luận minh bạch.',
          tone: ArenaGuideTone.arena,
        ),
      ],
      faqs: [
        ArenaGuideFaqDraft(
          question: 'Arena Points là gì?',
          answer:
              'Arena Points là đơn vị dùng trong Open Arena để tham gia challenge. Points không phải tiền thật và không liên quan đến crypto hoặc fiat.',
        ),
        ArenaGuideFaqDraft(
          question: 'Tạo challenge có mất phí không?',
          answer:
              'Không mất phí tạo. Nếu đặt entry points, creator có thể cần góp points vào pool theo cấu hình đã công bố.',
        ),
        ArenaGuideFaqDraft(
          question: 'Làm sao để challenge thu hút nhiều người?',
          answer:
              'Đặt tên rõ, entry points vừa phải, luật minh bạch, ưu tiên Auto Resolution và chia sẻ link đúng cộng đồng.',
        ),
        ArenaGuideFaqDraft(
          question: 'Kết quả được xác nhận như thế nào?',
          answer:
              'Có 4 cách: Auto, Mutual Confirm, Referee hoặc Community Vote. Auto thường ít tranh chấp nhất khi có nguồn dữ liệu phù hợp.',
        ),
        ArenaGuideFaqDraft(
          question: 'Nếu tôi không đồng ý kết quả thì sao?',
          answer:
              'Bạn có thể mở tranh chấp trong Resolution Center, gửi bằng chứng và theo dõi quy trình xử lý minh bạch.',
        ),
        ArenaGuideFaqDraft(
          question: 'Rule Clarity Score là gì?',
          answer:
              'Điểm đánh giá mức rõ ràng của luật chơi từ 0-100%. Score cao giúp giảm tranh chấp và tăng độ tin cậy.',
        ),
      ],
      examples: [
        ArenaGuideExampleDraft(
          title: 'BTC phá 100K trước 30/6?',
          template: 'Dự đoán giá',
          entryPoints: 100,
          format: 'Open Lobby',
          resolution: 'Auto',
          rating: 'Tốt',
          tone: ArenaGuideTone.success,
          reasons: [
            'Tên rõ ràng, có deadline',
            'Entry vừa phải',
            'Auto resolution',
          ],
        ),
        ArenaGuideExampleDraft(
          title: 'Ai đoán đúng?',
          template: 'Dự đoán',
          entryPoints: 500,
          format: '1v1',
          resolution: 'Mutual',
          rating: 'Cần cải thiện',
          tone: ArenaGuideTone.warning,
          reasons: [
            'Tên mơ hồ, thiếu chủ đề',
            'Entry cao cho beginner',
            'Thiếu mô tả chi tiết',
          ],
        ),
      ],
      keyConcepts: [
        ArenaGuideConceptDraft(
          term: 'Arena Points',
          definition:
              'Đơn vị dùng trong Open Arena để tham gia challenge. Không phải tiền thật.',
        ),
        ArenaGuideConceptDraft(
          term: 'Template',
          definition:
              'Mẫu challenge có sẵn cấu trúc và luật - bạn chỉ cần điền nội dung.',
        ),
        ArenaGuideConceptDraft(
          term: 'Mode',
          definition:
              'Challenge template đã hoàn chỉnh, có thể chia sẻ và clone bởi người khác.',
        ),
        ArenaGuideConceptDraft(
          term: 'Resolution',
          definition:
              'Cách xác nhận kết quả: Auto, Mutual, Referee hoặc Community Vote.',
        ),
        ArenaGuideConceptDraft(
          term: 'Trust Score',
          definition:
              'Điểm uy tín của creator dựa trên lịch sử tạo challenge và tỷ lệ tranh chấp.',
        ),
        ArenaGuideConceptDraft(
          term: 'Rule Clarity',
          definition:
              'Điểm rõ ràng của luật chơi. Càng cao càng ít tranh chấp.',
        ),
        ArenaGuideConceptDraft(
          term: 'Fair Play',
          definition:
              'Huy hiệu cho challenge hoặc creator tuân thủ quy tắc cộng đồng.',
        ),
      ],
      checklist: [
        'Tên challenge rõ ràng, có chủ đề và deadline',
        'Mô tả đầy đủ điều kiện thắng/thua',
        'Entry points phù hợp đối tượng (50-200 pts)',
        'Chọn Resolution method, ưu tiên Auto khi có thể',
        'Kiểm tra Rule Clarity Score >= 80%',
        'Thiết lập luật hòa và luật hủy',
        'Preview và đọc lại toàn bộ trước khi đăng',
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

String formatArenaPoints(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toString();
}
