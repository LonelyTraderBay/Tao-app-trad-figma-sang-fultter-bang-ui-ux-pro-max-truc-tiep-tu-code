part of '../pages/regulatory_disclosures_page.dart';

class _LegalHero extends StatelessWidget {
  const _LegalHero({required this.snapshot});

  final TradeRegulatoryDisclosuresSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      density: VitDensity.compact,
      borderColor: _legalPrimary,
      child: Row(
        children: [
          const CircleAvatar(
            radius: AppSpacing.x4,
            backgroundColor: AppColors.surface2,
            child: Icon(
              Icons.balance_rounded,
              color: _legalPrimary,
              size: TradeSpacingTokens.regulatoryDisclosuresHeroIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: _legalPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.heroDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: _legalPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalTabs extends StatelessWidget {
  const _LegalTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeRegulatoryTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeId,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.id,
              label: tab.label,
              widgetKey: RegulatoryDisclosuresPage.tabKey(tab.id),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _LegalTabBody extends StatelessWidget {
  const _LegalTabBody({
    required this.snapshot,
    required this.activeTabId,
    required this.onNotice,
  });

  final TradeRegulatoryDisclosuresSnapshot snapshot;
  final String activeTabId;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return switch (activeTabId) {
      'protection' => _ProtectionTab(
        protection: snapshot.protection,
        onNotice: onNotice,
      ),
      'restrictions' => _RestrictionsTab(restrictions: snapshot.restrictions),
      'liability' => _LiabilityTab(liability: snapshot.liability),
      'contact' => _ContactTab(
        contacts: snapshot.contacts,
        whistleblower: snapshot.whistleblower,
        terms: snapshot.terms,
        onNotice: onNotice,
      ),
      _ => _MifidTab(snapshot: snapshot),
    };
  }
}
