part of 'mock_profile_repository.dart';

const ProfileUser _profileUser = ProfileUser(
  id: 'USR001',
  fullName: 'Nguy\u1EC5n V\u0103n A',
  email: 'nguyenvana@email.com',
  phone: '+84 912 345 678',
  referralCode: 'VITTA-A2B3C',
  vipLevel: 'VIP 1',
  kycLevel: 'C\u1EA5p 1',
  kycStatus: 'Ch\u01B0a ho\u00E0n t\u1EA5t',
  joinDate: '2023-08-15',
);

const ProfileVipProgress _profileVip = ProfileVipProgress(
  label: 'VIP 1',
  nextLabel: 'VIP 2',
  volumeLabel:
      'Volume 30 ng\u00E0y: \$18,450 / \$50,000 \u0111\u1EC3 l\u00EAn VIP 2',
  progress: .35,
);

const ProfilePredictionBlock _profilePrediction = ProfilePredictionBlock(
  positions: 5,
  openOrders: 2,
  pnlLabel: '+\$440.00',
);

const ProfileArenaBlock _profileArena = ProfileArenaBlock(
  pointsLabel: '2,220',
  rooms: 3,
  creatorScoreLabel: '87%',
);

const List<ProfileProductShortcut> _profileProductShortcuts = [
  ProfileProductShortcut(
    id: 'wallet',
    label: 'V\u00ED',
    route: '/wallet',
    iconKey: 'wallet',
    stateLabel: 'Treasury',
    accentHex: 0xFFF5A524,
  ),
  ProfileProductShortcut(
    id: 'p2p',
    label: 'P2P',
    route: '/p2p',
    iconKey: 'users',
    stateLabel: 'Escrow',
    accentHex: 0xFFF5A524,
  ),
  ProfileProductShortcut(
    id: 'earn',
    label: 'Earn',
    route: '/earn',
    iconKey: 'zap',
    stateLabel: 'Yield',
    accentHex: 0xFFF5A524,
  ),
  ProfileProductShortcut(
    id: 'launchpad',
    label: 'Launchpad',
    route: '/launchpad',
    iconKey: 'rocket',
    stateLabel: 'Token',
    accentHex: 0xFFE58A00,
  ),
  ProfileProductShortcut(
    id: 'bots',
    label: 'Bot',
    route: '/trade/bots',
    iconKey: 'bot',
    stateLabel: 'Auto',
    accentHex: 0xFFE58A00,
  ),
  ProfileProductShortcut(
    id: 'copy',
    label: 'Copy',
    route: '/trade/copy-trading',
    iconKey: 'copy',
    stateLabel: 'Social',
    accentHex: 0xFFE58A00,
  ),
];

/// IA Profile section model (STEP-P1.3): Tài khoản · Bảo mật · Portfolio ·
/// Giới thiệu · Hỗ trợ · Pháp lý (scaffold — nội dung GOM ở P1.4).
const List<ProfileMenuSection> _profileSections = [
  ProfileMenuSection(
    id: 'account',
    label: 'T\u00C0I KHO\u1EA2N',
    accentHex: 0xFFE58A00,
    items: [
      ProfileMenuItem(
        id: 'kyc',
        label: 'X\u00E1c minh danh t\u00EDnh (KYC)',
        subtitle:
            'Ch\u01B0a ho\u00E0n t\u1EA5t \u2014 n\u00E2ng h\u1EA1n m\u1EE9c',
        subtitleHex: 0xFFF5A524,
        route: '/profile/kyc',
        iconKey: 'shield-check',
      ),
      ProfileMenuItem(
        id: 'edit',
        label: 'Ch\u1EC9nh s\u1EEDa h\u1ED3 s\u01A1',
        route: '/profile/edit',
        iconKey: 'user',
      ),
      ProfileMenuItem(
        id: 'devices',
        label: 'Qu\u1EA3n l\u00FD thi\u1EBFt b\u1ECB',
        subtitle: '4 thi\u1EBFt b\u1ECB \u0111\u00E3 \u0111\u0103ng nh\u1EADp',
        route: '/profile/devices',
        iconKey: 'phone',
      ),
      ProfileMenuItem(
        id: 'api',
        label: 'Qu\u1EA3n l\u00FD API',
        subtitle: '3 key \u0111ang ho\u1EA1t \u0111\u1ED9ng',
        route: '/profile/api',
        iconKey: 'key',
      ),
      ProfileMenuItem(
        id: 'sub-accounts',
        label: 'T\u00E0i kho\u1EA3n ph\u1EE5',
        subtitle: '5 t\u00E0i kho\u1EA3n',
        route: '/profile/sub-accounts',
        iconKey: 'users',
      ),
      ProfileMenuItem(
        id: 'vip',
        label: 'Ch\u01B0\u01A1ng tr\u00ECnh VIP',
        subtitle: 'VIP 1 \u2014 Maker 0.09%',
        subtitleHex: 0xFFF5A524,
        route: '/profile/vip',
        iconKey: 'crown',
      ),
      ProfileMenuItem(
        id: 'activity',
        label: 'Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng',
        route: '/profile/activity',
        iconKey: 'clipboard',
      ),
      ProfileMenuItem(
        id: 'my-arena',
        label: 'Arena c\u1EE7a t\u00F4i',
        subtitle: 'Ch\u1EC9 \u0111i\u1EC3m Arena',
        route: '/arena/my',
        iconKey: 'trophy',
      ),
      ProfileMenuItem(
        id: 'settings',
        label: 'C\u00E0i \u0111\u1EB7t chung',
        route: '/profile/settings',
        iconKey: 'settings',
      ),
    ],
  ),
  ProfileMenuSection(
    id: 'security',
    label: 'B\u1EA2O M\u1EACT',
    accentHex: 0xFF10B981,
    items: [
      ProfileMenuItem(
        id: 'security-center',
        label: 'B\u1EA3o m\u1EADt & 2FA',
        subtitle: '2FA, thi\u1EBFt b\u1ECB, m\u1EADt kh\u1EA9u',
        subtitleHex: 0xFF10B981,
        route: '/settings/security',
        iconKey: 'shield',
      ),
    ],
  ),
  ProfileMenuSection(
    id: 'portfolio',
    label: 'PORTFOLIO N\u00C2NG CAO',
    accentHex: 0xFF8B5CF6,
    items: [
      ProfileMenuItem(
        id: 'unified-portfolio',
        label: 'T\u1ED5ng quan \u0111a module',
        subtitle: 'Tổng hợp Spot · Earn · Prediction',
        route: '/unified-portfolio',
        iconKey: 'briefcase',
      ),
      ProfileMenuItem(
        id: 'cross-analytics',
        label: 'Ph\u00E2n t\u00EDch ch\u00E9o module',
        route: '/cross-module-analytics',
        iconKey: 'bar-chart',
      ),
      ProfileMenuItem(
        id: 'smart-alerts',
        label: 'C\u1EA3nh b\u00E1o th\u00F4ng minh',
        route: '/smart-alerts',
        iconKey: 'bell',
      ),
      ProfileMenuItem(
        id: 'tax-reports',
        label: 'B\u00E1o c\u00E1o thu\u1EBF',
        route: '/tax-reports',
        iconKey: 'file',
      ),
    ],
  ),
  ProfileMenuSection(
    id: 'referral',
    label: 'GI\u1EDAI THI\u1EC6U',
    accentHex: 0xFFF5A524,
    items: [
      ProfileMenuItem(
        id: 'referral-home',
        label: 'M\u1EDDi b\u1EA1n b\u00E8',
        subtitle: 'Ch\u01B0\u01A1ng tr\u00ECnh gi\u1EDBi thi\u1EC7u',
        route: '/referral',
        iconKey: 'users',
      ),
    ],
  ),
  ProfileMenuSection(
    id: 'support',
    label: 'H\u1ED6 TR\u1EE2',
    accentHex: 0xFF94A3B8,
    items: [
      ProfileMenuItem(
        id: 'support-home',
        label: 'Trung t\u00E2m h\u1ED7 tr\u1EE3',
        route: '/support',
        iconKey: 'help',
      ),
    ],
  ),
  ProfileMenuSection(
    id: 'legal',
    label: 'PH\u00C1P L\u00DD & B\u00C1O C\u00C1O',
    accentHex: 0xFF64748B,
    items: [],
  ),
];

const List<ProfileSecurityItem> _securityItems = [
  ProfileSecurityItem(
    id: 'two-factor',
    title: 'X\u00E1c th\u1EF1c 2 l\u1EDBp (2FA)',
    description: 'Google Authenticator ho\u1EB7c SMS',
    iconKey: 'phone',
    status: '\u0110ang b\u1EADt',
    statusHex: 0xFF10B981,
    route: '/auth/2fa-setup',
  ),
  ProfileSecurityItem(
    id: 'password',
    title: '\u0110\u1ED5i m\u1EADt kh\u1EA9u',
    description: 'C\u1EADp nh\u1EADt m\u1EADt kh\u1EA9u \u0111\u1ECBnh k\u1EF3',
    iconKey: 'key',
    route: '/auth/forgot-password',
  ),
  ProfileSecurityItem(
    id: 'withdraw-whitelist',
    title: 'Whitelist \u0111\u1ECBa ch\u1EC9 r\u00FAt ti\u1EC1n',
    description:
        'Ch\u1EC9 r\u00FAt \u0111\u1EBFn \u0111\u1ECBa ch\u1EC9 \u0111\u00E3 x\u00E1c minh',
    iconKey: 'shield',
    status: 'Ch\u01B0a c\u00E0i \u0111\u1EB7t',
    statusHex: 0xFFF5A524,
  ),
  ProfileSecurityItem(
    id: 'devices',
    title: 'Qu\u1EA3n l\u00FD thi\u1EBFt b\u1ECB \u0111\u0103ng nh\u1EADp',
    description: '3 thi\u1EBFt b\u1ECB \u0111ang ho\u1EA1t \u0111\u1ED9ng',
    iconKey: 'laptop',
  ),
  ProfileSecurityItem(
    id: 'activity',
    title: 'Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng',
    description:
        'Xem l\u1ECBch s\u1EED \u0111\u0103ng nh\u1EADp & thao t\u00E1c',
    iconKey: 'activity',
    route: '/profile/activity',
  ),
];

const List<ProfileKycLevel> _kycLevels = [
  ProfileKycLevel(
    level: 0,
    title: 'C\u01A1 b\u1EA3n',
    limits: [
      'N\u1EA1p: Kh\u00F4ng gi\u1EDBi h\u1EA1n',
      'R\u00FAt: \$2,000/ng\u00E0y',
    ],
    features: ['N\u1EA1p ti\u1EC1n', 'Giao d\u1ECBch Spot'],
    colorHex: 0xFFA7AFBF,
  ),
  ProfileKycLevel(
    level: 1,
    title: 'KYC C\u1EA5p 1',
    limits: [
      'N\u1EA1p: Kh\u00F4ng gi\u1EDBi h\u1EA1n',
      'R\u00FAt: \$20,000/ng\u00E0y',
    ],
    features: [
      'T\u1EA5t c\u1EA3 t\u00EDnh n\u0103ng c\u01A1 b\u1EA3n',
      'P2P Trading',
      'R\u00FAt ti\u1EC1n cao h\u01A1n',
    ],
    colorHex: 0xFFE58A00,
  ),
  ProfileKycLevel(
    level: 2,
    title: 'KYC C\u1EA5p 2',
    limits: [
      'N\u1EA1p: Kh\u00F4ng gi\u1EDBi h\u1EA1n',
      'R\u00FAt: \$100,000/ng\u00E0y',
    ],
    features: ['T\u1EA5t c\u1EA3 c\u1EA5p 1', 'OTC Trading', 'API Access'],
    colorHex: 0xFF10B981,
  ),
];

const List<ProfileDevice> _securityDevices = [
  ProfileDevice(
    id: 'd1',
    name: 'iPhone 14 Pro',
    os: 'iOS 17.2',
    location: 'H\u00E0 N\u1ED9i, Vi\u1EC7t Nam',
    lastSeen: 'Ngay b\u00E2y gi\u1EDD',
    isCurrent: true,
  ),
  ProfileDevice(
    id: 'd2',
    name: 'MacBook Pro',
    os: 'Chrome 121',
    location: 'H\u00E0 N\u1ED9i, Vi\u1EC7t Nam',
    lastSeen: '2 gi\u1EDD tr\u01B0\u1EDBc',
    isCurrent: false,
  ),
  ProfileDevice(
    id: 'd3',
    name: 'Samsung Galaxy S23',
    os: 'Android 14',
    location: 'TP. H\u1ED3 Ch\u00ED Minh, Vi\u1EC7t Nam',
    lastSeen: '5 ng\u00E0y tr\u01B0\u1EDBc',
    isCurrent: false,
  ),
];

const List<ProfileManagedDevice> _managedDevices = [
  ProfileManagedDevice(
    id: 'dev001',
    name: 'Chrome Desktop',
    type: 'desktop',
    browser: 'Chrome 121',
    os: 'Windows 11',
    ip: '113.161.88.123',
    location: 'Ho Chi Minh, VN',
    lastActive: 'Dang hoat dong',
    loginAt: '2024-02-23 09:30',
    isCurrent: true,
    isTrusted: true,
  ),
  ProfileManagedDevice(
    id: 'dev002',
    name: 'iPhone 15 Pro',
    type: 'mobile',
    browser: 'Safari 17',
    os: 'iOS 17.3',
    ip: '113.161.88.123',
    location: 'Ho Chi Minh, VN',
    lastActive: '2 gio truoc',
    loginAt: '2024-02-22 14:20',
    isCurrent: false,
    isTrusted: true,
  ),
  ProfileManagedDevice(
    id: 'dev003',
    name: 'MacBook Air',
    type: 'desktop',
    browser: 'Safari 17',
    os: 'macOS Sonoma',
    ip: '42.118.23.67',
    location: 'Ha Noi, VN',
    lastActive: '3 ngay truoc',
    loginAt: '2024-02-20 08:15',
    isCurrent: false,
    isTrusted: true,
  ),
  ProfileManagedDevice(
    id: 'dev004',
    name: 'Unknown Device',
    type: 'mobile',
    browser: 'Chrome Mobile',
    os: 'Android 14',
    ip: '171.224.180.55',
    location: 'Singapore',
    lastActive: '5 ngay truoc',
    loginAt: '2024-02-18 03:22',
    isCurrent: false,
    isTrusted: false,
  ),
];

const List<ProfileSubAccount> _subAccounts = [
  ProfileSubAccount(
    id: 'sub001',
    name: 'Bot Trading #1',
    email: 'bot1@vittrade.vn',
    type: 'spot',
    status: 'active',
    balance: 8450.20,
    pnl30d: 1234.50,
    permissions: ['spot_trade', 'read'],
    createdAt: '2024-01-15',
    lastActive: '2 phut truoc',
    apiKeyCount: 2,
    tradingVolume30d: 125000,
  ),
  ProfileSubAccount(
    id: 'sub002',
    name: 'Margin Account',
    email: 'margin@vittrade.vn',
    type: 'margin',
    status: 'active',
    balance: 15200,
    pnl30d: 3421.80,
    permissions: ['margin_trade', 'transfer', 'read'],
    createdAt: '2024-01-20',
    lastActive: '1 gio truoc',
    apiKeyCount: 1,
    tradingVolume30d: 450000,
  ),
  ProfileSubAccount(
    id: 'sub003',
    name: 'Futures #1',
    email: 'futures1@vittrade.vn',
    type: 'futures',
    status: 'active',
    balance: 5600,
    pnl30d: -890.30,
    permissions: ['futures_trade', 'read'],
    createdAt: '2024-02-01',
    lastActive: '5 phut truoc',
    apiKeyCount: 1,
    tradingVolume30d: 890000,
  ),
  ProfileSubAccount(
    id: 'sub004',
    name: 'DCA Strategy',
    email: 'dca@vittrade.vn',
    type: 'spot',
    status: 'frozen',
    balance: 2100.50,
    pnl30d: 567.20,
    permissions: ['spot_trade', 'read'],
    createdAt: '2024-02-10',
    lastActive: '3 ngay truoc',
    apiKeyCount: 0,
    tradingVolume30d: 15000,
  ),
  ProfileSubAccount(
    id: 'sub005',
    name: 'Team Member - Linh',
    email: 'linh@company.vn',
    type: 'all',
    status: 'active',
    balance: 32500,
    pnl30d: 8920,
    permissions: [
      'spot_trade',
      'margin_trade',
      'futures_trade',
      'transfer',
      'withdraw',
      'read',
    ],
    createdAt: '2023-12-01',
    lastActive: 'Vua xong',
    apiKeyCount: 3,
    tradingVolume30d: 1250000,
  ),
];
