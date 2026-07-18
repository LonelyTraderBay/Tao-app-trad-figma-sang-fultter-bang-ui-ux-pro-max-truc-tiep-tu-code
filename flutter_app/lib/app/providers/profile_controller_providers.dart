import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/profile/data/providers/profile_repository_provider.dart';
import 'package:vit_trade_flutter/features/profile/presentation/controllers/profile_controller.dart';

export 'package:vit_trade_flutter/features/profile/presentation/controllers/profile_controller.dart';

final profileControllerProvider = Provider<ProfileController>((ref) {
  return ProfileController(ref.watch(profileRepositoryProvider));
});

// GD4-F6 (bẫy 29 "controller forwarder mỏng"): ProfileController chỉ
// forward tới repository — giữ Provider<ProfileController> SYNC, thêm 11
// FutureProvider snapshot gọi xuyên qua controller (1 provider / method).

final profileSnapshotProvider = FutureProvider<ProfileSnapshot>(
  (ref) => ref.watch(profileControllerProvider).getProfile(),
);

final profileEditSnapshotProvider = FutureProvider<ProfileEditSnapshot>(
  (ref) => ref.watch(profileControllerProvider).getEditProfile(),
);

final profileSecuritySnapshotProvider = FutureProvider<ProfileSecuritySnapshot>(
  (ref) => ref.watch(profileControllerProvider).getSecurity(),
);

final profileKycSnapshotProvider = FutureProvider<ProfileKycSnapshot>(
  (ref) => ref.watch(profileControllerProvider).getKyc(),
);

final profileSettingsSnapshotProvider = FutureProvider<ProfileSettingsSnapshot>(
  (ref) => ref.watch(profileControllerProvider).getSettings(),
);

final profileActivitySnapshotProvider = FutureProvider<ProfileActivitySnapshot>(
  (ref) => ref.watch(profileControllerProvider).getActivity(),
);

final profileApiKeyCreateSnapshotProvider =
    FutureProvider<ProfileApiKeyCreateSnapshot>(
      (ref) => ref.watch(profileControllerProvider).getApiKeyCreate(),
    );

final profileApiManagementSnapshotProvider =
    FutureProvider<ProfileApiManagementSnapshot>(
      (ref) => ref.watch(profileControllerProvider).getApiManagement(),
    );

final profileVipSnapshotProvider = FutureProvider<ProfileVipSnapshot>(
  (ref) => ref.watch(profileControllerProvider).getVip(),
);

final profileDeviceManagementSnapshotProvider =
    FutureProvider<ProfileDeviceManagementSnapshot>(
      (ref) => ref.watch(profileControllerProvider).getDeviceManagement(),
    );

final profileSubAccountsSnapshotProvider =
    FutureProvider<ProfileSubAccountsSnapshot>(
      (ref) => ref.watch(profileControllerProvider).getSubAccounts(),
    );
