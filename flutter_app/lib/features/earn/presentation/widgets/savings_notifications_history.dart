part of '../pages/savings_notifications_page.dart';

class _NotificationsTabs extends StatelessWidget {
  const _NotificationsTabs({
    required this.tabs,
    required this.active,
    required this.unreadCount,
    required this.onChanged,
  });

  final List<SavingsNotificationTabDraft> tabs;
  final String active;
  final int unreadCount;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        0,
      ),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.id,
              label: tab.id == 'history' && unreadCount > 0
                  ? '${tab.label} ($unreadCount)'
                  : tab.label,
            ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({
    required this.history,
    required this.unreadCount,
    required this.onMarkAllRead,
    required this.onMarkRead,
    required this.onClearAll,
  });

  final List<SavingsNotificationDraft> history;
  final int unreadCount;
  final VoidCallback onMarkAllRead;
  final ValueChanged<String> onMarkRead;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HistoryActionBar(
          historyCount: history.length,
          unreadCount: unreadCount,
          onMarkAllRead: onMarkAllRead,
        ),
        const SizedBox(height: AppSpacing.x4),
        if (history.isEmpty)
          const _EmptyHistory()
        else
          Column(
            key: SavingsNotificationsPage.historyListKey,
            children: [
              for (final notification in history) ...[
                _NotificationCard(
                  key: notification == history.first
                      ? SavingsNotificationsPage.firstNotificationKey
                      : null,
                  notification: notification,
                  onTap: () => onMarkRead(notification.id),
                ),
                if (notification != history.last)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        if (history.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x5),
          _ClearAllButton(onTap: onClearAll),
        ],
      ],
    );
  }
}

class _HistoryActionBar extends StatelessWidget {
  const _HistoryActionBar({
    required this.historyCount,
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  final int historyCount;
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$historyCount thông báo · $unreadCount chưa đọc',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        if (unreadCount > 0)
          Material(
            color: AppColors.primary12,
            borderRadius: AppRadii.mdRadius,
            child: InkWell(
              key: SavingsNotificationsPage.markAllReadButtonKey,
              onTap: onMarkAllRead,
              borderRadius: AppRadii.mdRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3,
                  vertical: AppSpacing.x1,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.primary,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      'Đọc tất cả',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.primary,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final SavingsNotificationDraft notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _notificationColor(notification.type);
    final fill = notification.read
        ? AppColors.surface2
        : _notificationFill(notification.type);
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.cardLargeRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardLargeRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: AppRadii.cardLargeRadius,
            border: Border.all(
              color: notification.read
                  ? AppColors.cardBorder
                  : color.withValues(alpha: 0.28),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RoundIcon(
                  icon: _notificationIcon(notification.type),
                  color: color,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: notification.read
                                    ? AppTextStyles.medium
                                    : AppTextStyles.bold,
                                height: 1.25,
                              ),
                            ),
                          ),
                          if (!notification.read) ...[
                            const SizedBox(width: AppSpacing.x2),
                            const _UnreadDot(),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        notification.message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        notification.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
