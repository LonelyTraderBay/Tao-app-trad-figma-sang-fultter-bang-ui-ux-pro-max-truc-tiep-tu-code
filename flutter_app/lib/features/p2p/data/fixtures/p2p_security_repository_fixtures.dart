part of '../repositories/mock_p2p_repository.dart';

const List<P2PSecurityFeatureDraft> _p2pSecurityFeatures = [
  P2PSecurityFeatureDraft(
    id: '2fa',
    label: '2FA cho P2P',
    iconKey: 'phone',
    status: P2PSecurityStatus.enabled,
    scoreDelta: 30,
    route: '/p2p/security/2fa',
  ),
  P2PSecurityFeatureDraft(
    id: 'anti_phishing',
    label: 'Mã chống phishing',
    iconKey: 'anti_phishing',
    status: P2PSecurityStatus.enabled,
    scoreDelta: 20,
    route: '/p2p/security/anti-phishing',
  ),
  P2PSecurityFeatureDraft(
    id: 'trusted_devices',
    label: 'Thiết bị tin cậy',
    iconKey: 'devices',
    status: P2PSecurityStatus.warning,
    scoreDelta: 15,
    route: '/p2p/security/devices',
  ),
  P2PSecurityFeatureDraft(
    id: 'whitelist',
    label: 'Chế độ whitelist',
    iconKey: 'whitelist',
    status: P2PSecurityStatus.disabled,
    scoreDelta: 0,
    route: '/p2p/security/whitelist',
  ),
  P2PSecurityFeatureDraft(
    id: 'biometric',
    label: 'Khóa sinh trắc học',
    iconKey: 'biometric',
    status: P2PSecurityStatus.enabled,
    scoreDelta: 25,
    route: '/settings/security/biometric',
  ),
];

const List<P2PSecurityQuickActionDraft> _p2pSecurityQuickActions = [
  P2PSecurityQuickActionDraft(
    id: 'change_password',
    label: 'Đổi mật khẩu',
    iconKey: 'password',
    colorKey: 'p2p',
    route: '/settings/security/change-password',
  ),
  P2PSecurityQuickActionDraft(
    id: 'login_history',
    label: 'Lịch sử đăng nhập',
    iconKey: 'history',
    colorKey: 'success',
    route: '/p2p/security/login-history',
  ),
  P2PSecurityQuickActionDraft(
    id: 'devices',
    label: 'Quản lý thiết bị',
    iconKey: 'devices',
    colorKey: 'warning',
    route: '/p2p/security/devices',
  ),
  P2PSecurityQuickActionDraft(
    id: 'activity',
    label: 'Hoạt động đáng ngờ',
    iconKey: 'alert',
    colorKey: 'danger',
    route: '/p2p/security/suspicious-activity',
  ),
];

const List<P2PSecurityEventDraft> _p2pSecurityRecentEvents = [
  P2PSecurityEventDraft(
    id: 'login_success',
    label: 'Đăng nhập thành công',
    description: 'iPhone 15 Pro · Hà Nội, VN',
    time: '2 phút trước',
    iconKey: 'success',
    severity: P2PSecurityEventSeverity.info,
  ),
  P2PSecurityEventDraft(
    id: 'new_device',
    label: 'Thiết bị mới',
    description: 'MacBook Pro · TP.HCM, VN',
    time: '3 giờ trước',
    iconKey: 'device',
    severity: P2PSecurityEventSeverity.warning,
  ),
  P2PSecurityEventDraft(
    id: 'failed_login',
    label: 'Đăng nhập thất bại',
    description: '3 lần nhập sai mật khẩu',
    time: '1 ngày trước',
    iconKey: 'failed',
    severity: P2PSecurityEventSeverity.critical,
  ),
];

const List<P2PTwoFactorMethodDraft> _p2pTwoFactorMethods = [
  P2PTwoFactorMethodDraft(
    id: '2fa_sms',
    label: 'SMS OTP',
    description: '+84 *** *** **89',
    iconKey: 'sms',
    colorKey: 'success',
    enabled: true,
    isPrimary: true,
    setupRequired: false,
  ),
  P2PTwoFactorMethodDraft(
    id: '2fa_authenticator',
    label: 'Authenticator App',
    description: 'Google Authenticator, Authy',
    iconKey: 'authenticator',
    colorKey: 'p2p',
    enabled: false,
    isPrimary: false,
    setupRequired: true,
  ),
  P2PTwoFactorMethodDraft(
    id: '2fa_email',
    label: 'Email OTP',
    description: 'ngu***@gmail.com',
    iconKey: 'email',
    colorKey: 'warning',
    enabled: true,
    isPrimary: false,
    setupRequired: false,
  ),
];

const List<P2PTransactionThresholdDraft> _p2pTwoFactorThresholds = [
  P2PTransactionThresholdDraft(
    id: 'release',
    label: 'Release Escrow',
    description: 'Yêu cầu 2FA khi release >= threshold',
    valueLabel: '≥ 10,000,000 VND',
    enabled: true,
    editable: true,
  ),
  P2PTransactionThresholdDraft(
    id: 'create_order',
    label: 'Create Order',
    description: 'Yêu cầu 2FA khi tạo order >= threshold',
    valueLabel: '≥ 50,000,000 VND',
    enabled: false,
    editable: true,
  ),
  P2PTransactionThresholdDraft(
    id: 'cancel_order',
    label: 'Cancel Order',
    description: 'Luôn yêu cầu 2FA khi hủy đơn',
    valueLabel: '',
    enabled: true,
    editable: false,
  ),
];

const List<P2PTrustedDeviceDraft> _p2pTrustedDevices = [
  P2PTrustedDeviceDraft(
    id: 'device_iphone_15',
    name: 'iPhone 15 Pro',
    type: 'mobile',
    os: 'iOS 17.3',
    browser: 'Safari',
    location: 'Hà Nội, VN',
    ip: '123.21.45.67',
    lastActive: '2 phút trước',
    firstSeen: '2026-01-15',
    isCurrent: true,
    isTrusted: true,
    fingerprint: 'fp_abc123xyz789',
  ),
  P2PTrustedDeviceDraft(
    id: 'device_macbook',
    name: 'MacBook Pro',
    type: 'desktop',
    os: 'macOS 14.3',
    browser: 'Chrome 121',
    location: 'TP.HCM, VN',
    ip: '113.161.78.90',
    lastActive: '3 giờ trước',
    firstSeen: '2026-02-10',
    isCurrent: false,
    isTrusted: true,
    fingerprint: 'fp_def456uvw321',
  ),
  P2PTrustedDeviceDraft(
    id: 'device_samsung_s24',
    name: 'Samsung Galaxy S24',
    type: 'mobile',
    os: 'Android 14',
    browser: 'Chrome Mobile',
    location: 'Đà Nẵng, VN',
    ip: '14.231.56.12',
    lastActive: '1 ngày trước',
    firstSeen: '2026-03-01',
    isCurrent: false,
    isTrusted: false,
    fingerprint: 'fp_ghi789rst456',
  ),
  P2PTrustedDeviceDraft(
    id: 'device_ipad_pro',
    name: 'iPad Pro',
    type: 'tablet',
    os: 'iPadOS 17.2',
    browser: 'Safari',
    location: 'Hà Nội, VN',
    ip: '123.21.45.70',
    lastActive: '2 ngày trước',
    firstSeen: '2025-12-20',
    isCurrent: false,
    isTrusted: true,
    fingerprint: 'fp_jkl012mno789',
  ),
];

const List<String> _p2pDeviceSecurityTips = [
  'Kiểm tra thường xuyên danh sách thiết bị',
  'Xóa ngay thiết bị không nhận ra',
  'Không đánh dấu tin cậy thiết bị công cộng',
  'Đổi mật khẩu nếu phát hiện thiết bị lạ',
];

const List<String> _p2pAntiPhishingBenefits = [
  'Bảo vệ khỏi email phishing',
  'Xác thực email chính thức',
  'Ngăn chặn lừa đảo',
];

const List<P2PAntiPhishingExampleDraft> _p2pAntiPhishingExamples = [
  P2PAntiPhishingExampleDraft(
    id: 'legitimate',
    subject: '[VitTrade] P2P Order Confirmed',
    preview:
        'Anti-Phishing Code: SECURE2026\n\nYour P2P order #45892 has been confirmed...',
    isLegit: true,
  ),
  P2PAntiPhishingExampleDraft(
    id: 'phishing',
    subject: '[VitTrade] Urgent: Verify Your Account',
    preview:
        'Your account will be suspended. Click here immediately...\n(No anti-phishing code)',
    isLegit: false,
  ),
];

const List<String> _p2pAntiPhishingWarnings = [
  'Không chia sẻ code này với bất kỳ ai',
  'VitTrade không bao giờ hỏi code qua email/điện thoại',
  'Nếu email không có code, đó là phishing',
  'Báo ngay cho Support nếu nhận được email lạ',
];

const List<P2PLoginEventDraft> _p2pLoginHistoryEvents = [
  P2PLoginEventDraft(
    id: 'login_iphone_current',
    timestamp: '2026-03-05 14:30:22',
    deviceType: 'mobile',
    deviceName: 'iPhone 15 Pro',
    os: 'iOS 17.3',
    browser: 'Safari',
    city: 'Hà Nội',
    country: 'VN',
    ip: '123.21.45.67',
    status: 'success',
    statusLabel: 'Thành công',
    method: 'biometric',
    methodLabel: 'Biometric',
    isCurrent: true,
  ),
  P2PLoginEventDraft(
    id: 'login_macbook',
    timestamp: '2026-03-05 10:15:33',
    deviceType: 'desktop',
    deviceName: 'MacBook Pro',
    os: 'macOS 14.3',
    browser: 'Chrome 121',
    city: 'TP.HCM',
    country: 'VN',
    ip: '113.161.78.90',
    status: 'success',
    statusLabel: 'Thành công',
    method: '2fa',
    methodLabel: '2FA',
    isCurrent: false,
  ),
  P2PLoginEventDraft(
    id: 'login_samsung_s24',
    timestamp: '2026-03-04 22:45:10',
    deviceType: 'mobile',
    deviceName: 'Samsung Galaxy S24',
    os: 'Android 14',
    browser: 'Chrome Mobile',
    city: 'Đà Nẵng',
    country: 'VN',
    ip: '14.231.56.12',
    status: 'success',
    statusLabel: 'Thành công',
    method: 'password',
    methodLabel: 'Password',
    isCurrent: false,
  ),
  P2PLoginEventDraft(
    id: 'login_windows_suspicious',
    timestamp: '2026-03-04 15:20:05',
    deviceType: 'desktop',
    deviceName: 'Windows PC',
    os: 'Windows 11',
    browser: 'Edge',
    city: 'Singapore',
    country: 'SG',
    ip: '103.45.78.21',
    status: 'suspicious',
    statusLabel: 'Đáng ngờ',
    method: 'password',
    methodLabel: 'Password',
    isCurrent: false,
  ),
  P2PLoginEventDraft(
    id: 'login_unknown_failed',
    timestamp: '2026-03-04 08:10:44',
    deviceType: 'mobile',
    deviceName: 'Unknown Device',
    os: 'Android 12',
    browser: 'Chrome',
    city: 'Bangkok',
    country: 'TH',
    ip: '101.99.12.88',
    status: 'failed',
    statusLabel: 'Thất bại',
    method: 'password',
    methodLabel: 'Password',
    isCurrent: false,
  ),
];

const List<String> _p2pLoginHistorySecurityTips = [
  'Lịch sử được lưu trong 90 ngày',
  'Kiểm tra thường xuyên để phát hiện truy cập trái phép',
  'Báo ngay cho Support nếu thấy hoạt động đáng ngờ',
];

const List<P2PSuspiciousAlertDraft> _p2pSuspiciousAlerts = [
  P2PSuspiciousAlertDraft(
    id: 'suspicious_login_singapore',
    type: 'login',
    message: 'Đăng nhập từ vị trí lạ: Singapore',
    timestamp: '2026-03-05 14:20',
    severity: 'high',
    reviewed: false,
  ),
  P2PSuspiciousAlertDraft(
    id: 'suspicious_transaction_100m',
    type: 'transaction',
    message: 'Giao dịch bất thường: 100M VND',
    timestamp: '2026-03-04 18:30',
    severity: 'medium',
    reviewed: false,
  ),
  P2PSuspiciousAlertDraft(
    id: 'suspicious_device_android',
    type: 'device',
    message: 'Thiết bị mới: Unknown Android',
    timestamp: '2026-03-03 09:15',
    severity: 'low',
    reviewed: true,
  ),
];

const List<P2PE2EInfoItemDraft> _p2pE2EInfoItems = [
  P2PE2EInfoItemDraft(
    id: 'aes_rsa',
    iconKey: 'lock',
    title: 'AES-256 + RSA-2048',
    description:
        'Tin nhắn được mã hóa bằng khóa duy nhất cho mỗi cuộc trò chuyện. Ngay cả VitTrade cũng không thể đọc nội dung.',
    toneKey: 'p2p',
  ),
  P2PE2EInfoItemDraft(
    id: 'session_keys',
    iconKey: 'key',
    title: 'Khóa phiên tạm thời',
    description:
        'Mỗi phiên chat tạo khóa mới. Khóa cũ tự động hủy sau khi đơn hàng hoàn thành, đảm bảo Forward Secrecy.',
    toneKey: 'accent',
  ),
  P2PE2EInfoItemDraft(
    id: 'identity',
    iconKey: 'verified',
    title: 'Xác minh danh tính',
    description:
        'Đối tác đã được xác minh KYC. Tin nhắn chỉ giao tiếp với người dùng đã xác thực.',
    toneKey: 'success',
  ),
  P2PE2EInfoItemDraft(
    id: 'security_warning',
    iconKey: 'warning',
    title: 'Cảnh báo bảo mật',
    description:
        'Không chia sẻ mật khẩu, OTP, seed phrase hay thông tin nhạy cảm qua chat. VitTrade sẽ không bao giờ yêu cầu.',
    toneKey: 'warning',
  ),
];

const List<P2PE2EStepDraft> _p2pE2ESteps = [
  P2PE2EStepDraft(
    id: 'create_keys',
    step: '1',
    title: 'Tạo khóa',
    description: 'Khi bắt đầu chat, cặp khóa RSA-2048 được tạo trên thiết bị',
  ),
  P2PE2EStepDraft(
    id: 'exchange_keys',
    step: '2',
    title: 'Trao đổi khóa',
    description: 'Khóa công khai được trao đổi an toàn qua kênh xác thực',
  ),
  P2PE2EStepDraft(
    id: 'encrypt_messages',
    step: '3',
    title: 'Mã hóa tin nhắn',
    description: 'Mỗi tin nhắn được mã hóa AES-256 với khóa phiên duy nhất',
  ),
  P2PE2EStepDraft(
    id: 'safe_decrypt',
    step: '4',
    title: 'Giải mã an toàn',
    description: 'Chỉ khóa riêng trên thiết bị đối tác mới có thể giải mã',
  ),
];

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
