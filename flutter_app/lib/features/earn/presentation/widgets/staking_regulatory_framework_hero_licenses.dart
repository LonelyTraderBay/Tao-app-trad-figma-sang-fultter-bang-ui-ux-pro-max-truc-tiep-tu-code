part of '../pages/staking_regulatory_framework_page.dart';

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final StakingRegulatoryFrameworkSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRegulatoryFrameworkPage.heroKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingRegulatoryBodyLineHeight,
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

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<StakingRegulatoryTabDraft> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: StakingRegulatoryFrameworkPage.tabsKey,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        tabs: [
          for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
        ],
        activeKey: activeTab,
        onChanged: onChanged,
      ),
    );
  }
}

class _LicensesTab extends StatelessWidget {
  const _LicensesTab({required this.snapshot, required this.onLicenseTap});

  final StakingRegulatoryFrameworkSnapshot snapshot;
  final ValueChanged<StakingLicenseDraft> onLicenseTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingRegulatoryFrameworkPage.licensesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Global Regulatory Licenses',
          accentColor: AppColors.primarySoft,
          children: [
            Column(
              children: [
                for (final license in snapshot.licenses) ...[
                  _LicenseCard(
                    key: StakingRegulatoryFrameworkPage.licenseKey(
                      license.licenseNumber,
                    ),
                    license: license,
                    onTap: () => onLicenseTap(license),
                  ),
                  if (license != snapshot.licenses.last)
                    const SizedBox(height: AppSpacing.x3),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        _InfoNote(text: snapshot.licenseNote, icon: Icons.verified_outlined),
      ],
    );
  }
}

class _LicenseCard extends StatelessWidget {
  const _LicenseCard({super.key, required this.license, required this.onTap});

  final StakingLicenseDraft license;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX4,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: Icons.location_on_outlined, color: AppColors.buy),
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
                    Text(license.jurisdiction, style: AppTextStyles.baseMedium),
                    _StatusPill(status: license.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  license.regulator,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  license.licenseNumber,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final scope in license.scope.take(2))
                      _SmallPill(label: scope, color: AppColors.text2),
                    if (license.scope.length > 2)
                      _SmallPill(
                        label: '+${license.scope.length - 2} more',
                        color: AppColors.text3,
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
