import 'package:vit_trade_flutter/features/notifications/domain/entities/notifications_entities.dart';

/// Repository contract for fetching the notifications list as a
/// [NotificationsSnapshot].
abstract interface class NotificationsRepository {
  NotificationsSnapshot getNotifications();
}
