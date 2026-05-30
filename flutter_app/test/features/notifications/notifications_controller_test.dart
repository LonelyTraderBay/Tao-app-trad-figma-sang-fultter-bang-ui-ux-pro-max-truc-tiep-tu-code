import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/notifications/data/repositories/mock_notifications_repository.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/controllers/notifications_controller.dart';

void main() {
  group('NotificationsController', () {
    test('exposes notifications snapshot through repository contract', () {
      final controller = NotificationsController(
        const MockNotificationsRepository(),
      );

      final snapshot = controller.getNotifications();

      expect(snapshot.endpoint, '/api/mobile/notifications/notifications');
      expect(snapshot.notifications, hasLength(15));
      expect(snapshot.notifications.where((item) => !item.isRead), isNotEmpty);
      expect(
        snapshot.supportedStates,
        containsAll([
          NotificationsScreenState.loading,
          NotificationsScreenState.empty,
          NotificationsScreenState.error,
          NotificationsScreenState.offline,
        ]),
      );
    });
  });
}
