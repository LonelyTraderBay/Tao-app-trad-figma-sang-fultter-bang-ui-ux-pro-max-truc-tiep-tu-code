part of '../pages/complaints_handling_page.dart';

class _RightsNotice extends StatelessWidget {
  const _RightsNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _complaintsPrimary.withValues(alpha: .28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text1,
            size: AppSpacing.complaintCaseActionIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rights',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'You have the right to complain. We will investigate fairly '
                  'and respond within 8 weeks. If dissatisfied, you can refer '
                  'to the Financial Ombudsman Service.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitMetricCard(
            label: 'Active',
            value: '${snapshot.activeCount}',
            density: VitDensity.compact,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: VitMetricCard(
            label: 'Resolved',
            value: '${snapshot.resolvedCount}',
            accentColor: _complaintsGreen,
            density: VitDensity.compact,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: VitMetricCard(
            label: 'Avg. Days',
            value: '${snapshot.averageResolutionDays}',
            density: VitDensity.compact,
          ),
        ),
      ],
    );
  }
}

class _SubmitComplaintButton extends StatelessWidget {
  const _SubmitComplaintButton();

  @override
  Widget build(BuildContext context) {
    return VitNextActionCard(
      key: ComplaintsHandlingPage.submitKey,
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Submit a Complaint',
      subtitle: "We'll respond within 8 weeks",
      statusLabel: 'Regulated',
      ctaLabel: 'Start',
      accentColor: _complaintsPrimary,
      onTap: () => context.go(AppRoutePaths.tradeCopyComplaintSubmission),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final _ComplaintsTab active;
  final ValueChanged<_ComplaintsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active.name,
        tabs: [
          VitTabItem(
            key: _ComplaintsTab.overview.name,
            label: 'Overview',
            widgetKey: ComplaintsHandlingPage.tabKey(
              _ComplaintsTab.overview.name,
            ),
          ),
          VitTabItem(
            key: _ComplaintsTab.myComplaints.name,
            label: 'My Complaints',
            widgetKey: ComplaintsHandlingPage.tabKey(
              _ComplaintsTab.myComplaints.name,
            ),
          ),
          VitTabItem(
            key: _ComplaintsTab.process.name,
            label: 'Process',
            widgetKey: ComplaintsHandlingPage.tabKey(
              _ComplaintsTab.process.name,
            ),
          ),
        ],
        onChanged: (key) => onChanged(_ComplaintsTab.values.byName(key)),
      ),
    );
  }
}
