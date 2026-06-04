part of '../pages/notifications_page.dart';

class _NotificationToolbar extends StatelessWidget {
  const _NotificationToolbar({
    required this.unreadCount,
    required this.filter,
    required this.onToggleFilter,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final _NotificationFilter filter;
  final VoidCallback onToggleFilter;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: NotificationsPage.toolbarKey,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        AppSpacing.x3,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              '$unreadCount chưa đọc',
              style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
            ),
          ),
          _ToolbarButton(
            key: NotificationsPage.filterKey,
            icon: Icons.tune_rounded,
            label: filter == _NotificationFilter.all ? 'Tất cả' : 'Chưa đọc',
            color: AppColors.primary,
            onTap: onToggleFilter,
          ),
          if (onMarkAllRead != null) ...[
            const SizedBox(width: AppSpacing.x2),
            _ToolbarButton(
              key: NotificationsPage.markAllReadKey,
              icon: Icons.done_all_rounded,
              label: 'Đọc tất cả',
              color: AppColors.buy,
              onTap: onMarkAllRead!,
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({
    required this.notifications,
    required this.onOpen,
    required this.onDelete,
  });

  final List<AppNotificationDraft> notifications;
  final ValueChanged<AppNotificationDraft> onOpen;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < notifications.length; i++)
          _NotificationRow(
            notification: notifications[i],
            highlighted: i < 3 && !notifications[i].isRead,
            showDivider: i < notifications.length - 1,
            onTap: () => onOpen(notifications[i]),
            onDelete: () => onDelete(notifications[i].id),
          ),
      ],
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.notification,
    required this.highlighted,
    required this.showDivider,
    required this.onTap,
    required this.onDelete,
  });

  final AppNotificationDraft notification;
  final bool highlighted;
  final bool showDivider;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final style = _typeStyle(notification.type);
    return InkWell(
      key: NotificationsPage.notificationKey(notification.id),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.contentPad,
          AppSpacing.x2,
          AppSpacing.contentPad,
          AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.primary08 : AppColors.transparent,
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.divider))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TypeIcon(style: style),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: AppSpacing.x2),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      _TypePill(label: style.label, color: style.color),
                      const SizedBox(width: AppSpacing.x3),
                      Flexible(
                        child: Text(
                          notification.time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            _DeleteButton(id: notification.id, onDelete: onDelete),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          border: Border.all(color: color.withValues(alpha: .22)),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.style});

  final _NotificationTypeStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: AppSpacing.x1),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .16),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(style.icon, color: style.color, size: 19),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1.1,
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.id, required this.onDelete});

  final String id;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: NotificationsPage.deleteKey(id),
      onTap: onDelete,
      borderRadius: AppRadii.smRadius,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.sell10,
          borderRadius: AppRadii.mdRadius,
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.sell,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 36, height: 1, color: AppColors.borderSolid),
          const SizedBox(width: AppSpacing.x3),
          Text(
            '$count thông báo',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: AppSpacing.x3),
          Container(width: 36, height: 1, color: AppColors.borderSolid),
        ],
      ),
    );
  }
}
