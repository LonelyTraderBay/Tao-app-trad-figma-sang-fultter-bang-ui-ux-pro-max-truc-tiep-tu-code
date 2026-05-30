part of '../repositories/mock_p2p_repository.dart';

const List<P2PScamPatternDraft> _p2pFraudPatterns = [
  P2PScamPatternDraft(
    id: 'fake_payment',
    title: 'Bằng chứng thanh toán giả',
    severity: 'critical',
    description:
        'Đối tác gửi screenshot chuyển khoản giả để lừa bạn giải phóng coin',
    howItWorks: [
      'Tạo đơn mua coin trên P2P',
      'Gửi ảnh chuyển khoản chỉnh sửa hoặc giả mạo',
      'Yêu cầu bạn giải phóng coin ngay',
      'Coin bị mất, tiền không bao giờ đến',
    ],
    redFlags: [
      'Thúc giục giải phóng coin nhanh bất thường',
      'Screenshot thanh toán mờ hoặc bị crop',
      'Số tiền trên screenshot không khớp',
      'Tên người chuyển không khớp với tài khoản P2P',
    ],
    prevention: [
      'Luôn kiểm tra tài khoản ngân hàng trước khi giải phóng',
      'Chờ tiền có trong tài khoản, không chỉ nhìn SMS hoặc screenshot',
      'So sánh tên, số tiền và mã giao dịch chính xác',
      'Bấm Đã nhận chỉ khi tiền thực sự đã vào tài khoản',
    ],
    iconKey: 'payment',
  ),
  P2PScamPatternDraft(
    id: 'off_platform',
    title: 'Giao dịch ngoài nền tảng',
    severity: 'critical',
    description: 'Đối tác dụ giao dịch ngoài hệ thống để tránh escrow bảo vệ',
    howItWorks: [
      'Liên hệ qua Zalo hoặc Telegram ngoài chat P2P',
      'Đưa ra mức giá tốt hơn để dụ giao dịch trực tiếp',
      'Khi chuyển tiền hoặc coin, đối phương biến mất',
      'Không có escrow nên không thể dispute hoặc claim bảo hiểm',
    ],
    redFlags: [
      'Yêu cầu liên hệ qua kênh ngoài',
      'Đề nghị giá tốt hơn thị trường',
      'Yêu cầu chuyển coin hoặc tiền trực tiếp',
      'Hứa hẹn nhanh hơn, không cần quy trình',
    ],
    prevention: [
      'Không giao dịch ngoài nền tảng',
      'Mọi thanh toán phải qua flow P2P có escrow',
      'Report ngay nếu bị yêu cầu giao dịch ngoài',
      'Chỉ chat trong hệ thống vì tin nhắn ngoài không được bảo vệ',
    ],
    iconKey: 'globe',
  ),
  P2PScamPatternDraft(
    id: 'chargeback',
    title: 'Chargeback sau giao dịch',
    severity: 'high',
    description:
        'Buyer chuyển tiền rồi làm chargeback qua ngân hàng sau khi nhận coin',
    howItWorks: [
      'Buyer chuyển khoản thật sự qua ngân hàng',
      'Seller xác nhận nhận tiền và giải phóng coin',
      'Buyer liên hệ ngân hàng yêu cầu hoàn tiền',
      'Seller mất cả coin lẫn tiền',
    ],
    redFlags: [
      'Buyer mới, ít giao dịch nhưng order lớn',
      'Thúc giục giải phóng coin rất nhanh',
      'Completion rate thấp bất thường',
      'Không chịu dùng phương thức thanh toán thông thường',
    ],
    prevention: [
      'Chỉ giao dịch với buyer có rating và lịch sử tốt',
      'Cẩn thận với đơn giá trị lớn từ tài khoản mới',
      'Lưu trữ mọi bằng chứng giao dịch',
      'Nếu bị chargeback, gửi claim bảo hiểm ngay trong 7 ngày',
    ],
    iconKey: 'bank',
  ),
  P2PScamPatternDraft(
    id: 'impersonation',
    title: 'Mạo danh nhân viên sàn',
    severity: 'high',
    description:
        'Kẻ lừa đảo giả danh admin hoặc nhân viên sàn để lừa lấy thông tin',
    howItWorks: [
      'Liên hệ qua Telegram hoặc Zalo giả danh nhân viên hỗ trợ',
      'Thông báo tài khoản bị khóa hoặc cần xác minh',
      'Yêu cầu cung cấp mật khẩu, mã OTP hoặc seed phrase',
      'Chiếm quyền tài khoản hoặc rút hết coin',
    ],
    redFlags: [
      'Nhân viên liên hệ qua kênh ngoài',
      'Yêu cầu mật khẩu hoặc mã OTP',
      'Tạo cảm giác khẩn cấp phải làm ngay',
      'Link lạ yêu cầu đăng nhập',
    ],
    prevention: [
      'Nhân viên sàn không bao giờ yêu cầu mật khẩu hoặc OTP',
      'Chỉ liên hệ hỗ trợ qua kênh chính thức trong app',
      'Thiết lập Anti-Phishing Code để nhận diện email thật',
      'Không bấm link lạ, kiểm tra domain chính xác',
    ],
    iconKey: 'user',
  ),
  P2PScamPatternDraft(
    id: 'triangle_scam',
    title: 'Gian lận tam giác',
    severity: 'medium',
    description:
        'Kẻ lừa đảo dùng tiền từ nạn nhân khác để thanh toán đơn P2P của bạn',
    howItWorks: [
      'Kẻ lừa đảo tạo đơn mua coin từ seller',
      'Dụ nạn nhân chuyển tiền vào tài khoản seller',
      'Seller tưởng buyer đã thanh toán và giải phóng coin',
      'Nạn nhân report ngân hàng khiến seller bị khóa tài khoản',
    ],
    redFlags: [
      'Tên người chuyển không khớp với tên tài khoản P2P',
      'Lý do chuyển khoản ghi lạ hoặc không liên quan',
      'Yêu cầu xác nhận bằng mã ngoài hệ thống',
    ],
    prevention: [
      'Kiểm tra tên người chuyển phải khớp với tên P2P',
      'Nếu tên không khớp, không giải phóng và mở dispute',
      'Lưu trữ sao kê ngân hàng mọi giao dịch P2P',
    ],
    iconKey: 'triangle',
  ),
];

const List<P2PSafetyChecklistItemDraft> _p2pFraudChecklist = [
  P2PSafetyChecklistItemDraft(
    id: 'ck1',
    label: '2FA đã bật',
    description: 'Bảo vệ tài khoản bằng 2FA',
    checked: true,
    category: 'before',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck2',
    label: 'Anti-Phishing Code đã thiết lập',
    description: 'Nhận diện email thật từ sàn',
    checked: false,
    category: 'before',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck3',
    label: 'Kiểm tra rating đối tác',
    description: 'Chỉ giao dịch với merchant uy tín',
    checked: true,
    category: 'before',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck4',
    label: 'Xác nhận payment method hợp lệ',
    description: 'Phương thức thanh toán được hỗ trợ',
    checked: true,
    category: 'before',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck5',
    label: 'Kiểm tra tên người chuyển',
    description: 'Tên phải khớp với tên P2P',
    checked: false,
    category: 'during',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck6',
    label: 'Chỉ bấm "Đã nhận" khi tiền thật vào TK',
    description: 'Không tin screenshot',
    checked: true,
    category: 'during',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck7',
    label: 'Không giao dịch ngoài nền tảng',
    description: 'Mọi thao tác trong app',
    checked: true,
    category: 'during',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck8',
    label: 'Lưu bằng chứng giao dịch',
    description: 'Screenshot chat, sao kê ngân hàng',
    checked: false,
    category: 'during',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck9',
    label: 'Review đối tác sau giao dịch',
    description: 'Giúp cộng đồng nhận diện scam',
    checked: true,
    category: 'after',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck10',
    label: 'Biết cách gửi claim bảo hiểm',
    description: 'Nắm rõ quy trình trong 7 ngày',
    checked: false,
    category: 'after',
  ),
];

const List<P2PFraudEmergencyActionDraft> _p2pFraudEmergencyActions = [
  P2PFraudEmergencyActionDraft(
    id: 'insurance_claim',
    label: 'Gửi yêu cầu bồi thường bảo hiểm',
    route: '/p2p/insurance-fund',
    toneKey: 'danger',
    iconKey: 'shield',
  ),
  P2PFraudEmergencyActionDraft(
    id: 'support',
    label: 'Liên hệ hỗ trợ khẩn cấp',
    route: '/support',
    toneKey: 'warning',
    iconKey: 'phone',
  ),
  P2PFraudEmergencyActionDraft(
    id: 'report_merchant',
    label: 'Report merchant gian lận',
    route: '/p2p/report/mc001',
    toneKey: 'muted',
    iconKey: 'flag',
  ),
];

const List<P2PWalletTransferAssetDraft> _p2pWalletTransferAssets = [
  P2PWalletTransferAssetDraft(symbol: 'USDT', name: 'Tether'),
  P2PWalletTransferAssetDraft(symbol: 'BTC', name: 'Bitcoin'),
  P2PWalletTransferAssetDraft(symbol: 'VND', name: 'Vietnamese Dong'),
];

const List<P2PWalletTransferBalanceDraft> _p2pWalletTransferBalances = [
  P2PWalletTransferBalanceDraft(
    walletKey: 'main',
    walletLabel: 'Main Wallet',
    asset: 'USDT',
    available: 45200,
    balanceLabel: 'Khả dụng',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'p2p',
    walletLabel: 'P2P Wallet',
    asset: 'USDT',
    available: 12450.50,
    balanceLabel: 'Số dư',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'main',
    walletLabel: 'Main Wallet',
    asset: 'BTC',
    available: .1234,
    balanceLabel: 'Khả dụng',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'p2p',
    walletLabel: 'P2P Wallet',
    asset: 'BTC',
    available: .0524,
    balanceLabel: 'Số dư',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'main',
    walletLabel: 'Main Wallet',
    asset: 'VND',
    available: 120000000,
    balanceLabel: 'Khả dụng',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'p2p',
    walletLabel: 'P2P Wallet',
    asset: 'VND',
    available: 45600000,
    balanceLabel: 'Số dư',
  ),
];

const List<P2PFundLockRecordDraft> _p2pFundLockRecords = [
  P2PFundLockRecordDraft(
    id: 'fund_lock_45892',
    type: 'lock',
    asset: 'USDT',
    amount: 1500,
    reason: 'Order #45892 created',
    timestamp: '2026-03-05 14:20',
  ),
  P2PFundLockRecordDraft(
    id: 'fund_unlock_45880',
    type: 'unlock',
    asset: 'USDT',
    amount: 1000,
    reason: 'Order #45880 completed',
    timestamp: '2026-03-05 13:45',
  ),
  P2PFundLockRecordDraft(
    id: 'fund_lock_45870',
    type: 'lock',
    asset: 'BTC',
    amount: .01,
    reason: 'Order #45870 created',
    timestamp: '2026-03-05 10:30',
  ),
  P2PFundLockRecordDraft(
    id: 'fund_unlock_45850',
    type: 'unlock',
    asset: 'VND',
    amount: 12000000,
    reason: 'Order #45850 released',
    timestamp: '2026-03-04 16:20',
  ),
];

const List<P2PWalletBalanceDraft> _p2pWalletBalances = [
  P2PWalletBalanceDraft(
    asset: 'USDT',
    available: 12450.50,
    inEscrow: 3200,
    locked: 500,
    total: 16150.50,
    usdValue: 16150.50,
  ),
  P2PWalletBalanceDraft(
    asset: 'BTC',
    available: .0524,
    inEscrow: .01,
    locked: 0,
    total: .0624,
    usdValue: 4243.20,
  ),
  P2PWalletBalanceDraft(
    asset: 'VND',
    available: 45600000,
    inEscrow: 12000000,
    locked: 0,
    total: 57600000,
    usdValue: 2400,
  ),
];

const List<P2PWalletTransactionDraft> _p2pWalletTransactions = [
  P2PWalletTransactionDraft(
    id: 'tx_escrow_release_45892',
    type: 'escrow_release',
    asset: 'USDT',
    amount: 1500,
    status: 'completed',
    time: '10 phút trước',
    orderId: '#P2P-45892',
  ),
  P2PWalletTransactionDraft(
    id: 'tx_transfer_in_5000',
    type: 'transfer_in',
    asset: 'USDT',
    amount: 5000,
    status: 'completed',
    time: '2 giờ trước',
  ),
  P2PWalletTransactionDraft(
    id: 'tx_escrow_lock_45880',
    type: 'escrow_lock',
    asset: 'BTC',
    amount: .01,
    status: 'pending',
    time: '3 giờ trước',
    orderId: '#P2P-45880',
  ),
  P2PWalletTransactionDraft(
    id: 'tx_transfer_out_vnd',
    type: 'transfer_out',
    asset: 'VND',
    amount: 10000000,
    status: 'completed',
    time: '1 ngày trước',
  ),
];

const List<P2PLimitUsageDraft> _p2pLimitTrackerUsages = [
  P2PLimitUsageDraft(
    period: 'daily',
    label: 'Hôm nay',
    used: 35000000,
    limit: 50000000,
    percentage: 70,
  ),
  P2PLimitUsageDraft(
    period: 'weekly',
    label: 'Tuần',
    used: 180000000,
    limit: 300000000,
    percentage: 60,
  ),
  P2PLimitUsageDraft(
    period: 'monthly',
    label: 'Tháng',
    used: 650000000,
    limit: 1000000000,
    percentage: 65,
  ),
];

const List<P2PLimitBreakdownDraft> _p2pLimitTrackerBreakdown = [
  P2PLimitBreakdownDraft(date: '05/03', buy: 20000000, sell: 15000000),
  P2PLimitBreakdownDraft(date: '04/03', buy: 30000000, sell: 10000000),
  P2PLimitBreakdownDraft(date: '03/03', buy: 25000000, sell: 20000000),
  P2PLimitBreakdownDraft(date: '02/03', buy: 15000000, sell: 25000000),
];

const P2PTransactionLimitTierDraft _p2pTransactionLimitTier1 =
    P2PTransactionLimitTierDraft(
      tier: 1,
      name: 'Basic',
      statusLabel: 'Đang dùng',
      dailyBuy: 50000000,
      dailySell: 50000000,
      weeklyTotal: 300000000,
      monthlyTotal: 1000000000,
      perTransaction: 20000000,
      requirements: ['KYC Basic (CMND/CCCD)'],
    );

const P2PTransactionLimitTierDraft _p2pTransactionLimitTier2 =
    P2PTransactionLimitTierDraft(
      tier: 2,
      name: 'Intermediate',
      statusLabel: 'Có thể nâng cấp',
      dailyBuy: 200000000,
      dailySell: 200000000,
      weeklyTotal: 1200000000,
      monthlyTotal: 4000000000,
      perTransaction: 100000000,
      requirements: [
        'KYC Intermediate',
        'Proof of Address',
        'Selfie Verification',
      ],
    );

const List<P2PTransactionLimitUsageDraft> _p2pTransactionLimitUsages = [
  P2PTransactionLimitUsageDraft(
    id: 'daily_buy',
    label: 'Mua hôm nay',
    current: 35000000,
    max: 50000000,
    toneKey: 'buy',
  ),
  P2PTransactionLimitUsageDraft(
    id: 'daily_sell',
    label: 'Bán hôm nay',
    current: 15000000,
    max: 50000000,
    toneKey: 'sell',
  ),
  P2PTransactionLimitUsageDraft(
    id: 'weekly',
    label: 'Tuần này',
    current: 180000000,
    max: 300000000,
    toneKey: 'accent',
  ),
  P2PTransactionLimitUsageDraft(
    id: 'monthly',
    label: 'Tháng này',
    current: 650000000,
    max: 1000000000,
    toneKey: 'warning',
  ),
];

const List<P2PTransactionLimitDetailDraft> _p2pTransactionLimitDetails = [
  P2PTransactionLimitDetailDraft(
    id: 'daily_buy',
    label: 'Mua tối đa/ngày',
    value: 50000000,
    toneKey: 'buy',
    iconKey: 'trend',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'daily_sell',
    label: 'Bán tối đa/ngày',
    value: 50000000,
    toneKey: 'sell',
    iconKey: 'trend',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'weekly',
    label: 'Tổng/tuần',
    value: 300000000,
    toneKey: 'accent',
    iconKey: 'calendar',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'monthly',
    label: 'Tổng/tháng',
    value: 1000000000,
    toneKey: 'warning',
    iconKey: 'calendar',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'per_transaction',
    label: 'Tối đa/giao dịch',
    value: 20000000,
    toneKey: 'danger',
    iconKey: 'amount',
  ),
];

const List<String> _p2pTransactionLimitInfoBullets = [
  'Giới hạn reset vào 00:00 UTC+7 mỗi ngày/tuần/tháng',
  'Giới hạn áp dụng cho cả Buy và Sell orders',
  'Số tiền đang trong escrow không tính vào giới hạn',
  'Giới hạn có thể thay đổi theo chính sách compliance',
];
