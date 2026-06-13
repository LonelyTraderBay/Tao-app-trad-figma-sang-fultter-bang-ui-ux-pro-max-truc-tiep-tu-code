part of 'launchpad_webhooks_page.dart';

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
            size: AppSpacing.launchpadIconLg,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Webhooks gui HTTP POST den URL cua ban moi khi event xay ra tren blockchain. Dam bao endpoint co the xu ly payload va tra ve 2xx status code.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
