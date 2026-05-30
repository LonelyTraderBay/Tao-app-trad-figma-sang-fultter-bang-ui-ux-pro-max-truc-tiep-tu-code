part of '../repositories/mock_p2p_repository.dart';

const List<P2PContributionDraft> _p2pContributionHistoryItems = [
  P2PContributionDraft(
    id: 'c001',
    date: '2026-03-03',
    orderId: 'P2P-78470',
    orderAmount: 7200000,
    contributionAmount: 7200,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c002',
    date: '2026-03-02',
    orderId: 'P2P-78460',
    orderAmount: 18500000,
    contributionAmount: 18500,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c003',
    date: '2026-03-01',
    orderId: 'P2P-78450',
    orderAmount: 42000000,
    contributionAmount: 42000,
    feeRate: .1,
    coin: 'ETH',
  ),
  P2PContributionDraft(
    id: 'c004',
    date: '2026-02-25',
    orderId: 'P2P-78425',
    orderAmount: 25000000,
    contributionAmount: 25000,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c005',
    date: '2026-02-23',
    orderId: 'P2P-78412',
    orderAmount: 8000000,
    contributionAmount: 8000,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c006',
    date: '2026-02-22',
    orderId: 'P2P-78415',
    orderAmount: 50000000,
    contributionAmount: 50000,
    feeRate: .1,
    coin: 'ETH',
  ),
  P2PContributionDraft(
    id: 'c007',
    date: '2026-02-20',
    orderId: 'P2P-78390',
    orderAmount: 3000000,
    contributionAmount: 3000,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c008',
    date: '2026-02-18',
    orderId: 'P2P-78400',
    orderAmount: 15000000,
    contributionAmount: 15000,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c009',
    date: '2026-02-15',
    orderId: 'P2P-78380',
    orderAmount: 12500000,
    contributionAmount: 12500,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c010',
    date: '2026-02-10',
    orderId: 'P2P-78350',
    orderAmount: 22000000,
    contributionAmount: 22000,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c011',
    date: '2026-02-05',
    orderId: 'P2P-78320',
    orderAmount: 35000000,
    contributionAmount: 35000,
    feeRate: .1,
    coin: 'ETH',
  ),
  P2PContributionDraft(
    id: 'c012',
    date: '2026-01-28',
    orderId: 'P2P-78280',
    orderAmount: 18000000,
    contributionAmount: 18000,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c013',
    date: '2026-01-25',
    orderId: 'P2P-78250',
    orderAmount: 9500000,
    contributionAmount: 9500,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c014',
    date: '2026-01-20',
    orderId: 'P2P-78220',
    orderAmount: 28000000,
    contributionAmount: 28000,
    feeRate: .1,
    coin: 'ETH',
  ),
  P2PContributionDraft(
    id: 'c015',
    date: '2026-01-15',
    orderId: 'P2P-78180',
    orderAmount: 16000000,
    contributionAmount: 16000,
    feeRate: .1,
    coin: 'USDT',
  ),
];

const List<P2PEscrowAssetBalanceDraft> _p2pEscrowAssets = [
  P2PEscrowAssetBalanceDraft(asset: 'USDT', totalAmount: 3200, orderCount: 3),
  P2PEscrowAssetBalanceDraft(asset: 'BTC', totalAmount: .01, orderCount: 1),
  P2PEscrowAssetBalanceDraft(
    asset: 'VND',
    totalAmount: 12000000,
    orderCount: 1,
  ),
];

const Map<String, List<P2PEscrowOrderDraft>> _p2pEscrowOrders = {
  'USDT': [
    P2PEscrowOrderDraft(
      id: '1',
      orderId: '#P2P-45892',
      type: P2PEscrowOrderType.sell,
      asset: 'USDT',
      amount: 1500,
      fiatAmount: 36000000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***89',
      status: P2PEscrowOrderStatus.paid,
      lockedAt: '2026-03-05 14:20',
      estimatedRelease: '2026-03-05 15:20',
    ),
    P2PEscrowOrderDraft(
      id: '2',
      orderId: '#P2P-45880',
      type: P2PEscrowOrderType.sell,
      asset: 'USDT',
      amount: 1000,
      fiatAmount: 24000000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***12',
      status: P2PEscrowOrderStatus.pendingPayment,
      lockedAt: '2026-03-05 13:45',
      estimatedRelease: '2026-03-05 14:45',
    ),
    P2PEscrowOrderDraft(
      id: '3',
      orderId: '#P2P-45870',
      type: P2PEscrowOrderType.sell,
      asset: 'USDT',
      amount: 700,
      fiatAmount: 16800000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***45',
      status: P2PEscrowOrderStatus.dispute,
      lockedAt: '2026-03-05 10:30',
      estimatedRelease: 'Đang giải quyết',
      warning:
          'Đơn hàng đang tranh chấp. Số tiền sẽ được giữ cho đến khi giải quyết xong.',
    ),
  ],
  'BTC': [
    P2PEscrowOrderDraft(
      id: '4',
      orderId: '#P2P-45860',
      type: P2PEscrowOrderType.sell,
      asset: 'BTC',
      amount: .01,
      fiatAmount: 25000000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***78',
      status: P2PEscrowOrderStatus.paid,
      lockedAt: '2026-03-04 16:20',
      estimatedRelease: '2026-03-05 16:20',
    ),
  ],
  'VND': [
    P2PEscrowOrderDraft(
      id: '5',
      orderId: '#P2P-45850',
      type: P2PEscrowOrderType.buy,
      asset: 'USDT',
      amount: 500,
      fiatAmount: 12000000,
      fiatCurrency: 'VND',
      counterparty: 'seller_***34',
      status: P2PEscrowOrderStatus.pendingRelease,
      lockedAt: '2026-03-05 12:10',
      estimatedRelease: '2026-03-05 13:10',
    ),
  ],
};

const List<String> _p2pEscrowHelpBullets = [
  'Bán crypto: sau khi bạn release cho buyer',
  'Mua crypto: sau khi seller release cho bạn',
  'Tranh chấp: sau khi Support giải quyết xong',
  'Hủy đơn: tiền trả về ngay lập tức',
];

const String _p2pEscrowAddress = '0x579bdf13579bdf13579bdf13579bdf13579bdf13';

const List<P2PEscrowSignerDraft> _p2pEscrowSigners = [
  P2PEscrowSignerDraft(
    id: 'buyer',
    role: 'buyer',
    label: 'Người mua',
    address: '0xfb73fb73fb73fb73fb73fb73fb73fb73fb73fb73',
    hasSigned: false,
  ),
  P2PEscrowSignerDraft(
    id: 'seller',
    role: 'seller',
    label: 'Người bán (CryptoKing_VN)',
    address: '0xfb73fb73fb73fb73fb73fb73fb73fb73fb73fb73',
    hasSigned: false,
  ),
  P2PEscrowSignerDraft(
    id: 'platform',
    role: 'platform',
    label: 'VitTrade Platform',
    address: '0xfb73fb73fb73fb73fb73fb73fb73fb73fb73fb73',
    hasSigned: true,
    signedAt: '11:00',
  ),
];

const List<P2PEscrowTimelineEventDraft> _p2pEscrowTimeline = [
  P2PEscrowTimelineEventDraft(
    id: 'created',
    label: 'Escrow được tạo',
    description: 'Smart contract khởi tạo · 200.0000 USDT',
    time: '11:00',
    status: P2POrderStepStatus.completed,
    iconKey: 'key',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'locked',
    label: 'Coin đã khóa',
    description: '200.0000 USDT chuyển vào escrow address',
    time: '11:00',
    status: P2POrderStepStatus.completed,
    iconKey: 'lock',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'waiting_payment',
    label: 'Chờ thanh toán fiat',
    description: 'Người mua cần chuyển khoản & xác nhận',
    time: 'Đang chờ',
    status: P2POrderStepStatus.active,
    iconKey: 'clock',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'confirm_pending',
    label: 'Xác nhận nhận tiền',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'shield',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'release_pending',
    label: 'Giải phóng coin',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'unlock',
  ),
];

const List<P2PKycTierDraft> _p2pKycTiers = [
  P2PKycTierDraft(
    id: 1,
    name: 'Basic',
    badge: 'Cơ bản',
    toneKey: 'success',
    iconKey: 'shield',
    requirements: [
      P2PKycRequirementDraft(label: 'CMND/CCCD/Passport', iconKey: 'file'),
      P2PKycRequirementDraft(label: 'OCR + Face Match', iconKey: 'camera'),
    ],
    limits: P2PKycLimitsDraft(
      dailyBuy: 50000000,
      dailySell: 50000000,
      monthlyVolume: 500000000,
    ),
    benefits: [
      'Giao dịch P2P cơ bản',
      'Tạo tối đa 3 quảng cáo',
      'Rút tối đa 20M VND/ngày',
    ],
    verificationTime: '10 phút',
    status: P2PKycTierStatus.current,
  ),
  P2PKycTierDraft(
    id: 2,
    name: 'Intermediate',
    badge: 'Trung cấp',
    toneKey: 'p2p',
    iconKey: 'badge',
    requirements: [
      P2PKycRequirementDraft(label: 'KYC Basic', iconKey: 'check'),
      P2PKycRequirementDraft(label: 'Proof of Address', iconKey: 'file'),
      P2PKycRequirementDraft(label: 'Selfie với ID', iconKey: 'camera'),
    ],
    limits: P2PKycLimitsDraft(
      dailyBuy: 200000000,
      dailySell: 200000000,
      monthlyVolume: 2000000000,
    ),
    benefits: [
      'Tất cả quyền Basic',
      'Tạo không giới hạn quảng cáo',
      'Rút tối đa 100M VND/ngày',
      'Ưu tiên hỗ trợ',
    ],
    verificationTime: '24 giờ',
    status: P2PKycTierStatus.available,
  ),
  P2PKycTierDraft(
    id: 3,
    name: 'Advanced',
    badge: 'Nâng cao',
    toneKey: 'warning',
    iconKey: 'star',
    requirements: [
      P2PKycRequirementDraft(label: 'KYC Intermediate', iconKey: 'check'),
      P2PKycRequirementDraft(
        label: 'Video Call Verification',
        iconKey: 'video',
      ),
      P2PKycRequirementDraft(label: 'Source of Funds', iconKey: 'file'),
      P2PKycRequirementDraft(
        label: 'Enhanced Due Diligence',
        iconKey: 'shield',
      ),
    ],
    limits: P2PKycLimitsDraft(
      dailyBuy: 1000000000,
      dailySell: 1000000000,
      monthlyVolume: 10000000000,
    ),
    benefits: [
      'Tất cả quyền Intermediate',
      'Merchant Badge',
      'API Trading Access',
      'Dedicated Support 24/7',
      'Phí ưu đãi đặc biệt',
    ],
    verificationTime: '3-5 ngày làm việc',
    status: P2PKycTierStatus.available,
  ),
];

const List<P2PKycStatusStepDraft> _p2pKycStatusSteps = [
  P2PKycStatusStepDraft(
    id: 'identity',
    label: 'Identity Verification',
    description: 'CMND/CCCD/Passport + OCR',
    iconKey: 'file',
    status: P2PKycStepStatus.completed,
    completedAt: '2026-03-04 14:35',
  ),
  P2PKycStatusStepDraft(
    id: 'face_match',
    label: 'Face Match',
    description: 'So khớp khuôn mặt với ID',
    iconKey: 'face',
    status: P2PKycStepStatus.completed,
    completedAt: '2026-03-04 14:36',
  ),
  P2PKycStatusStepDraft(
    id: 'address_proof',
    label: 'Address Proof',
    description: 'Hóa đơn tiện ích / Bank statement',
    iconKey: 'upload',
    status: P2PKycStepStatus.processing,
    estimatedTime: '2-4 giờ',
  ),
  P2PKycStatusStepDraft(
    id: 'selfie_verification',
    label: 'Selfie Verification',
    description: 'Selfie với ID card',
    iconKey: 'camera',
    status: P2PKycStepStatus.waiting,
    estimatedTime: '10 phút',
    actionLabel: 'Bắt đầu',
    actionRoute: '/p2p/kyc/selfie',
  ),
  P2PKycStatusStepDraft(
    id: 'compliance_review',
    label: 'Compliance Review',
    description: 'Xem xét cuối cùng',
    iconKey: 'shield',
    status: P2PKycStepStatus.waiting,
    estimatedTime: '1-2 ngày làm việc',
  ),
];

const List<P2PIdentityDocumentTypeDraft> _p2pIdentityDocumentTypes = [
  P2PIdentityDocumentTypeDraft(
    id: 'cccd',
    label: 'Căn cước công dân',
    description: 'CCCD gắn chip (12 số)',
    iconKey: 'id_card',
  ),
  P2PIdentityDocumentTypeDraft(
    id: 'cmnd',
    label: 'Chứng minh nhân dân',
    description: 'CMND cũ (9 số)',
    iconKey: 'badge',
  ),
  P2PIdentityDocumentTypeDraft(
    id: 'passport',
    label: 'Hộ chiếu',
    description: 'Passport quốc tế',
    iconKey: 'passport',
  ),
];

const List<String> _p2pIdentityGuidelines = [
  'Đảm bảo ảnh rõ nét, không bị mờ hoặc nhòe',
  'Chụp toàn bộ giấy tờ, không bị cắt góc',
  'Không chụp qua màn hình hoặc ảnh photocopy',
  'Ánh sáng đủ, không bị lóa hoặc bóng tối',
  'Thông tin cá nhân phải đọc được rõ ràng',
];

const List<String> _p2pIdentitySecurityNotes = [
  'Tài liệu được mã hóa end-to-end',
  'Chỉ team Compliance được xem',
  'Tự động xóa sau 90 ngày nếu không approve',
  'Tuân thủ GDPR & Privacy Policy',
];

const List<P2PAddressDocumentTypeDraft> _p2pAddressDocumentTypes = [
  P2PAddressDocumentTypeDraft(
    id: 'utility',
    label: 'Hóa đơn tiện ích',
    description: 'Điện, nước, gas, internet',
    iconKey: 'receipt',
    examples: [
      'Hóa đơn điện EVN',
      'Hóa đơn nước',
      'Hóa đơn internet FPT/Viettel',
    ],
  ),
  P2PAddressDocumentTypeDraft(
    id: 'bank_statement',
    label: 'Sao kê ngân hàng',
    description: 'Bank statement 3 tháng gần nhất',
    iconKey: 'bank_card',
    examples: ['Sao kê Vietcombank', 'Sao kê BIDV', 'Sao kê Techcombank'],
  ),
  P2PAddressDocumentTypeDraft(
    id: 'gov_letter',
    label: 'Giấy tờ chính phủ',
    description: 'Giấy xác nhận tạm trú, hộ khẩu',
    iconKey: 'government',
    examples: ['Giấy xác nhận tạm trú', 'Sổ hộ khẩu'],
  ),
  P2PAddressDocumentTypeDraft(
    id: 'lease',
    label: 'Hợp đồng thuê nhà',
    description: 'Lease agreement có công chứng',
    iconKey: 'home',
    examples: ['Hợp đồng thuê nhà công chứng'],
  ),
];

const List<String> _p2pAddressRequirements = [
  'Tài liệu phải trong vòng 3 tháng',
  'Địa chỉ phải khớp với thông tin đã khai báo',
  'Tên phải khớp với CMND/CCCD',
  'Tài liệu phải rõ nét, đầy đủ thông tin',
  'Chấp nhận cả bản scan và ảnh chụp',
];

const List<String> _p2pAddressSecurityNotes = [
  'Tài liệu được mã hóa AES-256',
  'Chỉ Compliance team được xem',
  'Tự động xóa sau 90 ngày nếu không approve',
  'Tuân thủ GDPR & PDPA',
];

const List<String> _p2pSelfieGuidelines = [
  'Giữ ID card cạnh khuôn mặt',
  'Đảm bảo khuôn mặt và ID rõ nét',
  'Ánh sáng đủ, không chói ngược',
  'Không đeo kính đen, khẩu trang',
  'Nhìn thẳng vào camera',
];

const List<String> _p2pSelfieTips = [
  'Sử dụng môi trường đủ sáng',
  'Giữ điện thoại ổn định',
  'Làm theo hướng dẫn từng bước',
  'Khuôn mặt nên ở chính giữa khung hình',
];
