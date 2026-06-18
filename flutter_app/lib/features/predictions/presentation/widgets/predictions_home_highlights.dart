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
      padding: AppSpacing.predictionHomeCompactCardPadding,
      child: Row(
        children: [
          _HighlightIconBox(
            icon: icon,
            color: color,
            background: color.withValues(alpha: .12),
            iconSize: AppSpacing.predictionHomeHighlightCtaIcon,
          ),
          const SizedBox(width: AppSpacing.predictionHomeHighlightGap),
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
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.predictionHomeHighlightCtaIcon,
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
      padding: AppSpacing.predictionHomeCompactCardPadding,
      child: Row(
        children: [
          const _HighlightIconBox(
            icon: Icons.bolt_rounded,
            color: AppColors.warn,
            background: AppColors.warn10,
            iconSize: AppSpacing.predictionHomeHighlightIcon,
          ),
          const SizedBox(width: AppSpacing.predictionHomeHighlightGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breaking movers (24h)',
                  style: AppTextStyles.control.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.predictionHomeHighlightTinyGap,
                ),
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
                      const SizedBox(width: AppSpacing.predictionHomeActionGap),
                    ],
                    Text(
                      '& ${snapshot.breakingMovers.length - 2}+ more',
                      style: AppTextStyles.numericMicro.copyWith(
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
            size: AppSpacing.predictionHomeHighlightCtaIcon,
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
      padding: AppSpacing.predictionHomeBridgeCardPadding,
      child: Row(
        children: [
          const _HighlightIconBox(
            icon: Icons.sports_esports_rounded,
            color: AppColors.warn,
            background: AppColors.warn10,
            iconSize: AppSpacing.predictionHomeHighlightIcon,
          ),
          const SizedBox(width: AppSpacing.predictionHomeHighlightGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.predictionHomeBridgeWrapGap,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Thử thách cùng chủ đề',
                      style: AppTextStyles.control.copyWith(
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
                const SizedBox(height: AppSpacing.predictionHomeBridgeTinyGap),
                Text(
                  'Khám phá các room social points-only trong Open Arena',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
                const SizedBox(height: AppSpacing.predictionHomeBridgeTinyGap),
                Text(
                  'Xem Arena',
                  style: AppTextStyles.badge.copyWith(color: AppColors.warn),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.warn,
            size: AppSpacing.predictionHomeHighlightCtaIcon,
          ),
        ],
      ),
    );
  }
}

class _HighlightIconBox extends StatelessWidget {
  const _HighlightIconBox({
    required this.icon,
    required this.color,
    required this.background,
    required this.iconSize,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.predictionHomeHighlightIconBox,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
