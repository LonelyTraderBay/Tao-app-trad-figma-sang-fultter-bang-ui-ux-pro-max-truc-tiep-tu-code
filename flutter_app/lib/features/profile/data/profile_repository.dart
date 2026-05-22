import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => const MockProfileRepository(),
);

abstract interface class ProfileRepository {
  ProfileSnapshot getProfile();
  ProfileEditSnapshot getEditProfile();
  ProfileSecuritySnapshot getSecurity();
  ProfileKycSnapshot getKyc();
  ProfileSettingsSnapshot getSettings();
  ProfileActivitySnapshot getActivity();
  ProfileApiKeyCreateSnapshot getApiKeyCreate();
  ProfileApiManagementSnapshot getApiManagement();
}

enum ProfileScreenState { loading, empty, error, offline, submitting, success }

final class ProfileSnapshot {
  const ProfileSnapshot({
    required this.user,
    required this.vip,
    required this.prediction,
    required this.arena,
    required this.sections,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final ProfileUser user;
  final ProfileVipProgress vip;
  final ProfilePredictionBlock prediction;
  final ProfileArenaBlock arena;
  final List<ProfileMenuSection> sections;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
}

final class ProfileUser {
  const ProfileUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.referralCode,
    required this.vipLevel,
    required this.kycLevel,
    required this.kycStatus,
    required this.joinDate,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String referralCode;
  final String vipLevel;
  final String kycLevel;
  final String kycStatus;
  final String joinDate;
}

final class ProfileEditSnapshot {
  const ProfileEditSnapshot({
    required this.user,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final ProfileUser user;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
}

final class ProfileSecuritySnapshot {
  const ProfileSecuritySnapshot({
    required this.score,
    required this.scoreLabel,
    required this.scoreColorHex,
    required this.items,
    required this.devices,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int score;
  final String scoreLabel;
  final int scoreColorHex;
  final List<ProfileSecurityItem> items;
  final List<ProfileDevice> devices;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
}

final class ProfileKycSnapshot {
  const ProfileKycSnapshot({
    required this.currentLevel,
    required this.statusTitle,
    required this.statusDescription,
    required this.levels,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int currentLevel;
  final String statusTitle;
  final String statusDescription;
  final List<ProfileKycLevel> levels;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
}

final class ProfileKycLevel {
  const ProfileKycLevel({
    required this.level,
    required this.title,
    required this.limits,
    required this.features,
    required this.colorHex,
  });

  final int level;
  final String title;
  final List<String> limits;
  final List<String> features;
  final int colorHex;
}

final class ProfileSettingsSnapshot {
  const ProfileSettingsSnapshot({
    required this.currencyOptions,
    required this.selectedCurrency,
    required this.languages,
    required this.selectedLanguageId,
    required this.tradeSecurity,
    required this.notifications,
    required this.appInfo,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<String> currencyOptions;
  final String selectedCurrency;
  final List<ProfileLanguageOption> languages;
  final String selectedLanguageId;
  final List<ProfileSettingsItem> tradeSecurity;
  final List<ProfileSettingsItem> notifications;
  final List<ProfileInfoRow> appInfo;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
}

final class ProfileLanguageOption {
  const ProfileLanguageOption({required this.id, required this.label});

  final String id;
  final String label;
}

final class ProfileSettingsItem {
  const ProfileSettingsItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
    this.enabled,
    this.canToggle = true,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconKey;
  final bool? enabled;
  final bool canToggle;
}

final class ProfileInfoRow {
  const ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;
}

final class ProfileActivitySnapshot {
  const ProfileActivitySnapshot({
    required this.filters,
    required this.logs,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<ProfileActivityFilter> filters;
  final List<ProfileActivityLog> logs;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
}

final class ProfileActivityFilter {
  const ProfileActivityFilter({required this.id, required this.label});

  final String id;
  final String label;
}

final class ProfileActivityLog {
  const ProfileActivityLog({
    required this.id,
    required this.type,
    required this.description,
    required this.ipAddress,
    required this.device,
    required this.location,
    required this.status,
    required this.timestamp,
  });

  final String id;
  final String type;
  final String description;
  final String ipAddress;
  final String device;
  final String location;
  final String status;
  final String timestamp;
}

final class ProfileApiKeyCreateSnapshot {
  const ProfileApiKeyCreateSnapshot({
    required this.permissions,
    required this.expiryOptions,
    required this.securityTips,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<ProfileApiPermission> permissions;
  final List<ProfileApiExpiryOption> expiryOptions;
  final List<String> securityTips;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
}

final class ProfileApiManagementSnapshot {
  const ProfileApiManagementSnapshot({
    required this.keys,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<ProfileApiKey> keys;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
}

final class ProfileApiKey {
  const ProfileApiKey({
    required this.id,
    required this.name,
    required this.key,
    required this.secret,
    required this.permissions,
    required this.ipWhitelist,
    required this.createdAt,
    required this.expiresAt,
    required this.lastUsed,
    required this.isActive,
    required this.requestCount,
  });

  final String id;
  final String name;
  final String key;
  final String secret;
  final List<String> permissions;
  final List<String> ipWhitelist;
  final String createdAt;
  final String? expiresAt;
  final String? lastUsed;
  final bool isActive;
  final int requestCount;

  ProfileApiKey copyWith({bool? isActive}) {
    return ProfileApiKey(
      id: id,
      name: name,
      key: key,
      secret: secret,
      permissions: permissions,
      ipWhitelist: ipWhitelist,
      createdAt: createdAt,
      expiresAt: expiresAt,
      lastUsed: lastUsed,
      isActive: isActive ?? this.isActive,
      requestCount: requestCount,
    );
  }
}

final class ProfileApiPermission {
  const ProfileApiPermission({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.colorHex,
    this.required = false,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final int colorHex;
  final bool required;
}

final class ProfileApiExpiryOption {
  const ProfileApiExpiryOption({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class ProfileSecurityItem {
  const ProfileSecurityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    this.status,
    this.statusHex,
    this.route,
    this.danger = false,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String? status;
  final int? statusHex;
  final String? route;
  final bool danger;
}

final class ProfileDevice {
  const ProfileDevice({
    required this.id,
    required this.name,
    required this.os,
    required this.location,
    required this.lastSeen,
    required this.isCurrent,
  });

  final String id;
  final String name;
  final String os;
  final String location;
  final String lastSeen;
  final bool isCurrent;
}

final class ProfileVipProgress {
  const ProfileVipProgress({
    required this.label,
    required this.nextLabel,
    required this.volumeLabel,
    required this.progress,
  });

  final String label;
  final String nextLabel;
  final String volumeLabel;
  final double progress;
}

final class ProfilePredictionBlock {
  const ProfilePredictionBlock({
    required this.positions,
    required this.openOrders,
    required this.pnlLabel,
  });

  final int positions;
  final int openOrders;
  final String pnlLabel;
}

final class ProfileArenaBlock {
  const ProfileArenaBlock({
    required this.pointsLabel,
    required this.rooms,
    required this.creatorScoreLabel,
  });

  final String pointsLabel;
  final int rooms;
  final String creatorScoreLabel;
}

final class ProfileMenuSection {
  const ProfileMenuSection({
    required this.id,
    required this.label,
    required this.accentHex,
    required this.items,
  });

  final String id;
  final String label;
  final int accentHex;
  final List<ProfileMenuItem> items;
}

final class ProfileMenuItem {
  const ProfileMenuItem({
    required this.id,
    required this.label,
    required this.route,
    required this.iconKey,
    this.subtitle,
    this.subtitleHex,
  });

  final String id;
  final String label;
  final String route;
  final String iconKey;
  final String? subtitle;
  final int? subtitleHex;
}

final class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository();

  @override
  ProfileSnapshot getProfile() {
    return const ProfileSnapshot(
      user: _profileUser,
      vip: _profileVip,
      prediction: _profilePrediction,
      arena: _profileArena,
      sections: _profileSections,
      endpoint: '/api/mobile/profile/profile',
      actionDraft: 'read-only + local navigation actions',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
      ],
    );
  }

  @override
  ProfileEditSnapshot getEditProfile() {
    return const ProfileEditSnapshot(
      user: _profileUser,
      endpoint: '/api/mobile/profile/profile-edit',
      actionDraft: 'PATCH /user/settings',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
        ProfileScreenState.submitting,
        ProfileScreenState.success,
      ],
    );
  }

  @override
  ProfileSecuritySnapshot getSecurity() {
    return const ProfileSecuritySnapshot(
      score: 3,
      scoreLabel: 'Cao',
      scoreColorHex: 0xFF10B981,
      items: _securityItems,
      devices: _securityDevices,
      endpoint: '/api/mobile/profile/profile-security',
      actionDraft:
          'PATCH /user/settings + local navigation to auth and activity routes',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
        ProfileScreenState.submitting,
        ProfileScreenState.success,
      ],
    );
  }

  @override
  ProfileKycSnapshot getKyc() {
    return const ProfileKycSnapshot(
      currentLevel: 2,
      statusTitle: 'KYC C\u1EA5p 2 \u2014 \u0110\u00E3 x\u00E1c minh',
      statusDescription:
          'T\u00E0i kho\u1EA3n c\u1EE7a b\u1EA1n \u0111\u00E3 \u0111\u01B0\u1EE3c x\u00E1c minh \u0111\u1EA7y \u0111\u1EE7',
      levels: _kycLevels,
      endpoint: '/api/mobile/profile/profile-kyc',
      actionDraft: 'POST /kyc/submission-step',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
        ProfileScreenState.submitting,
        ProfileScreenState.success,
      ],
    );
  }

  @override
  ProfileSettingsSnapshot getSettings() {
    return const ProfileSettingsSnapshot(
      currencyOptions: ['USD', 'VND', 'EUR', 'BTC'],
      selectedCurrency: 'USD',
      languages: _settingsLanguages,
      selectedLanguageId: 'vi',
      tradeSecurity: _settingsTradeSecurity,
      notifications: _settingsNotifications,
      appInfo: _settingsAppInfo,
      endpoint: '/api/mobile/profile/profile-settings',
      actionDraft: 'PATCH /user/settings or module settings',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
        ProfileScreenState.submitting,
        ProfileScreenState.success,
      ],
    );
  }

  @override
  ProfileActivitySnapshot getActivity() {
    return const ProfileActivitySnapshot(
      filters: _activityFilters,
      logs: _activityLogs,
      endpoint: '/api/mobile/profile/profile-activity',
      actionDraft: 'read-only + local filter actions',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
      ],
    );
  }

  @override
  ProfileApiKeyCreateSnapshot getApiKeyCreate() {
    return const ProfileApiKeyCreateSnapshot(
      permissions: _apiCreatePermissions,
      expiryOptions: _apiCreateExpiryOptions,
      securityTips: _apiCreateSecurityTips,
      endpoint: '/api/mobile/profile/profile-api-create',
      actionDraft: 'POST /user/api-keys + local confirm/result steps',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
        ProfileScreenState.submitting,
        ProfileScreenState.success,
      ],
    );
  }

  @override
  ProfileApiManagementSnapshot getApiManagement() {
    return const ProfileApiManagementSnapshot(
      keys: _apiManagementKeys,
      endpoint: '/api/mobile/profile/profile-api',
      actionDraft:
          'read-only + local toggle, copy, secret reveal, delete, and create navigation actions',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
        ProfileScreenState.submitting,
        ProfileScreenState.success,
      ],
    );
  }
}

const ProfileUser _profileUser = ProfileUser(
  id: 'USR001',
  fullName: 'Nguy\u1EC5n V\u0103n A',
  email: 'nguyenvana@email.com',
  phone: '+84 912 345 678',
  referralCode: 'VITTA-A2B3C',
  vipLevel: 'VIP 1',
  kycLevel: 'C\u1EA5p 2',
  kycStatus: '\u0110\u00E3 x\u00E1c minh \u2713',
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

const List<ProfileMenuSection> _profileSections = [
  ProfileMenuSection(
    id: 'account',
    label: 'T\u00C0I KHO\u1EA2N',
    accentHex: 0xFFE58A00,
    items: [
      ProfileMenuItem(
        id: 'kyc',
        label: 'X\u00E1c minh danh t\u00EDnh (KYC)',
        subtitle: '\u0110\u00E3 x\u00E1c minh \u2713',
        subtitleHex: 0xFF10B981,
        route: '/profile/kyc',
        iconKey: 'shield-check',
      ),
      ProfileMenuItem(
        id: 'security',
        label: 'B\u1EA3o m\u1EADt',
        subtitle: '2FA \u0111ang b\u1EADt',
        subtitleHex: 0xFF10B981,
        route: '/profile/security',
        iconKey: 'shield',
      ),
      ProfileMenuItem(
        id: 'vip',
        label: 'VIP Program',
        subtitle: 'VIP 1 \u2014 Maker 0.09%',
        subtitleHex: 0xFFF5A524,
        route: '/profile/vip',
        iconKey: 'crown',
      ),
      ProfileMenuItem(
        id: 'notifications',
        label: 'Th\u00F4ng b\u00E1o',
        subtitle: 'Qu\u1EA3n l\u00FD c\u1EA3nh b\u00E1o',
        route: '/notifications',
        iconKey: 'bell',
      ),
      ProfileMenuItem(
        id: 'api',
        label: 'Qu\u1EA3n l\u00FD API',
        subtitle: '3 key \u0111ang ho\u1EA1t \u0111\u1ED9ng',
        route: '/profile/api',
        iconKey: 'key',
      ),
      ProfileMenuItem(
        id: 'devices',
        label: 'Qu\u1EA3n l\u00FD thi\u1EBFt b\u1ECB',
        subtitle: '4 thi\u1EBFt b\u1ECB \u0111\u00E3 \u0111\u0103ng nh\u1EADp',
        route: '/profile/devices',
        iconKey: 'phone',
      ),
      ProfileMenuItem(
        id: 'sub-accounts',
        label: 'T\u00E0i kho\u1EA3n ph\u1EE5',
        subtitle: '5 t\u00E0i kho\u1EA3n',
        route: '/profile/sub-accounts',
        iconKey: 'users',
      ),
      ProfileMenuItem(
        id: 'orders',
        label: 'L\u1ECBch s\u1EED l\u1EC7nh',
        subtitle: 'Xem l\u1EC7nh \u0111\u00E3 \u0111\u1EB7t',
        route: '/trade/orders-history',
        iconKey: 'clipboard',
      ),
    ],
  ),
  ProfileMenuSection(
    id: 'settings',
    label: 'C\u00C0I \u0110\u1EB6T',
    accentHex: 0xFF94A3B8,
    items: [
      ProfileMenuItem(
        id: 'language',
        label: 'Ng\u00F4n ng\u1EEF',
        subtitle: 'Ti\u1EBFng Vi\u1EC7t',
        route: '/profile/settings',
        iconKey: 'globe',
      ),
      ProfileMenuItem(
        id: 'settings',
        label: 'C\u00E0i \u0111\u1EB7t chung',
        route: '/profile/settings',
        iconKey: 'settings',
      ),
      ProfileMenuItem(
        id: 'onboarding',
        label: 'Xem l\u1EA1i Onboarding',
        subtitle: 'H\u01B0\u1EDBng d\u1EABn s\u1EED d\u1EE5ng app',
        route: '/onboarding',
        iconKey: 'rotate',
      ),
      ProfileMenuItem(
        id: 'tips',
        label: 'M\u1EB9o s\u1EED d\u1EE5ng',
        subtitle: '\u0110\u00E3 t\u1EAFt',
        subtitleHex: 0xFFEF4444,
        route: '/profile/settings',
        iconKey: 'message',
      ),
    ],
  ),
  ProfileMenuSection(
    id: 'explore',
    label: 'KH\u00C1M PH\u00C1',
    accentHex: 0xFF8B5CF6,
    items: [
      ProfileMenuItem(
        id: 'topics',
        label: 'Kh\u00E1m ph\u00E1 ch\u1EE7 \u0111\u1EC1',
        subtitle: 'Crypto, Sports, Politics...',
        route: '/topics',
        iconKey: 'compass',
      ),
      ProfileMenuItem(
        id: 'referral',
        label: 'Ch\u01B0\u01A1ng tr\u00ECnh gi\u1EDBi thi\u1EC7u',
        subtitle: 'Nh\u1EADn 20% hoa h\u1ED3ng',
        route: '/referral',
        iconKey: 'users',
      ),
      ProfileMenuItem(
        id: 'leaderboard',
        label: 'Prediction Leaderboard',
        subtitle: 'Xem top traders',
        route: '/markets/predictions/leaderboard',
        iconKey: 'trophy',
      ),
      ProfileMenuItem(
        id: 'dca',
        label: 'Mua t\u1EF1 \u0111\u1ED9ng DCA',
        subtitle:
            '\u0110\u1EA7u t\u01B0 \u0111\u1ECBnh k\u1EF3 t\u1EF1 \u0111\u1ED9ng',
        subtitleHex: 0xFF10B981,
        route: '/dca',
        iconKey: 'refresh',
      ),
      ProfileMenuItem(
        id: 'staking',
        label: 'Staking & Earn',
        subtitle: 'APY t\u1EDBi 24.5%',
        route: '/earn/staking',
        iconKey: 'zap',
      ),
      ProfileMenuItem(
        id: 'bots',
        label: 'Trading Bots',
        subtitle: 'Giao d\u1ECBch t\u1EF1 \u0111\u1ED9ng 24/7',
        route: '/trade/bots',
        iconKey: 'bot',
      ),
      ProfileMenuItem(
        id: 'support',
        label: 'Trung t\u00E2m h\u1ED7 tr\u1EE3',
        route: '/support',
        iconKey: 'help',
      ),
      ProfileMenuItem(
        id: 'news',
        label: 'Tin t\u1EE9c & Th\u00F4ng b\u00E1o',
        route: '/news',
        iconKey: 'file',
      ),
      ProfileMenuItem(
        id: 'rate',
        label: '\u0110\u00E1nh gi\u00E1 \u1EE9ng d\u1EE5ng',
        route: '/profile',
        iconKey: 'star',
      ),
    ],
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
    key: 'vt_live_4x7j9mKpQr2LwNvSbEuF8yTcZdHgXkAm',
    secret: 'sk_live_J8mK3pRtYxWvCqBnZ5hGfD2sLuNaE9cT',
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
    key: 'vt_live_9nRdBsWkMpL3xTaEjQzYcV7hGfC2uNm',
    secret: 'sk_live_C4yBfNrKxZpD8wTqLuMaV2jEsGcH7iR',
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
    key: 'vt_live_2hFcPqLsAkX6rBnJmWdYvT8eGzNuCjQ',
    secret: 'sk_live_X6jNzQpMsRvKcT3bGaHwF9yLuB2dEiC',
    permissions: ['read', 'trade', 'withdraw'],
    ipWhitelist: [],
    createdAt: '01/12/2025',
    expiresAt: '01/12/2025',
    lastUsed: '30/11/2025 22:00',
    isActive: false,
    requestCount: 892,
  ),
];
