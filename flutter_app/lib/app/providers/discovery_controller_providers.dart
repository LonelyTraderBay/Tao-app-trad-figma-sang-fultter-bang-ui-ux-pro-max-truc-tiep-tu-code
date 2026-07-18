import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/discovery/data/providers/discovery_repository_provider.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/controllers/discovery_controller.dart';

export 'package:vit_trade_flutter/features/discovery/presentation/controllers/discovery_controller.dart';

// GD4-F6 (bẫy 29 "controller forwarder mỏng"): DiscoveryController chỉ bọc
// repository, không giữ ViewState riêng — giữ nguyên `Provider<DiscoveryController>`
// SYNC. 2 method của nó nhận tham số theo mỗi lần gõ/chọn topic, nên bọc bằng
// `.family` FutureProvider (autoDispose — mỗi keystroke tạo 1 family member
// mới, xem bẫy 16) thay vì 1 snapshot provider duy nhất.

final discoveryControllerProvider = Provider<DiscoveryController>((ref) {
  return DiscoveryController(ref.watch(discoveryRepositoryProvider));
});

final unifiedSearchSnapshotProvider = FutureProvider.autoDispose
    .family<UnifiedSearchSnapshot, String>((ref, query) {
      return ref.watch(discoveryControllerProvider).unifiedSearch(query: query);
    });

final topicHubSnapshotProvider = FutureProvider.autoDispose
    .family<TopicHubSnapshot, ({String topicId, bool detailEndpoint})>((
      ref,
      args,
    ) {
      return ref
          .watch(discoveryControllerProvider)
          .topicHub(topicId: args.topicId, detailEndpoint: args.detailEndpoint);
    });
