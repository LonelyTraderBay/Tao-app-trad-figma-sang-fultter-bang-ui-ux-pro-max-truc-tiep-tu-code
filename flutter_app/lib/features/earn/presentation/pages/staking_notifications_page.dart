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

class StakingNotificationsPage extends ConsumerStatefulWidget {
  const StakingNotificationsPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc371_info_banner');
  static const settingsKey = Key('sc371_settings');
  static const channelsKey = Key('sc371_channels');
  static const historyKey = Key('sc371_history');
  static const markAllReadKey = Key('sc371_mark_all_read');
  static const dndKey = Key('sc371_dnd');
  static const footerKey = Key('sc371_footer');

  static Key settingKey(String id) => Key('sc371_setting_$id');

  static Key channelKey(String id) => Key('sc371_channel_$id');

  static Key notificationKey(String id) => Key('sc371_notification_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingNotificationsPage> createState() =>
      _StakingNotificationsPageState();
}

class _StakingNotificationsPageState
    extends ConsumerState<StakingNotificationsPage> {
  List<StakingNotificationSettingDraft>? _settings;
  List<StakingNotificationChannelDraft>? _channels;
  List<StakingNotificationHistoryDraft>? _history;
  bool _dndEnabled = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingNotificationsRepositoryProvider)
        .getNotifications();
    _settings ??= snapshot.settings;
    _channels ??= snapshot.channels;
    _history ??= snapshot.history;

    final history = _history!;
    final unreadCount = history
        .where((notification) => !notification.read)
        .length;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-371 StakingNotificationsPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _SettingsList(
                      settings: _settings!,
                      onToggle: _toggleSetting,
                    ),
                    _ChannelsList(
                      channels: _channels!,
                      onToggle: _toggleChannel,
                    ),
                    _HistoryList(
                      history: history,
                      unreadCount: unreadCount,
                      onMarkAllRead: _markAllRead,
                      onMarkRead: _markRead,
                    ),
                    _DoNotDisturbCard(
                      enabled: _dndEnabled,
                      onToggle: () {
                        HapticFeedback.selectionClick();
                        setState(() => _dndEnabled = !_dndEnabled);
                      },
                    ),
                    _FooterNote(text: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  void _toggleChannel(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _channels = [
        for (final channel in _channels!)
          channel.id == id
              ? channel.copyWith(enabled: !channel.enabled)
              : channel,
      ];
    });
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
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingNotificationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingNotificationsPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList({required this.settings, required this.onToggle});

  final List<StakingNotificationSettingDraft> settings;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingNotificationsPage.settingsKey,
      label: 'Cài đặt Thông báo',
      accentColor: AppColors.primarySoft,
      children: [
        Column(
          children: [
            for (final setting in settings) ...[
              _SettingCard(
                key: StakingNotificationsPage.settingKey(setting.id),
                setting: setting,
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
    required this.onToggle,
  });

  final StakingNotificationSettingDraft setting;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(setting.priority);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      setting.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (setting.priority == StakingNotificationPriority.high)
                      const _PriorityPill(),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  setting.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.45,
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

class _ChannelsList extends StatelessWidget {
  const _ChannelsList({required this.channels, required this.onToggle});

  final List<StakingNotificationChannelDraft> channels;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingNotificationsPage.channelsKey,
      label: 'Kênh nhận Thông báo',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (final channel in channels) ...[
                _ChannelRow(
                  key: StakingNotificationsPage.channelKey(channel.id),
                  channel: channel,
                  onToggle: () => onToggle(channel.id),
                ),
                if (channel != channels.last)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({super.key, required this.channel, required this.onToggle});

  final StakingNotificationChannelDraft channel;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            channel.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        _ToggleSwitch(on: channel.enabled, onTap: onToggle),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.history,
    required this.unreadCount,
    required this.onMarkAllRead,
    required this.onMarkRead,
  });

  final List<StakingNotificationHistoryDraft> history;
  final int unreadCount;
  final VoidCallback onMarkAllRead;
  final ValueChanged<String> onMarkRead;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingNotificationsPage.historyKey,
      label: 'Lịch sử ($unreadCount chưa đọc)',
      accentColor: AppColors.primarySoft,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${history.length} thông báo gần đây',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            if (unreadCount > 0)
              TextButton(
                key: StakingNotificationsPage.markAllReadKey,
                onPressed: onMarkAllRead,
                child: Text(
                  'Đánh dấu tất cả đã đọc',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.primarySoft,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Column(
          children: [
            for (final notification in history) ...[
              _NotificationCard(
                key: StakingNotificationsPage.notificationKey(notification.id),
                notification: notification,
                onTap: () => onMarkRead(notification.id),
              ),
              if (notification != history.last)
                const SizedBox(height: AppSpacing.x3),
            ],
          ],
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

  final StakingNotificationHistoryDraft notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _notificationColor(notification.type);
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: notification.read
          ? null
          : AppColors.primarySoft.withValues(alpha: 0.28),
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _notificationIcon(notification.type), color: color),
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
                        ),
                      ),
                    ),
                    if (!notification.read) const _UnreadDot(),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  notification.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  notification.time,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DoNotDisturbCard extends StatelessWidget {
  const _DoNotDisturbCard({required this.enabled, required this.onToggle});

  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingNotificationsPage.dndKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chế độ Không làm phiền', style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Tắt tất cả thông báo từ 22:00-07:00 (trừ High priority)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x3),
                _ToggleSwitch(on: enabled, onTap: onToggle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingNotificationsPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
          width: 48,
          height: 26,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: on ? AppColors.buy : AppColors.primary30,
            borderRadius: AppRadii.lgRadius,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
            child: const SizedBox(
              width: 18,
              height: 18,
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

class _PriorityPill extends StatelessWidget {
  const _PriorityPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.sell15,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          'Quan trọng',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.sell,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
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
        border: Border.all(color: color.withValues(alpha: 0.30)),
        borderRadius: AppRadii.lgRadius,
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
      padding: EdgeInsets.only(left: AppSpacing.x2, top: AppSpacing.x1),
      child: SizedBox(
        width: AppSpacing.x2,
        height: AppSpacing.x2,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

Color _priorityColor(StakingNotificationPriority priority) {
  return switch (priority) {
    StakingNotificationPriority.high => AppColors.sell,
    StakingNotificationPriority.medium => AppColors.primarySoft,
    StakingNotificationPriority.low => AppColors.text3,
  };
}

IconData _settingsIcon(String iconKey) {
  return switch (iconKey) {
    'calendar' => Icons.calendar_today_outlined,
    'trend' => Icons.trending_up_rounded,
    'reward' => Icons.attach_money_rounded,
    'zap' => Icons.bolt_rounded,
    'alert' => Icons.warning_amber_rounded,
    'clock' => Icons.schedule_rounded,
    _ => Icons.notifications_none_rounded,
  };
}

Color _notificationColor(StakingNotificationType type) {
  return switch (type) {
    StakingNotificationType.maturity => AppColors.primarySoft,
    StakingNotificationType.apyChange => AppColors.buy,
    StakingNotificationType.reward => AppColors.buy,
    StakingNotificationType.risk => AppColors.sell,
    StakingNotificationType.system => AppColors.primarySoft,
  };
}

IconData _notificationIcon(StakingNotificationType type) {
  return switch (type) {
    StakingNotificationType.maturity => Icons.calendar_today_outlined,
    StakingNotificationType.apyChange => Icons.trending_up_rounded,
    StakingNotificationType.reward => Icons.attach_money_rounded,
    StakingNotificationType.risk => Icons.warning_amber_rounded,
    StakingNotificationType.system => Icons.bolt_rounded,
  };
}
