import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';

/// Data source contract for the Profile feature: read snapshots for
/// account, security, KYC, settings, activity, API keys, VIP, devices, and
/// sub-accounts screens.
abstract interface class ProfileRepository {
  ProfileSnapshot getProfile();
  ProfileEditSnapshot getEditProfile();
  ProfileSecuritySnapshot getSecurity();
  ProfileKycSnapshot getKyc();
  ProfileSettingsSnapshot getSettings();
  ProfileActivitySnapshot getActivity();
  ProfileApiKeyCreateSnapshot getApiKeyCreate();
  ProfileApiManagementSnapshot getApiManagement();
  ProfileVipSnapshot getVip();
  ProfileDeviceManagementSnapshot getDeviceManagement();
  ProfileSubAccountsSnapshot getSubAccounts();
}
