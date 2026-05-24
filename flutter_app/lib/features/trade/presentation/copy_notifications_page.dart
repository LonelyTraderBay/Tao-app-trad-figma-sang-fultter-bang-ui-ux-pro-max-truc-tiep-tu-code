import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _notificationPrimary = AppColors.primary;
const _notificationPanel = AppColors.surface2;
const _notificationCard = AppColors.surface;
const _notificationChip = AppColors.surface3;
const _notificationMuted = Color(0xFF667085);

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
    final repository = ref.watch(tradeRepositoryProvider);
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

class _SettingsAction extends StatelessWidget {
  const _SettingsAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: CopyNotificationsPage.settingsKey,
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _notificationChip,
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: const Icon(
          Icons.settings_outlined,
          color: AppColors.text1,
          size: 21,
        ),
      ),
    );
  }
}

class _UnreadSummary extends StatelessWidget {
  const _UnreadSummary({
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _notificationPrimary),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: _notificationPrimary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$unreadCount thông báo chưa đọc',
              style: AppTextStyles.caption.copyWith(
                color: _notificationPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            key: CopyNotificationsPage.markAllReadKey,
            onPressed: onMarkAllRead,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Đánh dấu tất cả đã đọc',
              style: AppTextStyles.caption.copyWith(
                color: _notificationPrimary,
                decoration: TextDecoration.underline,
                decorationColor: _notificationPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<TradeCopyNotificationTab> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final active = tab.id == activeTab;
          return _FilterPill(
            key: CopyNotificationsPage.tabKey(tab.id),
            tab: tab,
            active: active,
            onTap: () => onChanged(tab.id),
          );
        },
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    super.key,
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final TradeCopyNotificationTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardLargeRadius,
      child: Container(
        width: 53,
        height: 53,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _notificationPrimary.withValues(alpha: .16)
              : _notificationChip,
          borderRadius: AppRadii.cardLargeRadius,
          border: Border.all(
            color: active ? _notificationPrimary : Colors.transparent,
          ),
        ),
        child: Text(
          _tabLabel(tab.label),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: active ? _notificationPrimary : _notificationMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
      ),
    );
  }

  String _tabLabel(String label) {
    return switch (label) {
      'Tất cả' => 'Tất\ncả',
      'Chưa đọc' => 'Chưa\nđọc',
      'Cập nhật' => 'Cập\nnhật',
      'Hệ thống' => 'Hệ\nthống',
      _ => label,
    };
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final TradeCopyNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _notificationColor(notification);
    final read = notification.read;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: read ? _notificationCard : _notificationPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: read ? AppColors.cardBorder : color),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _notificationIcon(notification),
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Opacity(
                opacity: read ? .7 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontSize: 14,
                              fontWeight: read
                                  ? FontWeight.w700
                                  : FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ),
                        if (!read) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 3),
                            decoration: const BoxDecoration(
                              color: _notificationPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.message,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                        height: 1.42,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _MetaItem(
                          icon: Icons.access_time_rounded,
                          label: notification.timestamp,
                        ),
                        if (notification.providerName != null)
                          _MetaItem(
                            icon: Icons.group_outlined,
                            label: notification.providerName!,
                          ),
                        if (notification.pnl != null)
                          Text(
                            _formatPnl(notification.pnl!),
                            style: AppTextStyles.caption.copyWith(
                              color: notification.pnl! >= 0
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                      ],
                    ),
                    if (notification.pair != null) ...[
                      const SizedBox(height: 10),
                      _PairChip(notification: notification, color: color),
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
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: 11),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _PairChip extends StatelessWidget {
  const _PairChip({required this.notification, required this.color});

  final TradeCopyNotification notification;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final side = notification.side == TradeOrderSide.sell ? 'SELL' : 'BUY';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        '$side ${notification.pair}',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications({required this.activeTab});

  final String activeTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: _notificationChip,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.text3,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            activeTab == 'unread'
                ? 'Không có thông báo chưa đọc'
                : 'Chưa có thông báo nào',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _notificationIcon(TradeCopyNotification notification) {
  if (notification.severity == TradeCopyNotificationSeverity.critical) {
    return Icons.warning_amber_rounded;
  }
  return switch (notification.type) {
    TradeCopyNotificationType.trade => Icons.show_chart_rounded,
    TradeCopyNotificationType.risk => Icons.track_changes_rounded,
    TradeCopyNotificationType.update => Icons.feed_outlined,
    TradeCopyNotificationType.system => Icons.info_outline_rounded,
  };
}

Color _notificationColor(TradeCopyNotification notification) {
  if (notification.severity == TradeCopyNotificationSeverity.critical) {
    return AppColors.sell;
  }
  if (notification.severity == TradeCopyNotificationSeverity.warning) {
    return AppColors.warn;
  }
  return switch (notification.type) {
    TradeCopyNotificationType.trade => _notificationPrimary,
    TradeCopyNotificationType.risk => AppColors.sell,
    TradeCopyNotificationType.update => const Color(0xFF8B5CF6),
    TradeCopyNotificationType.system => AppColors.text3,
  };
}

String _formatPnl(double value) {
  final prefix = value >= 0 ? '+' : '-';
  return '$prefix\$${value.abs().toStringAsFixed(0)}';
}
