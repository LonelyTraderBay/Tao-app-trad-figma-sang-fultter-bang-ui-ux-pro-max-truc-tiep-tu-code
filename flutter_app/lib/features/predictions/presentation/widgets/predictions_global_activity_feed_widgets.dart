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
      child: Container(
        constraints: const BoxConstraints(minHeight: 78),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.surface3,
                shape: BoxShape.circle,
              ),
              child: Text(
                activity.avatar,
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 5,
                    runSpacing: 3,
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
                          fontSize: 12,
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
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_formatWhole(activity.shares)} shares @ \$${activity.price.toStringAsFixed(2)}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 10,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 58,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatAmount(activity.amount),
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: sideColor,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.timestamp,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          height: 1,
          fontWeight: AppTextStyles.bold,
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
