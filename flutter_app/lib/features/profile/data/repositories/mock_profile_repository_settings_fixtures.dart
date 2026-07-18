part of 'mock_profile_repository.dart';

const List<ProfileLanguageOption> _settingsLanguages = [
  ProfileLanguageOption(id: 'vi', label: 'Ti\u1EBFng Vi\u1EC7t'),
  ProfileLanguageOption(id: 'en', label: 'English'),
];

const List<ProfileSettingsItem> _settingsTradeSecurity = [
  ProfileSettingsItem(
    id: 'biometric',
    title: '\u0110\u0103ng nh\u1EADp sinh tr\u1EAFc h\u1ECDc',
    subtitle: 'Face ID / V\u00E2n tay',
    iconKey: 'shield',
    enabled: false,
  ),
  ProfileSettingsItem(
    id: 'order-confirm',
    title: 'X\u00E1c nh\u1EADn l\u1EC7nh',
    subtitle:
        'Hi\u1EC7n m\u00E0n h\u00ECnh x\u00E1c nh\u1EADn tr\u01B0\u1EDBc khi \u0111\u1EB7t l\u1EC7nh',
    iconKey: 'none',
    enabled: true,
  ),
  ProfileSettingsItem(
    id: 'withdraw-limit',
    title: 'Gi\u1EDBi h\u1EA1n r\u00FAt ti\u1EC1n 24h',
    subtitle: 'Hi\u1EC7n t\u1EA1i: \$100,000/ng\u00E0y',
    iconKey: 'none',
    canToggle: false,
  ),
];

const List<ProfileSettingsItem> _settingsNotifications = [
  ProfileSettingsItem(
    id: 'trade',
    title: 'L\u1EC7nh giao d\u1ECBch',
    subtitle: 'Th\u00F4ng b\u00E1o khi l\u1EC7nh kh\u1EDBp',
    iconKey: 'bell',
    enabled: true,
  ),
  ProfileSettingsItem(
    id: 'price',
    title: 'C\u1EA3nh b\u00E1o gi\u00E1',
    subtitle: 'Th\u00F4ng b\u00E1o khi gi\u00E1 \u0111\u1EA1t ng\u01B0\u1EE1ng',
    iconKey: 'bell',
    enabled: true,
  ),
  ProfileSettingsItem(
    id: 'security',
    title: 'B\u1EA3o m\u1EADt',
    subtitle: '\u0110\u0103ng nh\u1EADp m\u1EDBi, r\u00FAt ti\u1EC1n',
    iconKey: 'bell',
    enabled: true,
  ),
  ProfileSettingsItem(
    id: 'p2p',
    title: 'P2P',
    subtitle: '\u0110\u01A1n h\u00E0ng P2P m\u1EDBi',
    iconKey: 'bell',
    enabled: true,
  ),
  ProfileSettingsItem(
    id: 'arena',
    title: 'Open Arena',
    subtitle: 'Challenge, k\u1EBFt qu\u1EA3, l\u1EDDi m\u1EDDi',
    iconKey: 'bell',
    enabled: true,
  ),
  ProfileSettingsItem(
    id: 'news',
    title: 'Tin t\u1EE9c & Khuy\u1EBFn m\u1EA1i',
    subtitle: 'C\u1EADp nh\u1EADt th\u1ECB tr\u01B0\u1EDDng',
    iconKey: 'bell',
    enabled: false,
  ),
];

const List<ProfileInfoRow> _settingsAppInfo = [
  ProfileInfoRow(label: 'Phi\u00EAn b\u1EA3n', value: '2.4.1 (Build 241)'),
  ProfileInfoRow(label: 'M\u00F4i tr\u01B0\u1EDDng', value: 'Production'),
  ProfileInfoRow(
    label: 'C\u1EADp nh\u1EADt l\u1EA7n cu\u1ED1i',
    value: '21/02/2026',
  ),
];

const List<ProfileActivityFilter> _activityFilters = [
  ProfileActivityFilter(id: 'all', label: 'T\u1EA5t c\u1EA3'),
  ProfileActivityFilter(id: 'login', label: '\u0110\u0103ng nh\u1EADp'),
  ProfileActivityFilter(id: 'security', label: 'B\u1EA3o m\u1EADt'),
];

const List<ProfileActivityLog> _activityLogs = [
  ProfileActivityLog(
    id: 'act001',
    type: 'login',
    description: '\u0110\u0103ng nh\u1EADp th\u00E0nh c\u00F4ng',
    ipAddress: '113.161.88.123',
    device: 'Chrome 121 \u2022 Windows 10',
    location: 'H\u1ED3 Ch\u00ED Minh, Vi\u1EC7t Nam',
    status: 'success',
    timestamp: '2024-02-23 09:30:15',
  ),
  ProfileActivityLog(
    id: 'act002',
    type: 'login',
    description: '\u0110\u0103ng nh\u1EADp th\u00E0nh c\u00F4ng',
    ipAddress: '113.161.88.123',
    device: 'Chrome Mobile \u2022 Android 14',
    location: 'H\u1ED3 Ch\u00ED Minh, Vi\u1EC7t Nam',
    status: 'success',
    timestamp: '2024-02-22 14:20:42',
  ),
  ProfileActivityLog(
    id: 'act003',
    type: 'password_change',
    description: '\u0110\u1ED5i m\u1EADt kh\u1EA9u',
    ipAddress: '113.161.88.123',
    device: 'Chrome 121 \u2022 Windows 10',
    location: 'H\u1ED3 Ch\u00ED Minh, Vi\u1EC7t Nam',
    status: 'success',
    timestamp: '2024-02-21 10:15:33',
  ),
  ProfileActivityLog(
    id: 'act004',
    type: 'login',
    description:
        '\u0110\u0103ng nh\u1EADp th\u1EA5t b\u1EA1i (sai m\u1EADt kh\u1EA9u)',
    ipAddress: '42.118.23.67',
    device: 'Safari \u2022 iOS 17',
    location: 'H\u00E0 N\u1ED9i, Vi\u1EC7t Nam',
    status: 'failed',
    timestamp: '2024-02-20 23:45:12',
  ),
  ProfileActivityLog(
    id: 'act005',
    type: '2fa_enable',
    description: 'B\u1EADt x\u00E1c th\u1EF1c 2 l\u1EDBp',
    ipAddress: '113.161.88.123',
    device: 'Chrome 121 \u2022 Windows 10',
    location: 'H\u1ED3 Ch\u00ED Minh, Vi\u1EC7t Nam',
    status: 'success',
    timestamp: '2024-02-20 08:00:00',
  ),
  ProfileActivityLog(
    id: 'act006',
    type: 'login',
    description: '\u0110\u0103ng nh\u1EADp t\u1EEB thi\u1EBFt b\u1ECB m\u1EDBi',
    ipAddress: '171.224.180.55',
    device: 'Unknown \u2022 Unknown',
    location: 'Singapore',
    status: 'suspicious',
    timestamp: '2024-02-18 03:22:11',
  ),
  ProfileActivityLog(
    id: 'act007',
    type: 'kyc_submit',
    description: 'N\u1ED9p h\u1ED3 s\u01A1 KYC c\u1EA5p 2',
    ipAddress: '113.161.88.123',
    device: 'Chrome 121 \u2022 Windows 10',
    location: 'H\u1ED3 Ch\u00ED Minh, Vi\u1EC7t Nam',
    status: 'success',
    timestamp: '2024-02-15 16:30:00',
  ),
];

const List<ProfileApiPermission> _apiCreatePermissions = [
  ProfileApiPermission(
    id: 'read',
    label: '\u0110\u1ECDc d\u1EEF li\u1EC7u',
    description:
        'Xem s\u1ED1 d\u01B0, l\u1ECBch s\u1EED giao d\u1ECBch, th\u00F4ng tin t\u00E0i kho\u1EA3n',
    iconKey: 'eye',
    colorHex: 0xFFE58A00,
    required: true,
  ),
  ProfileApiPermission(
    id: 'trade',
    label: 'Giao d\u1ECBch',
    description:
        '\u0110\u1EB7t l\u1EC7nh, h\u1EE7y l\u1EC7nh, ch\u1EC9nh s\u1EEDa l\u1EC7nh',
    iconKey: 'refresh',
    colorHex: 0xFFF5A524,
  ),
  ProfileApiPermission(
    id: 'withdraw',
    label: 'R\u00FAt ti\u1EC1n',
    description:
        'R\u00FAt t\u00E0i s\u1EA3n ra v\u00ED ngo\u00E0i \u2014 quy\u1EC1n nguy hi\u1EC3m',
    iconKey: 'lock',
    colorHex: 0xFFEF4444,
  ),
];

const List<ProfileApiExpiryOption> _apiCreateExpiryOptions = [
  ProfileApiExpiryOption(
    id: 'none',
    label: 'Kh\u00F4ng h\u1EBFt h\u1EA1n',
    description: 'Ho\u1EA1t \u0111\u1ED9ng v\u0129nh vi\u1EC5n',
  ),
  ProfileApiExpiryOption(
    id: '30d',
    label: '30 ng\u00E0y',
    description: 'H\u1EBFt h\u1EA1n sau 1 th\u00E1ng',
  ),
  ProfileApiExpiryOption(
    id: '90d',
    label: '90 ng\u00E0y',
    description: 'H\u1EBFt h\u1EA1n sau 3 th\u00E1ng',
  ),
  ProfileApiExpiryOption(
    id: '1y',
    label: '1 n\u0103m',
    description: 'H\u1EBFt h\u1EA1n sau 12 th\u00E1ng',
  ),
];

const List<String> _apiCreateSecurityTips = [
  'Lu\u00F4n gi\u1EDBi h\u1EA1n IP whitelist cho API key',
  'Kh\u00F4ng chia s\u1EBB Secret Key v\u1EDBi b\u1EA5t k\u1EF3 ai',
  'T\u1EA1o key ri\u00EAng cho t\u1EEBng \u1EE9ng d\u1EE5ng/bot',
  'Ch\u1EC9 c\u1EA5p quy\u1EC1n t\u1ED1i thi\u1EC3u c\u1EA7n thi\u1EBFt',
];

const List<ProfileApiKey> _apiManagementKeys = [
  ProfileApiKey(
    id: 'key1',
    name: 'Trading Bot Alpha',
    // SEC-S41: chuỗi ví dụ có marker rõ ràng — KHÔNG dùng chuỗi entropy cao
    // "trông như thật" trong fixture (secret scanner sẽ chặn).
    key: 'vt_live_VI_DU_KHONG_THAT_bot_alpha_01',
    secret: 'sk_live_VI_DU_KHONG_THAT_bot_alpha_02',
    permissions: ['read', 'trade'],
    ipWhitelist: ['192.168.1.100', '10.0.0.5'],
    createdAt: '10/01/2026',
    expiresAt: '10/01/2027',
    lastUsed: '23/02/2026 14:23',
    isActive: true,
    requestCount: 45231,
  ),
  ProfileApiKey(
    id: 'key2',
    name: 'Portfolio Tracker',
    key: 'vt_live_VI_DU_KHONG_THAT_portfolio_01',
    secret: 'sk_live_VI_DU_KHONG_THAT_portfolio_02',
    permissions: ['read'],
    ipWhitelist: [],
    createdAt: '05/02/2026',
    expiresAt: null,
    lastUsed: '22/02/2026 09:15',
    isActive: true,
    requestCount: 12840,
  ),
  ProfileApiKey(
    id: 'key3',
    name: 'Test Key (C\u0169)',
    key: 'vt_live_VI_DU_KHONG_THAT_test_cu_01',
    secret: 'sk_live_VI_DU_KHONG_THAT_test_cu_02',
    permissions: ['read', 'trade', 'withdraw'],
    ipWhitelist: [],
    createdAt: '01/12/2025',
    expiresAt: '01/12/2025',
    lastUsed: '30/11/2025 22:00',
    isActive: false,
    requestCount: 892,
  ),
];
