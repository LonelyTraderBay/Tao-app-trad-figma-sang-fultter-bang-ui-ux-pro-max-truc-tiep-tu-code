import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/features/onboarding/data/providers/onboarding_repository_provider.dart';
import 'package:vit_trade_flutter/features/onboarding/presentation/controllers/onboarding_controller.dart';

export 'package:vit_trade_flutter/features/onboarding/presentation/controllers/onboarding_controller.dart';

final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  return OnboardingController(ref.watch(onboardingRepositoryProvider));
});

/// GĐ4-F1: cờ user đã đi qua (hoặc bỏ qua) onboarding lần đầu — đọc-lúc-dựng
/// cho router/nhánh khởi động dùng sau (ví dụ quyết định route ban đầu).
/// KHÔNG reactive theo write (`OnboardingFlow` ghi cờ trực tiếp qua
/// [keyValueStoreProvider], không qua provider này) — chấp nhận được vì đây
/// là cờ một-chiều, không cần cập nhật UI ngay khi ghi.
final onboardingSeenProvider = Provider<bool>((ref) {
  return ref
          .watch(keyValueStoreProvider)
          .getBool(KeyValueStoreKeys.onboardingSeen) ??
      false;
});
