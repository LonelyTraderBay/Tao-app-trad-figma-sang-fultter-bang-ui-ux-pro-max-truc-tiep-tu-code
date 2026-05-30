part of '../repositories/mock_p2p_repository.dart';

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

const List<P2PMyOrdersTabDraft> _p2pMyOrdersTabs = [
  P2PMyOrdersTabDraft(id: 'processing', label: 'Đang xử lý'),
  P2PMyOrdersTabDraft(id: 'completed', label: 'Hoàn tất'),
  P2PMyOrdersTabDraft(id: 'disputed', label: 'Tranh chấp'),
];

const List<P2PMyOrderDraft> _p2pMyOrders = [
  P2PMyOrderDraft(
    id: 'p2p001',
    orderNumber: 'VT-P2P-20240223-001',
    type: 'buy',
    asset: 'USDT',
    amount: 200,
    price: 25350,
    total: 5070000,
    currency: 'VND',
    status: 'pending_payment',
    merchant: 'CryptoKing_VN',
    merchantId: 'mc001',
    createdAt: '2024-02-23 11:00:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p002',
    orderNumber: 'VT-P2P-20240223-002',
    type: 'sell',
    asset: 'USDT',
    amount: 500,
    price: 25280,
    total: 12640000,
    currency: 'VND',
    status: 'paid',
    merchant: 'VIPTrader_HN',
    merchantId: 'mc004',
    createdAt: '2024-02-23 09:15:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p003',
    orderNumber: 'VT-P2P-20240222-003',
    type: 'buy',
    asset: 'USDT',
    amount: 1000,
    price: 25300,
    total: 25300000,
    currency: 'VND',
    status: 'released',
    merchant: 'TradeMaster99',
    merchantId: 'mc002',
    createdAt: '2024-02-22 14:30:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p004',
    orderNumber: 'VT-P2P-20240221-004',
    type: 'buy',
    asset: 'USDT',
    amount: 150,
    price: 25400,
    total: 3810000,
    currency: 'VND',
    status: 'released',
    merchant: 'CoinHunter_HCM',
    merchantId: 'mc003',
    createdAt: '2024-02-21 16:45:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p005',
    orderNumber: 'VT-P2P-20240220-005',
    type: 'sell',
    asset: 'USDT',
    amount: 300,
    price: 25260,
    total: 7578000,
    currency: 'VND',
    status: 'cancelled',
    merchant: 'FastTrade_SG',
    merchantId: 'mc005',
    createdAt: '2024-02-20 10:20:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p006',
    orderNumber: 'VT-P2P-20240219-006',
    type: 'buy',
    asset: 'USDT',
    amount: 800,
    price: 25350,
    total: 20280000,
    currency: 'VND',
    status: 'disputed',
    merchant: 'NewTrader01',
    merchantId: 'mc007',
    createdAt: '2024-02-19 08:10:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p007',
    orderNumber: 'VT-P2P-20240218-007',
    type: 'buy',
    asset: 'BTC',
    amount: .05,
    price: 1715000000,
    total: 85750000,
    currency: 'VND',
    status: 'released',
    merchant: 'BTCWhale_VN',
    merchantId: 'mc006',
    createdAt: '2024-02-18 12:00:00',
  ),
];

String _formatVndDots(double value) {
  final whole = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
    buffer.write(whole[i]);
  }
  return buffer.toString();
}

const Map<String, P2PClaimDetailDraft> _p2pClaimDetails = {
  'sample': _p2pClaimDetailPaid,
  'ic001': _p2pClaimDetailPaid,
};

const P2PClaimDetailDraft _p2pClaimDetailPaid = P2PClaimDetailDraft(
  id: 'ic001',
  claimCode: 'CLM-001',
  orderId: 'P2P-78400',
  orderNumber: 'VT-P2P-20260218-001',
  reason: 'Gian lận',
  description:
      'Merchant không giải phóng coin sau khi đã xác nhận thanh toán thành công. Đã liên hệ merchant qua chat nhiều lần nhưng không phản hồi sau 6 giờ.',
  amount: 15000000,
  paidAmount: 12750000,
  currency: 'VND',
  status: P2PInsuranceClaimStatus.paid,
  submittedAt: '2026-02-18 14:30',
  estimatedReview: '2026-02-20 14:30',
  coveragePct: 85,
  maxCoverage: 100000000,
  notificationsEnabled: true,
  timeline: [
    P2PClaimTimelineEventDraft(
      id: 't1',
      statusKey: 'submitted',
      title: 'Yêu cầu đã gửi',
      description: 'Hệ thống tiếp nhận yêu cầu bồi thường',
      timestamp: '2026-02-18 14:30',
      actor: 'Hệ thống',
    ),
    P2PClaimTimelineEventDraft(
      id: 't2',
      statusKey: 'evidence_added',
      title: 'Bằng chứng bổ sung',
      description: 'Ảnh chụp màn hình chuyển khoản đã tải lên',
      timestamp: '2026-02-18 14:45',
      actor: 'Bạn',
    ),
    P2PClaimTimelineEventDraft(
      id: 't3',
      statusKey: 'reviewing',
      title: 'Bắt đầu điều tra',
      description: 'Nhân viên hỗ trợ bắt đầu xem xét bằng chứng',
      timestamp: '2026-02-19 09:15',
      actor: 'Nguyễn Văn A',
    ),
    P2PClaimTimelineEventDraft(
      id: 't4',
      statusKey: 'note_added',
      title: 'Ghi chú điều tra',
      description: 'Đã xác minh lịch sử chat và bằng chứng thanh toán',
      timestamp: '2026-02-19 11:30',
      actor: 'Nguyễn Văn A',
    ),
    P2PClaimTimelineEventDraft(
      id: 't5',
      statusKey: 'approved',
      title: 'Đã chấp thuận',
      description: 'Yêu cầu bồi thường đủ điều kiện, phê duyệt chi trả 85%',
      timestamp: '2026-02-19 16:00',
      actor: 'Trưởng nhóm',
    ),
    P2PClaimTimelineEventDraft(
      id: 't6',
      statusKey: 'paid',
      title: 'Đã chi trả',
      description: 'Chuyển 12.750.000 VND vào ví nội bộ',
      timestamp: '2026-02-20 10:00',
      actor: 'Hệ thống',
    ),
  ],
  evidence: [
    P2PClaimEvidenceDraft(
      id: 'e1',
      type: 'screenshot',
      name: 'chuyen_khoan_mb.png',
      size: '1.2 MB',
      uploadedAt: '2026-02-18 14:32',
    ),
    P2PClaimEvidenceDraft(
      id: 'e2',
      type: 'screenshot',
      name: 'chat_merchant.png',
      size: '850 KB',
      uploadedAt: '2026-02-18 14:35',
    ),
    P2PClaimEvidenceDraft(
      id: 'e3',
      type: 'screenshot',
      name: 'order_detail.png',
      size: '620 KB',
      uploadedAt: '2026-02-18 14:45',
    ),
    P2PClaimEvidenceDraft(
      id: 'e4',
      type: 'document',
      name: 'sao_ke_ngan_hang.pdf',
      size: '2.1 MB',
      uploadedAt: '2026-02-19 08:00',
    ),
  ],
  reviewerNotes: [
    P2PClaimReviewerNoteDraft(
      id: 'rn1',
      author: 'Nguyễn Văn A',
      role: 'Chuyên viên hỗ trợ',
      content:
          'Đã xác minh bằng chứng chuyển khoản qua MB Bank, khớp với số tiền giao dịch. Merchant không phản hồi sau 12 giờ theo quy định.',
      timestamp: '2026-02-19 11:30',
    ),
    P2PClaimReviewerNoteDraft(
      id: 'rn2',
      author: 'Trần Thị B',
      role: 'Trưởng nhóm Claims',
      content:
          'Phê duyệt chi trả 85% theo tier Pro. Merchant sẽ bị cảnh cáo và giảm hạng.',
      timestamp: '2026-02-19 16:00',
    ),
    P2PClaimReviewerNoteDraft(
      id: 'rn3',
      author: 'Hệ thống',
      role: 'Tự động',
      content:
          'Đã chuyển 12.750.000 VND vào ví nội bộ. Mã giao dịch: TXN-INS-20260220-001.',
      timestamp: '2026-02-20 10:00',
    ),
  ],
);

const List<P2PClaimBenchmarkDraft> _p2pClaimBenchmarks = [
  P2PClaimBenchmarkDraft(
    id: 'amount',
    title: 'Số tiền yêu cầu',
    value: '15.000.000 đ',
    caption: 'Tiền trung vị',
    comparison: 'Gần trung bình',
    progress: .32,
    toneKey: 'primary',
  ),
  P2PClaimBenchmarkDraft(
    id: 'resolution',
    title: 'Thời gian xử lý',
    value: '334h',
    caption: 'Chậm hơn 75% claims',
    comparison: 'Cao hơn TB',
    progress: 1,
    toneKey: 'warn',
  ),
  P2PClaimBenchmarkDraft(
    id: 'coverage',
    title: 'Tỷ lệ bảo hiểm',
    value: '85%',
    caption: 'Cao hơn 7% so với TB nền tảng',
    comparison: 'TB nền tảng: 78%',
    progress: .85,
    toneKey: 'buy',
  ),
];

const List<P2PClaimReasonShareDraft> _p2pClaimReasonShares = [
  P2PClaimReasonShareDraft(label: 'Gian lận', percent: 42, highlight: true),
  P2PClaimReasonShareDraft(label: 'Chargeback', percent: 28),
  P2PClaimReasonShareDraft(label: 'Lỗi dispute', percent: 18),
  P2PClaimReasonShareDraft(label: 'Khác', percent: 12),
];

const List<P2PMerchantBenefitDraft> _p2pMerchantBenefits = [
  P2PMerchantBenefitDraft(
    id: 'badge',
    title: 'Huy hiệu Merchant',
    subtitle: 'Tăng uy tín & thứ hạng hiển thị',
    iconKey: 'star',
    toneKey: 'warn',
  ),
  P2PMerchantBenefitDraft(
    id: 'fees',
    title: 'Phí ưu đãi',
    subtitle: 'Giảm 50% phí giao dịch P2P',
    iconKey: 'zap',
    toneKey: 'buy',
  ),
  P2PMerchantBenefitDraft(
    id: 'priority',
    title: 'Ưu tiên hiển thị',
    subtitle: 'Quảng cáo xuất hiện đầu danh sách',
    iconKey: 'users',
    toneKey: 'primary',
  ),
  P2PMerchantBenefitDraft(
    id: 'support',
    title: 'Hỗ trợ VIP',
    subtitle: 'Kênh hỗ trợ Merchant riêng 24/7',
    iconKey: 'shield',
    toneKey: 'accent',
  ),
];

const List<P2PMerchantRequirementDraft> _p2pMerchantRequirements = [
  P2PMerchantRequirementDraft(
    id: 'account_age',
    label: 'Tài khoản >= 30 ngày',
    value: '247 ngày',
    met: true,
    iconKey: 'clock',
  ),
  P2PMerchantRequirementDraft(
    id: 'orders',
    label: '>= 100 đơn hoàn thành',
    value: '156 đơn',
    met: true,
    iconKey: 'trend',
  ),
  P2PMerchantRequirementDraft(
    id: 'completion',
    label: 'Tỷ lệ HT >= 95%',
    value: '97.2%',
    met: true,
    iconKey: 'shield',
  ),
  P2PMerchantRequirementDraft(
    id: 'kyc',
    label: 'KYC cấp 2+',
    value: 'Cấp 2',
    met: true,
    iconKey: 'verified',
  ),
  P2PMerchantRequirementDraft(
    id: 'disputes',
    label: '<= 2 tranh chấp',
    value: '1 vụ',
    met: true,
    iconKey: 'warning',
  ),
];

const List<P2PMerchantDocumentDraft> _p2pMerchantDocuments = [
  P2PMerchantDocumentDraft(
    id: 'identity',
    title: 'CMND / CCCD / Hộ chiếu',
    subtitle: 'Ảnh 2 mặt rõ nét',
    required: true,
    iconKey: 'file',
  ),
  P2PMerchantDocumentDraft(
    id: 'business',
    title: 'Giấy phép kinh doanh',
    subtitle: 'Bản scan hoặc ảnh chụp',
    required: false,
    iconKey: 'award',
  ),
  P2PMerchantDocumentDraft(
    id: 'selfie',
    title: 'Ảnh selfie xác minh',
    subtitle: 'Cầm CMND + giấy ghi ngày',
    required: true,
    iconKey: 'camera',
  ),
];
