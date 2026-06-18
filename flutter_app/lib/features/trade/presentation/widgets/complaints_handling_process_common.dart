part of '../pages/complaints_handling_page.dart';

class _ProcessContent extends StatelessWidget {
  const _ProcessContent({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'How We Handle Complaints',
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        const SizedBox(height: AppSpacing.x4),
        _Card(
          padding: AppSpacing.cardPadding,
          child: Column(
            children: [
              for (final step in snapshot.processSteps) ...[
                _ProcessStep(step: step),
                if (step != snapshot.processSteps.last)
                  const SizedBox(height: AppSpacing.x4),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        const VitSectionHeader(
          title: 'Financial Ombudsman Service',
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        const SizedBox(height: AppSpacing.x4),
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
          size: AppSpacing.complaintCaseActionIcon,
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.complaintCaseLineHeightTight,
                ),
              ),
              const SizedBox(height: AppSpacing.formFieldLabelGap),
              Text(
                step.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.complaintsHandlingRightsBodyLineHeight,
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
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ombudsman.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.complaintsHandlingOmbudsmanLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.cardPaddingCompact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact:',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.complaintCaseLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  'Phone: ${ombudsman.phone}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    height: AppSpacing.complaintCaseLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Web: ${ombudsman.website}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    height: AppSpacing.complaintCaseLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyOmbudsmanReferral),
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.searchBarCompactHeight,
            leading: const Icon(Icons.info_outline_rounded),
            child: const Text('Learn About Ombudsman Referral'),
          ),
        ],
      ),
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
