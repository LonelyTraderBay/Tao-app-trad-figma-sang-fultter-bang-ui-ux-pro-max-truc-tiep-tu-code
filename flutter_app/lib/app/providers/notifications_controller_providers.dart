import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/notifications/data/providers/notifications_repository_provider.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/controllers/notifications_controller.dart';

export 'package:vit_trade_flutter/features/notifications/presentation/controllers/notifications_controller.dart';

final notificationsControllerProvider = Provider<NotificationsController>((
  ref,
) {
  return NotificationsController(ref.watch(notificationsRepositoryProvider));
});

/// GD4-F2: raw read — NotificationsRepository.getNotifications() is now
/// `Future<T>` (ADR-001 read idiom). [NotificationsStateController] (the
/// write/mutation Notifier below) seeds its state from this provider.
final notificationsSnapshotProvider = FutureProvider<NotificationsSnapshot>(
  (ref) => ref.watch(notificationsRepositoryProvider).getNotifications(),
);

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

/// GD4-F2 khuôn "controller GHI" (xem GD4-Async-Playbook.md mục "Controller
/// GHI" — cùng khuôn với `AddressBookStateController` trong
/// wallet_controller_providers.dart): Notifier vẫn SYNC, `build()` map
/// AsyncValue của [notificationsSnapshotProvider] sang một
/// [NotificationsViewState] luôn có sẵn (loading/error → snapshot rỗng với
/// `screenState` tương ứng) — trang notifications_page.dart đã có sẵn UI
/// theo `screenState` (switch loading/error/empty/offline/ready) nên KHÔNG
/// cần đổi trang sang `.when()`, chỉ cần Notifier phản ánh đúng trạng thái.
final class NotificationsStateController
    extends Notifier<NotificationsViewState> {
  @override
  NotificationsViewState build() {
    final asyncSnapshot = ref.watch(notificationsSnapshotProvider);
    return asyncSnapshot.when(
      data: NotificationsViewState.fromSnapshot,
      loading: () => NotificationsViewState.fromSnapshot(
        _placeholderSnapshot(NotificationsScreenState.loading),
      ),
      error: (error, stackTrace) => NotificationsViewState.fromSnapshot(
        _placeholderSnapshot(NotificationsScreenState.error),
      ),
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

  /// Retry entry point for the error state's "Thử lại" button — invalidates
  /// the underlying fetch so [build] re-runs against fresh repository data.
  void resetFromRepository() {
    ref.invalidate(notificationsSnapshotProvider);
  }
}

NotificationsSnapshot _placeholderSnapshot(NotificationsScreenState state) {
  return NotificationsSnapshot(
    endpoint: '/api/mobile/notifications/notifications',
    actionDraft: 'PATCH /user/settings or module settings',
    title: 'Thông báo',
    subtitle: 'Thông báo · Hệ thống',
    backRoute: '/home',
    notifications: const [],
    contractNotes:
        'Notifications feed supports read/delete/filter local state. Backend should return notificationsReferenceData and screenState; read/delete actions become PATCH user settings or notification state.',
    screenState: state,
    supportedStates: const {
      NotificationsScreenState.loading,
      NotificationsScreenState.empty,
      NotificationsScreenState.error,
      NotificationsScreenState.offline,
    },
  );
}
