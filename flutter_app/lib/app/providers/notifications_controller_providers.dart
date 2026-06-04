import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/notifications/data/providers/notifications_repository_provider.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/controllers/notifications_controller.dart';

export 'package:vit_trade_flutter/features/notifications/presentation/controllers/notifications_controller.dart';

final notificationsControllerProvider = Provider<NotificationsController>((
  ref,
) {
  return NotificationsController(ref.watch(notificationsRepositoryProvider));
});

final notificationsStateProvider =
    NotifierProvider<NotificationsStateController, NotificationsViewState>(
      NotificationsStateController.new,
    );

final notificationUnreadCountProvider = Provider<int>((ref) {
  try {
    return ref.watch(
      notificationsStateProvider.select((state) => state.unreadCount),
    );
  } on Object {
    return 0;
  }
});

final class NotificationsViewState {
  const NotificationsViewState({
    required this.snapshot,
    required this.notifications,
  });

  factory NotificationsViewState.fromSnapshot(NotificationsSnapshot snapshot) {
    return NotificationsViewState(
      snapshot: snapshot,
      notifications: List.unmodifiable(snapshot.notifications),
    );
  }

  final NotificationsSnapshot snapshot;
  final List<AppNotificationDraft> notifications;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  bool get hasUnread => unreadCount > 0;

  Set<NotificationsScreenState> get supportedStates => snapshot.supportedStates;

  NotificationsViewState copyWith({List<AppNotificationDraft>? notifications}) {
    return NotificationsViewState(
      snapshot: snapshot,
      notifications: List.unmodifiable(notifications ?? this.notifications),
    );
  }
}

final class NotificationsStateController
    extends Notifier<NotificationsViewState> {
  @override
  NotificationsViewState build() {
    return NotificationsViewState.fromSnapshot(
      ref.watch(notificationsRepositoryProvider).getNotifications(),
    );
  }

  void markRead(String id) {
    var changed = false;
    final next = state.notifications
        .map((notification) {
          if (notification.id != id || notification.isRead) return notification;
          changed = true;
          return notification.copyWith(isRead: true);
        })
        .toList(growable: false);

    if (changed) state = state.copyWith(notifications: next);
  }

  void markAllRead() {
    if (!state.hasUnread) return;
    state = state.copyWith(
      notifications: [
        for (final notification in state.notifications)
          notification.isRead
              ? notification
              : notification.copyWith(isRead: true),
      ],
    );
  }

  void deleteNotification(String id) {
    final next = state.notifications
        .where((notification) => notification.id != id)
        .toList(growable: false);
    if (next.length == state.notifications.length) return;
    state = state.copyWith(notifications: next);
  }

  void resetFromRepository() {
    state = NotificationsViewState.fromSnapshot(
      ref.read(notificationsRepositoryProvider).getNotifications(),
    );
  }
}
