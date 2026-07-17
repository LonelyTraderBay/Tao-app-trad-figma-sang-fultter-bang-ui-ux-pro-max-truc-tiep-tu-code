import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/notifications/data/notifications_repository.dart';

/// Smoke test for [MockNotificationsRepository]: exercises every method on
/// [NotificationsRepository] and asserts each call succeeds without
/// throwing and returns a plausible, non-empty result.
void main() {
  const repository = MockNotificationsRepository();

  group('MockNotificationsRepository smoke test', () {
    test('getNotifications returns a populated snapshot', () {
      final snapshot = repository.getNotifications();

      expect(snapshot, isA<NotificationsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.actionDraft, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.subtitle, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.notifications, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.screenState, NotificationsScreenState.ready);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getNotifications does not throw', () {
      expect(() => repository.getNotifications(), returnsNormally);
    });

    test('getNotifications exposes the expected endpoint and back route', () {
      final snapshot = repository.getNotifications();

      expect(snapshot.endpoint, '/api/mobile/notifications/notifications');
      expect(snapshot.backRoute, '/home');
    });

    test('notifications include a spot-checked entry with expected fields', () {
      final snapshot = repository.getNotifications();
      final first = snapshot.notifications.first;

      expect(first, isA<AppNotificationDraft>());
      expect(first.id, 'notif001');
      expect(first.type, AppNotificationType.trade);
      expect(first.title, isNotEmpty);
      expect(first.message, isNotEmpty);
      expect(first.time, isNotEmpty);
      expect(first.actionPath, isNotEmpty);
    });

    test('notifications cover multiple app notification types', () {
      final snapshot = repository.getNotifications();
      final types = snapshot.notifications.map((n) => n.type).toSet();

      expect(types, contains(AppNotificationType.arena));
      expect(types, contains(AppNotificationType.p2p));
      expect(types, contains(AppNotificationType.security));
      expect(types, contains(AppNotificationType.referral));
    });

    test('notifications include both read and unread entries', () {
      final snapshot = repository.getNotifications();

      expect(snapshot.notifications.any((n) => n.isRead), isTrue);
      expect(snapshot.notifications.any((n) => !n.isRead), isTrue);
    });

    test('supportedStates covers the non-ready screen states', () {
      final snapshot = repository.getNotifications();

      expect(
        snapshot.supportedStates,
        containsAll(<NotificationsScreenState>{
          NotificationsScreenState.loading,
          NotificationsScreenState.empty,
          NotificationsScreenState.error,
          NotificationsScreenState.offline,
        }),
      );
      expect(
        snapshot.supportedStates,
        isNot(contains(NotificationsScreenState.ready)),
      );
    });
  });
}
