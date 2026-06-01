import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/copy_notifications_page_sections.dart';
part '../widgets/copy_notifications_page_common.dart';

const _notificationPrimary = AppColors.primary;
const _notificationPanel = AppColors.surface2;
const _notificationCard = AppColors.surface;
const _notificationChip = AppColors.surface3;
const _notificationMuted = AppColors.text3;

class CopyNotificationsPage extends ConsumerStatefulWidget {
  const CopyNotificationsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc068_copy_notifications_scroll_content');
  static const settingsKey = Key('sc068_settings_action');
  static const markAllReadKey = Key('sc068_mark_all_read');

  static Key tabKey(String id) => Key('sc068_tab_$id');
  static Key notificationKey(String id) => Key('sc068_notification_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyNotificationsPage> createState() =>
      _CopyNotificationsPageState();
}

class _CopyNotificationsPageState extends ConsumerState<CopyNotificationsPage> {
  String? _activeTab;
  List<TradeCopyNotification>? _notifications;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tradeReadModelControllerProvider);
    final snapshot = repository.getCopyNotifications();
    final activeTab = _activeTab ?? snapshot.defaultTab;
    _activeTab ??= snapshot.defaultTab;
    _notifications ??= snapshot.notifications;

    final notifications = _notifications!;
    final unreadCount = notifications.where((item) => !item.read).length;
    final tabs = _tabsFor(notifications, snapshot.tabs);
    final filteredNotifications = _filtered(notifications, activeTab);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-068 CopyNotificationsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Thông báo',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
              trailing: _SettingsAction(
                onTap: () => context.go(AppRoutePaths.tradeCopySettings),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CopyNotificationsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (unreadCount > 0) ...[
                      _UnreadSummary(
                        unreadCount: unreadCount,
                        onMarkAllRead: _markAllRead,
                      ),
                      const SizedBox(height: 24),
                    ],
                    _FilterTabs(
                      tabs: tabs,
                      activeTab: activeTab,
                      onChanged: (id) => setState(() => _activeTab = id),
                    ),
                    const SizedBox(height: 24),
                    if (filteredNotifications.isEmpty)
                      _EmptyNotifications(activeTab: activeTab)
                    else
                      for (final notification in filteredNotifications) ...[
                        _NotificationCard(
                          key: CopyNotificationsPage.notificationKey(
                            notification.id,
                          ),
                          notification: notification,
                          onTap: () => _handleNotificationTap(notification),
                        ),
                        if (notification != filteredNotifications.last)
                          const SizedBox(height: 10),
                      ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TradeCopyNotification> _filtered(
    List<TradeCopyNotification> notifications,
    String activeTab,
  ) {
    return switch (activeTab) {
      'unread' => notifications.where((item) => !item.read).toList(),
      'trade' =>
        notifications
            .where((item) => item.type == TradeCopyNotificationType.trade)
            .toList(),
      'risk' =>
        notifications
            .where((item) => item.type == TradeCopyNotificationType.risk)
            .toList(),
      'update' =>
        notifications
            .where((item) => item.type == TradeCopyNotificationType.update)
            .toList(),
      'system' =>
        notifications
            .where((item) => item.type == TradeCopyNotificationType.system)
            .toList(),
      _ => notifications,
    };
  }

  List<TradeCopyNotificationTab> _tabsFor(
    List<TradeCopyNotification> notifications,
    List<TradeCopyNotificationTab> baseTabs,
  ) {
    final unreadCount = notifications.where((item) => !item.read).length;
    int unreadByType(TradeCopyNotificationType type) =>
        notifications.where((item) => item.type == type && !item.read).length;

    return baseTabs.map((tab) {
      final badge = switch (tab.id) {
        'all' => unreadCount,
        'unread' => unreadCount,
        'trade' => unreadByType(TradeCopyNotificationType.trade),
        'risk' => unreadByType(TradeCopyNotificationType.risk),
        'update' => unreadByType(TradeCopyNotificationType.update),
        'system' => unreadByType(TradeCopyNotificationType.system),
        _ => tab.badge ?? 0,
      };
      return TradeCopyNotificationTab(
        id: tab.id,
        label: tab.label,
        badge: badge == 0 ? null : badge,
      );
    }).toList();
  }

  void _markAllRead() {
    setState(() {
      _notifications = _notifications!
          .map((notification) => notification.copyWith(read: true))
          .toList();
    });
  }

  void _handleNotificationTap(TradeCopyNotification notification) {
    setState(() {
      _notifications = _notifications!
          .map(
            (item) =>
                item.id == notification.id ? item.copyWith(read: true) : item,
          )
          .toList();
    });

    final path = _safeNotificationActionPath(notification.actionPath);
    if (path != null) context.go(path);
  }
}

String? _safeNotificationActionPath(String? actionPath) {
  if (actionPath == AppRoutePaths.tradeCopyActive) {
    return AppRoutePaths.tradeCopyActive;
  }
  if (actionPath == AppRoutePaths.tradeCopySettings) {
    return AppRoutePaths.tradeCopySettings;
  }
  return null;
}
