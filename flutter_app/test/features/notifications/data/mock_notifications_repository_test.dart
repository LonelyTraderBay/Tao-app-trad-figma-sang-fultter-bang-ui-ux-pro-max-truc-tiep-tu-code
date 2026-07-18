import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/notifications/data/notifications_repository.dart';

/// Direct smoke test for [MockNotificationsRepository]: exercises the single
/// method on [NotificationsRepository] (getNotifications) and pins fixture
/// literals from
/// lib/features/notifications/data/repositories/mock_notifications_repository.dart
/// that test/features/notifications/mock_notifications_repository_test.dart
/// only asserts the shape of (hasLength/isNotEmpty). The notif001 id and
/// unread count reuse the literals already proven in
/// notifications_controller_test.dart.
void main() {
  const repository = MockNotificationsRepository();

  group('MockNotificationsRepository smoke test', () {
    test('getNotifications pins the endpoint, back route and feed length', () {
      final snapshot = repository.getNotifications();

      expect(snapshot, isA<NotificationsSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/notifications/notifications');
      expect(snapshot.backRoute, '/home');
      expect(snapshot.notifications, hasLength(15));
      expect(snapshot.screenState, NotificationsScreenState.ready);
    });

    test('notifications pin the first entry and the unread count', () {
      final snapshot = repository.getNotifications();
      final first = snapshot.notifications.first;

      expect(first.id, 'notif001');
      expect(first.type, AppNotificationType.trade);
      expect(first.isRead, isFalse);
      expect(first.actionPath, '/trade/orders');
      expect(snapshot.notifications.where((n) => !n.isRead), hasLength(7));
    });

    test('notifications cover every AppNotificationType used by the app', () {
      final snapshot = repository.getNotifications();
      final types = snapshot.notifications.map((n) => n.type).toSet();

      expect(
        types,
        containsAll(<AppNotificationType>{
          AppNotificationType.trade,
          AppNotificationType.priceAlert,
          AppNotificationType.deposit,
          AppNotificationType.security,
          AppNotificationType.p2p,
          AppNotificationType.system,
          AppNotificationType.withdraw,
          AppNotificationType.referral,
          AppNotificationType.arena,
        }),
      );
    });
  });
}
