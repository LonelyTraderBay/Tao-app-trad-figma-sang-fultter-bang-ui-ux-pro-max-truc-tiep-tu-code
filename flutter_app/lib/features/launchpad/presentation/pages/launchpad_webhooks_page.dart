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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

part 'launchpad_webhooks_page_part_01.dart';
part 'launchpad_webhooks_page_part_02.dart';
part 'launchpad_webhooks_page_part_03.dart';
part 'launchpad_webhooks_page_part_04.dart';
part '../widgets/launchpad_webhooks_sheet_state.dart';
part '../widgets/launchpad_webhooks_form_controls.dart';
part '../widgets/launchpad_webhooks_common_widgets.dart';

enum _WebhookTab { subscriptions, deliveries }

class LaunchpadWebhooksPage extends ConsumerStatefulWidget {
  const LaunchpadWebhooksPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc310_launchpad_webhooks_content');
  static const statsKey = Key('sc310_launchpad_webhooks_stats');
  static const tabsKey = Key('sc310_launchpad_webhooks_tabs');
  static const subscriptionsTabKey = Key('sc310_launchpad_webhooks_tab_subs');
  static const deliveriesTabKey = Key(
    'sc310_launchpad_webhooks_tab_deliveries',
  );
  static const createKey = Key('sc310_launchpad_webhooks_create');
  static const subscriptionsKey = Key('sc310_launchpad_webhooks_subs');
  static const deliveriesKey = Key('sc310_launchpad_webhooks_deliveries');
  static const infoKey = Key('sc310_launchpad_webhooks_info');
  static const createSheetKey = Key('sc310_launchpad_webhooks_create_sheet');
  static const createSubmitKey = Key('sc310_launchpad_webhooks_submit');
  static const createCloseKey = Key('sc310_launchpad_webhooks_close');

  static Key subscriptionKey(String id) =>
      Key('sc310_launchpad_webhooks_subscription_$id');
  static Key expandKey(String id) => Key('sc310_launchpad_webhooks_expand_$id');
  static Key toggleKey(String id) => Key('sc310_launchpad_webhooks_toggle_$id');
  static Key deleteKey(String id) => Key('sc310_launchpad_webhooks_delete_$id');
  static Key copyKey(String id, String field) =>
      Key('sc310_launchpad_webhooks_copy_${id}_$field');
  static Key deliveryKey(String id) =>
      Key('sc310_launchpad_webhooks_delivery_$id');
  static Key deliveryCopyKey(String id) =>
      Key('sc310_launchpad_webhooks_delivery_copy_$id');
  static Key eventKey(String type) =>
      Key('sc310_launchpad_webhooks_event_$type');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadWebhooksPage> createState() =>
      _LaunchpadWebhooksPageState();
}

class _LaunchpadWebhooksPageState extends ConsumerState<LaunchpadWebhooksPage> {
  late List<LaunchpadWebhookSubscriptionDraft> _subscriptions;
  var _activeTab = _WebhookTab.subscriptions;
  var _showCreateSheet = false;
  String? _expandedId;
  String? _copiedField;

  @override
  void initState() {
    super.initState();
    _subscriptions = List.of(
      ref.read(launchpadControllerProvider).getWebhooks().subscriptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getWebhooks();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final stats = _WebhookStats.from(_subscriptions, snapshot.deliveries);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-310 LaunchpadWebhooksPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              bottomInset: bottomInset,
              semanticLabel: 'SC-310 LaunchpadWebhooksPage scroll surface',
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: AppSpacing.launchpadHeaderStatsPadding,
                    child: _StatsGrid(
                      key: LaunchpadWebhooksPage.statsKey,
                      stats: stats,
                    ),
                  ),
                  ColoredBox(
                    key: LaunchpadWebhooksPage.tabsKey,
                    color: AppColors.surface,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(
                          height: AppSpacing.launchpadDividerHeight,
                          color: AppColors.divider,
                        ),
                        Padding(
                          padding: AppSpacing.launchpadHorizontalContentPadding,
                          child: _WebhookTabs(
                            activeTab: _activeTab,
                            onChanged: (tab) =>
                                setState(() => _activeTab = tab),
                          ),
                        ),
                        const Divider(
                          height: AppSpacing.launchpadDividerHeight,
                          color: AppColors.divider,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: LaunchpadWebhooksPage.contentKey,
                        physics: const BouncingScrollPhysics(),
                        child: VitPageContent(
                          padding: VitContentPadding.defaultPadding,
                          customGap: AppSpacing.x4,
                          children: [
                            if (_activeTab == _WebhookTab.subscriptions) ...[
                              _CreateWebhookCard(
                                onTap: () =>
                                    setState(() => _showCreateSheet = true),
                              ),
                              _SubscriptionsSection(
                                subscriptions: _subscriptions,
                                eventTypes: snapshot.eventTypes,
                                expandedId: _expandedId,
                                copiedField: _copiedField,
                                onExpand: (id) => setState(() {
                                  _expandedId = _expandedId == id ? null : id;
                                }),
                                onCopy: _copyField,
                                onToggle: _toggleStatus,
                                onDelete: _deleteSubscription,
                              ),
                            ] else
                              _DeliveriesSection(
                                deliveries: snapshot.deliveries,
                                eventTypes: snapshot.eventTypes,
                                copiedField: _copiedField,
                                onCopy: _copyField,
                              ),
                            const _InfoBanner(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showCreateSheet)
              Positioned.fill(
                child: _CreateWebhookSheet(
                  eventTypes: snapshot.eventTypes,
                  onClose: () => setState(() => _showCreateSheet = false),
                  onCreate: _createSubscription,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _copyField(String value, String field) {
    Clipboard.setData(ClipboardData(text: value));
    setState(() => _copiedField = field);
  }

  void _toggleStatus(String id) {
    setState(() {
      _subscriptions = [
        for (final subscription in _subscriptions)
          if (subscription.id == id)
            subscription.copyWith(
              status: subscription.status == LaunchpadWebhookStatus.active
                  ? LaunchpadWebhookStatus.paused
                  : LaunchpadWebhookStatus.active,
            )
          else
            subscription,
      ];
    });
  }

  void _deleteSubscription(String id) {
    setState(() {
      _subscriptions = [
        for (final subscription in _subscriptions)
          if (subscription.id != id) subscription,
      ];
      if (_expandedId == id) {
        _expandedId = null;
      }
    });
  }

  void _createSubscription(LaunchpadWebhookSubscriptionDraft subscription) {
    setState(() {
      _subscriptions = [..._subscriptions, subscription];
      _showCreateSheet = false;
      _expandedId = subscription.id;
    });
  }
}
