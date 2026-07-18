import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/domain/repositories/profile_repository.dart';

part 'mock_profile_repository_core_fixtures.dart';
part 'mock_profile_repository_settings_fixtures.dart';
part 'mock_profile_repository_vip_fixtures.dart';

/// Profile-scoped high-risk contract id for the security review panel.
/// Deliberately not registered in `HighRiskFlowContractIds`/
/// `HighRiskFlowContracts`/`HighRiskFlowBindings` — those model full
/// multi-stage money-movement/escrow flows with an entry/eligibility/
/// setup/preview/confirm/submit/receipt/manage/support route set that
/// this settings panel doesn't have; this is a display-only contract id.
const _profileSecurityReviewContractId = 'profile_security_review';

final class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) throw StateError('profile_mock_fetch_failed');
  }

  @override
  Future<ProfileSnapshot> getProfile() async {
    await _simulateNetwork();
    return const ProfileSnapshot(
      user: _profileUser,
      vip: _profileVip,
      prediction: _profilePrediction,
      arena: _profileArena,
      productShortcuts: _profileProductShortcuts,
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
  Future<ProfileEditSnapshot> getEditProfile() async {
    await _simulateNetwork();
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
  Future<ProfileSecuritySnapshot> getSecurity() async {
    await _simulateNetwork();
    return ProfileSecuritySnapshot(
      score: 3,
      scoreLabel: 'Cao',
      scoreColorHex: 0xFF10B981,
      items: _securityItems,
      devices: _securityDevices,
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.security,
        referenceId: 'profile-security',
        sourceRoute: '/profile/security',
        issueLabel: 'Account security support',
      ),
      endpoint: '/api/mobile/profile/profile-security',
      actionDraft:
          'PATCH /user/settings + local navigation to auth and activity routes',
      supportedStates: const [
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
        ProfileScreenState.submitting,
        ProfileScreenState.success,
      ],
      highRiskContractId: _profileSecurityReviewContractId,
    );
  }

  @override
  Future<ProfileKycSnapshot> getKyc() async {
    await _simulateNetwork();
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
  Future<ProfileSettingsSnapshot> getSettings() async {
    await _simulateNetwork();
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
  Future<ProfileActivitySnapshot> getActivity() async {
    await _simulateNetwork();
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
  Future<ProfileApiKeyCreateSnapshot> getApiKeyCreate() async {
    await _simulateNetwork();
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
  Future<ProfileApiManagementSnapshot> getApiManagement() async {
    await _simulateNetwork();
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
  Future<ProfileVipSnapshot> getVip() async {
    await _simulateNetwork();
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
  Future<ProfileDeviceManagementSnapshot> getDeviceManagement() async {
    await _simulateNetwork();
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
  Future<ProfileSubAccountsSnapshot> getSubAccounts() async {
    await _simulateNetwork();
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
