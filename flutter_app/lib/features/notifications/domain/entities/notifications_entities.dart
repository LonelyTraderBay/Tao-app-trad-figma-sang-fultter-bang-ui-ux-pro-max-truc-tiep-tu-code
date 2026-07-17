/// UI states the notifications screen can render.
enum NotificationsScreenState { loading, empty, error, offline, ready }

/// Category of an app notification, driving its icon and routing.
enum AppNotificationType {
  trade,
  deposit,
  withdraw,
  security,
  system,
  p2p,
  priceAlert,
  referral,
  arena,
}

/// Data contract for the notifications screen: the notification list plus
/// current screen state.
final class NotificationsSnapshot {
  const NotificationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.notifications,
    required this.contractNotes,
    required this.screenState,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<AppNotificationDraft> notifications;
  final String contractNotes;
  final NotificationsScreenState screenState;
  final Set<NotificationsScreenState> supportedStates;
}

/// A single notification entry in the notifications list.
final class AppNotificationDraft {
  const AppNotificationDraft({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    this.actionPath,
  });

  final String id;
  final AppNotificationType type;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String? actionPath;

  AppNotificationDraft copyWith({bool? isRead}) {
    return AppNotificationDraft(
      id: id,
      type: type,
      title: title,
      message: message,
      time: time,
      isRead: isRead ?? this.isRead,
      actionPath: actionPath,
    );
  }
}
