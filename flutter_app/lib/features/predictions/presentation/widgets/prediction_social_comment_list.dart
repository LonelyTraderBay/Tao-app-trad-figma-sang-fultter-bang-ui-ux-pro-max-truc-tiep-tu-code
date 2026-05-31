part of '../pages/prediction_social_page.dart';

class _CommentsSection extends StatelessWidget {
  const _CommentsSection({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '${snapshot.totalComments} binh luan',
      accentColor: _predictionPrimary,
      children: [
        for (final comment in snapshot.comments) _CommentCard(comment: comment),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment, this.reply = false});

  final PredictionSocialCommentDraft comment;
  final bool reply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: reply ? 48 : 0),
      child: VitCard(
        borderColor: comment.isPinned ? AppColors.primary15 : AppColors.border,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TierAvatar(tier: comment.userTier),
                const SizedBox(width: 10),
                Expanded(child: _CommentUser(comment: comment)),
                const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              comment.content,
              style: AppTextStyles.caption.copyWith(
                height: 1.55,
                color: AppColors.text1,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            _CommentActions(comment: comment, reply: reply),
            if (comment.replies.isNotEmpty) ...[
              const SizedBox(height: 14),
              for (final child in comment.replies)
                _CommentCard(comment: child, reply: true),
            ],
          ],
        ),
      ),
    );
  }
}

class _CommentUser extends StatelessWidget {
  const _CommentUser({required this.comment});

  final PredictionSocialCommentDraft comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              comment.userName,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                fontSize: 13,
              ),
            ),
            _SmallBadge(
              label: _tierLabel(comment.userTier),
              color: _tierColor(comment.userTier),
            ),
            if (comment.isPinned)
              const _SmallBadge(label: 'PINNED', color: _predictionPrimary),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.text3,
              size: 11,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                comment.createdAtLabel,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            const SizedBox(width: 7),
            _SmallBadge(
              label: _stanceLabel(comment.stance).toUpperCase(),
              color: _stanceColor(comment.stance),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommentActions extends StatelessWidget {
  const _CommentActions({required this.comment, required this.reply});

  final PredictionSocialCommentDraft comment;
  final bool reply;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionPill(
          icon: Icons.thumb_up_alt_outlined,
          label: '${comment.upvotes}',
          color: AppColors.buy,
        ),
        const SizedBox(width: 8),
        _ActionPill(
          icon: Icons.thumb_down_alt_outlined,
          label: '${comment.downvotes}',
          color: AppColors.sell,
        ),
        if (!reply) ...[
          const SizedBox(width: 8),
          const _ActionPill(
            icon: Icons.mode_comment_outlined,
            label: 'Tra loi',
          ),
        ],
        const SizedBox(width: 10),
        const _ActionPill(
          icon: Icons.flag_outlined,
          label: 'Bao cao',
          flat: true,
        ),
      ],
    );
  }
}

class _TierAvatar extends StatelessWidget {
  const _TierAvatar({required this.tier});

  final PredictionSocialTier tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _tierColor(tier),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppColors.onAccent,
        size: 17,
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          fontSize: 9,
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    this.color = AppColors.text3,
    this.flat = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: flat ? AppColors.transparent : AppColors.bg,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: flat ? AppColors.text3 : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentDisclaimer extends StatelessWidget {
  const _CommentDisclaimer();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary15,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Y kien nguoi dung chi mang tinh tham khao. Khong phai loi khuyen dau tu. Tu chiu trach nhiem quyet dinh.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
