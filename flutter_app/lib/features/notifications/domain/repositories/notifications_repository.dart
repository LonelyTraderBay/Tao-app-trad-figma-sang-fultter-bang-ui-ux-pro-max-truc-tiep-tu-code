import 'package:vit_trade_flutter/features/notifications/domain/entities/notifications_entities.dart';

/// Repository contract for fetching the notifications list as a
/// [NotificationsSnapshot].
///
/// GD4-F2: `Future<T>` — ADR-001's read idiom (see
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md).
abstract interface class NotificationsRepository {
  Future<NotificationsSnapshot> getNotifications();
}
