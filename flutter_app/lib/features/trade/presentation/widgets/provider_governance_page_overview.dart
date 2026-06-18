part of '../pages/provider_governance_page.dart';

class _ProviderDashboard extends StatelessWidget {
  const _ProviderDashboard({required this.stats});

  final TradeProviderGovernanceStats stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      height: AppSpacing.providerGovernanceDashboardHeight,
      padding: AppSpacing.providerGovernanceDashboardPadding,
      borderColor: _governancePrimary,
      child: Column(
        children: [
          Row(
            children: [
              const VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.lg,
                width: AppSpacing.providerGovernanceDashboardIconBox,
                height: AppSpacing.providerGovernanceDashboardIconBox,
                borderColor: _governancePrimary,
                alignment: Alignment.center,
                child: Icon(
                  Icons.shield_outlined,
                  color: _governancePrimary,
                  size: AppSpacing.providerGovernanceDashboardIcon,
                ),
              ),
              const SizedBox(
                width: AppSpacing.providerGovernanceDashboardGap,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Provider Dashboard',
                      style: AppTextStyles.body.copyWith(
                        color: _governancePrimary,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.providerGovernanceLineHeightTight,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.providerGovernanceCompactGap,
                    ),
                    Text(
                      'Managing ${stats.followers} followers',
                      style: AppTextStyles.caption.copyWith(
                        color: _governancePrimary,
                        height: AppSpacing.providerGovernanceLineHeightTight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.providerGovernanceDashboardMetricGap,
          ),
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
            height: AppSpacing.providerGovernanceLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.providerGovernanceCompactGap),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: _governancePrimary,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.providerGovernanceLineHeightTight,
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
      height: AppSpacing.providerGovernanceTabHeight,
      padding: AppSpacing.zeroInsets,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Notice(text: snapshot.warning),
        const SizedBox(height: AppSpacing.contentPad),
        Padding(
          padding: AppSpacing.providerGovernanceSectionTitlePadding,
          child: Text(
            'Strategy Modification Log',
            style: AppTextStyles.captionSm.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.providerGovernanceLineHeightTight,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final modification in snapshot.modifications) ...[
          _ModificationCard(modification: modification),
          if (modification != snapshot.modifications.last)
            const SizedBox(height: AppSpacing.rowGapRegular),
        ],
        const SizedBox(height: AppSpacing.contentPad - AppSpacing.x1),
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
      constraints: const BoxConstraints(
        minHeight: AppSpacing.providerGovernanceNoticeMinHeight,
      ),
      padding: AppSpacing.providerGovernanceNoticePadding,
      borderColor: _governanceWarningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _governanceWarning,
            size: AppSpacing.providerGovernanceNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.providerGovernanceNoticeGap),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _governanceWarning,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.providerGovernanceLineHeightReadable,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
