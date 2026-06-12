part of '../pages/staking_risk_disclosure_page.dart';

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.snapshot});

  final StakingRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingRiskDisclosurePage.warningKey,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.stakingRiskDisclosureWarningMinHeight,
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        border: Border.all(
          color: AppColors.sell20,
          width: AppSpacing.stakingRiskDisclosureBorderWidth,
        ),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: AppSpacing.stakingRiskDisclosureWarningIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.warningTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
                Text(
                  snapshot.warningBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingRiskDisclosureBodyLineHeight,
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

class _RiskTabs extends StatelessWidget {
  const _RiskTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<StakingRiskDisclosureTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface2,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.stakingRiskDisclosureTabsMinHeight,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(key: tab.id, label: tab.label, icon: null),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final StakingRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingRiskDisclosurePage.overviewKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(snapshot.summaryTitle),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        _RiskSummaryCard(snapshot: snapshot),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
        _SectionLabel(snapshot.productSectionTitle),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        for (final product in snapshot.products) ...[
          _RiskProductCard(product: product),
          if (product != snapshot.products.last)
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        ],
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Text(
            snapshot.disclaimer,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: AppSpacing.stakingRiskDisclosureNoticeLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _RiskSummaryCard extends StatelessWidget {
  const _RiskSummaryCard({required this.snapshot});

  final StakingRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.summaryBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.stakingRiskDisclosureSummaryLineHeight,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          Row(
            children: [
              for (final count in snapshot.riskCounts) ...[
                Expanded(child: _RiskCountTile(count: count)),
                if (count != snapshot.riskCounts.last)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskCountTile extends StatelessWidget {
  const _RiskCountTile({required this.count});

  final StakingRiskCountDraft count;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(count.level);
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.stakingRiskDisclosureCountMinHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: _riskTint(count.level),
        border: Border.all(color: color.withValues(alpha: .28)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${count.count}',
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.stakingRiskDisclosureCompactLineHeight,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
          Text(
            count.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RiskProductCard extends StatelessWidget {
  const _RiskProductCard({required this.product});

  final StakingRiskProductDraft product;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRiskDisclosurePage.productKey(product.name),
      radius: VitCardRadius.lg,
      constraints: BoxConstraints(
        minHeight: product.risks.length > 3
            ? AppSpacing.stakingRiskDisclosureProductMinHeightTall
            : AppSpacing.stakingRiskDisclosureProductMinHeight,
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _RiskLevelBadge(level: product.level, prefix: true),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final risk in product.risks)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface3,
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    risk,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.stakingRiskDisclosureCompactLineHeight,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
