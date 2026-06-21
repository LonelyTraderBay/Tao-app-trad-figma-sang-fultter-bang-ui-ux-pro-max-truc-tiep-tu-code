part of '../pages/predictions_rewards_page.dart';

class _ArenaRooms extends StatelessWidget {
  const _ArenaRooms({required this.snapshot});

  final PredictionRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final room = snapshot.arenaRooms.first;
    return VitPageSection(
      label: 'Room Arena cùng chủ đề',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          key: PredictionsRewardsPage.arenaBridgeKey,
          onTap: () => context.go(AppRoutePaths.arena),
          borderColor: AppColors.warningBorder,
          density: VitDensity.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warn,
                    size: AppSpacing.predictionRewardsArenaLabelIcon,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    'ARENA POINTS ONLY',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Row(
                children: [
                  Material(
                    color: AppColors.warn10,
                    borderRadius: AppRadii.mdRadius,
                    child: SizedBox.square(
                      dimension:
                          VitDensity.compact.controlHeight - AppSpacing.x2,
                      child: const Icon(
                        Icons.sports_esports_rounded,
                        color: AppColors.warn,
                        size: AppSpacing.predictionRewardsArenaIcon,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                room.slots,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            Text(
                              '${room.points} pts',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.warn,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            _TinyBadge(
                              label: room.badge,
                              color: AppColors.warn,
                              background: AppColors.warn10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.predictionRewardsArenaChevron,
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          'Room social points-only, không liên quan wallet hay vị thế Prediction.',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: AppSpacing.predictionRewardsTinyBadgePadding,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            height: AppSpacing.predictionRewardsTinyBadgeLineHeight,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}
