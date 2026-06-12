part of '../pages/complaints_handling_page.dart';

class _ProcessContent extends StatelessWidget {
  const _ProcessContent({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('How We Handle Complaints'),
        const SizedBox(height: 13),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (final step in snapshot.processSteps) ...[
                _ProcessStep(step: step),
                if (step != snapshot.processSteps.last)
                  const SizedBox(height: 13),
              ],
            ],
          ),
        ),
        const SizedBox(height: 25),
        const _SectionLabel('Financial Ombudsman Service'),
        const SizedBox(height: 13),
        _OmbudsmanCard(ombudsman: snapshot.ombudsman),
      ],
    );
  }
}

class _ProcessStep extends StatelessWidget {
  const _ProcessStep({required this.step});

  final TradeComplaintProcessStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: _complaintsGreen,
          size: 16,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                step.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OmbudsmanCard extends StatelessWidget {
  const _OmbudsmanCard({required this.ombudsman});

  final TradeOmbudsmanInfo ombudsman;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ombudsman.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact:',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Phone: ${ombudsman.phone}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Web: ${ombudsman.website}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyOmbudsmanReferral),
            icon: const Icon(Icons.info_outline_rounded, size: 14),
            label: const Text('Learn About Ombudsman Referral'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              foregroundColor: AppColors.text1,
              side: BorderSide(color: _complaintsBorder.withValues(alpha: .76)),
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
              textStyle: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 4,
          height: 15,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _complaintsPrimary,
              borderRadius: AppRadii.smRadius,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _complaintsBorder.withValues(alpha: .76),
      child: child,
    );
  }
}

IconData _iconForCategory(TradeComplaintCategoryIcon icon) {
  return switch (icon) {
    TradeComplaintCategoryIcon.trade => Icons.trending_up_rounded,
    TradeComplaintCategoryIcon.account => Icons.group_outlined,
    TradeComplaintCategoryIcon.payment => Icons.description_outlined,
    TradeComplaintCategoryIcon.service => Icons.chat_bubble_outline_rounded,
    TradeComplaintCategoryIcon.fees => Icons.bar_chart_rounded,
    TradeComplaintCategoryIcon.other => Icons.error_outline_rounded,
  };
}

({String label, Color color}) _statusPresentation(TradeComplaintStatus status) {
  return switch (status) {
    TradeComplaintStatus.submitted => (
      label: 'Submitted',
      color: _complaintsPrimary,
    ),
    TradeComplaintStatus.underReview => (
      label: 'Under Review',
      color: _complaintsAmber,
    ),
    TradeComplaintStatus.resolved => (
      label: 'Resolved',
      color: _complaintsGreen,
    ),
    TradeComplaintStatus.escalated => (
      label: 'Escalated',
      color: _complaintsRed,
    ),
  };
}
