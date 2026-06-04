import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/notifications_page_sections.dart';
part '../widgets/notifications_page_common.dart';

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
  _NotificationFilter _filter = _NotificationFilter.all;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsStateProvider);
    final snapshot = state.snapshot;
    final notifications = state.notifications;
    final unreadCount = state.unreadCount;
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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
    ref.read(notificationsStateProvider.notifier).markAllRead();
  }

  void _deleteNotification(String id) {
    HapticFeedback.selectionClick();
    ref.read(notificationsStateProvider.notifier).deleteNotification(id);
  }

  void _openNotification(AppNotificationDraft notification) {
    HapticFeedback.selectionClick();
    if (!notification.isRead) {
      ref.read(notificationsStateProvider.notifier).markRead(notification.id);
    }
    final path = _safeActionPath(notification.actionPath);
    if (path != null) context.go(path);
  }
}
