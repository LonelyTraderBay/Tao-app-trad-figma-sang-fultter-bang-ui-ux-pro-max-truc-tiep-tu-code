import 'package:vit_trade_flutter/features/referral/domain/entities/referral_entities.dart';
import 'package:vit_trade_flutter/features/referral/domain/repositories/referral_repository.dart';

final class MockReferralRepository implements ReferralRepository {
  const MockReferralRepository();

  @override
  ReferralHomeSnapshot getHome() {
    final stats = ReferralHomeStatsDraft(
      totalFriends: _friends.length,
      kycCompleted: _friends.where((friend) => friend.kycCompleted).length,
      activeFriends: _friends
          .where((friend) => friend.status == ReferralFriendStatus.activeTrader)
          .length,
      totalCommission: _completedRewardTotal,
      pendingCommission: _pendingRewardTotal,
      totalVolume: _friends.fold(
        0.0,
        (sum, friend) => sum + friend.totalVolume,
      ),
      thisMonthCommission: 421,
      thisMonthFriends: 2,
    );

    return ReferralHomeSnapshot(
      endpoint: '/api/mobile/referral/referral',
      actionDraft: 'read-only or local navigation action',
      title: 'Giới thiệu bạn bè',
      subtitle: 'Chương trình · Referral',
      backRoute: '/home',
      referralCode: 'VITTA-A2B3C',
      referralLink: 'https://vittrade.vn/ref/VITTA-A2B3C',
      stats: stats,
      currentTier: _tierRules[1],
      nextTier: _tierRules[2],
      campaign: _activeCampaign,
      socialProof: _socialProof,
      milestones: _milestones,
      pendingCommissions: _pendingCommissions,
      leaderboard: _leaderboard,
      detailLinks: [
        ReferralDetailLinkDraft(
          id: 'friends',
          title: 'Bạn bè đã mời (${stats.totalFriends})',
          subtitle: '${stats.kycCompleted} đã KYC',
          route: '/referral/history',
        ),
        ReferralDetailLinkDraft(
          id: 'rewards',
          title: 'Phần thưởng',
          subtitle:
              '${_formatUsd(_completedRewardTotal)} tổng tích luỹ · ${_formatUsd(_pendingRewardTotal)} đang chờ',
          route: '/referral/rewards',
        ),
        ReferralDetailLinkDraft(
          id: 'rules',
          title: 'Bảng hạng & Điều khoản',
          subtitle: 'Hạng hiện tại: Bạc (Silver)',
          route: '/referral/rules',
        ),
      ],
      howItWorks: [
        const ReferralStepDraft(
          step: 1,
          title: 'Chia sẻ link',
          description:
              'Gửi link giới thiệu cho bạn bè qua Zalo, Facebook, Telegram',
        ),
        const ReferralStepDraft(
          step: 2,
          title: 'Bạn bè đăng ký & KYC',
          description: 'Cả hai nhận thưởng 8.00 USDT',
        ),
        const ReferralStepDraft(
          step: 3,
          title: 'Bạn bè giao dịch',
          description: 'Bạn bè bắt đầu trade trên VitTrade',
        ),
        const ReferralStepDraft(
          step: 4,
          title: 'Nhận hoa hồng vĩnh viễn',
          description: '25% phí GD, real-time, không giới hạn',
        ),
      ],
      campaignHistory: _campaignHistory,
      contractNotes:
          'Referral home is a read-only referral hub. Copy/share, calculator, and navigation actions stay local until backend integration.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  @override
  ReferralHistorySnapshot getHistory({
    ReferralFriendFilter filter = ReferralFriendFilter.all,
    ReferralHistorySort sort = ReferralHistorySort.date,
    String query = '',
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = _friends
        .where((friend) => _matchesFilter(friend, filter))
        .where(
          (friend) =>
              normalizedQuery.isEmpty ||
              friend.name.toLowerCase().contains(normalizedQuery),
        )
        .toList();

    filtered.sort((a, b) {
      return switch (sort) {
        ReferralHistorySort.commission => b.totalCommission.compareTo(
          a.totalCommission,
        ),
        ReferralHistorySort.volume => b.totalVolume.compareTo(a.totalVolume),
        ReferralHistorySort.date => 0,
      };
    });

    return ReferralHistorySnapshot(
      endpoint: '/api/mobile/referral/referral-history',
      actionDraft: 'read-only or local navigation action',
      title: 'Lịch sử giới thiệu',
      subtitle: 'Lịch sử · Referral',
      backRoute: '/referral',
      searchHint: 'Tìm bạn bè...',
      stats: ReferralStatsDraft(
        totalFriends: _friends.length,
        kycCompleted: _friends.where((friend) => friend.kycCompleted).length,
        activeFriends: _friends
            .where(
              (friend) => friend.status == ReferralFriendStatus.activeTrader,
            )
            .length,
      ),
      filters: _buildFilters(),
      sortOptions: const [
        ReferralSortDraft(
          sort: ReferralHistorySort.date,
          label: 'Ngày tham gia',
        ),
        ReferralSortDraft(
          sort: ReferralHistorySort.commission,
          label: 'Hoa hồng',
        ),
        ReferralSortDraft(
          sort: ReferralHistorySort.volume,
          label: 'Khối lượng',
        ),
      ],
      friends: filtered,
      filter: filter,
      sort: sort,
      query: query,
      contractNotes:
          'Referral history is read-only; reminder actions are local notification drafts until backend wiring.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  @override
  ReferralRewardsSnapshot getRewards({
    ReferralRewardFilter filter = ReferralRewardFilter.all,
    ReferralRewardSort sort = ReferralRewardSort.date,
  }) {
    final records = _rewardRecords
        .where((record) => _matchesRewardFilter(record, filter))
        .toList();

    records.sort((a, b) {
      return switch (sort) {
        ReferralRewardSort.amount => b.amount.compareTo(a.amount),
        ReferralRewardSort.date => 0,
      };
    });

    final completed = records
        .where((record) => record.status == ReferralRewardStatus.completed)
        .length;
    final pending = records
        .where((record) => record.status == ReferralRewardStatus.pending)
        .length;

    return ReferralRewardsSnapshot(
      endpoint: '/api/mobile/referral/referral-rewards',
      actionDraft: 'read-only or local navigation action',
      title: 'Phần thưởng',
      subtitle: 'Phần thưởng · Referral',
      backRoute: '/referral',
      totalCommission: _completedRewardTotal,
      pendingCommission: _pendingRewardTotal,
      kycBonusTotal: _kycBonusTotal,
      tradeCommissionTotal: _tradeCommissionTotal,
      thisMonthCommission: 421,
      tierName: 'Bạc',
      tierNameEn: 'Silver',
      chartPoints: _chartPoints,
      filters: const [
        ReferralRewardFilterDraft(
          filter: ReferralRewardFilter.all,
          label: 'Tất cả',
        ),
        ReferralRewardFilterDraft(
          filter: ReferralRewardFilter.kycBonus,
          label: 'Thưởng KYC',
        ),
        ReferralRewardFilterDraft(
          filter: ReferralRewardFilter.tradeCommission,
          label: 'Hoa hồng GD',
        ),
      ],
      sortOptions: const [
        ReferralRewardSortDraft(
          sort: ReferralRewardSort.date,
          label: 'Mới nhất',
        ),
        ReferralRewardSortDraft(
          sort: ReferralRewardSort.amount,
          label: 'Số tiền',
        ),
      ],
      records: records,
      filter: filter,
      sort: sort,
      completedCount: completed,
      pendingCount: pending,
      exportRanges: _exportRanges,
      disputeTypes: _disputeTypes,
      disputes: _disputes,
      contractNotes:
          'Referral rewards is a read-only ledger. Export and dispute reporting are local action drafts until backend integration.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  @override
  ReferralRulesSnapshot getRules() {
    return ReferralRulesSnapshot(
      endpoint: '/api/mobile/referral/referral-rules',
      actionDraft: 'read-only or local navigation action',
      title: 'Quy tắc chương trình',
      subtitle: 'Quy tắc · Referral',
      backRoute: '/referral',
      tiers: _tierRules,
      rewardTypes: _rewardTypeRules,
      terms: _programTerms,
      faqs: _ruleFaqs,
      disclaimer:
          'Chương trình giới thiệu không được sử dụng cho mục đích quảng cáo sai lệch. VitTrade không cam kết lợi nhuận từ giao dịch. Thưởng giới thiệu chỉ dựa trên phí giao dịch, không liên quan đến kết quả đầu tư.',
      currentTierIndex: 1,
      contractNotes:
          'Referral rules is a read-only reference surface. Backend should return tier, reward, term, FAQ, disclaimer, and screen state data.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  @override
  ReferralFriendDetailSnapshot getFriendDetail(String friendId) {
    return ReferralFriendDetailSnapshot(
      endpoint: '/api/mobile/referral/referral-friend-$friendId',
      actionDraft: 'read-only or local navigation action',
      title: 'Chi tiết bạn bè',
      subtitle: 'Bạn bè · Referral',
      backRoute: '/referral/history',
      friendId: friendId,
      found: false,
      emptyTitle: 'Không tìm thấy bạn bè',
      emptyMessage: 'ID không hợp lệ hoặc đã bị xóa',
      listRoute: '/referral/history',
      contractNotes:
          'SC-289 preserves the Flutter not-found state for friend001, where the route id does not resolve to a referral friend.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  bool _matchesFilter(ReferralFriendDraft friend, ReferralFriendFilter filter) {
    return switch (filter) {
      ReferralFriendFilter.all => true,
      ReferralFriendFilter.activeTrader =>
        friend.status == ReferralFriendStatus.activeTrader,
      ReferralFriendFilter.kycDone =>
        friend.status == ReferralFriendStatus.kycDone,
      ReferralFriendFilter.pendingKyc =>
        friend.status == ReferralFriendStatus.pendingKyc,
    };
  }

  bool _matchesRewardFilter(
    ReferralRewardRecordDraft record,
    ReferralRewardFilter filter,
  ) {
    return switch (filter) {
      ReferralRewardFilter.all => true,
      ReferralRewardFilter.kycBonus =>
        record.type == ReferralRewardType.kycBonus,
      ReferralRewardFilter.tradeCommission =>
        record.type == ReferralRewardType.tradeCommission,
    };
  }
}

List<ReferralFilterDraft> _buildFilters() {
  return [
    ReferralFilterDraft(
      filter: ReferralFriendFilter.all,
      label: 'Tất cả',
      count: _friends.length,
    ),
    ReferralFilterDraft(
      filter: ReferralFriendFilter.activeTrader,
      label: 'Đang GD',
      count: _friends
          .where((friend) => friend.status == ReferralFriendStatus.activeTrader)
          .length,
    ),
    ReferralFilterDraft(
      filter: ReferralFriendFilter.kycDone,
      label: 'Đã KYC',
      count: _friends
          .where((friend) => friend.status == ReferralFriendStatus.kycDone)
          .length,
    ),
    ReferralFilterDraft(
      filter: ReferralFriendFilter.pendingKyc,
      label: 'Chờ KYC',
      count: _friends
          .where((friend) => friend.status == ReferralFriendStatus.pendingKyc)
          .length,
    ),
  ];
}

const _activeCampaign = ReferralCampaignDraft(
  title: 'Tháng 3 Bùng Nổ',
  description: 'Mời bạn bè trong tháng 3 nhận thưởng x2 KYC bonus!',
  bonusLabel: 'x2 Thưởng KYC',
  daysLeft: 29,
  totalParticipants: 1247,
  extraReward: 'Top 10 người mời nhiều nhất nhận thêm 500 USDT',
  bonusMultiplier: 2,
);

const _socialProof = [
  ReferralSocialProofDraft(value: '14.9K+', label: 'Người giới thiệu'),
  ReferralSocialProofDraft(value: '\$2.3M+', label: 'Tổng đã trả'),
  ReferralSocialProofDraft(value: '78%', label: 'Tỷ lệ KYC'),
  ReferralSocialProofDraft(value: '\$127', label: 'TB/tháng'),
];

const _milestones = [
  ReferralMilestoneDraft(
    id: 'ms-1',
    friends: 1,
    reward: '5 USDT',
    description: 'Lời mời đầu tiên',
    claimed: true,
  ),
  ReferralMilestoneDraft(
    id: 'ms-3',
    friends: 3,
    reward: '10 USDT',
    description: 'Người kết nối',
    claimed: true,
  ),
  ReferralMilestoneDraft(
    id: 'ms-5',
    friends: 5,
    reward: '20 USDT + Hạng Bạc',
    description: 'Cộng đồng nhỏ',
    claimed: true,
  ),
  ReferralMilestoneDraft(
    id: 'ms-10',
    friends: 10,
    reward: '50 USDT',
    description: 'Nhà vô địch giới thiệu',
    claimed: false,
  ),
  ReferralMilestoneDraft(
    id: 'ms-20',
    friends: 20,
    reward: '100 USDT + Hạng Vàng',
    description: 'Super Referrer',
    claimed: false,
  ),
];

const _pendingCommissions = [
  ReferralPendingCommissionDraft(
    id: 'pd-01',
    friendName: 'Đỗ Quốc B.',
    friendInitial: 'Đ',
    amount: 5,
    currency: 'USDT',
    reason: 'Chờ KYC',
    reasonDetail:
        'Bạn bè đã đăng ký nhưng chưa hoàn tất xác minh danh tính. Thưởng sẽ được cộng ngay khi KYC hoàn tất.',
    eta: 'Phụ thuộc bạn bè',
    progress: 40,
  ),
  ReferralPendingCommissionDraft(
    id: 'pd-02',
    friendName: 'Bùi Anh K.',
    friendInitial: 'B',
    amount: 5,
    currency: 'USDT',
    reason: 'Chờ KYC',
    reasonDetail:
        'Bạn bè mới đăng ký, đang chờ hoàn tất KYC. Nhắc họ để nhận thưởng nhanh hơn.',
    eta: 'Phụ thuộc bạn bè',
    progress: 20,
  ),
];

const _leaderboard = [
  ReferralLeaderboardDraft(
    rank: 1,
    name: 'CryptoKing_VN',
    friends: 247,
    totalEarned: 12840,
    tier: 'Tinh Hoa',
  ),
  ReferralLeaderboardDraft(
    rank: 2,
    name: 'TraderPro88',
    friends: 189,
    totalEarned: 9450,
    tier: 'Tinh Hoa',
  ),
  ReferralLeaderboardDraft(
    rank: 3,
    name: 'MinhDev',
    friends: 156,
    totalEarned: 7820,
    tier: 'Tinh Hoa',
  ),
  ReferralLeaderboardDraft(
    rank: 4,
    name: 'HanoiTrader',
    friends: 98,
    totalEarned: 5640,
    tier: 'Kim Cương',
  ),
  ReferralLeaderboardDraft(
    rank: 5,
    name: 'SaiGon_Finance',
    friends: 72,
    totalEarned: 3950,
    tier: 'Kim Cương',
  ),
];

const _campaignHistory = [
  ReferralCampaignHistoryDraft(
    id: 'camp-march-2026',
    title: 'Tháng 3 Bùng Nổ',
    description: 'Mời bạn bè nhận thưởng x2 KYC bonus suốt tháng 3!',
    bonusLabel: 'x2 Thưởng KYC',
    dateRange: '01/03/2026 - 31/03/2026',
    statusLabel: 'Đang diễn ra',
    participants: 1247,
    result: '3 bạn mới · +30.00 thưởng',
  ),
  ReferralCampaignHistoryDraft(
    id: 'camp-feb-2026',
    title: 'Tết Nguyên Đán 2026',
    description: 'Mừng xuân mới, mời bạn nhận lì xì crypto.',
    bonusLabel: 'x3 Thưởng KYC',
    dateRange: '25/01/2026 - 08/02/2026',
    statusLabel: 'Đã kết thúc',
    participants: 3842,
    result: '5 bạn mới · +75.00 thưởng · #156 xếp hạng',
  ),
  ReferralCampaignHistoryDraft(
    id: 'camp-jan-2026',
    title: 'Khởi Động 2026',
    description: 'Năm mới, ví mới với x1.5 hoa hồng giao dịch.',
    bonusLabel: 'x1.5 Hoa hồng',
    dateRange: '01/01/2026 - 31/01/2026',
    statusLabel: 'Đã kết thúc',
    participants: 2156,
    result: '2 bạn mới · +18.50 thưởng',
  ),
  ReferralCampaignHistoryDraft(
    id: 'camp-dec-2025',
    title: 'Christmas Airdrop',
    description: 'Mời bạn nhận hộp quà ngẫu nhiên 5-50 USDT.',
    bonusLabel: 'Hộp quà ngẫu nhiên',
    dateRange: '15/12/2025 - 31/12/2025',
    statusLabel: 'Đã kết thúc',
    participants: 5621,
    result: '1 bạn mới · +15.00 thưởng',
  ),
];

const _friends = [
  ReferralFriendDraft(
    id: 'friend001',
    initial: 'N',
    name: 'Nguyễn Thanh T.',
    joinedDate: '15/01/2025',
    status: ReferralFriendStatus.activeTrader,
    totalCommission: 46.90,
    totalVolume: 23450,
    firstTradeDate: '17/01/2026',
    route: '/referral/friend/friend001',
  ),
  ReferralFriendDraft(
    id: 'friend002',
    initial: 'T',
    name: 'Trần Văn H.',
    joinedDate: '20/01/2025',
    status: ReferralFriendStatus.activeTrader,
    totalCommission: 24.80,
    totalVolume: 12380,
    firstTradeDate: '23/01/2026',
    route: '/referral/friend/friend002',
  ),
  ReferralFriendDraft(
    id: 'friend003',
    initial: 'L',
    name: 'Lê Minh D.',
    joinedDate: '02/02/2025',
    status: ReferralFriendStatus.activeTrader,
    totalCommission: 17.80,
    totalVolume: 8920,
    firstTradeDate: '05/02/2026',
    route: '/referral/friend/friend003',
  ),
  ReferralFriendDraft(
    id: 'friend004',
    initial: 'P',
    name: 'Phạm Hải Y.',
    joinedDate: '10/02/2025',
    status: ReferralFriendStatus.kycDone,
    totalCommission: 0,
    totalVolume: 0,
    firstTradeDate: null,
    route: '/referral/friend/friend004',
  ),
  ReferralFriendDraft(
    id: 'friend005',
    initial: 'H',
    name: 'Hoàng Đạt V.',
    joinedDate: '14/02/2025',
    status: ReferralFriendStatus.activeTrader,
    totalCommission: 37.50,
    totalVolume: 18760,
    firstTradeDate: '16/02/2026',
    route: '/referral/friend/friend005',
  ),
  ReferralFriendDraft(
    id: 'friend006',
    initial: 'V',
    name: 'Võ Thị L.',
    joinedDate: '18/02/2025',
    status: ReferralFriendStatus.activeTrader,
    totalCommission: 11.30,
    totalVolume: 5640,
    firstTradeDate: '20/02/2026',
    route: '/referral/friend/friend006',
  ),
  ReferralFriendDraft(
    id: 'friend007',
    initial: 'Đ',
    name: 'Đỗ Quốc B.',
    joinedDate: '22/02/2025',
    status: ReferralFriendStatus.pendingKyc,
    totalCommission: 0,
    totalVolume: 0,
    firstTradeDate: null,
    route: '/referral/friend/friend007',
  ),
  ReferralFriendDraft(
    id: 'friend008',
    initial: 'B',
    name: 'Bùi Anh K.',
    joinedDate: '25/02/2025',
    status: ReferralFriendStatus.pendingKyc,
    totalCommission: 0,
    totalVolume: 0,
    firstTradeDate: null,
    route: '/referral/friend/friend008',
  ),
];

const _rewardRecords = [
  ReferralRewardRecordDraft(
    id: 'cr-01',
    friendName: 'Hoàng Đạt V.',
    friendInitial: 'H',
    type: ReferralRewardType.tradeCommission,
    amount: 22.30,
    currency: 'USDT',
    action: 'Giao dịch Spot BTC/USDT',
    date: '28/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-02',
    friendName: 'Nguyễn Thanh T.',
    friendInitial: 'N',
    type: ReferralRewardType.tradeCommission,
    amount: 12.40,
    currency: 'USDT',
    action: 'Giao dịch Spot ETH/USDT',
    date: '27/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-03',
    friendName: 'Võ Thị L.',
    friendInitial: 'V',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Thưởng KYC hoàn tất',
    date: '27/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-04',
    friendName: 'Trần Văn H.',
    friendInitial: 'T',
    type: ReferralRewardType.tradeCommission,
    amount: 8.20,
    currency: 'USDT',
    action: 'Giao dịch P2P',
    date: '26/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-05',
    friendName: 'Lê Minh D.',
    friendInitial: 'L',
    type: ReferralRewardType.tradeCommission,
    amount: 15.60,
    currency: 'USDT',
    action: 'Giao dịch Spot SOL/USDT',
    date: '25/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-06',
    friendName: 'Hoàng Đạt V.',
    friendInitial: 'H',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Thưởng KYC hoàn tất',
    date: '24/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-07',
    friendName: 'Nguyễn Thanh T.',
    friendInitial: 'N',
    type: ReferralRewardType.tradeCommission,
    amount: 9.80,
    currency: 'USDT',
    action: 'Giao dịch P2P',
    date: '23/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-08',
    friendName: 'Trần Văn H.',
    friendInitial: 'T',
    type: ReferralRewardType.tradeCommission,
    amount: 7.50,
    currency: 'USDT',
    action: 'Giao dịch Spot',
    date: '22/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-09',
    friendName: 'Lê Minh D.',
    friendInitial: 'L',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Thưởng KYC hoàn tất',
    date: '21/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-10',
    friendName: 'Phạm Hải Y.',
    friendInitial: 'P',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Thưởng KYC hoàn tất',
    date: '20/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-11',
    friendName: 'Hoàng Đạt V.',
    friendInitial: 'H',
    type: ReferralRewardType.tradeCommission,
    amount: 18.90,
    currency: 'USDT',
    action: 'Giao dịch Spot BNB/USDT',
    date: '19/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-12',
    friendName: 'Nguyễn Thanh T.',
    friendInitial: 'N',
    type: ReferralRewardType.tradeCommission,
    amount: 14.20,
    currency: 'USDT',
    action: 'Giao dịch Convert',
    date: '18/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-13',
    friendName: 'Đỗ Quốc B.',
    friendInitial: 'Đ',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Chờ hoàn tất KYC',
    date: '01/03/2026',
    status: ReferralRewardStatus.pending,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-14',
    friendName: 'Bùi Anh K.',
    friendInitial: 'B',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Chờ hoàn tất KYC',
    date: '01/03/2026',
    status: ReferralRewardStatus.pending,
  ),
];

const _tierRules = [
  ReferralTierRuleDraft(
    id: 'bronze',
    name: 'Đồng',
    nameEn: 'Bronze',
    minFriends: 0,
    commissionPercent: 20,
    kycBonus: 5,
  ),
  ReferralTierRuleDraft(
    id: 'silver',
    name: 'Bạc',
    nameEn: 'Silver',
    minFriends: 5,
    commissionPercent: 25,
    kycBonus: 8,
  ),
  ReferralTierRuleDraft(
    id: 'gold',
    name: 'Vàng',
    nameEn: 'Gold',
    minFriends: 20,
    commissionPercent: 30,
    kycBonus: 12,
  ),
  ReferralTierRuleDraft(
    id: 'diamond',
    name: 'Kim Cương',
    nameEn: 'Diamond',
    minFriends: 50,
    commissionPercent: 35,
    kycBonus: 18,
  ),
  ReferralTierRuleDraft(
    id: 'elite',
    name: 'Tinh Hoa',
    nameEn: 'Elite',
    minFriends: 100,
    commissionPercent: 40,
    kycBonus: 25,
  ),
];

const _rewardTypeRules = [
  ReferralRewardTypeRuleDraft(
    id: 'kyc_bonus',
    title: 'Thưởng KYC cố định',
    body:
        'Khi bạn bè hoàn tất xác minh danh tính (KYC), cả bạn và bạn bè đều nhận thưởng cố định bằng USDT. Mức thưởng tùy theo hạng của bạn.',
    highlight: 'Cộng vào ví trong 24h',
  ),
  ReferralRewardTypeRuleDraft(
    id: 'trade_commission',
    title: 'Hoa hồng giao dịch',
    body:
        'Bạn nhận phần trăm phí giao dịch Spot, P2P, Convert của bạn bè được giới thiệu. Hoa hồng được cộng real-time và không giới hạn thời gian.',
    highlight: 'Vĩnh viễn, không giới hạn',
  ),
];

const _programTerms = [
  'Mỗi người dùng chỉ được giới thiệu bởi 1 người. Mã giới thiệu phải được nhập khi đăng ký.',
  'Bạn bè phải hoàn tất KYC để cả hai nhận thưởng cố định.',
  'Hoa hồng giao dịch được tính trên phí thực tế bạn bè đã trả.',
  'Lên hạng tự động khi số bạn bè đủ điều kiện. % hoa hồng mới áp dụng ngay.',
  'VitTrade có quyền thay đổi chương trình với thông báo trước 30 ngày.',
  'Nghiêm cấm spam, tự giới thiệu, hoặc gian lận. Vi phạm sẽ bị khóa tài khoản.',
];

const _ruleFaqs = [
  ReferralFaqDraft(
    question: 'Làm sao để nhận thưởng giới thiệu?',
    answer:
        'Chia sẻ mã hoặc link giới thiệu cho bạn bè. Khi họ đăng ký và hoàn tất KYC, cả hai sẽ nhận thưởng cố định bằng USDT. Ngoài ra, bạn còn nhận hoa hồng từ phí giao dịch của họ.',
  ),
  ReferralFaqDraft(
    question: 'Thưởng KYC cố định là gì?',
    answer:
        'Khi bạn bè hoàn tất xác minh danh tính, cả bạn và bạn bè đều nhận một khoản thưởng cố định. Thưởng được cộng vào ví trong 24h.',
  ),
  ReferralFaqDraft(
    question: 'Hoa hồng giao dịch được tính như thế nào?',
    answer:
        'Bạn nhận phần trăm phí giao dịch của bạn bè được giới thiệu. Tỷ lệ phụ thuộc vào hạng hiện tại của tài khoản.',
  ),
  ReferralFaqDraft(
    question: 'Làm sao để lên hạng?',
    answer:
        'Mời càng nhiều bạn bè đủ điều kiện, hạng càng cao và tỷ lệ hoa hồng càng lớn.',
  ),
  ReferralFaqDraft(
    question: 'Hoa hồng có thời hạn không?',
    answer:
        'Không. Miễn là bạn bè còn giao dịch hợp lệ, bạn vẫn nhận hoa hồng theo hạng hiện tại.',
  ),
  ReferralFaqDraft(
    question: 'Tôi có thể rút hoa hồng không?',
    answer:
        'Có, hoa hồng được cộng trực tiếp vào số dư USDT trong ví. Bạn có thể rút hoặc giao dịch bình thường.',
  ),
];

const _chartPoints = [
  ReferralChartPointDraft(month: 'T10', commission: 187),
  ReferralChartPointDraft(month: 'T11', commission: 234),
  ReferralChartPointDraft(month: 'T12', commission: 198),
  ReferralChartPointDraft(month: 'T1', commission: 312),
  ReferralChartPointDraft(month: 'T2', commission: 421),
];

const _exportRanges = [
  ReferralExportRangeDraft(id: 'all', label: 'Tất cả'),
  ReferralExportRangeDraft(id: 'this_month', label: 'Tháng này'),
  ReferralExportRangeDraft(id: 'last_month', label: 'Tháng trước'),
  ReferralExportRangeDraft(id: 'last_3_months', label: '3 tháng gần nhất'),
];

const _disputeTypes = [
  ReferralDisputeTypeDraft(
    id: 'missing_commission',
    label: 'Thiếu hoa hồng',
    description: 'Bạn bè giao dịch nhưng không nhận hoa hồng',
  ),
  ReferralDisputeTypeDraft(
    id: 'wrong_amount',
    label: 'Sai số tiền',
    description: 'Số tiền hoa hồng không khớp tỷ lệ',
  ),
  ReferralDisputeTypeDraft(
    id: 'delayed',
    label: 'Chậm trễ',
    description: 'Hoa hồng chưa được cộng sau 24h',
  ),
  ReferralDisputeTypeDraft(
    id: 'other',
    label: 'Vấn đề khác',
    description: 'Vấn đề không thuộc các loại trên',
  ),
];

const _disputes = [
  ReferralDisputeDraft(
    id: 'DISP-001',
    typeId: 'delayed',
    description: 'Hoa hồng P2P ngày 23/02 chưa nhận được sau 48h.',
    statusLabel: 'Đã giải quyết',
    createdDate: '25/02/2026',
    resolvedDate: '26/02/2026',
    resolution: 'Đã cộng bổ sung 9.80 USDT vào ví.',
  ),
];

double get _completedRewardTotal => _rewardRecords
    .where((record) => record.status == ReferralRewardStatus.completed)
    .fold(0.0, (total, record) => total + record.amount)
    ._roundedCurrency;

double get _pendingRewardTotal => _rewardRecords
    .where((record) => record.status == ReferralRewardStatus.pending)
    .fold(0.0, (total, record) => total + record.amount)
    ._roundedCurrency;

double get _kycBonusTotal => _rewardRecords
    .where(
      (record) =>
          record.type == ReferralRewardType.kycBonus &&
          record.status == ReferralRewardStatus.completed,
    )
    .fold(0.0, (total, record) => total + record.amount)
    ._roundedCurrency;

double get _tradeCommissionTotal => _rewardRecords
    .where(
      (record) =>
          record.type == ReferralRewardType.tradeCommission &&
          record.status == ReferralRewardStatus.completed,
    )
    .fold(0.0, (total, record) => total + record.amount)
    ._roundedCurrency;

String _formatUsd(double value) => '\$${value.toStringAsFixed(2)}';

extension on double {
  double get _roundedCurrency => (this * 100).roundToDouble() / 100;
}
