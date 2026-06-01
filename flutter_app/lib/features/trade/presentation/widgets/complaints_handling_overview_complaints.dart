part of '../pages/complaints_handling_page.dart';

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Complaint Categories'),
        const SizedBox(height: 13),
        _CategoryGrid(categories: snapshot.categories),
        const SizedBox(height: 26),
        const _SectionLabel('Resolution Timeline'),
        const SizedBox(height: 10),
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
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final category in categories)
          SizedBox(
            width: 194,
            height: 82,
            child: _Card(
              padding: const EdgeInsets.fromLTRB(13, 18, 13, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _iconForCategory(category.icon),
                    color: _complaintsPrimary,
                    size: 17,
                  ),
                  const Spacer(),
                  Text(
                    category.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
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
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      child: Column(
        children: [
          for (final item in timeline) ...[
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _complaintsPanel2,
                    borderRadius: AppRadii.cardRadius,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.step}',
                    style: AppTextStyles.caption.copyWith(
                      color: _complaintsPrimary,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (item != timeline.last) const SizedBox(height: 16),
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
        const _SectionLabel('Your Complaints'),
        const SizedBox(height: 13),
        for (final complaint in complaints) ...[
          _ComplaintCard(complaint: complaint),
          if (complaint != complaints.last) const SizedBox(height: 12),
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: status.color.withValues(alpha: .11),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: status.color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        complaint.id,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      Text(
                        status.label,
                        style: AppTextStyles.micro.copyWith(
                          color: status.color,
                          fontSize: 9,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    complaint.subject,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${complaint.category} - Submitted ${complaint.submittedDate}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}
