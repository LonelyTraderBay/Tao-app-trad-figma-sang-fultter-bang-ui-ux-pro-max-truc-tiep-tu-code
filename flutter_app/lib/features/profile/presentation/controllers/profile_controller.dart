import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/domain/repositories/profile_repository.dart';

export 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
export 'package:vit_trade_flutter/features/profile/domain/repositories/profile_repository.dart';

final class ProfileController implements ProfileRepository {
  const ProfileController(this._repository);

  final ProfileRepository _repository;

  @override
  Future<ProfileSnapshot> getProfile() {
    return _repository.getProfile();
  }

  @override
  Future<ProfileEditSnapshot> getEditProfile() {
    return _repository.getEditProfile();
  }

  @override
  Future<ProfileSecuritySnapshot> getSecurity() {
    return _repository.getSecurity();
  }

  @override
  Future<ProfileKycSnapshot> getKyc() {
    return _repository.getKyc();
  }

  @override
  Future<ProfileSettingsSnapshot> getSettings() {
    return _repository.getSettings();
  }

  @override
  Future<ProfileActivitySnapshot> getActivity() {
    return _repository.getActivity();
  }

  @override
  Future<ProfileApiKeyCreateSnapshot> getApiKeyCreate() {
    return _repository.getApiKeyCreate();
  }

  @override
  Future<ProfileApiManagementSnapshot> getApiManagement() {
    return _repository.getApiManagement();
  }

  @override
  Future<ProfileVipSnapshot> getVip() {
    return _repository.getVip();
  }

  @override
  Future<ProfileDeviceManagementSnapshot> getDeviceManagement() {
    return _repository.getDeviceManagement();
  }

  @override
  Future<ProfileSubAccountsSnapshot> getSubAccounts() {
    return _repository.getSubAccounts();
  }
}
