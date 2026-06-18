part of 'launchpad_webhooks_page.dart';

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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: AppSpacing.launchpadDividerHeight,
            color: AppColors.divider,
          ),
          Padding(
            padding: AppSpacing.launchpadPaddingX3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Events',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final type in subscription.eventTypes)
                      _MiniPill(
                        label: type,
                        color: _eventColor(type, eventTypes),
                      ),
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
                        label:
                            subscription.status == LaunchpadWebhookStatus.active
                            ? 'Pause'
                            : 'Resume',
                        icon:
                            subscription.status == LaunchpadWebhookStatus.active
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color:
                            subscription.status == LaunchpadWebhookStatus.active
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
        ],
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
          Column(
            children: [
              Padding(
                padding: AppSpacing.launchpadVerticalPaddingX2,
                child: Row(
                  children: [
                    Text(
                      row.label,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        row.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style:
                            (row.copyValue == null
                                    ? AppTextStyles.micro
                                    : AppTextStyles.monoCode)
                                .copyWith(
                                  color: row.danger
                                      ? AppColors.sell
                                      : AppColors.text1,
                                  fontWeight: AppTextStyles.medium,
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
              const Divider(
                height: AppSpacing.launchpadDividerHeight,
                color: AppColors.divider,
              ),
            ],
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
    return KeyedSubtree(
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
      padding: AppSpacing.launchpadPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.launchpadBox30,
            height: AppSpacing.launchpadBox30,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: eventColor.withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Icon(
                Icons.bolt_rounded,
                color: eventColor,
                size: AppSpacing.launchpadIconLg,
              ),
            ),
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
                      style: AppTextStyles.captionSm.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
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
                      ),
                    ),
                    if (delivery.statusCode != null)
                      Text(
                        delivery.statusCode.toString(),
                        style: AppTextStyles.numericMicro.copyWith(
                          color: delivery.statusCode! < 300
                              ? AppColors.buy
                              : AppColors.sell,
                        ),
                      ),
                    if (delivery.responseTime != null)
                      Text(
                        '${delivery.responseTime}ms',
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text3,
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
                          style: AppTextStyles.monoCode.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      _CopyButton(
                        key: LaunchpadWebhooksPage.deliveryCopyKey(delivery.id),
                        active: copiedField == delivery.id,
                        size: AppSpacing.launchpadIcon2xl,
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
