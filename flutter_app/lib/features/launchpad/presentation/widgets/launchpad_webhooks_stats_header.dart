part of '../pages/launchpad_webhooks_page.dart';

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
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: color.withValues(alpha: .22),
      background: ColoredBox(color: color.withValues(alpha: .08)),
      padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: _launchpadWebhooksLineHeightTight,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.chartLabelXs.copyWith(
              color: AppColors.text3,
              height: _launchpadWebhooksLineHeightShort,
            ),
          ),
        ],
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
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: activeTab.name,
      tabs: const [
        VitTabItem(
          key: 'subscriptions',
          label: 'subscriptions',
          widgetKey: LaunchpadWebhooksPage.subscriptionsTabKey,
        ),
        VitTabItem(
          key: 'deliveries',
          label: 'deliveries',
          widgetKey: LaunchpadWebhooksPage.deliveriesTabKey,
        ),
      ],
      onChanged: (key) => onChanged(_WebhookTab.values.byName(key)),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: LaunchpadWebhooksPage.infoKey,
      decoration: const ShapeDecoration(
        color: AppColors.accent06,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.accent20),
        ),
      ),
      child: Padding(
        padding: _launchpadWebhooksCompactCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.accent,
              size: _launchpadWebhooksIconLg,
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
      ),
    );
  }
}
