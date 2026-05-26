import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';

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
