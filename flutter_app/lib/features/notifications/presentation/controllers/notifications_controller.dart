import 'package:vit_trade_flutter/features/notifications/domain/entities/notifications_entities.dart';
import 'package:vit_trade_flutter/features/notifications/domain/repositories/notifications_repository.dart';

export 'package:vit_trade_flutter/features/notifications/domain/entities/notifications_entities.dart';
export 'package:vit_trade_flutter/features/notifications/domain/repositories/notifications_repository.dart';

final class NotificationsController implements NotificationsRepository {
  const NotificationsController(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<NotificationsSnapshot> getNotifications() {
    return _repository.getNotifications();
  }
}
