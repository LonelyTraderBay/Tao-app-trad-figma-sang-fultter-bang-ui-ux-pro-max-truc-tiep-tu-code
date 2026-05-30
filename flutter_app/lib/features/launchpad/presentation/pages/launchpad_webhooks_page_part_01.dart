part of 'launchpad_webhooks_page.dart';

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
