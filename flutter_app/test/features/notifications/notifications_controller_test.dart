import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/features/notifications/data/repositories/mock_notifications_repository.dart';

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
      expect(snapshot.screenState, NotificationsScreenState.ready);
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

    test('global state exposes unread count and idempotent mutations', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(notificationUnreadCountProvider), 7);

      container.read(notificationsStateProvider.notifier).markRead('notif001');
      expect(container.read(notificationUnreadCountProvider), 6);

      container.read(notificationsStateProvider.notifier).markRead('notif001');
      expect(container.read(notificationUnreadCountProvider), 6);

      container
          .read(notificationsStateProvider.notifier)
          .deleteNotification('notif002');
      expect(container.read(notificationUnreadCountProvider), 5);
      expect(
        container
            .read(notificationsStateProvider)
            .notifications
            .where((item) => item.id == 'notif002'),
        isEmpty,
      );

      container.read(notificationsStateProvider.notifier).markAllRead();
      expect(container.read(notificationUnreadCountProvider), 0);

      container.read(notificationsStateProvider.notifier).resetFromRepository();
      expect(container.read(notificationUnreadCountProvider), 7);
    });
  });
}
