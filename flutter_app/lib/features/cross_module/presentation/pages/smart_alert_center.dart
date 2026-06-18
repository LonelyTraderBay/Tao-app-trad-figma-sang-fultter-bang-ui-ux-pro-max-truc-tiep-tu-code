import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';

part '../widgets/smart_alert_center_tabs.dart';
part '../widgets/smart_alert_center_cards.dart';
part '../widgets/smart_alert_center_history_settings.dart';
part '../widgets/smart_alert_center_common.dart';

class SmartAlertCenter extends ConsumerStatefulWidget {
  const SmartAlertCenter({super.key, this.shellRenderMode});

  static const contentKey = Key('sc323_smart_alert_center_content');
  static const createButtonKey = Key('sc323_create_alert_button');
  static Key tabKey(SmartAlertTab tab) => Key('sc323_tab_${tab.name}');
  static Key channelKey(String channelId) => Key('sc323_channel_$channelId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SmartAlertCenter> createState() => _SmartAlertCenterState();
}

class _SmartAlertCenterState extends ConsumerState<SmartAlertCenter> {
  SmartAlertTab _activeTab = SmartAlertTab.active;
  final Map<String, bool> _channelOverrides = {};

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(smartAlertsControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-323 SmartAlertCenter',
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
              _SmartAlertTabs(
                tabs: snapshot.tabs,
                active: _activeTab,
                onChanged: (tab) {
                  HapticFeedback.selectionClick();
                  setState(() => _activeTab = tab);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: SmartAlertCenter.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.crossModuleScrollPadding(bottomInset),
                  child: VitPageContent(
                    gap: VitContentGap.defaultGap,
                    children: [
                      if (_activeTab == SmartAlertTab.active)
                        _ActiveAlertsTab(snapshot: snapshot)
                      else if (_activeTab == SmartAlertTab.history)
                        _AlertHistoryTab(snapshot: snapshot)
                      else
                        _AlertSettingsTab(
                          snapshot: snapshot,
                          isChannelEnabled: (channel) =>
                              _channelOverrides[channel.id] ?? channel.enabled,
                          onToggleChannel: (channel) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              final current =
                                  _channelOverrides[channel.id] ??
                                  channel.enabled;
                              _channelOverrides[channel.id] = !current;
                            });
                          },
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
}
