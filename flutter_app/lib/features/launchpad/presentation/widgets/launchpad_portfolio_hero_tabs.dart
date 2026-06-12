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
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.launchpadBox48,
                height: AppSpacing.launchpadBox48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary12,
                  border: Border.all(color: AppColors.primary30),
                  borderRadius: AppRadii.lgRadius,
                ),
                child: const Icon(
                  Icons.business_center_outlined,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
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
              height: AppSpacing.launchpadLineHeightShort,
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
          InkWell(
            key: LaunchpadPortfolioPage.tabKey(tab.id),
            onTap: () => onChanged(tab),
            borderRadius: AppRadii.inputRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x3,
              ),
              decoration: BoxDecoration(
                color: tab == activeTab
                    ? AppColors.primary12
                    : AppColors.surface2,
                border: Border.all(
                  color: tab == activeTab
                      ? AppColors.primary30
                      : AppColors.cardBorder,
                ),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Text(
                tab.label,
                style: AppTextStyles.caption.copyWith(
                  color: tab == activeTab ? AppColors.primary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
