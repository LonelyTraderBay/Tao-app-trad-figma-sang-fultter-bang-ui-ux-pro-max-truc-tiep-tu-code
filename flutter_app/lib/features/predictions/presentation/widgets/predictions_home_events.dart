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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 5,
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
          const SizedBox(height: 10),
          Text(
            event.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          if (isMulti)
            _MultiOutcomeRow(event: event)
          else
            _BinaryOutcomeBar(outcomes: outcomes),
          const SizedBox(height: 12),
          _EventStatsRow(event: event),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _OutcomeActionButton(outcome: outcomes.first)),
              const SizedBox(width: 8),
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
              style: AppTextStyles.caption.copyWith(
                color: yes.color,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              '${no.label} ${no.chance}%',
              style: AppTextStyles.caption.copyWith(
                color: no.color,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 8,
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
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final outcome in event.outcomes.take(3))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: outcome.color.withValues(alpha: .12),
              border: Border.all(color: outcome.color.withValues(alpha: .25)),
              borderRadius: AppRadii.smRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: outcome.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  outcome.label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${outcome.chance}%',
                  style: AppTextStyles.micro.copyWith(
                    color: outcome.color,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
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
        const SizedBox(width: 12),
        _StatText(
          icon: Icons.group_outlined,
          label: _formatInt(event.participants),
        ),
        const SizedBox(width: 12),
        _StatText(
          icon: Icons.schedule_rounded,
          label: _timeRemaining(event.endDate),
        ),
        const Spacer(),
        Icon(
          event.change24h >= 0
              ? Icons.trending_up_rounded
              : Icons.trending_down_rounded,
          size: 12,
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
          Icon(icon, size: 11, color: AppColors.text3),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
              ),
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
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: outcome.color.withValues(alpha: .12),
        border: Border.all(color: outcome.color.withValues(alpha: .25)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        '${outcome.label} ${outcome.chance}%',
        style: AppTextStyles.caption.copyWith(
          color: outcome.color,
          fontWeight: AppTextStyles.bold,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
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
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              color: AppColors.text3.withValues(alpha: .40),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'No events found',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: 4),
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
