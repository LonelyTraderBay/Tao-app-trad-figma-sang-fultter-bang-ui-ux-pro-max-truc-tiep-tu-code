part of '../pages/provider_governance_page.dart';

class _ModificationCard extends StatelessWidget {
  const _ModificationCard({required this.modification});

  final TradeStrategyModification modification;

  @override
  Widget build(BuildContext context) {
    final typeColor = _modificationColor(modification.type);
    return VitCard(
      height: AppSpacing.providerGovernanceModificationHeight,
      padding: AppSpacing.providerGovernanceModificationPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitAccentPill(
                label: modification.type.replaceAll('_', ' ').toUpperCase(),
                accentColor: typeColor,
              ),
              const SizedBox(width: AppSpacing.x3),
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.providerGovernanceModificationIcon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Change:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.providerGovernanceLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Text(
                modification.oldValue,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.providerGovernanceLineHeightTight,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.providerGovernanceModificationIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  modification.newValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.providerGovernanceLineHeightTight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: AppSpacing.providerGovernanceMetaIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                modification.date,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.providerGovernanceLineHeightTight,
                ),
              ),
              const SizedBox(width: AppSpacing.providerGovernanceMetaGap),
              const Icon(
                Icons.group_outlined,
                color: AppColors.text3,
                size: AppSpacing.providerGovernanceMetaIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  '${modification.followerImpact} followers impacted',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.providerGovernanceLineHeightTight,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const VitAccentPill(
            label: 'Notification sent 24h before implementation',
            accentColor: AppColors.buy,
            size: VitStatusPillSize.md,
          ),
        ],
      ),
    );
  }
}

class _RequestButton extends StatelessWidget {
  const _RequestButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: ProviderGovernancePage.requestActionKey,
      onPressed: onPressed,
      height: AppSpacing.providerGovernanceRequestHeight,
      leading: const Icon(Icons.edit_outlined),
      child: const Text('Request Strategy Modification'),
    );
  }
}

class _CommunicationTab extends StatelessWidget {
  const _CommunicationTab({required this.snapshot, required this.onBroadcast});

  final TradeProviderGovernanceSnapshot snapshot;
  final VoidCallback onBroadcast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _RequestButton(onPressed: onBroadcast),
        const SizedBox(height: AppSpacing.rowPy),
        for (final message in snapshot.messages) ...[
          _SimplePanel(
            title: message.subject,
            body:
                '${message.recipients} recipients · ${message.openRate}% open rate · ${message.date}',
          ),
          if (message != snapshot.messages.last)
            const SizedBox(height: AppSpacing.rowGapRegular),
        ],
      ],
    );
  }
}

class _FeesTab extends StatelessWidget {
  const _FeesTab({required this.snapshot});

  final TradeProviderGovernanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SimplePanel(
          title: 'Performance Fee Waterfall',
          body:
              'This Month \$${snapshot.stats.monthlyFeesEarned.toStringAsFixed(0)} · All-Time \$${snapshot.stats.allTimeFeesEarned.toStringAsFixed(0)}',
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final contributor in snapshot.feeContributors) ...[
          _SimplePanel(
            title: contributor.name,
            body:
                'Profit \$${contributor.profit.toStringAsFixed(0)} · Fee \$${contributor.fee.toStringAsFixed(0)}',
          ),
          if (contributor != snapshot.feeContributors.last)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ComplianceTab extends StatelessWidget {
  const _ComplianceTab({required this.snapshot});

  final TradeProviderGovernanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in snapshot.complianceItems) ...[
          _SimplePanel(
            title: item.item,
            body: 'Last check: ${item.lastCheck}',
            leading: Icons.check_circle_outline_rounded,
          ),
          if (item != snapshot.complianceItems.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x4),
        _SimplePanel(
          title: 'Compliance Score: ${snapshot.stats.complianceScore}/100',
          body: 'Excellent standing — All requirements met',
        ),
      ],
    );
  }
}

class _SimplePanel extends StatelessWidget {
  const _SimplePanel({required this.title, required this.body, this.leading});

  final String title;
  final String body;
  final IconData? leading;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.providerGovernancePanelPadding,
      child: Row(
        children: [
          if (leading != null) ...[
            Icon(
              leading,
              color: AppColors.buy,
              size: AppSpacing.providerGovernancePanelIcon,
            ),
            const SizedBox(width: AppSpacing.rowGapRegular),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
