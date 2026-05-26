import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:vit_trade_flutter/features/notifications/data/repositories/mock_notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return const MockNotificationsRepository();
});
