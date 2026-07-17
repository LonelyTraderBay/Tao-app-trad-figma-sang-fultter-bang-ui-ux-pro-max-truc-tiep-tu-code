part 'profile_api_vip_entities.dart';
part 'profile_home_menu_entities.dart';

/// UI state a Profile screen snapshot supports rendering.
enum ProfileScreenState { loading, empty, error, offline, submitting, success }

/// Data for the profile home screen: [user] summary, VIP progress,
/// Prediction/Arena summary blocks, product shortcuts, and menu sections.
final class ProfileSnapshot {
  const ProfileSnapshot({
    required this.user,
    required this.vip,
    required this.prediction,
    required this.arena,
    required this.productShortcuts,
    required this.sections,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    this.screenState = ProfileScreenState.success,
  });

  final ProfileUser user;
  final ProfileVipProgress vip;
  final ProfilePredictionBlock prediction;
  final ProfileArenaBlock arena;
  final List<ProfileProductShortcut> productShortcuts;
  final List<ProfileMenuSection> sections;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
  final ProfileScreenState screenState;
}

/// Account identity fields (name, contact, VIP/KYC level, join date) for
/// the signed-in user.
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

/// Data for the edit-profile screen: the editable [user] fields.
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

/// Data for the security screen: overall security [score], checklist
/// [items], and logged-in [devices].
final class ProfileSecuritySnapshot {
  const ProfileSecuritySnapshot({
    required this.score,
    required this.scoreLabel,
    required this.scoreColorHex,
    required this.items,
    required this.devices,
    required this.supportRoute,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    this.highRiskContractId,
  });

  final int score;
  final String scoreLabel;
  final int scoreColorHex;
  final List<ProfileSecurityItem> items;
  final List<ProfileDevice> devices;
  final String supportRoute;
  final String endpoint;
  final String actionDraft;
  final List<ProfileScreenState> supportedStates;
  final String? highRiskContractId;
}

/// Data for the KYC verification screen: current level, status copy, and
/// all available [levels].
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

/// One KYC verification level's limits/features on the KYC screen.
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

/// Data for the app settings screen: currency/language options plus
/// trade-security, notification, and app-info setting rows.
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

/// One selectable app-language option on the settings screen.
final class ProfileLanguageOption {
  const ProfileLanguageOption({required this.id, required this.label});

  final String id;
  final String label;
}

/// One toggleable/navigable setting row on the settings screen.
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

/// One label/value info row (e.g. app version) on the settings screen.
final class ProfileInfoRow {
  const ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;
}

/// Data for the account activity log screen: available [filters] and
/// activity [logs].
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

/// One selectable activity-type filter on the activity log screen.
final class ProfileActivityFilter {
  const ProfileActivityFilter({required this.id, required this.label});

  final String id;
  final String label;
}

/// One account activity entry (IP, device, location, status) on the
/// activity log screen.
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
