import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/domain/repositories/profile_repository.dart';

export 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
export 'package:vit_trade_flutter/features/profile/domain/repositories/profile_repository.dart';

final class ProfileController implements ProfileRepository {
  const ProfileController(this._repository);

  final ProfileRepository _repository;

  @override
  ProfileSnapshot getProfile() {
    return _repository.getProfile();
  }

  @override
  ProfileEditSnapshot getEditProfile() {
    return _repository.getEditProfile();
  }

  @override
  ProfileSecuritySnapshot getSecurity() {
    return _repository.getSecurity();
  }

  @override
  ProfileKycSnapshot getKyc() {
    return _repository.getKyc();
  }

  @override
  ProfileSettingsSnapshot getSettings() {
    return _repository.getSettings();
  }

  @override
  ProfileActivitySnapshot getActivity() {
    return _repository.getActivity();
  }

  @override
  ProfileApiKeyCreateSnapshot getApiKeyCreate() {
    return _repository.getApiKeyCreate();
  }

  @override
  ProfileApiManagementSnapshot getApiManagement() {
    return _repository.getApiManagement();
  }

  @override
  ProfileVipSnapshot getVip() {
    return _repository.getVip();
  }

  @override
  ProfileDeviceManagementSnapshot getDeviceManagement() {
    return _repository.getDeviceManagement();
  }

  @override
  ProfileSubAccountsSnapshot getSubAccounts() {
    return _repository.getSubAccounts();
  }
}
