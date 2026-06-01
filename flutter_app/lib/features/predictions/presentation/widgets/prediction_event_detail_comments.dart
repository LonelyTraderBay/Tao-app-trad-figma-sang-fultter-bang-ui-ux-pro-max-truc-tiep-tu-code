part of '../pages/prediction_event_detail_page.dart';

class _CommentsContent extends StatelessWidget {
  const _CommentsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: AppColors.warn08,
            border: Border.all(color: AppColors.warningBorder),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: 15,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Beware of external links. Do not share personal or financial information.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warn,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        _CommentRow(
          name: 'MacroAlpha',
          side: 'Yes',
          text: 'Strong ETF flow and liquidity backdrop support this market.',
          likes: 18,
        ),
        _CommentRow(
          name: 'RiskDesk',
          side: 'No',
          text: 'Watch macro rates and exchange liquidity before sizing up.',
          likes: 9,
        ),
        const SizedBox(height: 10),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Add a comment...',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                'Post',
                style: AppTextStyles.caption.copyWith(
                  color: _predictionPrimary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({
    required this.name,
    required this.side,
    required this.text,
    required this.likes,
  });

  final String name;
  final String side;
  final String text;
  final int likes;

  @override
  Widget build(BuildContext context) {
    final color = side == 'Yes' ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surface2,
            child: Text(
              name[0],
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 7,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _TinyBadge(
                      label: side,
                      color: color,
                      background: color.withValues(alpha: .12),
                    ),
                    Text(
                      '4m ago',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up_alt_outlined,
                      color: AppColors.text3,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$likes',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Báo cáo',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
