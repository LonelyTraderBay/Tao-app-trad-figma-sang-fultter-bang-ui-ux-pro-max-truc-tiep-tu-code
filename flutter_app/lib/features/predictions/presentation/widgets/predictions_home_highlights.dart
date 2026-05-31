part of '../pages/predictions_home_page.dart';

class _PredictionCtaCard extends StatelessWidget {
  const _PredictionCtaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      borderColor: color.withValues(alpha: .20),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
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
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _BreakingMoversCard extends StatelessWidget {
  const _BreakingMoversCard({required this.snapshot, required this.onTap});

  final PredictionHomeSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionsHomePage.breakingMoversKey,
      onTap: onTap,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.warn,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breaking movers (24h)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    for (final mover in snapshot.breakingMovers.take(2)) ...[
                      Text(
                        _formatPercent(mover.change24h),
                        style: AppTextStyles.micro.copyWith(
                          color: mover.change24h >= 0
                              ? AppColors.buy
                              : AppColors.sell,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '& ${snapshot.breakingMovers.length - 2}+ more',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _ArenaBridgeCard extends StatelessWidget {
  const _ArenaBridgeCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionsHomePage.arenaBridgeKey,
      onTap: onTap,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.sports_esports_rounded,
              color: AppColors.warn,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 7,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Thử thách cùng chủ đề',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _SmallBadge(
                      label: 'Arena Points only',
                      color: AppColors.warn,
                      background: AppColors.warn10,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Khám phá các room social points-only trong Open Arena',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 3),
                Text(
                  'Xem Arena',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.warn,
            size: 18,
          ),
        ],
      ),
    );
  }
}
