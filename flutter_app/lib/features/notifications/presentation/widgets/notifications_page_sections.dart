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
    return VitCard(
      key: NotificationsPage.toolbarKey,
      width: double.infinity,
      radius: VitCardRadius.sm,
      variant: VitCardVariant.inner,
      borderColor: AppColors.divider,
      padding: AppSpacing.notificationsToolbarPadding,
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
    return VitCard(
      key: NotificationsPage.notificationKey(notification.id),
      width: double.infinity,
      radius: VitCardRadius.sm,
      variant: highlighted ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: showDivider ? AppColors.divider : AppColors.transparent,
      padding: AppSpacing.notificationsRowPadding,
      onTap: onTap,
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
                      const Padding(
                        padding: AppSpacing.notificationsUnreadDotMargin,
                        child: SizedBox.square(
                          dimension: AppSpacing.notificationsUnreadDotSize,
                          child: Material(
                            color: AppColors.primary,
                            shape: CircleBorder(),
                          ),
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
                    height: AppSpacing.notificationsMessageLineHeight,
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
    return VitIconButton(
      icon: icon,
      tooltip: label,
      label: label,
      size: VitIconButtonSize.md,
      variant: color == AppColors.buy
          ? VitIconButtonVariant.success
          : VitIconButtonVariant.primary,
      onPressed: onTap,
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.style});

  final _NotificationTypeStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.notificationsTypeIconMargin,
      child: SizedBox.square(
        dimension: AppSpacing.notificationsTypeIconBox,
        child: Material(
          color: style.color.withValues(alpha: .16),
          borderRadius: AppRadii.lgRadius,
          child: Icon(
            style.icon,
            color: style.color,
            size: AppSpacing.notificationsTypeIcon,
          ),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.id, required this.onDelete});

  final String id;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      key: NotificationsPage.deleteKey(id),
      icon: Icons.delete_outline_rounded,
      tooltip: 'Delete notification',
      size: VitIconButtonSize.md,
      variant: VitIconButtonVariant.danger,
      onPressed: onDelete,
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.notificationsFooterPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: AppSpacing.notificationsFooterDividerWidth,
            height: AppSpacing.notificationsFooterDividerHeight,
            child: ColoredBox(color: AppColors.borderSolid),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            '$count thông báo',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: AppSpacing.x3),
          const SizedBox(
            width: AppSpacing.notificationsFooterDividerWidth,
            height: AppSpacing.notificationsFooterDividerHeight,
            child: ColoredBox(color: AppColors.borderSolid),
          ),
        ],
      ),
    );
  }
}
