import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/launchpad_repository.dart';

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
      ref.read(launchpadRepositoryProvider).getWebhooks().subscriptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getWebhooks();
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
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    AppSpacing.x2,
                  ),
                  child: _StatsGrid(
                    key: LaunchpadWebhooksPage.statsKey,
                    stats: stats,
                  ),
                ),
                Container(
                  key: LaunchpadWebhooksPage.tabsKey,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.divider),
                      bottom: BorderSide(color: AppColors.divider),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.contentPad,
                  ),
                  child: _WebhookTabs(
                    activeTab: _activeTab,
                    onChanged: (tab) => setState(() => _activeTab = tab),
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
                      padding: EdgeInsets.only(bottom: bottomInset),
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

final class _WebhookStats {
  const _WebhookStats({
    required this.total,
    required this.active,
    required this.errors,
    required this.delivered,
  });

  factory _WebhookStats.from(
    List<LaunchpadWebhookSubscriptionDraft> subscriptions,
    List<LaunchpadWebhookDeliveryDraft> deliveries,
  ) {
    return _WebhookStats(
      total: subscriptions.length,
      active: subscriptions
          .where((sub) => sub.status == LaunchpadWebhookStatus.active)
          .length,
      errors: subscriptions
          .where((sub) => sub.status == LaunchpadWebhookStatus.error)
          .length,
      delivered: deliveries
          .where(
            (delivery) =>
                delivery.status == LaunchpadWebhookDeliveryStatus.delivered,
          )
          .length,
    );
  }

  final int total;
  final int active;
  final int errors;
  final int delivered;
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({super.key, required this.stats});

  final _WebhookStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'Tong',
            value: stats.total.toString(),
            color: AppModuleAccents.launchpad,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _StatTile(
            label: 'Active',
            value: stats.active.toString(),
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _StatTile(
            label: 'Errors',
            value: stats.errors.toString(),
            color: AppColors.sell,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _StatTile(
            label: 'Delivered',
            value: stats.delivered.toString(),
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.base.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: 1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 9,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebhookTabs extends StatelessWidget {
  const _WebhookTabs({required this.activeTab, required this.onChanged});

  final _WebhookTab activeTab;
  final ValueChanged<_WebhookTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _UnderlineTabButton(
          key: LaunchpadWebhooksPage.subscriptionsTabKey,
          label: 'subscriptions',
          active: activeTab == _WebhookTab.subscriptions,
          onTap: () => onChanged(_WebhookTab.subscriptions),
        ),
        _UnderlineTabButton(
          key: LaunchpadWebhooksPage.deliveriesTabKey,
          label: 'deliveries',
          active: activeTab == _WebhookTab.deliveries,
          onTap: () => onChanged(_WebhookTab.deliveries),
        ),
      ],
    );
  }
}

class _UnderlineTabButton extends StatelessWidget {
  const _UnderlineTabButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? AppColors.primary : AppColors.text3,
                    fontWeight: active
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: active ? 132 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateWebhookCard extends StatelessWidget {
  const _CreateWebhookCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadWebhooksPage.createKey,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.accent30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.accent15,
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(Icons.add_rounded, color: AppColors.accent),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tao webhook moi',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Dang ky nhan event tu smart contract',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionsSection extends StatelessWidget {
  const _SubscriptionsSection({
    required this.subscriptions,
    required this.eventTypes,
    required this.expandedId,
    required this.copiedField,
    required this.onExpand,
    required this.onCopy,
    required this.onToggle,
    required this.onDelete,
  });

  final List<LaunchpadWebhookSubscriptionDraft> subscriptions;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String? expandedId;
  final String? copiedField;
  final ValueChanged<String> onExpand;
  final void Function(String value, String field) onCopy;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadWebhooksPage.subscriptionsKey,
      child: subscriptions.isEmpty
          ? const _EmptySubscriptions()
          : VitPageSection(
              label: 'Active Subscriptions',
              accentColor: AppColors.buy,
              children: [
                for (final subscription in subscriptions)
                  _SubscriptionCard(
                    subscription: subscription,
                    eventTypes: eventTypes,
                    expanded: expandedId == subscription.id,
                    copiedField: copiedField,
                    onExpand: () => onExpand(subscription.id),
                    onCopy: onCopy,
                    onToggle: () => onToggle(subscription.id),
                    onDelete: () => onDelete(subscription.id),
                  ),
              ],
            ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.eventTypes,
    required this.expanded,
    required this.copiedField,
    required this.onExpand,
    required this.onCopy,
    required this.onToggle,
    required this.onDelete,
  });

  final LaunchpadWebhookSubscriptionDraft subscription;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final bool expanded;
  final String? copiedField;
  final VoidCallback onExpand;
  final void Function(String value, String field) onCopy;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(subscription.status);

    return VitCard(
      key: LaunchpadWebhooksPage.subscriptionKey(subscription.id),
      clip: true,
      borderColor: expanded
          ? statusColor.withValues(alpha: .42)
          : AppColors.cardBorder,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: statusColor),
            Expanded(
              child: Column(
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      key: LaunchpadWebhooksPage.expandKey(subscription.id),
                      onTap: onExpand,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.x3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ChainIcon(subscription: subscription),
                            const SizedBox(width: AppSpacing.x3),
                            Expanded(child: _SubscriptionSummary(subscription)),
                            Icon(
                              expanded
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              color: AppColors.text3,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (expanded)
                    _SubscriptionExpanded(
                      subscription: subscription,
                      eventTypes: eventTypes,
                      copiedField: copiedField,
                      onCopy: onCopy,
                      onToggle: onToggle,
                      onDelete: onDelete,
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

class _SubscriptionSummary extends StatelessWidget {
  const _SubscriptionSummary(this.subscription);

  final LaunchpadWebhookSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              subscription.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            _StatusPill(
              label: _statusLabel(subscription.status),
              color: _statusColor(subscription.status),
              icon: _statusIcon(subscription.status),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _MiniPill(label: subscription.chain, color: subscription.accent),
            Text(
              '${subscription.eventTypes.length} events',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1.2,
              ),
            ),
            Text(
              '${subscription.triggerCount} triggers',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChainIcon extends StatelessWidget {
  const _ChainIcon({required this.subscription});

  final LaunchpadWebhookSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: subscription.accent.withValues(alpha: .15),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(Icons.hub_outlined, color: subscription.accent, size: 18),
    );
  }
}

class _SubscriptionExpanded extends StatelessWidget {
  const _SubscriptionExpanded({
    required this.subscription,
    required this.eventTypes,
    required this.copiedField,
    required this.onCopy,
    required this.onToggle,
    required this.onDelete,
  });

  final LaunchpadWebhookSubscriptionDraft subscription;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String? copiedField;
  final void Function(String value, String field) onCopy;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x3,
          AppSpacing.x3,
          AppSpacing.x3,
          AppSpacing.x3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Events',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 9,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                for (final type in subscription.eventTypes)
                  _MiniPill(label: type, color: _eventColor(type, eventTypes)),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            _MetadataRows(
              rows: [
                _MetadataRowDraft(
                  label: 'URL',
                  value: subscription.webhookUrl,
                  copyValue: subscription.webhookUrl,
                ),
                _MetadataRowDraft(
                  label: 'Contract',
                  value: subscription.maskedContract,
                  copyValue: subscription.contractAddress,
                ),
                _MetadataRowDraft(
                  label: 'Retry',
                  value:
                      '${_retryLabel(subscription.retryPolicy)} (max ${subscription.maxRetries})',
                ),
                _MetadataRowDraft(
                  label: 'Created',
                  value: subscription.createdAt,
                ),
                if (subscription.lastTriggered != null)
                  _MetadataRowDraft(
                    label: 'Last triggered',
                    value: subscription.lastTriggered!,
                  ),
                if (subscription.lastError != null)
                  _MetadataRowDraft(
                    label: 'Last error',
                    value: subscription.lastError!,
                    danger: true,
                  ),
              ],
              copiedField: copiedField,
              subscriptionId: subscription.id,
              onCopy: onCopy,
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(
                  child: _SmallActionButton(
                    key: LaunchpadWebhooksPage.toggleKey(subscription.id),
                    label: subscription.status == LaunchpadWebhookStatus.active
                        ? 'Pause'
                        : 'Resume',
                    icon: subscription.status == LaunchpadWebhookStatus.active
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: subscription.status == LaunchpadWebhookStatus.active
                        ? AppColors.warn
                        : AppColors.buy,
                    onTap: onToggle,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                _SmallActionButton(
                  key: LaunchpadWebhooksPage.deleteKey(subscription.id),
                  label: 'Xoa',
                  icon: Icons.delete_outline_rounded,
                  color: AppColors.sell,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataRows extends StatelessWidget {
  const _MetadataRows({
    required this.rows,
    required this.copiedField,
    required this.subscriptionId,
    required this.onCopy,
  });

  final List<_MetadataRowDraft> rows;
  final String? copiedField;
  final String subscriptionId;
  final void Function(String value, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in rows)
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
              child: Row(
                children: [
                  Text(
                    row.label,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      row.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.micro.copyWith(
                        color: row.danger ? AppColors.sell : AppColors.text1,
                        fontWeight: AppTextStyles.medium,
                        fontFamily: row.copyValue == null ? null : 'monospace',
                      ),
                    ),
                  ),
                  if (row.copyValue != null) ...[
                    const SizedBox(width: AppSpacing.x2),
                    _CopyButton(
                      key: LaunchpadWebhooksPage.copyKey(
                        subscriptionId,
                        row.label,
                      ),
                      active: copiedField == '${subscriptionId}_${row.label}',
                      onTap: () => onCopy(
                        row.copyValue!,
                        '${subscriptionId}_${row.label}',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

final class _MetadataRowDraft {
  const _MetadataRowDraft({
    required this.label,
    required this.value,
    this.copyValue,
    this.danger = false,
  });

  final String label;
  final String value;
  final String? copyValue;
  final bool danger;
}

class _DeliveriesSection extends StatelessWidget {
  const _DeliveriesSection({
    required this.deliveries,
    required this.eventTypes,
    required this.copiedField,
    required this.onCopy,
  });

  final List<LaunchpadWebhookDeliveryDraft> deliveries;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String? copiedField;
  final void Function(String value, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadWebhooksPage.deliveriesKey,
      child: VitPageSection(
        label: 'Delivery History',
        accentColor: AppColors.primary,
        children: [
          for (final delivery in deliveries)
            _DeliveryCard(
              delivery: delivery,
              eventTypes: eventTypes,
              copiedField: copiedField,
              onCopy: onCopy,
            ),
        ],
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({
    required this.delivery,
    required this.eventTypes,
    required this.copiedField,
    required this.onCopy,
  });

  final LaunchpadWebhookDeliveryDraft delivery;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String? copiedField;
  final void Function(String value, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    final eventColor = _eventColor(delivery.eventType, eventTypes);
    final deliveryColor = _deliveryStatusColor(delivery.status);

    return VitCard(
      key: LaunchpadWebhooksPage.deliveryKey(delivery.id),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: eventColor.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(Icons.bolt_rounded, color: eventColor, size: 15),
          ),
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
                      delivery.eventType,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontSize: 12,
                      ),
                    ),
                    _StatusPill(
                      label: _deliveryStatusLabel(delivery.status),
                      color: deliveryColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      delivery.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                      ),
                    ),
                    if (delivery.statusCode != null)
                      Text(
                        delivery.statusCode.toString(),
                        style: AppTextStyles.micro.copyWith(
                          color: delivery.statusCode! < 300
                              ? AppColors.buy
                              : AppColors.sell,
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                      ),
                    if (delivery.responseTime != null)
                      Text(
                        '${delivery.responseTime}ms',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
                if (delivery.txHash != null) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'tx: ${delivery.txHash}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontFamily: 'monospace',
                            fontSize: 9,
                          ),
                        ),
                      ),
                      _CopyButton(
                        key: LaunchpadWebhooksPage.deliveryCopyKey(delivery.id),
                        active: copiedField == delivery.id,
                        size: 18,
                        onTap: () => onCopy(delivery.txHash!, delivery.id),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateWebhookSheet extends StatefulWidget {
  const _CreateWebhookSheet({
    required this.eventTypes,
    required this.onClose,
    required this.onCreate,
  });

  final List<LaunchpadWebhookEventDraft> eventTypes;
  final VoidCallback onClose;
  final ValueChanged<LaunchpadWebhookSubscriptionDraft> onCreate;

  @override
  State<_CreateWebhookSheet> createState() => _CreateWebhookSheetState();
}

class _CreateWebhookSheetState extends State<_CreateWebhookSheet> {
  final _labelController = TextEditingController();
  final _urlController = TextEditingController();
  final _contractController = TextEditingController();
  final Set<String> _selectedEvents = {};
  var _chain = 'BSC';
  var _retryPolicy = LaunchpadWebhookRetryPolicy.exponential;

  @override
  void dispose() {
    _labelController.dispose();
    _urlController.dispose();
    _contractController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _labelController.text.trim().isNotEmpty &&
      _urlController.text.trim().isNotEmpty &&
      _contractController.text.trim().isNotEmpty &&
      _selectedEvents.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: LaunchpadWebhooksPage.createSheetKey,
      color: Colors.black.withValues(alpha: .72),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: DeviceMetrics.width),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.cardLarge),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x3,
                  AppSpacing.contentPad,
                  AppSpacing.x6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.borderSolid,
                          borderRadius: AppRadii.xsRadius,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tao Webhook moi',
                            style: AppTextStyles.base.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          key: LaunchpadWebhooksPage.createCloseKey,
                          onPressed: widget.onClose,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _SheetTextField(
                      label: 'Ten webhook',
                      hint: 'VD: Staking Monitor',
                      controller: _labelController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _SheetTextField(
                      label: 'Webhook URL',
                      hint: 'https://api.example.com/webhooks',
                      controller: _urlController,
                      monospace: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _SheetTextField(
                      label: 'Contract Address',
                      hint: '0x...',
                      controller: _contractController,
                      monospace: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _ChoiceGroup(
                      label: 'Chain',
                      items: const ['BSC', 'Ethereum', 'Polygon', 'Arbitrum'],
                      active: _chain,
                      colorFor: _chainColor,
                      onChanged: (value) => setState(() => _chain = value),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      'Events (${_selectedEvents.length})',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        for (final event in widget.eventTypes)
                          _SelectablePill(
                            key: LaunchpadWebhooksPage.eventKey(event.type),
                            label: event.label,
                            color: event.accent,
                            active: _selectedEvents.contains(event.type),
                            onTap: () => setState(() {
                              if (!_selectedEvents.add(event.type)) {
                                _selectedEvents.remove(event.type);
                              }
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _ChoiceGroup(
                      label: 'Retry Policy',
                      items: const ['none', 'linear', 'exponential'],
                      active: _retryLabel(_retryPolicy),
                      colorFor: (_) => AppColors.primary,
                      onChanged: (value) => setState(() {
                        _retryPolicy = switch (value) {
                          'none' => LaunchpadWebhookRetryPolicy.none,
                          'linear' => LaunchpadWebhookRetryPolicy.linear,
                          _ => LaunchpadWebhookRetryPolicy.exponential,
                        };
                      }),
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    VitCtaButton(
                      key: LaunchpadWebhooksPage.createSubmitKey,
                      onPressed: _canSubmit ? _submit : null,
                      child: const Text('Tao Webhook'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final now = DateTime.now().millisecondsSinceEpoch;
    widget.onCreate(
      LaunchpadWebhookSubscriptionDraft(
        id: 'wh_new_$now',
        label: _labelController.text.trim(),
        contractAddress: _contractController.text.trim(),
        chain: _chain,
        accent: _chainColor(_chain),
        eventTypes: _selectedEvents.toList(),
        webhookUrl: _urlController.text.trim(),
        status: LaunchpadWebhookStatus.pending,
        createdAt: 'Hom nay',
        triggerCount: 0,
        errorCount: 0,
        filters: const [],
        retryPolicy: _retryPolicy,
        maxRetries: _retryPolicy == LaunchpadWebhookRetryPolicy.none ? 0 : 3,
      ),
    );
  }
}

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.monospace = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFamily: monospace ? 'monospace' : null,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontFamily: monospace ? 'monospace' : null,
            ),
            filled: true,
            fillColor: AppColors.surface2,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x3,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderSolid),
              borderRadius: AppRadii.inputRadius,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: AppRadii.inputRadius,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceGroup extends StatelessWidget {
  const _ChoiceGroup({
    required this.label,
    required this.items,
    required this.active,
    required this.colorFor,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final String active;
  final Color Function(String value) colorFor;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final item in items) ...[
                _SelectablePill(
                  label: item,
                  color: colorFor(item),
                  active: active == item,
                  onTap: () => onChanged(item),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectablePill extends StatelessWidget {
  const _SelectablePill({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: active ? color.withValues(alpha: .14) : AppColors.surface2,
            border: Border.all(
              color: active
                  ? color.withValues(alpha: .34)
                  : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: active ? color : AppColors.text3,
              fontWeight: AppTextStyles.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .11),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 9),
              const SizedBox(width: 3),
            ],
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 9,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    super.key,
    required this.active,
    required this.onTap,
    this.size = 22,
  });

  final bool active;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      padding: EdgeInsets.zero,
      onPressed: onTap,
      icon: Icon(
        active ? Icons.check_rounded : Icons.copy_rounded,
        color: active ? AppColors.buy : AppColors.text3,
        size: size * .55,
      ),
    );
  }
}

class _EmptySubscriptions extends StatelessWidget {
  const _EmptySubscriptions();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(Icons.hub_outlined, color: AppColors.text3, size: 32),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chua co webhook nao',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Tao webhook de nhan thong bao event tu contract',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadWebhooksPage.infoKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.accent06,
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.accent,
            size: 15,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Webhooks gui HTTP POST den URL cua ban moi khi event xay ra tren blockchain. Dam bao endpoint co the xu ly payload va tra ve 2xx status code.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _statusLabel(LaunchpadWebhookStatus status) {
  return switch (status) {
    LaunchpadWebhookStatus.active => 'Active',
    LaunchpadWebhookStatus.paused => 'Paused',
    LaunchpadWebhookStatus.error => 'Error',
    LaunchpadWebhookStatus.pending => 'Pending',
  };
}

Color _statusColor(LaunchpadWebhookStatus status) {
  return switch (status) {
    LaunchpadWebhookStatus.active => AppColors.buy,
    LaunchpadWebhookStatus.paused => AppColors.warn,
    LaunchpadWebhookStatus.error => AppColors.sell,
    LaunchpadWebhookStatus.pending => AppColors.text3,
  };
}

IconData _statusIcon(LaunchpadWebhookStatus status) {
  return switch (status) {
    LaunchpadWebhookStatus.active => Icons.check_circle_outline_rounded,
    LaunchpadWebhookStatus.paused => Icons.pause_circle_outline_rounded,
    LaunchpadWebhookStatus.error => Icons.error_outline_rounded,
    LaunchpadWebhookStatus.pending => Icons.schedule_rounded,
  };
}

String _deliveryStatusLabel(LaunchpadWebhookDeliveryStatus status) {
  return switch (status) {
    LaunchpadWebhookDeliveryStatus.delivered => 'Delivered',
    LaunchpadWebhookDeliveryStatus.failed => 'Failed',
    LaunchpadWebhookDeliveryStatus.retrying => 'Retrying',
    LaunchpadWebhookDeliveryStatus.pending => 'Pending',
  };
}

Color _deliveryStatusColor(LaunchpadWebhookDeliveryStatus status) {
  return switch (status) {
    LaunchpadWebhookDeliveryStatus.delivered => AppColors.buy,
    LaunchpadWebhookDeliveryStatus.failed => AppColors.sell,
    LaunchpadWebhookDeliveryStatus.retrying => AppColors.warn,
    LaunchpadWebhookDeliveryStatus.pending => AppColors.text3,
  };
}

String _retryLabel(LaunchpadWebhookRetryPolicy retryPolicy) {
  return switch (retryPolicy) {
    LaunchpadWebhookRetryPolicy.none => 'none',
    LaunchpadWebhookRetryPolicy.linear => 'linear',
    LaunchpadWebhookRetryPolicy.exponential => 'exponential',
  };
}

Color _eventColor(String type, List<LaunchpadWebhookEventDraft> eventTypes) {
  for (final event in eventTypes) {
    if (event.type == type) return event.accent;
  }
  return AppColors.text3;
}

Color _chainColor(String value) {
  return switch (value) {
    'BSC' => AppColors.warn,
    'Ethereum' => AppColors.primary,
    'Polygon' => AppColors.accent,
    'Arbitrum' => AppColors.primarySoft,
    _ => AppColors.text3,
  };
}
