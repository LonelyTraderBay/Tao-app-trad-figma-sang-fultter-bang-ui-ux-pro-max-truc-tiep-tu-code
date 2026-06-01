part of '../pages/complaints_handling_page.dart';

class _RightsNotice extends StatelessWidget {
  const _RightsNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text1, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rights',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have the right to complain. We will investigate fairly '
                  'and respond within 8 weeks. If dissatisfied, you can refer '
                  'to the Financial Ombudsman Service.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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
          child: _StatCard(label: 'Active', value: '${snapshot.activeCount}'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Resolved',
            value: '${snapshot.resolvedCount}',
            valueColor: _complaintsGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Avg. Days',
            value: '${snapshot.averageResolutionDays}',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      child: SizedBox(
        height: 46,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.heroNumber.copyWith(
                color: valueColor,
                fontSize: 20,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitComplaintButton extends StatelessWidget {
  const _SubmitComplaintButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _complaintsPrimary,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: ComplaintsHandlingPage.submitKey,
        borderRadius: AppRadii.inputRadius,
        onTap: () => context.go(AppRoutePaths.tradeCopyComplaintSubmission),
        child: SizedBox(
          height: 78,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 15, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: AppSpacing.inputHeight,
                  decoration: BoxDecoration(
                    color: AppColors.onAccent.withValues(alpha: .20),
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.onAccent,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Submit a Complaint',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.onAccent,
                          fontSize: 14,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "We'll respond within 8 weeks",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.onAccent,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.onAccent,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final _ComplaintsTab active;
  final ValueChanged<_ComplaintsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: _complaintsPanel,
      child: Row(
        children: [
          _TabButton(
            tab: _ComplaintsTab.overview,
            label: 'Overview',
            active: active,
            onChanged: onChanged,
          ),
          _TabButton(
            tab: _ComplaintsTab.myComplaints,
            label: 'My Complaints',
            active: active,
            onChanged: onChanged,
          ),
          _TabButton(
            tab: _ComplaintsTab.process,
            label: 'Process',
            active: active,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.label,
    required this.active,
    required this.onChanged,
  });

  final _ComplaintsTab tab;
  final String label;
  final _ComplaintsTab active;
  final ValueChanged<_ComplaintsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final isActive = active == tab;
    return Expanded(
      child: InkWell(
        key: ComplaintsHandlingPage.tabKey(tab.name),
        onTap: () => onChanged(tab),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: isActive ? _complaintsPrimary : AppColors.text3,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 2,
              color: isActive ? _complaintsPrimary : AppColors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
