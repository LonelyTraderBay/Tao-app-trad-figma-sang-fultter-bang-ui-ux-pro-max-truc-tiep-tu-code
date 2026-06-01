part of '../pages/provider_governance_page.dart';

class _ModificationCard extends StatelessWidget {
  const _ModificationCard({required this.modification});

  final TradeStrategyModification modification;

  @override
  Widget build(BuildContext context) {
    final typeColor = _modificationColor(modification.type);
    return Container(
      height: 154,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: _governanceCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                height: 20,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  modification.type.replaceAll('_', ' ').toUpperCase(),
                  style: AppTextStyles.micro.copyWith(
                    color: typeColor,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: 13,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Change:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                modification.oldValue,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 13,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  modification.newValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: 11,
              ),
              const SizedBox(width: 4),
              Text(
                modification.date,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
              const SizedBox(width: 17),
              const Icon(
                Icons.group_outlined,
                color: AppColors.text3,
                size: 11,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${modification.followerImpact} followers impacted',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 28,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: _governancePill,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Text(
              '✓ Notification sent 24h before implementation',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontSize: 9,
                height: 1,
              ),
            ),
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
    return InkWell(
      key: ProviderGovernancePage.requestActionKey,
      onTap: onPressed,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _governancePrimary,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.edit_outlined,
              color: AppColors.onAccent,
              size: 17,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Request Strategy Modification',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
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
        const SizedBox(height: 14),
        for (final message in snapshot.messages) ...[
          _SimplePanel(
            title: message.subject,
            body:
                '${message.recipients} recipients · ${message.openRate}% open rate · ${message.date}',
          ),
          if (message != snapshot.messages.last) const SizedBox(height: 10),
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
        const SizedBox(height: 12),
        for (final contributor in snapshot.feeContributors) ...[
          _SimplePanel(
            title: contributor.name,
            body:
                'Profit \$${contributor.profit.toStringAsFixed(0)} · Fee \$${contributor.fee.toStringAsFixed(0)}',
          ),
          if (contributor != snapshot.feeContributors.last)
            const SizedBox(height: 8),
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
          if (item != snapshot.complianceItems.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 12),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _governanceCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            Icon(leading, color: AppColors.buy, size: 17),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
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
