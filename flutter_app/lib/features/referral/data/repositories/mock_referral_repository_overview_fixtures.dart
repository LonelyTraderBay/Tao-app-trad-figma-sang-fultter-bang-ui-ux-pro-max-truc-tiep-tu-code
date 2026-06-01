part of 'mock_referral_repository.dart';

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
