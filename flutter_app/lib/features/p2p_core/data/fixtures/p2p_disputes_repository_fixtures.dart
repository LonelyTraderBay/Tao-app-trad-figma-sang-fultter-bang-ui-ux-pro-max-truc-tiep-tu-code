part of '../repositories/mock_p2p_repository.dart';

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
