part of '../repositories/mock_p2p_repository.dart';

const List<P2POrderTimelineEventDraft> _p2pOrderTimelineEvents = [
  P2POrderTimelineEventDraft(
    id: '1',
    typeKey: 'created',
    title: 'Order Created',
    time: '2026-03-05 14:20:00',
    status: P2POrderTimelineStatus.completed,
    actor: 'You',
  ),
  P2POrderTimelineEventDraft(
    id: '2',
    typeKey: 'matched',
    title: 'Matched with Seller',
    time: '2026-03-05 14:20:15',
    status: P2POrderTimelineStatus.completed,
    actor: 'System',
  ),
  P2POrderTimelineEventDraft(
    id: '3',
    typeKey: 'locked',
    title: 'Funds Locked in Escrow',
    time: '2026-03-05 14:20:30',
    status: P2POrderTimelineStatus.completed,
    actor: 'Seller',
  ),
  P2POrderTimelineEventDraft(
    id: '4',
    typeKey: 'payment',
    title: 'Payment Instructions Sent',
    time: '2026-03-05 14:21:00',
    status: P2POrderTimelineStatus.completed,
    actor: 'Seller',
  ),
  P2POrderTimelineEventDraft(
    id: '5',
    typeKey: 'paid',
    title: 'Marked as Paid',
    time: '2026-03-05 14:35:22',
    status: P2POrderTimelineStatus.completed,
    actor: 'You',
  ),
  P2POrderTimelineEventDraft(
    id: '6',
    typeKey: 'confirming',
    title: 'Awaiting Seller Confirmation',
    time: '2026-03-05 14:35:30',
    status: P2POrderTimelineStatus.pending,
    actor: 'Seller',
  ),
];

const List<P2POrderRateTagDraft> _p2pOrderRateTags = [
  P2POrderRateTagDraft(label: 'Giao dich nhanh', iconKey: 'speed'),
  P2POrderRateTagDraft(label: 'Than thien', iconKey: 'positive'),
  P2POrderRateTagDraft(label: 'Dang tin cay', iconKey: 'trust'),
  P2POrderRateTagDraft(label: 'Gia tot', iconKey: 'price'),
  P2POrderRateTagDraft(label: 'Phan hoi cham', iconKey: 'slow'),
  P2POrderRateTagDraft(label: 'Can cai thien', iconKey: 'improve'),
];

const List<String> _p2pOrderCancelReasons = [
  'Không muốn giao dịch nữa',
  'Đã tìm được giá tốt hơn',
  'Người bán không phản hồi',
  'Thông tin thanh toán không đúng',
  'Lý do khác',
];

const List<String> _p2pOrderProofTips = [
  'Chụp toàn bộ màn hình giao dịch ngân hàng',
  'Hiển thị rõ số tiền, ngày giờ và người nhận',
  'Nội dung chuyển khoản phải đúng mã đơn',
  'Không chỉnh sửa hoặc cắt ghép ảnh',
];

const List<P2POrderPaymentFieldDraft> _p2pOrderPaymentFields = [
  P2POrderPaymentFieldDraft(
    id: 'bank',
    label: 'Ngân hàng',
    value: 'Vietcombank',
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'account',
    label: 'Số tài khoản',
    value: '1234567890',
    monospace: true,
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'name',
    label: 'Tên chủ TK',
    value: 'NGUYEN VAN B',
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'amount',
    label: 'Số tiền',
    value: '5.070.000 VND',
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'content',
    label: 'Nội dung CK',
    value: 'VITTA P2P001',
    monospace: true,
    emphasis: true,
  ),
];

const List<P2POrderTimelineStepDraft> _p2pOrderTimelineSteps = [
  P2POrderTimelineStepDraft(
    id: 'created',
    label: 'Đơn hàng đã tạo',
    description: 'Mua 200.0000 USDT - Escrow đã khóa',
    time: '11:00',
    status: P2POrderStepStatus.completed,
    iconKey: 'created',
  ),
  P2POrderTimelineStepDraft(
    id: 'payment',
    label: 'Chờ thanh toán',
    description: 'Chuyển 5.070.000 VND qua Vietcombank',
    time: 'Đang chờ',
    status: P2POrderStepStatus.active,
    iconKey: 'payment',
  ),
  P2POrderTimelineStepDraft(
    id: 'confirm',
    label: 'Xác nhận thanh toán',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'confirm',
  ),
  P2POrderTimelineStepDraft(
    id: 'release',
    label: 'Giải phóng crypto',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'release',
  ),
];

const List<P2POrderQuickActionDraft> _p2pOrderQuickActions = [
  P2POrderQuickActionDraft(
    id: 'merchant',
    label: 'Merchant',
    iconKey: 'merchant',
    route: '/p2p/merchant/mc001',
  ),
  P2POrderQuickActionDraft(
    id: 'block',
    label: 'Chặn',
    iconKey: 'block',
    route: '/p2p/blacklist',
  ),
  P2POrderQuickActionDraft(
    id: 'guide',
    label: 'Hướng dẫn',
    iconKey: 'guide',
    route: '/p2p/guide',
  ),
  P2POrderQuickActionDraft(
    id: 'support',
    label: 'Hỗ trợ',
    iconKey: 'support',
    route: '/support/help',
  ),
];

const List<P2PChatMessageDraft> _p2pChatMessages = [
  P2PChatMessageDraft(
    id: 'system-created',
    sender: P2PChatSender.system,
    text:
        'Đơn hàng #VT-P2P-20240221-001 đã được tạo. Vui lòng thanh toán trong 15 phút.',
    time: '11:00',
  ),
  P2PChatMessageDraft(
    id: 'merchant-hello',
    sender: P2PChatSender.other,
    text: 'Xin chào! Vui lòng chuyển khoản theo thông tin tôi cung cấp nhé',
    time: '11:01',
  ),
  P2PChatMessageDraft(
    id: 'buyer-account',
    sender: P2PChatSender.me,
    text: 'Vâng, tôi sẽ chuyển ngay. Số tài khoản là 1234567890 đúng không?',
    time: '11:02',
  ),
  P2PChatMessageDraft(
    id: 'merchant-confirm',
    sender: P2PChatSender.other,
    text: 'Đúng rồi. Chủ tài khoản NGUYEN VAN B - Vietcombank.',
    time: '11:02',
  ),
  P2PChatMessageDraft(
    id: 'buyer-paid',
    sender: P2PChatSender.me,
    text: 'Đã chuyển khoản xong, vui lòng xác nhận nhé!',
    time: '11:07',
  ),
];

const List<String> _p2pChatQuickReplies = [
  'Tôi đã chuyển khoản xong',
  'Bạn đã nhận tiền chưa?',
  'Cảm ơn bạn!',
  'Tôi cần hỗ trợ',
];

const List<P2PDisputeLevelDraft> _p2pDisputeLevels = [
  P2PDisputeLevelDraft(
    level: 1,
    shortLabel: 'Xử lý tự động',
    label: 'Bot AI',
    description: 'Hệ thống AI phân tích bằng chứng & đưa ra khuyến nghị',
    avgTime: '~5 phút',
    iconKey: 'bot',
  ),
  P2PDisputeLevelDraft(
    level: 2,
    shortLabel: 'Nhân viên hỗ trợ',
    label: 'Support Agent',
    description: 'Nhân viên xem xét chi tiết, liên hệ cả hai bên',
    avgTime: '~2 giờ',
    iconKey: 'support',
  ),
  P2PDisputeLevelDraft(
    level: 3,
    shortLabel: 'Trọng tài',
    label: 'Arbitration',
    description: 'Trọng tài viên độc lập đánh giá & ra quyết định',
    avgTime: '~24 giờ',
    iconKey: 'scale',
  ),
  P2PDisputeLevelDraft(
    level: 4,
    shortLabel: 'Đội ngũ pháp lý',
    label: 'Legal Team',
    description: 'Xử lý bởi đội ngũ pháp lý trong trường hợp nghiêm trọng',
    avgTime: '~48 giờ',
    iconKey: 'briefcase',
  ),
];

const List<P2PDisputeEvidenceDraft> _p2pDisputeEvidence = [
  P2PDisputeEvidenceDraft(
    id: 'proof-transfer-001',
    fileName: 'proof_transfer_001.jpg',
  ),
  P2PDisputeEvidenceDraft(
    id: 'screenshot-chat-001',
    fileName: 'screenshot_chat_001.jpg',
  ),
];

const List<P2PDisputeEvidenceDocumentDraft> _p2pDisputeEvidenceDocuments = [
  P2PDisputeEvidenceDocumentDraft(
    id: 'payment',
    label: 'Payment Receipt',
    iconKey: 'file',
    uploaded: true,
  ),
  P2PDisputeEvidenceDocumentDraft(
    id: 'chat',
    label: 'Chat Screenshot',
    iconKey: 'image',
    uploaded: true,
  ),
  P2PDisputeEvidenceDocumentDraft(
    id: 'transaction',
    label: 'Transaction Proof',
    iconKey: 'file',
    uploaded: false,
  ),
];

const List<String> _p2pDisputeReasons = [
  'Seller không release sau khi nhận tiền',
  'Buyer không thanh toán',
  'Thông tin thanh toán sai',
  'Số tiền không khớp',
  'Khác (ghi rõ)',
];

const List<P2PDisputeListItemDraft> _p2pDisputeList = [
  P2PDisputeListItemDraft(
    id: 'disp001',
    orderId: 'p2p006',
    orderNumber: 'VT-P2P-20240219-006',
    status: P2PDisputeStatus.underReview,
    statusLabel: 'Đang xem xét',
    reason: 'Đã thanh toán nhưng người bán không xác nhận',
    createdAt: '2024-02-19 08:50',
    evidenceCount: 2,
    timelineCount: 5,
  ),
];

const List<String> _p2pDisputeGuideSteps = [
  'Vào đơn hàng đang có vấn đề',
  'Bấm "Mở tranh chấp" trong trang chi tiết đơn',
  'Mô tả vấn đề và đính kèm bằng chứng',
  'Chờ hệ thống xử lý (trung bình 2-24 giờ)',
];

const List<P2PAdDailyPerformanceDraft> _p2pAdDailyPerformance = [
  P2PAdDailyPerformanceDraft(
    date: '20/02',
    impressions: 412,
    orders: 8,
    volume: 68000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '21/02',
    impressions: 389,
    orders: 12,
    volume: 95000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '22/02',
    impressions: 478,
    orders: 15,
    volume: 112000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '23/02',
    impressions: 356,
    orders: 6,
    volume: 48000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '24/02',
    impressions: 501,
    orders: 18,
    volume: 142000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '25/02',
    impressions: 445,
    orders: 14,
    volume: 108000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '26/02',
    impressions: 520,
    orders: 20,
    volume: 158000000,
  ),
];

const List<P2PAdHourlyHeatmapDraft> _p2pAdHourlyHeatmap = [
  P2PAdHourlyHeatmapDraft(hour: 0, orders: 2),
  P2PAdHourlyHeatmapDraft(hour: 1, orders: 1),
  P2PAdHourlyHeatmapDraft(hour: 2, orders: 0),
  P2PAdHourlyHeatmapDraft(hour: 3, orders: 0),
  P2PAdHourlyHeatmapDraft(hour: 4, orders: 1),
  P2PAdHourlyHeatmapDraft(hour: 5, orders: 2),
  P2PAdHourlyHeatmapDraft(hour: 6, orders: 4),
  P2PAdHourlyHeatmapDraft(hour: 7, orders: 8),
  P2PAdHourlyHeatmapDraft(hour: 8, orders: 15),
  P2PAdHourlyHeatmapDraft(hour: 9, orders: 22),
  P2PAdHourlyHeatmapDraft(hour: 10, orders: 28),
  P2PAdHourlyHeatmapDraft(hour: 11, orders: 24),
  P2PAdHourlyHeatmapDraft(hour: 12, orders: 18),
  P2PAdHourlyHeatmapDraft(hour: 13, orders: 20),
  P2PAdHourlyHeatmapDraft(hour: 14, orders: 26),
  P2PAdHourlyHeatmapDraft(hour: 15, orders: 24),
  P2PAdHourlyHeatmapDraft(hour: 16, orders: 22),
  P2PAdHourlyHeatmapDraft(hour: 17, orders: 18),
  P2PAdHourlyHeatmapDraft(hour: 18, orders: 15),
  P2PAdHourlyHeatmapDraft(hour: 19, orders: 20),
  P2PAdHourlyHeatmapDraft(hour: 20, orders: 25),
  P2PAdHourlyHeatmapDraft(hour: 21, orders: 22),
  P2PAdHourlyHeatmapDraft(hour: 22, orders: 12),
  P2PAdHourlyHeatmapDraft(hour: 23, orders: 5),
];

const List<P2PAdPaymentBreakdownDraft> _p2pAdPaymentBreakdown = [
  P2PAdPaymentBreakdownDraft(
    method: 'Vietcombank',
    count: 156,
    volume: 1240000000,
  ),
  P2PAdPaymentBreakdownDraft(method: 'Momo', count: 118, volume: 940000000),
];

const List<P2PAdCompetitorComparisonDraft> _p2pAdCompetitorComparison = [
  P2PAdCompetitorComparisonDraft(
    metric: 'Giá',
    yours: 25360,
    average: 25320,
    top: 25280,
  ),
  P2PAdCompetitorComparisonDraft(
    metric: 'Tỷ lệ HT (%)',
    yours: 94.8,
    average: 89.2,
    top: 98.5,
  ),
  P2PAdCompetitorComparisonDraft(
    metric: 'Phản hồi (s)',
    yours: 45,
    average: 120,
    top: 25,
  ),
  P2PAdCompetitorComparisonDraft(
    metric: 'Rating',
    yours: 4.8,
    average: 4.2,
    top: 4.9,
  ),
];

const List<P2PAdOptimizationTipDraft> _p2pAdOptimizationTips = [
  P2PAdOptimizationTipDraft(
    tone: 'buy',
    iconKey: 'check',
    text: 'Tỷ lệ hoàn thành tốt! Duy trì phản hồi nhanh để giữ vị trí top 3.',
  ),
  P2PAdOptimizationTipDraft(
    tone: 'accent',
    iconKey: 'clock',
    text: 'Giờ cao điểm 9h-11h & 20h-21h. Đảm bảo online trong khung giờ này.',
  ),
  P2PAdOptimizationTipDraft(
    tone: 'warn',
    iconKey: 'trend',
    text: 'CVR tốt! Xem xét tăng available amount để đón thêm đơn.',
  ),
];

const List<P2PDisputeTimelineDraft> _p2pDisputeTimeline = [
  P2PDisputeTimelineDraft(
    id: 'created',
    event: 'Đơn hàng được tạo',
    time: '2024-02-19 08:10',
  ),
  P2PDisputeTimelineDraft(
    id: 'paid',
    event: 'Đã thanh toán',
    detail: 'Chuyển khoản Vietcombank',
    time: '2024-02-19 08:15',
  ),
  P2PDisputeTimelineDraft(
    id: 'expired',
    event: 'Hết thời gian xác nhận',
    time: '2024-02-19 08:45',
  ),
  P2PDisputeTimelineDraft(
    id: 'submitted',
    event: 'Khiếu nại được gửi',
    detail: 'Bằng chứng: 2 ảnh',
    time: '2024-02-19 08:50',
  ),
  P2PDisputeTimelineDraft(
    id: 'review',
    event: 'Đang xem xét',
    detail: 'Bộ phận hỗ trợ đã tiếp nhận',
    time: '2024-02-19 09:00',
    active: true,
  ),
];

const List<P2PDisputeSupportMessageDraft> _p2pDisputeSupportMessages = [
  P2PDisputeSupportMessageDraft(
    id: 'user-open',
    sender: P2PDisputeMessageSender.user,
    text:
        'Tôi đã chuyển khoản xong nhưng seller không xác nhận. Đính kèm ảnh chụp giao dịch ngân hàng.',
    time: '08:50',
  ),
  P2PDisputeSupportMessageDraft(
    id: 'support-received',
    sender: P2PDisputeMessageSender.support,
    text:
        'Chào bạn, chúng tôi đã nhận được khiếu nại. Đang liên hệ người bán để xác minh. Vui lòng chờ trong 24h.',
    time: '09:05',
  ),
  P2PDisputeSupportMessageDraft(
    id: 'support-update',
    sender: P2PDisputeMessageSender.support,
    text:
        'Cập nhật: Người bán đã xác nhận nhận được tiền. Crypto sẽ được giải phóng trong 5 phút.',
    time: '10:30',
  ),
];

const List<P2PMerchantProfileDraft> _p2pMerchants = [
  P2PMerchantProfileDraft(
    id: 'mc001',
    name: 'CryptoKing_VN',
    level: 3,
    kycVerified: true,
    joinDate: '15/6/2022',
    totalTrades: 1243,
    totalTrades30d: 89,
    completionRate: 98.5,
    avgReleaseTime: '2 phút',
    avgPayTime: '5 phút',
    totalVolume30dUsd: 850000,
    isOnline: true,
    lastActive: '1 phút trước',
    positiveRate: 97.8,
    negativeCount: 3,
    activeAds: 4,
  ),
  P2PMerchantProfileDraft(
    id: 'mc004',
    name: 'VIPTrader_HN',
    level: 3,
    kycVerified: true,
    joinDate: '5/11/2021',
    totalTrades: 3421,
    totalTrades30d: 210,
    completionRate: 99.1,
    avgReleaseTime: '1 phút',
    avgPayTime: '3 phút',
    totalVolume30dUsd: 2100000,
    isOnline: true,
    lastActive: 'Vừa xong',
    positiveRate: 99.3,
    negativeCount: 1,
    activeAds: 5,
  ),
];
