import 'package:vit_trade_flutter/features/notifications/domain/entities/notifications_entities.dart';

abstract interface class NotificationsRepository {
  NotificationsSnapshot getNotifications();
}
