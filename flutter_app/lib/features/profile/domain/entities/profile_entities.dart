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

final class ProfileVipSnapshot {
  const ProfileVipSnapshot({
    required this.currentLevel,
    required this.monthlyVolume,
    required this.assetHold,
    required this.memberSince,
    required this.tiers,
    required this.history,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int currentLevel;
  final double monthlyVolume;
  final double assetHold;
  final String memberSince;
  final List<ProfileVipTier> tiers;
  final List<ProfileVipHistoryRow> history;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;

  ProfileVipTier get currentTier =>
      tiers.firstWhere((tier) => tier.level == currentLevel);

  ProfileVipTier? get nextTier {
    for (final tier in tiers) {
      if (tier.level == currentLevel + 1) return tier;
    }
    return null;
  }
}

final class ProfileDeviceManagementSnapshot {
  const ProfileDeviceManagementSnapshot({
    required this.devices,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<ProfileManagedDevice> devices;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;

  ProfileManagedDevice? get currentDevice {
    for (final device in devices) {
      if (device.isCurrent) return device;
    }
    return null;
  }

  List<ProfileManagedDevice> get otherDevices =>
      devices.where((device) => !device.isCurrent).toList(growable: false);

  int get trustedCount => devices.where((device) => device.isTrusted).length;
  int get untrustedCount => devices.where((device) => !device.isTrusted).length;
  int get activeCount =>
      devices.where((device) => device.lastActive == 'Dang hoat dong').length;
}

final class ProfileManagedDevice {
  const ProfileManagedDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.browser,
    required this.os,
    required this.ip,
    required this.location,
    required this.lastActive,
    required this.loginAt,
    required this.isCurrent,
    required this.isTrusted,
  });

  final String id;
  final String name;
  final String type;
  final String browser;
  final String os;
  final String ip;
  final String location;
  final String lastActive;
  final String loginAt;
  final bool isCurrent;
  final bool isTrusted;

  ProfileManagedDevice copyWith({bool? isTrusted}) {
    return ProfileManagedDevice(
      id: id,
      name: name,
      type: type,
      browser: browser,
      os: os,
      ip: ip,
      location: location,
      lastActive: lastActive,
      loginAt: loginAt,
      isCurrent: isCurrent,
      isTrusted: isTrusted ?? this.isTrusted,
    );
  }
}

final class ProfileSubAccountsSnapshot {
  const ProfileSubAccountsSnapshot({
    required this.accounts,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<ProfileSubAccount> accounts;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;

  double get totalBalance =>
      accounts.fold(0, (sum, account) => sum + account.balance);
  double get totalPnl30d =>
      accounts.fold(0, (sum, account) => sum + account.pnl30d);
  int get activeCount =>
      accounts.where((account) => account.status == 'active').length;
  int get apiKeyCount =>
      accounts.fold(0, (sum, account) => sum + account.apiKeyCount);
}

final class ProfileSubAccount {
  const ProfileSubAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.status,
    required this.balance,
    required this.pnl30d,
    required this.permissions,
    required this.createdAt,
    required this.lastActive,
    required this.apiKeyCount,
    required this.tradingVolume30d,
  });

  final String id;
  final String name;
  final String email;
  final String type;
  final String status;
  final double balance;
  final double pnl30d;
  final List<String> permissions;
  final String createdAt;
  final String lastActive;
  final int apiKeyCount;
  final double tradingVolume30d;
}

final class ProfileVipTier {
  const ProfileVipTier({
    required this.level,
    required this.name,
    required this.badge,
    required this.iconKey,
    required this.monthlyVolume,
    required this.assetHold,
    required this.makerFee,
    required this.takerFee,
    required this.withdrawLimit,
    required this.features,
  });

  final int level;
  final String name;
  final String badge;
  final String iconKey;
  final double monthlyVolume;
  final double assetHold;
  final double makerFee;
  final double takerFee;
  final double withdrawLimit;
  final List<String> features;
}

final class ProfileVipHistoryRow {
  const ProfileVipHistoryRow({
    required this.date,
    required this.volume,
    required this.level,
    required this.fee,
    required this.saved,
  });

  final String date;
  final String volume;
  final String level;
  final String fee;
  final String saved;
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
