import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_notification_preferences_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_notification_preferences_delivery.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_notification_preferences_events.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_notification_preferences_summary.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

class SavingsNotificationPreferencesPage extends ConsumerStatefulWidget {
  const SavingsNotificationPreferencesPage({super.key, this.shellRenderMode});

  static const summaryKey = SavingsNotificationPreferencesKeys.summary;
  static const statsKey = SavingsNotificationPreferencesKeys.stats;
  static const eventsListKey = SavingsNotificationPreferencesKeys.eventsList;
  static const productsListKey =
      SavingsNotificationPreferencesKeys.productsList;
  static const deliveryListKey =
      SavingsNotificationPreferencesKeys.deliveryList;
  static const masterToggleKey =
      SavingsNotificationPreferencesKeys.masterToggle;

  static Key alertKey(String id) =>
      SavingsNotificationPreferencesKeys.alert(id);
  static Key productKey(String id) =>
      SavingsNotificationPreferencesKeys.product(id);
  static Key channelKey(String id) =>
      SavingsNotificationPreferencesKeys.channel(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsNotificationPreferencesPage> createState() =>
      _SavingsNotificationPreferencesPageState();
}

class _SavingsNotificationPreferencesPageState
    extends ConsumerState<SavingsNotificationPreferencesPage> {
  String? _tab;
  bool? _masterEnabled;
  late List<SavingsNotificationAlertDraft> _alerts;
  late List<SavingsDeliveryChannelDraft> _channels;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(savingsNotificationPreferencesRepositoryProvider)
        .getPreferences();
    _alerts = snapshot.alerts;
    _channels = snapshot.channels;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsNotificationPreferencesRepositoryProvider)
        .getPreferences();
    final activeTab = _tab ?? snapshot.defaultTab;
    final masterEnabled = _masterEnabled ?? snapshot.masterEnabled;
    final enabledAlerts = _alerts.where((item) => item.enabled).length;
    final enabledChannels = _channels.where((item) => item.enabled).length;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-345 SavingsNotificationPreferencesPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      VitCard(
                        variant: VitCardVariant.standard,
                        radius: VitCardRadius.md,
                        padding: AppSpacing.zeroInsets,
                        child: SavingsNotificationMasterSummaryCard(
                          masterEnabled: masterEnabled,
                          enabledAlerts: enabledAlerts,
                          totalAlerts: _alerts.length,
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _masterEnabled = value;
                              if (!value) {
                                _alerts = [
                                  for (final alert in _alerts)
                                    SavingsNotificationAlertDraft(
                                      id: alert.id,
                                      title: alert.title,
                                      description: alert.description,
                                      iconKey: alert.iconKey,
                                      enabled: false,
                                      category: alert.category,
                                      severity: alert.severity,
                                    ),
                                ];
                              }
                            });
                          },
                        ),
                      ),
                      SavingsNotificationQuickStats(
                        enabledChannels: enabledChannels,
                        totalChannels: _channels.length,
                        digestFrequency: snapshot.digestFrequency,
                        quietHours: snapshot.quietHours,
                      ),
                      SavingsNotificationTabs(
                        tabs: snapshot.tabs,
                        active: activeTab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (activeTab == 'events')
                        SavingsNotificationEventsTab(
                          alerts: _alerts,
                          masterEnabled: masterEnabled,
                          onToggle: _toggleAlert,
                        )
                      else if (activeTab == 'products')
                        SavingsNotificationProductsTab(
                          products: snapshot.productAlerts,
                        )
                      else
                        SavingsNotificationDeliveryTab(
                          channels: _channels,
                          digestFrequency: snapshot.digestFrequency,
                          quietHours: snapshot.quietHours,
                          onToggle: _toggleChannel,
                        ),
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

  void _toggleAlert(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _alerts = [
        for (final alert in _alerts)
          alert.id == id
              ? SavingsNotificationAlertDraft(
                  id: alert.id,
                  title: alert.title,
                  description: alert.description,
                  iconKey: alert.iconKey,
                  enabled: !alert.enabled,
                  category: alert.category,
                  severity: alert.severity,
                )
              : alert,
      ];
    });
  }

  void _toggleChannel(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _channels = [
        for (final channel in _channels)
          channel.id == id && !channel.locked
              ? SavingsDeliveryChannelDraft(
                  id: channel.id,
                  label: channel.label,
                  detail: channel.detail,
                  iconKey: channel.iconKey,
                  enabled: !channel.enabled,
                  locked: channel.locked,
                )
              : channel,
      ];
    });
  }
}
