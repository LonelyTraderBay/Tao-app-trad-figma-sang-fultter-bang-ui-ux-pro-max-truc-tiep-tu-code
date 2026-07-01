part of '../pages/provider_governance_page.dart';

class _ProviderDashboard extends StatelessWidget {
  const _ProviderDashboard({required this.stats});

  final TradeProviderGovernanceStats stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      density: VitDensity.compact,
      borderColor: _governancePrimary,
      child: Column(
        children: [
          Row(
            children: [
              const VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.large,
                width: AppSpacing.inputHeight - AppSpacing.x3,
                height: AppSpacing.inputHeight - AppSpacing.x3,
                borderColor: _governancePrimary,
                alignment: Alignment.center,
                child: Icon(
                  Icons.shield_outlined,
                  color: _governancePrimary,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Provider Dashboard',
                      style: AppTextStyles.body.copyWith(
                        color: _governancePrimary,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Managing ${stats.followers} followers',
                      style: AppTextStyles.caption.copyWith(
                        color: _governancePrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
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
          style: AppTextStyles.micro.copyWith(color: _governancePrimary),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: _governancePrimary,
            fontWeight: AppTextStyles.bold,
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
      density: VitDensity.compact,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x1),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeId,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.id,
              label: tab.label,
              widgetKey: ProviderGovernancePage.tabKey(tab.id),
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
    return VitPageContent(
      padding: VitContentPadding.none,
      density: VitDensity.compact,
      fullBleed: true,
      children: [
        _Notice(text: snapshot.warning),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.x2),
          child: Text(
            'Strategy Modification Log',
            style: AppTextStyles.captionSm.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        for (final modification in snapshot.modifications)
          _ModificationCard(modification: modification),
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
      density: VitDensity.compact,
      borderColor: _governanceWarningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _governanceWarning,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _governanceWarning,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
