part of '../pages/launchpad_portfolio_page.dart';

class _PortfolioHero extends StatelessWidget {
  const _PortfolioHero({required this.subscriptions});

  final List<LaunchpadSubscriptionDraft> subscriptions;

  @override
  Widget build(BuildContext context) {
    final totalInvested = subscriptions.fold<double>(
      0,
      (sum, subscription) => sum + subscription.amount,
    );
    final allocatedCount = subscriptions
        .where(
          (subscription) =>
              subscription.status == LaunchpadSubscriptionStatus.allocated ||
              subscription.status ==
                  LaunchpadSubscriptionStatus.partiallyAllocated ||
              subscription.status == LaunchpadSubscriptionStatus.claimed,
        )
        .length;
    final pendingCount = subscriptions
        .where(
          (subscription) =>
              subscription.status == LaunchpadSubscriptionStatus.pending,
        )
        .length;

    return VitCard(
      key: LaunchpadPortfolioPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      padding: AppSpacing.launchpadPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: AppSpacing.launchpadBox48,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.primary12,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.lgRadius,
                      side: const BorderSide(color: AppColors.primary30),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.business_center_outlined,
                      color: AppColors.primary,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng đã đầu tư',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                    Text(
                      _formatUsd(totalInvested),
                      style: AppTextStyles.pageTitle.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Dự án',
                  value: '${subscriptions.length}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Đã phân bổ',
                  value: '$allocatedCount',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Đang chờ',
                  value: '$pendingCount',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: AppSpacing.launchpadMetricCardPadding,
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: AppSpacing.launchpadLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioTabs extends StatelessWidget {
  const _PortfolioTabs({required this.activeTab, required this.onChanged});

  final _PortfolioTab activeTab;
  final ValueChanged<_PortfolioTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: LaunchpadPortfolioPage.tabsKey,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x3,
      children: [
        for (final tab in _PortfolioTab.values)
          VitChoicePill(
            key: LaunchpadPortfolioPage.tabKey(tab.id),
            label: tab.label,
            selected: tab == activeTab,
            onTap: () => onChanged(tab),
            accentColor: AppColors.primary,
            padding: AppSpacing.launchpadActionButtonPadding,
          ),
      ],
    );
  }
}
