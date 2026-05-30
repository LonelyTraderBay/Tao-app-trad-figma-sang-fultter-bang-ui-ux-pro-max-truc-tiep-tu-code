import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/notifications/data/providers/notifications_repository_provider.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/controllers/notifications_controller.dart';

export 'package:vit_trade_flutter/features/notifications/presentation/controllers/notifications_controller.dart';

final notificationsControllerProvider = Provider<NotificationsController>((
  ref,
) {
  return NotificationsController(ref.watch(notificationsRepositoryProvider));
});
