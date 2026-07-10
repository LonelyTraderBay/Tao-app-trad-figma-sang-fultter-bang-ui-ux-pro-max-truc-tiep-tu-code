import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/core/utils/accent_tone.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'launchpad_webhooks_page_part_01.dart';
part 'launchpad_webhooks_page_part_02.dart';
part 'launchpad_webhooks_page_part_03.dart';
part 'launchpad_webhooks_page_part_04.dart';
part '../widgets/launchpad_webhooks_sheet_state.dart';
part '../widgets/launchpad_webhooks_form_controls.dart';
part '../widgets/launchpad_webhooks_common_widgets.dart';

enum _WebhookTab { subscriptions, deliveries }

const double _launchpadWebhooksLineHeightTight = 1.0;
const double _launchpadWebhooksLineHeightShort = 1.2;
const double _launchpadWebhooksDividerHeight = AppSpacing.hairlineStroke;
const double _launchpadWebhooksMarkerWidth = AppSpacing.x1;
const double _launchpadWebhooksPrimaryIconBox = AppSpacing.inputHeight;
const double _launchpadWebhooksDeliveryIconBox = AppSpacing.x6;
const double _launchpadWebhooksIconLg = AppSpacing.iconSm;
const double _launchpadWebhooksIcon2xl = AppSpacing.iconMd;
const double _launchpadWebhooksEmptyIcon = AppSpacing.iconLg;
const double _launchpadWebhooksCopyButtonExtent = AppSpacing.x5;
const double _launchpadWebhooksActionButtonHeight =
    AppSpacing.buttonCompact + AppSpacing.x1;
const double _launchpadWebhooksSheetMaxWidth = 440;
const double _launchpadWebhooksSheetHandleWidth =
    AppSpacing.inputHeight - AppSpacing.x1;
const double _launchpadWebhooksSheetHandleHeight =
    AppSpacing.x1 + AppSpacing.hairlineStroke;
const EdgeInsetsGeometry _launchpadWebhooksHeaderStatsPadding =
    EdgeInsetsDirectional.fromSTEB(
      AppSpacing.contentPad,
      AppSpacing.x2,
      AppSpacing.contentPad,
      AppSpacing.x1,
    );
const EdgeInsetsGeometry _launchpadWebhooksCardPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x3,
    );
const EdgeInsetsGeometry _launchpadWebhooksCompactCardPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );
const EdgeInsetsGeometry _launchpadWebhooksSheetPadding =
    EdgeInsetsDirectional.fromSTEB(
      AppSpacing.contentPad,
      AppSpacing.x3,
      AppSpacing.contentPad,
      AppSpacing.x4,
    );

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
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;
    final stats = _WebhookStats.from(_subscriptions, snapshot.deliveries);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-310 LaunchpadWebhooksPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              semanticLabel: 'SC-310 LaunchpadWebhooksPage scroll surface',
              header: VitHeader(
                title: snapshot.title,
                subtitle: 'Webhook tích hợp · Chỉ dùng cho developer',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: _launchpadWebhooksHeaderStatsPadding,
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
                          height: _launchpadWebhooksDividerHeight,
                          color: AppColors.divider,
                        ),
                        Padding(
                          padding: LaunchpadSpacingTokens
                              .launchpadHorizontalContentPadding,
                          child: _WebhookTabs(
                            activeTab: _activeTab,
                            onChanged: (tab) =>
                                setState(() => _activeTab = tab),
                          ),
                        ),
                        const Divider(
                          height: _launchpadWebhooksDividerHeight,
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
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsetsDirectional.only(
                          bottom: scrollEndPadding,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.compact,
                          density: VitDensity.compact,
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
