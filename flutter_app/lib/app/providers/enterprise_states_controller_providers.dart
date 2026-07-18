import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/enterprise_states/data/providers/enterprise_states_repository_provider.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/controllers/enterprise_states_controller.dart';

export 'package:vit_trade_flutter/features/enterprise_states/presentation/controllers/enterprise_states_controller.dart';

// GD4-F6 (bẫy 29 "controller forwarder mỏng"): giữ nguyên
// `Provider<EnterpriseStatesController>` SYNC, thêm FutureProvider snapshot
// gọi xuyên qua controller.

final enterpriseStatesControllerProvider = Provider<EnterpriseStatesController>(
  (ref) {
    return EnterpriseStatesController(
      ref.watch(enterpriseStatesRepositoryProvider),
    );
  },
);

final enterpriseStatesSnapshotProvider =
    FutureProvider<EnterpriseStatesSnapshot>(
      (ref) => ref.watch(enterpriseStatesControllerProvider).reference(),
    );
