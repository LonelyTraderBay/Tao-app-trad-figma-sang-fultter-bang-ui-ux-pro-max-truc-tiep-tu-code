part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryRuleBuilderMethods on _MockArenaRepositoryBase {
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
}
