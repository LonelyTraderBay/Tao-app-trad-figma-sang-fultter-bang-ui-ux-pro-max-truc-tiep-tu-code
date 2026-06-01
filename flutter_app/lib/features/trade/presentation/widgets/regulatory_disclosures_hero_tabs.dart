part of '../pages/regulatory_disclosures_page.dart';

class _LegalHero extends StatelessWidget {
  const _LegalHero({required this.snapshot});

  final TradeRegulatoryDisclosuresSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _legalPrimary.withValues(alpha: .04),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _legalPrimary, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _legalPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.balance_rounded,
              color: AppColors.onAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
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
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  snapshot.heroDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _legalPrimary,
                    fontSize: 10.5,
                    height: 1.2,
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
    return Container(
      height: 53,
      color: _legalTabsBackground,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: RegulatoryDisclosuresPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _legalPrimary
                                : AppColors.text3,
                            fontSize: 11,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 65 : 0,
                      height: 2,
                      color: _legalPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
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
