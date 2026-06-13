part of '../pages/provider_governance_page.dart';

class _ProviderDashboard extends StatelessWidget {
  const _ProviderDashboard({required this.stats});

  final TradeProviderGovernanceStats stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      height: 136,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      borderColor: _governancePrimary,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: _governancePrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.onAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Provider Dashboard',
                      style: AppTextStyles.body.copyWith(
                        color: _governancePrimary,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Managing ${stats.followers} followers',
                      style: AppTextStyles.caption.copyWith(
                        color: _governancePrimary,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DashboardStat(label: 'AUM', value: '\$125K'),
              ),
              Expanded(
                child: _DashboardStat(
                  label: 'This Month',
                  value: '\$${stats.monthlyFeesEarned.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _DashboardStat(
                  label: 'Compliance',
                  value: '${stats.complianceScore}/100',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  const _DashboardStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: _governancePrimary,
            height: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: _governancePrimary,
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _GovernanceTabs extends StatelessWidget {
  const _GovernanceTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeProviderGovernanceTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 53,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: ProviderGovernancePage.tabKey(tab.id),
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
                                ? _governancePrimary
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 67 : 0,
                      height: 2,
                      color: _governancePrimary,
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

class _ModificationsTab extends StatelessWidget {
  const _ModificationsTab({required this.snapshot, required this.onRequest});

  final TradeProviderGovernanceSnapshot snapshot;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Notice(text: snapshot.warning),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Strategy Modification Log',
            style: AppTextStyles.captionSm.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        for (final modification in snapshot.modifications) ...[
          _ModificationCard(modification: modification),
          if (modification != snapshot.modifications.last)
            const SizedBox(height: 10),
        ],
        const SizedBox(height: 16),
        _RequestButton(onPressed: onRequest),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      borderColor: _governanceWarningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _governanceWarning,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _governanceWarning,
                fontWeight: AppTextStyles.bold,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
