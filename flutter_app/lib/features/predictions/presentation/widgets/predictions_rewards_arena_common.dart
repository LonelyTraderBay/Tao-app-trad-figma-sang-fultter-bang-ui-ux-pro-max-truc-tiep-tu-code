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
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warn,
                    size: 10,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'ARENA POINTS ONLY',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontSize: 9,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.warn10,
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: const Icon(
                      Icons.sports_esports_rounded,
                      color: AppColors.warn,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${room.points} pts',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.warn,
                                fontSize: 10,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
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
                    size: 17,
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          'Room social points-only, không liên quan wallet hay vị thế Prediction.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
          ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          height: 1.1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}
