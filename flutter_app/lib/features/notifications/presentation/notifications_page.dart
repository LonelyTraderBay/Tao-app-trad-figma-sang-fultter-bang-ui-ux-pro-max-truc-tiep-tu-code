import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/notifications_repository.dart';

enum _NotificationFilter { all, unread }

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc291_notifications_content');
  static const toolbarKey = Key('sc291_notifications_toolbar');
  static const filterKey = Key('sc291_notifications_filter');
  static const markAllReadKey = Key('sc291_notifications_mark_all_read');
  static const emptyKey = Key('sc291_notifications_empty');

  static Key notificationKey(String id) => Key('sc291_notification_$id');
  static Key deleteKey(String id) => Key('sc291_delete_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  List<AppNotificationDraft>? _notifications;
  _NotificationFilter _filter = _NotificationFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(notificationsRepositoryProvider)
        .getNotifications();
    _notifications ??= snapshot.notifications;
    final notifications = _notifications!;
    final unreadCount = notifications.where((item) => !item.isRead).length;
    final filtered = _filter == _NotificationFilter.all
        ? notifications
        : notifications.where((item) => !item.isRead).toList();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-291 NotificationsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: NotificationsPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    children: [
                      _NotificationToolbar(
                        unreadCount: unreadCount,
                        filter: _filter,
                        onToggleFilter: _toggleFilter,
                        onMarkAllRead: unreadCount > 0 ? _markAllRead : null,
                      ),
                      if (filtered.isEmpty)
                        VitEmptyState(
                          key: NotificationsPage.emptyKey,
                          title: _filter == _NotificationFilter.unread
                              ? 'Không có thông báo chưa đọc'
                              : 'Chưa có thông báo nào',
                          message:
                              'Thông báo giao dịch, bảo mật và hệ thống sẽ hiển thị tại đây',
                          icon: Icons.notifications_off_rounded,
                          actionLabel: _filter == _NotificationFilter.unread
                              ? 'Xem tất cả'
                              : null,
                          onAction: _filter == _NotificationFilter.unread
                              ? _toggleFilter
                              : null,
                        )
                      else
                        _NotificationList(
                          notifications: filtered,
                          onOpen: _openNotification,
                          onDelete: _deleteNotification,
                        ),
                      if (filtered.isNotEmpty)
                        _ListFooter(count: filtered.length),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFilter() {
    HapticFeedback.selectionClick();
    setState(() {
      _filter = _filter == _NotificationFilter.all
          ? _NotificationFilter.unread
          : _NotificationFilter.all;
    });
  }

  void _markAllRead() {
    HapticFeedback.selectionClick();
    setState(() {
      _notifications = _notifications!
          .map((item) => item.copyWith(isRead: true))
          .toList();
    });
  }

  void _deleteNotification(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _notifications = _notifications!.where((item) => item.id != id).toList();
    });
  }

  void _openNotification(AppNotificationDraft notification) {
    HapticFeedback.selectionClick();
    if (!notification.isRead) {
      setState(() {
        _notifications = _notifications!
            .map(
              (item) => item.id == notification.id
                  ? item.copyWith(isRead: true)
                  : item,
            )
            .toList();
      });
    }
    final path = _safeActionPath(notification.actionPath);
    if (path != null) context.go(path);
  }
}

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
            icon: Icons.filter_alt_outlined,
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
          color: highlighted ? AppColors.primary08 : Colors.transparent,
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

final class _NotificationTypeStyle {
  const _NotificationTypeStyle({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

_NotificationTypeStyle _typeStyle(AppNotificationType type) {
  return switch (type) {
    AppNotificationType.trade => const _NotificationTypeStyle(
      label: 'Giao dịch',
      icon: Icons.check_circle_rounded,
      color: AppColors.buy,
    ),
    AppNotificationType.deposit => const _NotificationTypeStyle(
      label: 'Nạp tiền',
      icon: Icons.arrow_downward_rounded,
      color: AppColors.primary,
    ),
    AppNotificationType.withdraw => const _NotificationTypeStyle(
      label: 'Rút tiền',
      icon: Icons.arrow_upward_rounded,
      color: AppColors.accent,
    ),
    AppNotificationType.security => const _NotificationTypeStyle(
      label: 'Bảo mật',
      icon: Icons.lock_rounded,
      color: AppColors.sell,
    ),
    AppNotificationType.system => const _NotificationTypeStyle(
      label: 'Hệ thống',
      icon: Icons.settings_rounded,
      color: AppColors.text2,
    ),
    AppNotificationType.p2p => const _NotificationTypeStyle(
      label: 'P2P',
      icon: Icons.handshake_rounded,
      color: AppColors.buy,
    ),
    AppNotificationType.priceAlert => const _NotificationTypeStyle(
      label: 'Cảnh báo giá',
      icon: Icons.notifications_active_rounded,
      color: AppColors.warn,
    ),
    AppNotificationType.referral => const _NotificationTypeStyle(
      label: 'Giới thiệu',
      icon: Icons.card_giftcard_rounded,
      color: AppColors.warn,
    ),
    AppNotificationType.arena => const _NotificationTypeStyle(
      label: 'Open Arena',
      icon: Icons.military_tech_rounded,
      color: AppColors.accent,
    ),
  };
}

String? _safeActionPath(String? rawPath) {
  return switch (rawPath) {
    null || '' => null,
    '/trade/orders' => '/trade/orders-history',
    '/pair/ethusdt' => '/pair/ethusdt',
    '/wallet' => '/wallet',
    '/profile/activity' => '/profile/activity',
    '/p2p/order/p2p001' => '/p2p/order/p2p001',
    '/news' => '/news',
    '/wallet/history' => '/wallet/history',
    '/referral/rewards' => '/referral/rewards',
    '/referral/history' => '/referral/history',
    '/arena/challenge/ch001' => '/arena/challenge/ch001',
    '/arena/challenge/room003' => '/arena/challenge/room003',
    '/arena/points' => '/arena/points',
    '/arena/challenge/room002' => '/arena/challenge/room002',
    '/arena/mode/mode001' => '/arena/mode/mode001',
    _ => null,
  };
}
