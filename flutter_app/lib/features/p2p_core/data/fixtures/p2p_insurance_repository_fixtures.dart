part of '../repositories/mock_p2p_repository.dart';

const List<P2PInsuranceEligibilityItemDraft> _p2pInsuranceEligibilityItems = [
  P2PInsuranceEligibilityItemDraft(label: 'Niêm sự cố thuộc diện nhận claim'),
  P2PInsuranceEligibilityItemDraft(
    label: 'KYC đã xác minh',
    value: 'Level 2 — Pro',
    highlight: true,
  ),
  P2PInsuranceEligibilityItemDraft(
    label: '2FA đã bật',
    value: 'Google Authenticator',
    highlight: true,
  ),
  P2PInsuranceEligibilityItemDraft(
    label: 'Tier đủ điều kiện',
    value: 'Pro — bảo hiểm 85%',
    highlight: true,
  ),
  P2PInsuranceEligibilityItemDraft(
    label: 'Hạn mức còn lại',
    value: '75.000.000 đ / 30 ngày',
    highlight: true,
  ),
  P2PInsuranceEligibilityItemDraft(
    label: 'Giao dịch P2P gần đây',
    value: '3 đơn trong 7 ngày qua',
    highlight: true,
  ),
];

const List<P2PInsuranceCoverageTierDraft> _p2pInsuranceCoverageTiers = [
  P2PInsuranceCoverageTierDraft(name: 'Thường', coveragePct: 'Không có'),
  P2PInsuranceCoverageTierDraft(name: 'Xác minh', coveragePct: '70%'),
  P2PInsuranceCoverageTierDraft(
    name: 'Pro',
    coveragePct: '85%',
    highlight: true,
  ),
  P2PInsuranceCoverageTierDraft(
    name: 'Elite',
    coveragePct: '100%',
    bonus: '+10%',
  ),
];

const List<P2PInsuranceNotificationPrefDraft> _p2pInsuranceNotificationPrefs = [
  P2PInsuranceNotificationPrefDraft(
    key: 'status_change',
    label: 'Thay đổi trạng thái',
    description: 'Khi claim chuyển sang trạng thái mới',
    enabled: true,
  ),
  P2PInsuranceNotificationPrefDraft(
    key: 'reviewer_note',
    label: 'Ghi chú reviewer',
    description: 'Khi có ghi chú mới từ nhân viên',
    enabled: true,
  ),
  P2PInsuranceNotificationPrefDraft(
    key: 'evidence_request',
    label: 'Yêu cầu bằng chứng',
    description: 'Khi cần bổ sung tài liệu',
    enabled: true,
  ),
  P2PInsuranceNotificationPrefDraft(
    key: 'payment_complete',
    label: 'Chi trả hoàn tất',
    description: 'Khi tiền đã chuyển vào ví',
    enabled: true,
  ),
  P2PInsuranceNotificationPrefDraft(
    key: 'fund_report',
    label: 'Báo cáo quỹ hàng tuần',
    description: 'Cập nhật tình hình quỹ bảo hiểm',
    enabled: false,
  ),
];

const List<P2PInsuranceClaimDraft> _p2pInsuranceClaims = [
  P2PInsuranceClaimDraft(
    id: 'ic001',
    claimCode: 'CLM-001',
    orderId: 'P2P-78400',
    reason: 'Gian lận',
    amount: 15000000,
    paidAmount: 12750000,
    status: P2PInsuranceClaimStatus.paid,
    submittedAt: '2026-02-18',
  ),
  P2PInsuranceClaimDraft(
    id: 'ic002',
    claimCode: 'CLM-002',
    orderId: 'P2P-78412',
    reason: 'Chargeback',
    amount: 8000000,
    status: P2PInsuranceClaimStatus.reviewing,
    submittedAt: '2026-02-23',
  ),
  P2PInsuranceClaimDraft(
    id: 'ic003',
    claimCode: 'CLM-003',
    orderId: 'P2P-78415',
    reason: 'Lỗi dispute',
    amount: 50000000,
    status: P2PInsuranceClaimStatus.approved,
    submittedAt: '2026-02-22',
  ),
  P2PInsuranceClaimDraft(
    id: 'ic004',
    claimCode: 'CLM-004',
    orderId: 'P2P-78390',
    reason: 'Khác',
    amount: 3000000,
    status: P2PInsuranceClaimStatus.rejected,
    submittedAt: '2026-02-20',
  ),
  P2PInsuranceClaimDraft(
    id: 'ic005',
    claimCode: 'CLM-005',
    orderId: 'P2P-78425',
    reason: 'Gian lận',
    amount: 25000000,
    status: P2PInsuranceClaimStatus.pending,
    submittedAt: '2026-02-25',
  ),
];

const List<P2PInsuranceChartPointDraft> _p2pInsuranceChartPoints = [
  P2PInsuranceChartPointDraft(
    day: '01/02',
    balance: 380,
    inflow: 12,
    outflow: 5,
  ),
  P2PInsuranceChartPointDraft(
    day: '05/02',
    balance: 394,
    inflow: 11,
    outflow: 4,
  ),
  P2PInsuranceChartPointDraft(
    day: '09/02',
    balance: 408,
    inflow: 13,
    outflow: 6,
  ),
  P2PInsuranceChartPointDraft(
    day: '13/02',
    balance: 430,
    inflow: 15,
    outflow: 5,
  ),
  P2PInsuranceChartPointDraft(
    day: '17/02',
    balance: 455,
    inflow: 20,
    outflow: 5,
  ),
  P2PInsuranceChartPointDraft(
    day: '21/02',
    balance: 478,
    inflow: 19,
    outflow: 6,
  ),
  P2PInsuranceChartPointDraft(
    day: '25/02',
    balance: 505,
    inflow: 20,
    outflow: 5,
  ),
  P2PInsuranceChartPointDraft(
    day: '01/03',
    balance: 523,
    inflow: 14,
    outflow: 6,
  ),
];

const List<String> _p2pInsuranceCertificateCoveredCases = [
  'Gian lận - merchant không giải phóng coin',
  'Chargeback - buyer hoàn tiền qua ngân hàng',
  'Lỗi hệ thống - dispute phân xử sai',
  'Trường hợp khác - xem xét riêng',
];

const List<String> _p2pInsuranceCertificateExclusions = [
  'Biến động giá tài sản',
  'Lỗi nhập sai địa chỉ ví',
  'Giao dịch ngoài nền tảng',
  'Gian lận từ phía người claim',
];

const List<P2PInsuranceScoreFactorDraft> _p2pInsuranceScoreFactors = [
  P2PInsuranceScoreFactorDraft(
    id: 'kyc',
    label: 'Xác minh danh tính',
    description: 'KYC Level 2 đã hoàn tất',
    score: 20,
    maxScore: 20,
    statusLabel: 'Xuất sắc',
    toneKey: 'buy',
    iconKey: 'user_check',
  ),
  P2PInsuranceScoreFactorDraft(
    id: 'trading',
    label: 'Lịch sử giao dịch',
    description: '128 giao dịch thành công, 99.2% completion',
    score: 22,
    maxScore: 25,
    statusLabel: 'Tốt',
    toneKey: 'primary',
    iconKey: 'bar_chart',
    recommendation: 'Hoàn thành thêm 20 giao dịch để đạt điểm tối đa',
  ),
  P2PInsuranceScoreFactorDraft(
    id: 'claim_history',
    label: 'Lịch sử claims',
    description: '5 claims, 60% được duyệt, 0 gian lận',
    score: 16,
    maxScore: 20,
    statusLabel: 'Tốt',
    toneKey: 'accent',
    iconKey: 'shield',
    recommendation:
        'Tỷ lệ duyệt 60% - cải thiện chất lượng bằng chứng khi gửi claim',
  ),
  P2PInsuranceScoreFactorDraft(
    id: 'account_age',
    label: 'Tuổi tài khoản',
    description: '14 tháng hoạt động liên tục',
    score: 12,
    maxScore: 15,
    statusLabel: 'Tốt',
    toneKey: 'warn',
    iconKey: 'award',
    recommendation: 'Đạt 18 tháng để nhận điểm tối đa',
  ),
  P2PInsuranceScoreFactorDraft(
    id: 'security',
    label: 'Bảo mật tài khoản',
    description: '2FA bật, chưa có anti-phishing code',
    score: 8,
    maxScore: 20,
    statusLabel: 'Trung bình',
    toneKey: 'sell',
    iconKey: 'lock',
    recommendation:
        'Thiết lập Anti-Phishing Code và Biometrics để tăng 12 điểm',
  ),
];

const List<P2PInsuranceScoreQuickActionDraft> _p2pInsuranceScoreQuickActions = [
  P2PInsuranceScoreQuickActionDraft(
    label: 'Thiết lập Anti-Phishing Code',
    gain: '+8 điểm',
    toneKey: 'sell',
    route: '/profile/settings',
  ),
  P2PInsuranceScoreQuickActionDraft(
    label: 'Bật Biometrics / Passkey',
    gain: '+4 điểm',
    toneKey: 'warn',
    route: '/profile/settings',
  ),
  P2PInsuranceScoreQuickActionDraft(
    label: 'Hoàn thành thêm 20 giao dịch',
    gain: '+3 điểm',
    toneKey: 'primary',
    route: '/p2p',
  ),
  P2PInsuranceScoreQuickActionDraft(
    label: 'Duy trì 4 tháng nữa',
    gain: '+3 điểm',
    toneKey: 'accent',
  ),
];

const List<P2PInsuranceScoreTierDraft> _p2pInsuranceScoreTiers = [
  P2PInsuranceScoreTierDraft(
    name: 'Thường',
    requiredScore: 0,
    coveragePct: '0%',
    requirements: ['Tạo tài khoản'],
    isCurrent: false,
    isUnlocked: true,
  ),
  P2PInsuranceScoreTierDraft(
    name: 'Xác minh',
    requiredScore: 30,
    coveragePct: '70%',
    requirements: ['KYC Level 1+', 'Điểm bảo vệ ≥ 30', '2FA bật'],
    isCurrent: false,
    isUnlocked: true,
  ),
  P2PInsuranceScoreTierDraft(
    name: 'Pro',
    requiredScore: 60,
    coveragePct: '85%',
    requirements: [
      'KYC Level 2',
      'Điểm bảo vệ ≥ 60',
      '50+ giao dịch',
      'Completion ≥ 95%',
    ],
    isCurrent: true,
    isUnlocked: true,
  ),
  P2PInsuranceScoreTierDraft(
    name: 'Elite',
    requiredScore: 90,
    coveragePct: '100% +10%',
    requirements: [
      'KYC Level 2',
      'Điểm bảo vệ ≥ 90',
      '200+ giao dịch',
      'Completion ≥ 98%',
      '0 vi phạm 6 tháng',
      'Anti-Phishing Code bật',
    ],
    isCurrent: false,
    isUnlocked: false,
  ),
];

const List<P2PInsurancePolicySectionDraft> _p2pInsurancePolicySections = [
  P2PInsurancePolicySectionDraft(
    id: 'scope',
    title: '1. Phạm vi bảo hiểm',
    content: [
      'Quỹ Bảo Hiểm P2P bảo vệ merchants và buyers trên nền tảng giao dịch P2P khỏi các rủi ro gian lận, chargeback, và lỗi hệ thống trong quá trình giao dịch.',
      'Bảo hiểm áp dụng cho tất cả giao dịch P2P đã hoàn tất trên nền tảng, với điều kiện người dùng đã đóng góp vào quỹ thông qua phí giao dịch.',
      'Bảo hiểm KHÔNG bao gồm: thiệt hại do biến động giá thị trường, lỗi của người dùng trong việc nhập sai địa chỉ ví, hoặc các giao dịch ngoài nền tảng.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'eligibility',
    title: '2. Điều kiện đủ tiêu chuẩn',
    content: [
      'Người dùng phải hoàn tất xác minh danh tính (KYC) ít nhất ở mức "Xác minh" để được bảo hiểm.',
      'Giao dịch phải được thực hiện hoàn toàn trên nền tảng, bao gồm thanh toán và giải phóng coin.',
      'Yêu cầu bồi thường phải được gửi trong vòng 7 ngày kể từ ngày giao dịch xảy ra sự cố.',
      'Mỗi người dùng có hạn mức bồi thường tối đa 100.000.000 VND trong 30 ngày.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'tiers',
    title: '3. Các mức bảo hiểm',
    content: [
      'Thường: Không được bảo hiểm - cần hoàn tất KYC để kích hoạt.',
      'Xác minh: Bảo hiểm 70% giá trị giao dịch - áp dụng cho người dùng đã KYC.',
      'Pro: Bảo hiểm 85% giá trị giao dịch - áp dụng cho merchants Pro đã được phê duyệt.',
      'Elite: Bảo hiểm 100% giá trị giao dịch + 10% bonus - áp dụng cho merchants Elite có uy tín cao.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'contribution',
    title: '4. Đóng góp quỹ',
    content: [
      '0.1% giá trị mỗi giao dịch P2P sẽ được tự động trích vào Quỹ Bảo Hiểm.',
      'Phí đóng góp được hiển thị rõ trong phần phí giao dịch trước khi xác nhận.',
      'Đóng góp không được hoàn lại và không thể rút ra khỏi quỹ.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'claims',
    title: '5. Quy trình yêu cầu bồi thường',
    content: [
      'Bước 1: Gửi yêu cầu bồi thường kèm mã đơn hàng, lý do, số tiền, và mô tả chi tiết.',
      'Bước 2: Đội ngũ hỗ trợ sẽ xem xét yêu cầu trong vòng 48 giờ làm việc.',
      'Bước 3: Nếu được phê duyệt, chi trả sẽ được thực hiện trong vòng 72 giờ vào ví nội bộ.',
      'Bước 4: Nếu bị từ chối, người dùng có thể kháng nghị trong vòng 14 ngày.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'evidence',
    title: '6. Bằng chứng yêu cầu',
    content: [
      'Người dùng cần cung cấp bằng chứng đầy đủ: ảnh chụp màn hình giao dịch, lịch sử chat, sao kê ngân hàng.',
      'Bằng chứng phải là nguyên gốc, không chỉnh sửa. Phát hiện giả mạo sẽ dẫn đến từ chối vĩnh viễn.',
      'Tất cả bằng chứng được mã hóa và chỉ nhân viên có thẩm quyền mới được truy cập.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'exclusions',
    title: '7. Các trường hợp loại trừ',
    content: [
      'Giao dịch ngoài nền tảng hoặc sử dụng kênh thanh toán không được hỗ trợ.',
      'Thiệt hại do biến động giá thị trường sau khi giao dịch hoàn tất.',
      'Yêu cầu gửi sau thời hạn 7 ngày kể từ ngày sự cố.',
      'Người dùng có lịch sử gian lận hoặc vi phạm điều khoản sử dụng.',
      'Yêu cầu vượt quá hạn mức bồi thường trong kỳ 30 ngày.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'privacy',
    title: '8. Bảo mật dữ liệu',
    content: [
      'Thông tin cá nhân và bằng chứng được lưu trữ theo tiêu chuẩn bảo mật AES-256.',
      'Dữ liệu chỉ được sử dụng cho mục đích xem xét yêu cầu bồi thường.',
      'Sau khi yêu cầu được giải quyết, bằng chứng sẽ được lưu trữ trong 90 ngày rồi tự động xóa.',
      'Người dùng có quyền yêu cầu xóa dữ liệu sớm hơn theo chính sách GDPR.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'governance',
    title: '9. Quản trị quỹ',
    content: [
      'Quỹ Bảo Hiểm được kiểm toán định kỳ bởi đơn vị kiểm toán độc lập.',
      'Báo cáo Proof of Reserves được công bố hàng tháng.',
      'Tỷ lệ thanh khoản (Solvency Ratio) được giám sát liên tục và công khai.',
      'Nền tảng có quyền tạm ngưng nhận claims mới nếu tỷ lệ thanh khoản dưới 100%.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'amendments',
    title: '10. Sửa đổi điều khoản',
    content: [
      'Nền tảng có quyền sửa đổi điều khoản bảo hiểm với thông báo trước 30 ngày.',
      'Người dùng sẽ được thông báo qua email và push notification về các thay đổi.',
      'Tiếp tục sử dụng dịch vụ sau ngày có hiệu lực đồng nghĩa với việc chấp nhận điều khoản mới.',
    ],
  ),
];

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
