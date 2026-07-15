import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

import 'package:vit_trade_flutter/features/earn/presentation/widgets/hub/earn_custody_risk_banner.dart';

part '../../widgets/savings/savings_notifications_history.dart';
part '../../widgets/savings/savings_notifications_settings.dart';
part '../../widgets/savings/savings_notifications_common.dart';

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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: kSavingsToolsHeaderSubtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  physics: const ClampingScrollPhysics(),
                  padding: EarnSpacingTokens.earnBottomInsetPadding(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
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
                      const SavingsToolsYieldFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
