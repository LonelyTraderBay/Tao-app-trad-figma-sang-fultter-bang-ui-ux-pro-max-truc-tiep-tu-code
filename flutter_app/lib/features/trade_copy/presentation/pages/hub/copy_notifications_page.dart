import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../widgets/hub/copy_notifications_page_sections.dart';
part '../../widgets/hub/copy_notifications_page_common.dart';

const _notificationPrimary = AppColors.primary;

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
    final repository = ref.watch(tradeCopyTradingRepositoryProvider);
    final snapshot = repository.getCopyNotifications();
    final activeTab = _activeTab ?? snapshot.defaultTab;
    _activeTab ??= snapshot.defaultTab;
    _notifications ??= snapshot.notifications;

    final notifications = _notifications!;
    final unreadCount = notifications.where((item) => !item.read).length;
    final tabs = _tabsFor(notifications, snapshot.tabs);
    final filteredNotifications = _filtered(notifications, activeTab);

    return VitTradeDetailScaffold(
      title: 'Thông báo',
      semanticLabel: 'Thông báo',
      semanticIdentifier: 'SC-068',
      contentKey: CopyNotificationsPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      headerActions: [
        VitHeaderActionItem(
          key: CopyNotificationsPage.settingsKey,
          type: VitHeaderActionType.settings,
          onPressed: () => context.push(AppRoutePaths.tradeCopySettings),
        ),
      ],
      children: [
        if (unreadCount > 0)
          VitTradeSection(
            title: 'Chưa đọc',
            child: _UnreadSummary(
              unreadCount: unreadCount,
              onMarkAllRead: _markAllRead,
            ),
          ),
        VitTradeSection(
          title: 'Bộ lọc',
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final tab in tabs) ...[
                  VitFilterChip(
                    key: CopyNotificationsPage.tabKey(tab.id),
                    label: tab.label,
                    active: tab.id == activeTab,
                    onTap: () => setState(() => _activeTab = tab.id),
                    color: _notificationPrimary,
                    count: tab.badge,
                  ),
                  if (tab != tabs.last)
                    const SizedBox(
                      width: AppSpacing.statusPillHorizontalPaddingMd,
                    ),
                ],
              ],
            ),
          ),
        ),
        VitTradeSection(
          title: 'Danh sách',
          child: filteredNotifications.isEmpty
              ? _EmptyNotifications(activeTab: activeTab)
              : Column(
                  children: [
                    for (final notification in filteredNotifications) ...[
                      _NotificationCard(
                        key: CopyNotificationsPage.notificationKey(
                          notification.id,
                        ),
                        notification: notification,
                        onTap: () => _handleNotificationTap(notification),
                      ),
                      if (notification != filteredNotifications.last)
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                    ],
                  ],
                ),
        ),
        VitTradeSection(
          title: 'Đánh giá rủi ro',
          child: const VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.cardPaddingCompact,
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Notification risk review',
              message:
                  'Unread risk alerts, action routes, copy-trading updates and next steps are reviewed before navigation or bulk read changes.',
              contractId: 'copy-notifications-review',
            ),
          ),
        ),
        const TradeBodyReviewSection(
          title: 'Notification body review',
          message: 'Copy notification body reviewed',
          detail:
              'Unread summary, filters, cards, empty, bulk read, and navigation states stay visible.',
          primary:
              'Unread risk alerts remain separated from general copy updates.',
          secondary: 'Filter state stays visible before notification actions.',
          tertiary: 'Navigation stays scoped to copy-trading review screens.',
        ),
      ],
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
    if (path != null) context.push(path);
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
