import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/domain/repositories/profile_repository.dart';

part 'mock_profile_repository_core_fixtures.dart';
part 'mock_profile_repository_settings_fixtures.dart';
part 'mock_profile_repository_vip_fixtures.dart';

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

  @override
  ProfileVipSnapshot getVip() {
    return const ProfileVipSnapshot(
      currentLevel: 1,
      monthlyVolume: 12450,
      assetHold: 54276,
      memberSince: '15/08/2023',
      tiers: _vipTiers,
      history: _vipHistory,
      endpoint: '/api/mobile/profile/profile-vip',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
      ],
    );
  }

  @override
  ProfileDeviceManagementSnapshot getDeviceManagement() {
    return const ProfileDeviceManagementSnapshot(
      devices: _managedDevices,
      endpoint: '/api/mobile/profile/profile-devices',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
      ],
    );
  }

  @override
  ProfileSubAccountsSnapshot getSubAccounts() {
    return const ProfileSubAccountsSnapshot(
      accounts: _subAccounts,
      endpoint: '/api/mobile/profile/profile-sub-accounts',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
      ],
    );
  }
}
