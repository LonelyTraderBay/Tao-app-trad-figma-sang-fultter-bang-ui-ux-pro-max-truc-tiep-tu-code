part of 'profile_entities.dart';

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
    this.screenState = ProfileScreenState.success,
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
  final ProfileScreenState screenState;

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
    this.screenState = ProfileScreenState.success,
  });

  final List<ProfileSubAccount> accounts;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
  final ProfileScreenState screenState;

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
