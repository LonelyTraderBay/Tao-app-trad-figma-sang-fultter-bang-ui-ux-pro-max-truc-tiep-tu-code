import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';

/// Data source contract for the Profile feature: read snapshots for
/// account, security, KYC, settings, activity, API keys, VIP, devices, and
/// sub-accounts screens.
abstract interface class ProfileRepository {
  Future<ProfileSnapshot> getProfile();
  Future<ProfileEditSnapshot> getEditProfile();
  Future<ProfileSecuritySnapshot> getSecurity();
  Future<ProfileKycSnapshot> getKyc();
  Future<ProfileSettingsSnapshot> getSettings();
  Future<ProfileActivitySnapshot> getActivity();
  Future<ProfileApiKeyCreateSnapshot> getApiKeyCreate();
  Future<ProfileApiManagementSnapshot> getApiManagement();
  Future<ProfileVipSnapshot> getVip();
  Future<ProfileDeviceManagementSnapshot> getDeviceManagement();
  Future<ProfileSubAccountsSnapshot> getSubAccounts();
}
