part of 'mock_referral_repository.dart';

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

const _socialProof = [
  ReferralSocialProofDraft(value: '14.9K+', label: 'Người giới thiệu'),
  ReferralSocialProofDraft(value: '\$2.3M+', label: 'Tổng đã trả'),
  ReferralSocialProofDraft(value: '78%', label: 'Tỷ lệ KYC'),
  ReferralSocialProofDraft(value: '\$127', label: 'TB/tháng'),
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
