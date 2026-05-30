import 'package:vit_trade_flutter/features/notifications/domain/entities/notifications_errors.dart';
import 'package:vit_trade_flutter/features/notifications/domain/repositories/notifications_repository.dart';

final class FailClosedNotificationsRepository
    implements NotificationsRepository {
  const FailClosedNotificationsRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const NotificationsBackendContractMissingException();
  }
}
