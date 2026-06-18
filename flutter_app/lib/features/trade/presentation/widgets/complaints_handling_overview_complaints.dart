part of '../pages/complaints_handling_page.dart';

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Complaint Categories',
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        const SizedBox(height: AppSpacing.complaintsHandlingReviewGap),
        _CategoryGrid(categories: snapshot.categories),
        const SizedBox(height: AppSpacing.complaintsHandlingPrimaryGap),
        const VitSectionHeader(
          title: 'Resolution Timeline',
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        const SizedBox(height: AppSpacing.complaintsHandlingReviewGap),
        _TimelineCard(timeline: snapshot.timeline),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<TradeComplaintCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.complaintsHandlingGridGap,
      runSpacing: AppSpacing.complaintsHandlingGridGap,
      children: [
        for (final category in categories)
          SizedBox(
            width: AppSpacing.complaintsHandlingCategoryWidth,
            height: AppSpacing.complaintsHandlingCategoryHeight,
            child: _Card(
              padding: AppSpacing.complaintsHandlingCategoryPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _iconForCategory(category.icon),
                    color: _complaintsPrimary,
                    size: AppSpacing.complaintCaseSmallIcon,
                  ),
                  const Spacer(),
                  Text(
                    category.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: AppSpacing.complaintCaseLineHeightTight,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.timeline});

  final List<TradeComplaintTimelineStep> timeline;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.complaintsHandlingTimelinePadding,
      child: Column(
        children: [
          for (final item in timeline) ...[
            Row(
              children: [
                VitCard(
                  width: AppSpacing.complaintsHandlingTimelineStepSize,
                  height: AppSpacing.complaintsHandlingTimelineStepSize,
                  variant: VitCardVariant.inner,
                  alignment: Alignment.center,
                  child: Text(
                    '${item.step}',
                    style: AppTextStyles.caption.copyWith(
                      color: _complaintsPrimary,
                      fontWeight: AppTextStyles.bold,
                      height: AppSpacing.complaintCaseLineHeightTight,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.complaintsHandlingGridGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.complaintCaseLineHeightTight,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.complaintsHandlingTimelineLabelGap,
                      ),
                      Text(
                        item.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: AppSpacing.complaintCaseLineHeightTight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (item != timeline.last)
              const SizedBox(
                height: AppSpacing.complaintsHandlingTimelineItemGap,
              ),
          ],
        ],
      ),
    );
  }
}

class _MyComplaintsContent extends StatelessWidget {
  const _MyComplaintsContent({required this.complaints});

  final List<TradeComplaint> complaints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Your Complaints',
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        const SizedBox(height: AppSpacing.complaintsHandlingReviewGap),
        for (final complaint in complaints) ...[
          _ComplaintCard(complaint: complaint),
          if (complaint != complaints.last)
            const SizedBox(height: AppSpacing.complaintsHandlingReviewGap),
        ],
      ],
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  const _ComplaintCard({required this.complaint});

  final TradeComplaint complaint;

  @override
  Widget build(BuildContext context) {
    final status = _statusPresentation(complaint.status);
    return InkWell(
      key: ComplaintsHandlingPage.complaintKey(complaint.id),
      borderRadius: AppRadii.cardRadius,
      onTap: () =>
          context.go(AppRoutePaths.tradeCopyComplaintTracking(complaint.id)),
      child: _Card(
        padding: AppSpacing.complaintCaseCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VitCard(
              width: AppSpacing.walletAddressIconSize,
              height: AppSpacing.walletAddressIconSize,
              variant: VitCardVariant.ghost,
              borderColor: status.color.withValues(alpha: .24),
              alignment: Alignment.center,
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: status.color,
                size: AppSpacing.complaintCaseTrailingIcon,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.x3,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        complaint.id,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.complaintCaseLineHeightTight,
                        ),
                      ),
                      VitAccentPill(
                        label: status.label,
                        accentColor: status.color,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.complaintsHandlingGridGap),
                  Text(
                    complaint.subject,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.complaintCaseLineHeightBody,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.formFieldLabelGap),
                  Text(
                    '${complaint.category} - Submitted ${complaint.submittedDate}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppSpacing.complaintCaseLineHeightTight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.complaintCaseSmallIcon,
            ),
          ],
        ),
      ),
    );
  }
}
