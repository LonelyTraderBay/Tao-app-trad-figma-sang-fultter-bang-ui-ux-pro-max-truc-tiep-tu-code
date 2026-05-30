import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/network/api_client.dart';

typedef RepositoryFactory<T> = T Function();
typedef RemoteRepositoryFactory<T> = T Function(ApiClient client);
typedef FailClosedRepositoryFactory<T> = T Function();

T guardedRepository<T>(
  Ref ref, {
  required String featureName,
  required RepositoryFactory<T> mock,
  RemoteRepositoryFactory<T>? remote,
  FailClosedRepositoryFactory<T>? failClosed,
}) {
  final config = ref.watch(appConfigProvider);
  if (config.enableMockData) return mock();

  if (remote != null) {
    return remote(ref.watch(apiClientProvider));
  }

  if (failClosed != null) return failClosed();

  throw StateError(
    '$featureName remote repository is required when mock data is disabled. '
    'Configure a remote repository before using this feature in production.',
  );
}
