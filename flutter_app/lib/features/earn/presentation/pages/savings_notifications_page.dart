import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class SavingsNotificationsPage extends ConsumerStatefulWidget {
  const SavingsNotificationsPage({super.key, this.shellRenderMode});

  static const historyListKey = Key('sc337_history_list');
  static const settingsListKey = Key('sc337_settings_list');
  static const firstNotificationKey = Key('sc337_first_notification');
  static const markAllReadButtonKey = Key('sc337_mark_all_read');
  static const clearAllButtonKey = Key('sc337_clear_all_notifications');

  static Key tabKey(String id) => Key('sc337_tab_$id');
  static Key settingKey(String id) => Key('sc337_setting_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsNotificationsPage> createState() =>
      _SavingsNotificationsPageState();
}

class _SavingsNotificationsPageState
    extends ConsumerState<SavingsNotificationsPage> {
  String? _activeTab;
  List<SavingsNotificationDraft>? _history;
  List<SavingsNotificationSettingDraft>? _settings;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsNotificationsRepositoryProvider)
        .getNotifications();
    _activeTab ??= snapshot.defaultTab;
    _history ??= snapshot.history;
    _settings ??= snapshot.settings;

    final history = _history!;
    final settings = _settings!;
    final unreadCount = history
        .where((notification) => !notification.read)
        .length;
    final enabledCount = settings.where((setting) => setting.enabled).length;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-337 SavingsNotificationsPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            _NotificationsTabs(
              tabs: snapshot.tabs,
              active: _activeTab!,
              unreadCount: unreadCount,
              onChanged: (tab) {
                HapticFeedback.selectionClick();
                setState(() => _activeTab = tab);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    if (_activeTab == 'history')
                      _HistoryTab(
                        history: history,
                        unreadCount: unreadCount,
                        onMarkAllRead: _markAllRead,
                        onMarkRead: _markRead,
                        onClearAll: _clearAll,
                      )
                    else
                      _SettingsTab(
                        snapshot: snapshot,
                        settings: settings,
                        enabledCount: enabledCount,
                        onToggle: _toggleSetting,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markRead(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _history = [
        for (final notification in _history!)
          notification.id == id
              ? notification.copyWith(read: true)
              : notification,
      ];
    });
  }

  void _markAllRead() {
    HapticFeedback.selectionClick();
    setState(() {
      _history = [
        for (final notification in _history!) notification.copyWith(read: true),
      ];
    });
  }

  void _clearAll() {
    HapticFeedback.selectionClick();
    setState(() => _history = const []);
  }

  void _toggleSetting(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _settings = [
        for (final setting in _settings!)
          setting.id == id
              ? setting.copyWith(enabled: !setting.enabled)
              : setting,
      ];
    });
  }
}

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

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    required this.snapshot,
    required this.settings,
    required this.enabledCount,
    required this.onToggle,
  });

  final SavingsNotificationsSnapshot snapshot;
  final List<SavingsNotificationSettingDraft> settings;
  final int enabledCount;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsNotificationsPage.settingsListKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SettingsSummary(
          title: snapshot.settingsTitle,
          subtitle:
              '${snapshot.settingsSubtitle} Đang bật $enabledCount/${settings.length} loại thông báo.',
        ),
        const SizedBox(height: AppSpacing.x5),
        for (final priority in SavingsNotificationPriority.values) ...[
          _PrioritySection(
            priority: priority,
            settings: settings
                .where((setting) => setting.priority == priority)
                .toList(),
            onToggle: onToggle,
          ),
          if (priority != SavingsNotificationPriority.values.last)
            const SizedBox(height: AppSpacing.x5),
        ],
        const SizedBox(height: AppSpacing.x5),
        _Disclaimer(text: snapshot.disclaimer),
      ],
    );
  }
}

class _SettingsSummary extends StatelessWidget {
  const _SettingsSummary({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20, width: 1.5),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.baseMedium),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrioritySection extends StatelessWidget {
  const _PrioritySection({
    required this.priority,
    required this.settings,
    required this.onToggle,
  });

  final SavingsNotificationPriority priority;
  final List<SavingsNotificationSettingDraft> settings;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    if (settings.isEmpty) return const SizedBox.shrink();
    final color = _priorityColor(priority);
    return VitPageSection(
      label: _priorityLabel(priority),
      accentColor: color,
      children: [
        Column(
          children: [
            for (final setting in settings) ...[
              _SettingCard(
                key: SavingsNotificationsPage.settingKey(setting.id),
                setting: setting,
                color: color,
                onToggle: () => onToggle(setting.id),
              ),
              if (setting != settings.last)
                const SizedBox(height: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    super.key,
    required this.setting,
    required this.color,
    required this.onToggle,
  });

  final SavingsNotificationSettingDraft setting;
  final Color color;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      onTap: onToggle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _settingsIcon(setting.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setting.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  setting.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _ToggleSwitch(on: setting.enabled, onTap: onToggle),
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({required this.on, required this.onTap});

  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: on,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: 24,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: on ? AppColors.primary : AppColors.borderSolid,
            borderRadius: AppRadii.mdRadius,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
            child: const SizedBox(
              width: 16,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.onAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClearAllButton extends StatelessWidget {
  const _ClearAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.sell10,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        key: SavingsNotificationsPage.clearAllButtonKey,
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.sell20),
            borderRadius: AppRadii.lgRadius,
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.sell,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Xóa tất cả thông báo',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x7,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text('Chưa có thông báo', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Thông báo về tiết kiệm sẽ hiển thị tại đây',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.x1),
      child: SizedBox(
        width: AppSpacing.x2,
        height: AppSpacing.x2,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

Color _notificationColor(SavingsNotificationType type) {
  return switch (type) {
    SavingsNotificationType.maturity => AppColors.warn,
    SavingsNotificationType.apy => AppColors.buy,
    SavingsNotificationType.interest => AppColors.primary,
    SavingsNotificationType.compound => AppColors.accent,
    SavingsNotificationType.product => AppColors.primarySoft,
    SavingsNotificationType.system => AppColors.text3,
  };
}

Color _notificationFill(SavingsNotificationType type) {
  return switch (type) {
    SavingsNotificationType.maturity => AppColors.warn10,
    SavingsNotificationType.apy => AppColors.buy10,
    SavingsNotificationType.interest => AppColors.primary08,
    SavingsNotificationType.compound => AppColors.accent08,
    SavingsNotificationType.product => AppColors.primary08,
    SavingsNotificationType.system => AppColors.surface2,
  };
}

IconData _notificationIcon(SavingsNotificationType type) {
  return switch (type) {
    SavingsNotificationType.maturity => Icons.calendar_today_outlined,
    SavingsNotificationType.apy => Icons.trending_up_rounded,
    SavingsNotificationType.interest => Icons.savings_outlined,
    SavingsNotificationType.compound => Icons.bolt_rounded,
    SavingsNotificationType.product => Icons.notifications_none_rounded,
    SavingsNotificationType.system => Icons.settings_outlined,
  };
}

Color _priorityColor(SavingsNotificationPriority priority) {
  return switch (priority) {
    SavingsNotificationPriority.high => AppColors.sell,
    SavingsNotificationPriority.medium => AppColors.primary,
    SavingsNotificationPriority.low => AppColors.text3,
  };
}

String _priorityLabel(SavingsNotificationPriority priority) {
  return switch (priority) {
    SavingsNotificationPriority.high => 'Quan trọng',
    SavingsNotificationPriority.medium => 'Trung bình',
    SavingsNotificationPriority.low => 'Phụ',
  };
}

IconData _settingsIcon(String iconKey) {
  return switch (iconKey) {
    'calendar' => Icons.calendar_today_outlined,
    'trend' => Icons.trending_up_rounded,
    'piggy' => Icons.savings_outlined,
    'zap' => Icons.bolt_rounded,
    'bell' => Icons.notifications_none_rounded,
    'alert' => Icons.warning_amber_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.notifications_none_rounded,
  };
}
