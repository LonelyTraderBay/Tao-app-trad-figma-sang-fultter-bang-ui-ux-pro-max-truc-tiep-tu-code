part of '../pages/predictions_global_activity_page.dart';

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.snapshot});

  final PredictionGlobalActivitySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < snapshot.activities.length; index += 1)
          _ActivityRow(
            key: PredictionsGlobalActivityPage.activityKey(
              snapshot.activities[index].id,
            ),
            activity: snapshot.activities[index],
            event: snapshot.eventFor(snapshot.activities[index].eventId),
            last: index == snapshot.activities.length - 1,
          ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    super.key,
    required this.activity,
    required this.event,
    required this.last,
  });

  final PredictionGlobalActivityDraft activity;
  final PredictionEventDraft event;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final isBuy = activity.action == PredictionGlobalActivityAction.bought;
    final sideColor = isBuy ? AppColors.buy : AppColors.sell;
    return InkWell(
      onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.predictionActivityRowMinHeight,
            ),
            child: Padding(
              padding: AppSpacing.predictionActivityRowPadding,
              child: Row(
                children: [
                  Material(
                    color: AppColors.surface3,
                    shape: const CircleBorder(),
                    child: SizedBox.square(
                      dimension: AppSpacing.predictionActivityAvatarBox,
                      child: Center(
                        child: Text(
                          activity.avatar,
                          style: AppTextStyles.avatarMd,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.predictionActivityRowGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.predictionActivityActorSpacing,
                          runSpacing:
                              AppSpacing.predictionActivityActorRunSpacing,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              activity.user,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            Text(
                              isBuy ? 'bought' : 'sold',
                              style: AppTextStyles.caption.copyWith(
                                color: sideColor,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            _OutcomeBadge(
                              label: activity.outcome,
                              color: activity.outcome == 'Yes'
                                  ? AppColors.buy
                                  : AppColors.sell,
                            ),
                          ],
                        ),
                        const Padding(
                          padding: AppSpacing.predictionActivityEventGap,
                        ),
                        Text(
                          event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const Padding(
                          padding: AppSpacing.predictionActivityOrderGap,
                        ),
                        Text(
                          '${_formatWhole(activity.shares)} shares @ \$${activity.price.toStringAsFixed(2)}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.predictionActivityAmountGap),
                  SizedBox(
                    width: AppSpacing.predictionActivityAmountWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatAmount(activity.amount),
                          textAlign: TextAlign.right,
                          style: AppTextStyles.caption.copyWith(
                            color: sideColor,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const Padding(
                          padding: AppSpacing.predictionActivityTimestampGap,
                        ),
                        Text(
                          activity.timestamp,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!last)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: AppSpacing.dividerHairline,
                child: ColoredBox(color: AppColors.divider),
              ),
            ),
        ],
      ),
    );
  }
}

class _OutcomeBadge extends StatelessWidget {
  const _OutcomeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: AppSpacing.predictionActivityOutcomePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            height: AppSpacing.predictionActivityOutcomeLineHeight,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

String _formatAmount(double value) {
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatWhole(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i += 1) {
    final fromEnd = text.length - i;
    buffer.write(text[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
