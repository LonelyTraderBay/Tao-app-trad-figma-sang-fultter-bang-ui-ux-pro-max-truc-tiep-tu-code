part of '../pages/predictions_home_page.dart';

class _PredictionEventCard extends StatelessWidget {
  const _PredictionEventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final outcomes = event.outcomes.take(2).toList();
    final isMulti = event.outcomes.length > 2;
    return VitCard(
      onTap: onTap,
      padding: AppSpacing.predictionHomeEventPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.predictionHomeBadgeGap,
            runSpacing: AppSpacing.predictionHomeBadgeRunGap,
            children: [
              _SmallBadge(
                label: event.category,
                color: _marketPrimary,
                background: _marketPrimary.withValues(alpha: .12),
              ),
              for (final tag in event.tags)
                _SmallBadge(
                  label: tag,
                  color: AppColors.text3,
                  background: AppColors.surface2,
                ),
              if (event.isNew)
                _SmallBadge(
                  label: 'NEW',
                  color: AppColors.accent,
                  background: AppColors.accent12,
                ),
              if (event.isTrending)
                _SmallBadge(
                  label: 'HOT',
                  color: AppColors.warn,
                  background: AppColors.warn10,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.predictionHomeEventTitleGap),
          Text(
            event.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.predictionHomeEventTitleGap),
          if (isMulti)
            _MultiOutcomeRow(event: event)
          else
            _BinaryOutcomeBar(outcomes: outcomes),
          const SizedBox(height: AppSpacing.predictionHomeSectionGap),
          _EventStatsRow(event: event),
          const SizedBox(height: AppSpacing.predictionHomeSectionGap),
          Row(
            children: [
              Expanded(child: _OutcomeActionButton(outcome: outcomes.first)),
              const SizedBox(width: AppSpacing.predictionHomeActionGap),
              Expanded(child: _OutcomeActionButton(outcome: outcomes.last)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BinaryOutcomeBar extends StatelessWidget {
  const _BinaryOutcomeBar({required this.outcomes});

  final List<PredictionOutcomeDraft> outcomes;

  @override
  Widget build(BuildContext context) {
    final yes = outcomes.first;
    final no = outcomes.last;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${yes.label} ${yes.chance}%',
              style: AppTextStyles.badge.copyWith(color: yes.color),
            ),
            Text(
              '${no.label} ${no.chance}%',
              style: AppTextStyles.badge.copyWith(color: no.color),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.predictionHomeChanceLabelGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: AppSpacing.predictionHomeChanceBarHeight,
            child: Row(
              children: [
                Expanded(
                  flex: yes.chance,
                  child: ColoredBox(color: yes.color),
                ),
                Expanded(
                  flex: no.chance,
                  child: ColoredBox(color: no.color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MultiOutcomeRow extends StatelessWidget {
  const _MultiOutcomeRow({required this.event});

  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.predictionHomeOutcomeGap,
      runSpacing: AppSpacing.predictionHomeOutcomeGap,
      children: [
        for (final outcome in event.outcomes.take(3))
          Material(
            color: outcome.color.withValues(alpha: .12),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
              side: BorderSide(color: outcome.color.withValues(alpha: .25)),
            ),
            child: Padding(
              padding: AppSpacing.predictionHomeOutcomeChipPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: AppSpacing.predictionHomeOutcomeDot,
                    child: Material(
                      color: outcome.color,
                      shape: const CircleBorder(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.predictionHomeOutcomeGap),
                  Text(
                    outcome.label,
                    style: AppTextStyles.badge.copyWith(color: AppColors.text1),
                  ),
                  const SizedBox(width: AppSpacing.predictionHomeOutcomeGap),
                  Text(
                    '${outcome.chance}%',
                    style: AppTextStyles.badge.copyWith(color: outcome.color),
                  ),
                ],
              ),
            ),
          ),
        if (event.outcomes.length > 3)
          Text(
            '+${event.outcomes.length - 3} more',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}

class _EventStatsRow extends StatelessWidget {
  const _EventStatsRow({required this.event});

  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    final changeColor = event.change24h >= 0 ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        _StatText(
          icon: Icons.bar_chart_rounded,
          label: 'Vol: ${_formatVolume(event.volume24h)}',
        ),
        const SizedBox(width: AppSpacing.predictionHomeStatGap),
        _StatText(
          icon: Icons.group_outlined,
          label: _formatInt(event.participants),
        ),
        const SizedBox(width: AppSpacing.predictionHomeStatGap),
        _StatText(
          icon: Icons.schedule_rounded,
          label: _timeRemaining(event.endDate),
        ),
        const Spacer(),
        Icon(
          event.change24h >= 0
              ? Icons.trending_up_rounded
              : Icons.trending_down_rounded,
          size: AppSpacing.predictionHomeTrendIcon,
          color: changeColor,
        ),
        Text(
          _formatPercent(event.change24h),
          style: AppTextStyles.micro.copyWith(
            color: changeColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _StatText extends StatelessWidget {
  const _StatText({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSpacing.predictionHomeStatIcon,
            color: AppColors.text3,
          ),
          const SizedBox(width: AppSpacing.predictionHomeStatIconGap),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutcomeActionButton extends StatelessWidget {
  const _OutcomeActionButton({required this.outcome});

  final PredictionOutcomeDraft outcome;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.predictionHomeActionHeight,
      child: Material(
        color: outcome.color.withValues(alpha: .12),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.mdRadius,
          side: BorderSide(color: outcome.color.withValues(alpha: .25)),
        ),
        child: Center(
          child: Text(
            '${outcome.label} ${outcome.chance}%',
            style: AppTextStyles.caption.copyWith(
              color: outcome.color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({
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
      shape: RoundedRectangleBorder(borderRadius: AppRadii.badgeRadius),
      child: Padding(
        padding: AppSpacing.predictionHomeBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _PredictionsEmptyState extends StatelessWidget {
  const _PredictionsEmptyState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.predictionHomeEmptyHeight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              color: AppColors.text3.withValues(alpha: .40),
              size: AppSpacing.predictionHomeEmptyIcon,
            ),
            const SizedBox(height: AppSpacing.predictionHomeEmptyTitleGap),
            Text(
              'No events found',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.predictionHomeEmptySubtitleGap),
            Text(
              'Try adjusting your filters or search terms',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatInt(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index += 1) {
    if (index > 0 && (text.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[index]);
  }
  return buffer.toString();
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _timeRemaining(DateTime endDate) {
  final now = DateTime.utc(2026, 2, 27, 12);
  final diff = endDate.difference(now);
  if (diff.isNegative) return 'Ended';
  final days = diff.inDays;
  if (days > 30) return '${days ~/ 30} tháng';
  if (days > 0) return '$days ngày';
  return '${diff.inHours}h';
}
