part of 'mock_referral_repository.dart';

const _activeCampaign = ReferralCampaignDraft(
  title: 'Chương trình tháng 3',
  description:
      'Thưởng KYC tăng gấp đôi khi bạn bè hoàn tất xác minh trong tháng 3.',
  bonusLabel: 'Thưởng KYC x2',
  daysLeft: 29,
  totalParticipants: 1247,
  extraReward: '10 người mời nhiều nhất nhận thêm 500 USDT',
  bonusMultiplier: 2,
);

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
    description: 'Mốc 10 bạn bè',
    claimed: false,
  ),
  ReferralMilestoneDraft(
    id: 'ms-20',
    friends: 20,
    reward: '100 USDT + Hạng Vàng',
    description: 'Mốc 20 bạn bè',
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

const _campaignHistory = [
  ReferralCampaignHistoryDraft(
    id: 'camp-march-2026',
    title: 'Chương trình tháng 3',
    description:
        'Thưởng KYC tăng gấp đôi khi bạn bè hoàn tất xác minh trong tháng 3.',
    bonusLabel: 'Thưởng KYC x2',
    dateRange: '01/03/2026 - 31/03/2026',
    statusLabel: 'Đang diễn ra',
    participants: 1247,
    result: '3 bạn mới · +30.00 thưởng',
  ),
  ReferralCampaignHistoryDraft(
    id: 'camp-feb-2026',
    title: 'Tết Nguyên Đán 2026',
    description: 'Thưởng KYC tăng gấp ba trong dịp Tết Nguyên Đán.',
    bonusLabel: 'Thưởng KYC x3',
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
    title: 'Chương trình cuối năm 2025',
    description: 'Thưởng KYC bổ sung 5–50 USDT cho mỗi lời mời hợp lệ.',
    bonusLabel: 'Thưởng KYC bổ sung',
    dateRange: '15/12/2025 - 31/12/2025',
    statusLabel: 'Đã kết thúc',
    participants: 5621,
    result: '1 bạn mới · +15.00 thưởng',
  ),
];
