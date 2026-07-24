part of '../repositories/mock_p2p_repository.dart';

const List<P2PDashboardFilterDraft> _p2pDashboardFilters = [
  P2PDashboardFilterDraft(id: '7d', label: '7 ngày'),
  P2PDashboardFilterDraft(id: '30d', label: '30 ngày'),
  P2PDashboardFilterDraft(id: 'all', label: 'Tất cả'),
];

const P2PDashboardStatsDraft _p2pDashboardStats = P2PDashboardStatsDraft(
  totalOrders: 78,
  completedOrders: 64,
  cancelledOrders: 8,
  disputedOrders: 2,
  completionRate: 82.1,
  avgCompletionTime: '8 phút',
  totalVolume7d: 89500000,
  totalVolume30d: 385000000,
  totalVolumeAll: 1250000000,
  buyVolume30d: 245000000,
  sellVolume30d: 140000000,
  spreadRevenue30d: 1850000,
  avgOrderSize: 16200000,
  uniqueCounterparties: 23,
  repeatCustomerRate: 34.8,
  avgRatingReceived: 4.8,
  positiveReviewRate: 95.3,
  responseTimeAvg: '4 phút',
  platformAvgCompletionRate: 94.5,
  platformAvgResponseTime: '6 phút',
);

const List<P2PDashboardSeriesPointDraft> _p2pDashboardWeeklyVolume = [
  P2PDashboardSeriesPointDraft(label: 'T1', value: 45000000),
  P2PDashboardSeriesPointDraft(label: 'T2', value: 72000000),
  P2PDashboardSeriesPointDraft(label: 'T3', value: 98000000),
  P2PDashboardSeriesPointDraft(label: 'T4', value: 120000000),
  P2PDashboardSeriesPointDraft(label: 'T5', value: 85000000),
  P2PDashboardSeriesPointDraft(label: 'T6', value: 135000000),
  P2PDashboardSeriesPointDraft(label: 'T7', value: 68000000),
  P2PDashboardSeriesPointDraft(label: 'T8', value: 89500000),
];

const List<P2PDashboardMonthlyOrdersDraft> _p2pDashboardMonthlyOrders = [
  P2PDashboardMonthlyOrdersDraft(month: 'T9', buy: 4, sell: 2),
  P2PDashboardMonthlyOrdersDraft(month: 'T10', buy: 6, sell: 5),
  P2PDashboardMonthlyOrdersDraft(month: 'T11', buy: 8, sell: 4),
  P2PDashboardMonthlyOrdersDraft(month: 'T12', buy: 10, sell: 7),
  P2PDashboardMonthlyOrdersDraft(month: 'T1', buy: 12, sell: 6),
  P2PDashboardMonthlyOrdersDraft(month: 'T2', buy: 9, sell: 5),
];

const List<P2PDashboardAssetDraft> _p2pDashboardAssetDistribution = [
  P2PDashboardAssetDraft(asset: 'USDT', percentage: 72, volume: 277200000),
  P2PDashboardAssetDraft(asset: 'BTC', percentage: 18, volume: 69300000),
  P2PDashboardAssetDraft(asset: 'ETH', percentage: 6, volume: 23100000),
  P2PDashboardAssetDraft(asset: 'BNB', percentage: 3, volume: 11550000),
  P2PDashboardAssetDraft(asset: 'SOL', percentage: 1, volume: 3850000),
];

const P2PDashboardLevelDraft _p2pDashboardCurrentLevel = P2PDashboardLevelDraft(
  id: 3,
  name: 'Advanced',
  dailyUsed: 45500000,
  dailyLimit: 500000000,
  progress: .42,
  requirements: [],
);

const P2PDashboardLevelDraft _p2pDashboardNextLevel = P2PDashboardLevelDraft(
  id: 4,
  name: 'VIP',
  dailyUsed: 45500000,
  dailyLimit: 500000000,
  progress: .42,
  requirements: [
    'KYC Lv.2',
    '2FA đã bật',
    'Volume > 5 tỷ VND',
    '200+ giao dịch hoàn tất',
  ],
);

const List<P2PDashboardComparisonDraft> _p2pDashboardPlatformComparisons = [
  P2PDashboardComparisonDraft(
    label: 'Tỷ lệ hoàn thành',
    yours: 82.1,
    platform: 94.5,
    suffix: '%',
  ),
  P2PDashboardComparisonDraft(
    label: 'Phản hồi trung bình',
    yours: 4,
    platform: 6,
    suffix: ' phút',
    lowerBetter: true,
  ),
  P2PDashboardComparisonDraft(
    label: 'Đánh giá nhận được',
    yours: 4.8,
    platform: 4.3,
    suffix: '/5.0',
  ),
  P2PDashboardComparisonDraft(
    label: 'Tỷ lệ review tích cực',
    yours: 95.3,
    platform: 91,
    suffix: '%',
  ),
];

const List<P2PDashboardMerchantDraft> _p2pDashboardTopMerchants = [
  P2PDashboardMerchantDraft(
    id: 'mc001',
    name: 'CryptoKing_VN',
    trades: 15,
    volume: 127000000,
    rating: 4.8,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc004',
    name: 'VIPTrader_HN',
    trades: 12,
    volume: 98000000,
    rating: 4.9,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc002',
    name: 'TradeMaster99',
    trades: 8,
    volume: 62000000,
    rating: 4.2,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc006',
    name: 'BTCWhale_VN',
    trades: 5,
    volume: 85750000,
    rating: 4.9,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc005',
    name: 'FastTrade_SG',
    trades: 4,
    volume: 32000000,
    rating: 4.6,
  ),
];

const List<P2PDashboardActivityDraft> _p2pDashboardRecentActivity = [
  P2PDashboardActivityDraft(
    date: '23/02 11:00',
    type: 'buy',
    asset: 'USDT',
    amount: 200,
    total: 5070000,
    merchant: 'CryptoKing_VN',
    status: 'pending_payment',
  ),
  P2PDashboardActivityDraft(
    date: '23/02 09:15',
    type: 'sell',
    asset: 'USDT',
    amount: 500,
    total: 12640000,
    merchant: 'VIPTrader_HN',
    status: 'paid',
  ),
  P2PDashboardActivityDraft(
    date: '22/02 14:30',
    type: 'buy',
    asset: 'USDT',
    amount: 1000,
    total: 25300000,
    merchant: 'TradeMaster99',
    status: 'released',
  ),
  P2PDashboardActivityDraft(
    date: '21/02 16:45',
    type: 'buy',
    asset: 'USDT',
    amount: 150,
    total: 3810000,
    merchant: 'CoinHunter_HCM',
    status: 'released',
  ),
  P2PDashboardActivityDraft(
    date: '18/02 12:00',
    type: 'buy',
    asset: 'BTC',
    amount: .05,
    total: 85750000,
    merchant: 'BTCWhale_VN',
    status: 'released',
  ),
];

const List<P2PDashboardQuickActionDraft> _p2pDashboardQuickActions = [
  P2PDashboardQuickActionDraft(
    id: 'orders',
    label: 'Đơn hàng',
    route: '/p2p/my-orders',
    iconKey: 'orders',
  ),
  P2PDashboardQuickActionDraft(
    id: 'reviews',
    label: 'Đánh giá',
    route: '/p2p/reviews',
    iconKey: 'reviews',
  ),
  P2PDashboardQuickActionDraft(
    id: 'ads',
    label: 'Quảng cáo',
    route: '/p2p/my-ads',
    iconKey: 'ads',
  ),
  P2PDashboardQuickActionDraft(
    id: 'express',
    label: 'Express',
    route: '/p2p/express',
    iconKey: 'express',
  ),
];

const List<P2PAchievementCategoryDraft> _p2pAchievementCategories = [
  P2PAchievementCategoryDraft(id: 'trades', label: 'Giao dịch'),
  P2PAchievementCategoryDraft(id: 'volume', label: 'Khối lượng'),
  P2PAchievementCategoryDraft(id: 'trust', label: 'Uy tín'),
  P2PAchievementCategoryDraft(id: 'special', label: 'Đặc biệt'),
];

const List<P2PAchievementDraft> _p2pAchievements = [
  P2PAchievementDraft(
    id: 'ach001',
    title: 'Giao dịch đầu tiên',
    description: 'Hoàn thành giao dịch P2P đầu tiên',
    iconKey: 'bolt',
    toneKey: 'primary',
    progress: 1,
    currentValueLabel: '1/1 giao dịch',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-01-15',
    reward: '+5 điểm uy tín',
    rewardType: 'reputation',
    reputationPointsReward: 5,
    categoryId: 'trades',
  ),
  P2PAchievementDraft(
    id: 'ach002',
    title: 'Trader bền bỉ',
    description: 'Hoàn thành 50 giao dịch thành công',
    iconKey: 'target',
    toneKey: 'success',
    progress: 1,
    currentValueLabel: '50/50 giao dịch',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-02-10',
    reward: '+15 điểm uy tín',
    rewardType: 'reputation',
    reputationPointsReward: 15,
    categoryId: 'trades',
  ),
  P2PAchievementDraft(
    id: 'ach003',
    title: 'Bách chiến bách thắng',
    description: 'Hoàn thành 100 giao dịch thành công',
    iconKey: 'medal',
    toneKey: 'warning',
    progress: .78,
    currentValueLabel: '78/100 giao dịch',
    progressLabel: '78%',
    unlocked: false,
    reward: '+30 điểm uy tín',
    rewardType: 'reputation',
    categoryId: 'trades',
  ),
  P2PAchievementDraft(
    id: 'ach004',
    title: 'Volume 100M',
    description: 'Tổng khối lượng giao dịch đạt 100M VND',
    iconKey: 'trend',
    toneKey: 'accent',
    progress: 1,
    currentValueLabel: '100/100 triệu VND',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-02-15',
    reward: 'Giảm phí 0.05%',
    rewardType: 'fee',
    categoryId: 'volume',
  ),
  P2PAchievementDraft(
    id: 'ach005',
    title: 'Volume 500M',
    description: 'Tổng khối lượng giao dịch đạt 500M VND',
    iconKey: 'trend',
    toneKey: 'accent',
    progress: .42,
    currentValueLabel: '210/500 triệu VND',
    progressLabel: '42%',
    unlocked: false,
    reward: 'Giảm phí 0.10%',
    rewardType: 'fee',
    categoryId: 'volume',
  ),
  P2PAchievementDraft(
    id: 'ach006',
    title: 'Tỷ lệ hoàn tất 98%+',
    description: 'Duy trì tỷ lệ hoàn tất trên 98% với ≥20 giao dịch',
    iconKey: 'shield',
    toneKey: 'success',
    progress: 1,
    currentValueLabel: '98.5/98 %',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-02-20',
    reward: 'Huy hiệu "Tin cậy"',
    rewardType: 'badge',
    categoryId: 'trust',
  ),
  P2PAchievementDraft(
    id: 'ach007',
    title: 'Không tranh chấp',
    description: '50 giao dịch liên tiếp không có tranh chấp',
    iconKey: 'star',
    toneKey: 'warning',
    progress: .86,
    currentValueLabel: '43/50 giao dịch',
    progressLabel: '86%',
    unlocked: false,
    reward: 'Huy hiệu "An toàn"',
    rewardType: 'badge',
    categoryId: 'trust',
  ),
  P2PAchievementDraft(
    id: 'ach008',
    title: 'Cộng đồng',
    description: 'Được 20 đánh giá 5 sao từ đối tác giao dịch',
    iconKey: 'users',
    toneKey: 'highlight',
    progress: .65,
    currentValueLabel: '13/20 đánh giá',
    progressLabel: '65%',
    unlocked: false,
    reward: '+20 điểm uy tín',
    rewardType: 'reputation',
    categoryId: 'special',
  ),
  P2PAchievementDraft(
    id: 'ach009',
    title: 'Tốc độ thanh toán',
    description: 'Trung bình thanh toán dưới 3 phút (≥10 giao dịch)',
    iconKey: 'bolt',
    toneKey: 'orange',
    progress: 1,
    currentValueLabel: '2.5/3 phút',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-03-01',
    reward: 'Huy hiệu "Nhanh nhẹn"',
    rewardType: 'badge',
    categoryId: 'special',
  ),
];

const List<P2PBlacklistReasonDraft> _p2pBlacklistAddReasons = [
  P2PBlacklistReasonDraft(
    id: 'scam',
    label: 'Lừa đảo',
    iconKey: 'alert',
    toneKey: 'danger',
  ),
  P2PBlacklistReasonDraft(
    id: 'unresponsive',
    label: 'Không phản hồi',
    iconKey: 'clock',
    toneKey: 'warning',
  ),
  P2PBlacklistReasonDraft(
    id: 'fake_payment',
    label: 'Thanh toán giả',
    iconKey: 'ban',
    toneKey: 'danger',
  ),
  P2PBlacklistReasonDraft(
    id: 'harassment',
    label: 'Quấy rối',
    iconKey: 'message',
    toneKey: 'accent',
  ),
  P2PBlacklistReasonDraft(
    id: 'other',
    label: 'Lý do khác',
    iconKey: 'info',
    toneKey: 'neutral',
  ),
];

const List<P2PBlacklistEntryDraft> _p2pBlacklistEntries = [
  P2PBlacklistEntryDraft(
    id: 'bl001',
    userId: 'u_bad001',
    username: 'FakeTrader88',
    reasonId: 'fake_payment',
    reasonText: 'Gửi biên lai chuyển khoản giả, tiền không vào tài khoản.',
    blockedAt: '2024-02-18 14:30:00',
    orderId: 'p2p-fake001',
    tradesBefore: 3,
    completionRate: 45,
    isVerified: false,
    recent30d: false,
  ),
  P2PBlacklistEntryDraft(
    id: 'bl002',
    userId: 'u_bad002',
    username: 'SlowPay_VN',
    reasonId: 'unresponsive',
    reasonText:
        'Không phản hồi tin nhắn sau khi tạo đơn, để đơn hết hạn 3 lần liên tiếp.',
    blockedAt: '2024-02-15 09:12:00',
    orderId: 'p2p-slow001',
    tradesBefore: 7,
    completionRate: 28.6,
    isVerified: true,
    recent30d: false,
  ),
  P2PBlacklistEntryDraft(
    id: 'bl003',
    userId: 'u_bad003',
    username: 'Scammer_X',
    reasonId: 'scam',
    reasonText: 'Cố gắng lừa đảo bằng cách yêu cầu giao dịch ngoài nền tảng.',
    blockedAt: '2024-02-10 21:45:00',
    tradesBefore: 1,
    completionRate: 0,
    isVerified: false,
    recent30d: false,
  ),
  P2PBlacklistEntryDraft(
    id: 'bl004',
    userId: 'u_bad004',
    username: 'RudeTrader99',
    reasonId: 'harassment',
    reasonText: 'Ngôn ngữ xúc phạm và đe dọa trong chat.',
    blockedAt: '2024-01-28 16:20:00',
    orderId: 'p2p-rude001',
    tradesBefore: 12,
    completionRate: 75,
    isVerified: true,
    recent30d: false,
    badge: 'pro',
  ),
  P2PBlacklistEntryDraft(
    id: 'bl005',
    userId: 'u_bad005',
    username: 'GhostBuyer',
    reasonId: 'other',
    reasonText:
        'Tạo đơn liên tục rồi hủy, gây phiền hà và khóa crypto trong escrow.',
    blockedAt: '2024-01-20 10:05:00',
    tradesBefore: 15,
    completionRate: 33.3,
    isVerified: false,
    recent30d: false,
  ),
];

const List<P2PNotificationSettingDraft> _p2pNotificationSettings = [
  P2PNotificationSettingDraft(
    id: 'order_updates',
    label: 'Cập nhật đơn hàng',
    description: 'Cập nhật trạng thái đơn hàng',
    channels: {'push': true, 'email': true, 'sms': false},
  ),
  P2PNotificationSettingDraft(
    id: 'payment_received',
    label: 'Đã nhận thanh toán',
    description: 'Thông báo khi nhận thanh toán',
    channels: {'push': true, 'email': true, 'sms': true},
  ),
  P2PNotificationSettingDraft(
    id: 'release_reminder',
    label: 'Nhắc release',
    description: 'Nhắc giải phóng escrow đúng hạn',
    channels: {'push': true, 'email': false, 'sms': false},
  ),
  P2PNotificationSettingDraft(
    id: 'security_alerts',
    label: 'Cảnh báo bảo mật',
    description: 'Đăng nhập lạ, đổi phương thức thanh toán',
    channels: {'push': true, 'email': true, 'sms': true},
  ),
  P2PNotificationSettingDraft(
    id: 'kyc_updates',
    label: 'Cập nhật KYC',
    description: 'Cập nhật xác minh KYC',
    channels: {'push': true, 'email': true, 'sms': false},
  ),
];

const List<P2PSettingsToggleDraft> _p2pSettingsNotificationToggles = [
  P2PSettingsToggleDraft(
    id: 'orders',
    label: 'Đơn hàng',
    description: 'Thông báo khi có đơn mới, xác nhận, tranh chấp',
    iconKey: 'bell',
    toneKey: 'primary',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'chat',
    label: 'Tin nhắn',
    description: 'Thông báo tin nhắn mới trong chat',
    iconKey: 'message',
    toneKey: 'success',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'price',
    label: 'Cảnh báo giá',
    description: 'Khi giá thị trường biến động lớn',
    iconKey: 'alert',
    toneKey: 'danger',
    enabled: false,
  ),
  P2PSettingsToggleDraft(
    id: 'promo',
    label: 'Khuyến mãi',
    description: 'Ưu đãi phí, sự kiện P2P',
    iconKey: 'globe',
    toneKey: 'accent',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'sound',
    label: 'Âm thanh',
    description: 'Phát âm thanh khi có thông báo',
    iconKey: 'volume',
    toneKey: 'warning',
    enabled: true,
  ),
];

const List<P2PSettingsToggleDraft> _p2pSettingsPrivacyToggles = [
  P2PSettingsToggleDraft(
    id: 'online',
    label: 'Trạng thái online',
    description: 'Hiển thị trạng thái trực tuyến cho đối tác',
    iconKey: 'eye',
    toneKey: 'success',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'completion',
    label: 'Tỷ lệ hoàn thành',
    description: 'Hiển thị % hoàn thành trên profile',
    iconKey: 'shield',
    toneKey: 'primary',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'volume',
    label: 'Khối lượng giao dịch',
    description: 'Hiển thị tổng volume giao dịch',
    iconKey: 'wallet',
    toneKey: 'warning',
    enabled: false,
  ),
  P2PSettingsToggleDraft(
    id: 'last_seen',
    label: 'Lần hoạt động cuối',
    description: 'Hiển thị "hoạt động X phút trước"',
    iconKey: 'clock',
    toneKey: 'accent',
    enabled: true,
  ),
];

const List<P2PSettingsToggleDraft> _p2pSettingsSecurityToggles = [
  P2PSettingsToggleDraft(
    id: '2fa',
    label: 'Xác thực 2FA',
    description: 'Yêu cầu 2FA cho mọi giao dịch P2P',
    iconKey: 'lock',
    toneKey: 'danger',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'pin',
    label: 'Mã PIN giao dịch',
    description: 'Nhập PIN khi xác nhận đã nhận tiền',
    iconKey: 'fingerprint',
    toneKey: 'accent',
    enabled: false,
  ),
  P2PSettingsToggleDraft(
    id: 'ip',
    label: 'IP Whitelist',
    description: 'Chỉ cho phép giao dịch từ IP đã đăng ký',
    iconKey: 'globe',
    toneKey: 'primary',
    enabled: false,
  ),
];

const P2PSettingsAutoReplyDraft _p2pSettingsAutoReply =
    P2PSettingsAutoReplyDraft(
      enabled: true,
      buyTemplate: 'Cảm ơn bạn! Vui lòng chuyển khoản theo thông tin bên dưới.',
    );

const List<P2PGuideTabDraft> _p2pGuideTabs = [
  P2PGuideTabDraft(id: 'guide', label: 'Hướng dẫn'),
  P2PGuideTabDraft(id: 'safety', label: 'An toàn'),
  P2PGuideTabDraft(id: 'faq', label: 'FAQ'),
  P2PGuideTabDraft(id: 'video', label: 'Video'),
];

const List<P2PGuideFaqDraft> _p2pGuideFaqItems = [
  P2PGuideFaqDraft(
    id: 'what_is_p2p',
    question: 'P2P Trading là gì?',
    answer:
        'P2P (Peer-to-Peer) là hình thức mua bán crypto trực tiếp giữa người dùng với nhau, thông qua nền tảng trung gian. VitTrade cung cấp hệ thống Escrow để bảo vệ cả hai bên.',
  ),
  P2PGuideFaqDraft(
    id: 'fees',
    question: 'Phí giao dịch P2P là bao nhiêu?',
    answer:
        'Người tạo quảng cáo (Maker) miễn phí. Người đặt đơn (Taker) chịu phí 0.1%. Merchant được ưu đãi giảm 50% phí.',
  ),
  P2PGuideFaqDraft(
    id: 'escrow',
    question: 'Escrow hoạt động như thế nào?',
    answer:
        'Khi có đơn, crypto của người bán bị khóa trong hợp đồng thông minh. Chỉ khi người bán xác nhận đã nhận tiền, crypto mới được giải phóng cho người mua.',
  ),
  P2PGuideFaqDraft(
    id: 'dispute',
    question: 'Nếu có tranh chấp thì sao?',
    answer:
        'Bạn có thể mở tranh chấp trong vòng 72 giờ. Đội ngũ VitTrade sẽ xem xét bằng chứng từ cả hai bên và đưa ra phán quyết trong 24-48 giờ.',
  ),
  P2PGuideFaqDraft(
    id: 'payment_time',
    question: 'Thời gian thanh toán tối đa?',
    answer:
        'Tùy quảng cáo: 15, 30 hoặc 60 phút. Nếu quá thời hạn, đơn hàng tự động hủy và crypto trả về ví người bán.',
  ),
  P2PGuideFaqDraft(
    id: 'merchant',
    question: 'Tôi có thể trở thành Merchant?',
    answer:
        'Có. Cần: tài khoản trên 30 ngày, ít nhất 100 đơn hoàn thành, tỷ lệ hoàn thành từ 95%, KYC cấp 2 trở lên. Đăng ký tại mục Đăng ký Merchant.',
  ),
  P2PGuideFaqDraft(
    id: 'safe',
    question: 'VitTrade có an toàn không?',
    answer:
        'VitTrade sử dụng mã hóa E2E cho tin nhắn, hệ thống Escrow smart contract, KYC đa cấp và đội ngũ giám sát 24/7.',
  ),
];

const List<P2PGuideStepDraft> _p2pGuideBuySteps = [
  P2PGuideStepDraft(
    id: 'buy_search',
    step: 1,
    title: 'Tìm quảng cáo',
    description:
        'Chọn quảng cáo BÁN phù hợp với giá, phương thức thanh toán và giới hạn mong muốn.',
    iconKey: 'search',
    toneKey: 'primary',
  ),
  P2PGuideStepDraft(
    id: 'buy_pay',
    step: 2,
    title: 'Đặt đơn & Thanh toán',
    description:
        'Nhập số lượng, xác nhận đơn. Chuyển tiền đúng thông tin và thời hạn quy định.',
    iconKey: 'payment',
    toneKey: 'accent',
  ),
  P2PGuideStepDraft(
    id: 'buy_chat',
    step: 3,
    title: 'Chat & Xác nhận',
    description:
        'Liên hệ người bán qua chat mã hóa E2E. Gửi bằng chứng chuyển khoản.',
    iconKey: 'chat',
    toneKey: 'success',
  ),
  P2PGuideStepDraft(
    id: 'buy_receive',
    step: 4,
    title: 'Nhận crypto',
    description:
        'Sau khi người bán xác nhận, crypto tự động chuyển vào ví của bạn.',
    iconKey: 'wallet',
    toneKey: 'warning',
  ),
];

const List<P2PGuideStepDraft> _p2pGuideSellSteps = [
  P2PGuideStepDraft(
    id: 'sell_create',
    step: 1,
    title: 'Đăng quảng cáo',
    description:
        'Tạo quảng cáo BÁN với giá, số lượng, phương thức thanh toán và điều kiện.',
    iconKey: 'file',
    toneKey: 'danger',
  ),
  P2PGuideStepDraft(
    id: 'sell_escrow',
    step: 2,
    title: 'Escrow tự động',
    description:
        'Khi có đơn, crypto tự động bị khóa trong Escrow để bảo vệ người mua.',
    iconKey: 'lock',
    toneKey: 'accent',
  ),
  P2PGuideStepDraft(
    id: 'sell_check',
    step: 3,
    title: 'Kiểm tra thanh toán',
    description: 'Kiểm tra tài khoản ngân hàng. Xác nhận khi đã nhận đủ tiền.',
    iconKey: 'eye',
    toneKey: 'primary',
  ),
  P2PGuideStepDraft(
    id: 'sell_release',
    step: 4,
    title: 'Giải phóng crypto',
    description:
        'Nhấn xác nhận, crypto tự động chuyển cho người mua. Hoàn tất.',
    iconKey: 'check',
    toneKey: 'success',
  ),
];

const List<P2PGuideTipDraft> _p2pGuideSafetyTips = [
  P2PGuideTipDraft(
    id: 'platform_only',
    title: 'Chỉ giao dịch trên nền tảng',
    description: 'Không chuyển tiền hoặc crypto ra ngoài hệ thống VitTrade.',
    iconKey: 'shield',
    toneKey: 'primary',
  ),
  P2PGuideTipDraft(
    id: 'secrets',
    title: 'Không chia sẻ thông tin nhạy cảm',
    description: 'Mật khẩu, OTP, seed phrase không bao giờ chia sẻ trong chat.',
    iconKey: 'lock',
    toneKey: 'danger',
  ),
  P2PGuideTipDraft(
    id: 'fraud',
    title: 'Cảnh giác lừa đảo',
    description:
        'Kiểm tra kỹ số tiền, tên người nhận. Không tin đã chuyển nếu chưa thấy tiền.',
    iconKey: 'alert',
    toneKey: 'warning',
  ),
  P2PGuideTipDraft(
    id: 'partner',
    title: 'Kiểm tra đối tác',
    description:
        'Ưu tiên merchant có huy hiệu, tỷ lệ hoàn thành cao và nhiều đơn hoàn thành.',
    iconKey: 'users',
    toneKey: 'success',
  ),
];

const List<P2PGuideVideoDraft> _p2pGuideVideos = [
  P2PGuideVideoDraft(
    id: 'start',
    title: 'Bắt đầu giao dịch P2P',
    duration: '5:32',
    views: '12.5K',
    thumb: 'P2P',
    level: 'Cơ bản',
    toneKey: 'success',
  ),
  P2PGuideVideoDraft(
    id: 'ads',
    title: 'Cách tạo quảng cáo hiệu quả',
    duration: '8:15',
    views: '8.3K',
    thumb: 'ADS',
    level: 'Trung bình',
    toneKey: 'warning',
  ),
  P2PGuideVideoDraft(
    id: 'security',
    title: 'Bảo mật tài khoản P2P',
    duration: '6:48',
    views: '15.2K',
    thumb: 'SEC',
    level: 'Cơ bản',
    toneKey: 'primary',
  ),
  P2PGuideVideoDraft(
    id: 'dispute',
    title: 'Xử lý tranh chấp',
    duration: '7:20',
    views: '6.1K',
    thumb: 'DSP',
    level: 'Nâng cao',
    toneKey: 'danger',
  ),
];
