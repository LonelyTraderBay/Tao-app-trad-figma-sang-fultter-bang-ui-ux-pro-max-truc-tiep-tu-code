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
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SmallBadge(
                label: event.category,
                color: _marketPrimary,
                background: _marketPrimary.withValues(alpha: .12),
              ),
              const Spacer(),
              Text(
                _timeRemaining(event.endDate),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          if (isMulti)
            _MultiOutcomeRow(event: event)
          else
            _BinaryOutcomeBar(outcomes: outcomes),
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
              style: AppTextStyles.badge.copyWith(
                color: yes.color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            Text(
              '${no.label} ${no.chance}%',
              style: AppTextStyles.badge.copyWith(
                color: no.color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: AppSpacing.x2,
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
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        for (final outcome in event.outcomes.take(3))
          Text(
            '${outcome.label} ${outcome.chance}%',
            style: AppTextStyles.badge.copyWith(
              color: outcome.color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        if (event.outcomes.length > 3)
          Text(
            '+${event.outcomes.length - 3} khác',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
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
  const _PredictionsEmptyState({
    required this.hasActiveFilters,
    required this.onClearFilters,
    required this.onBreaking,
  });

  final bool hasActiveFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onBreaking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: AppColors.text3.withValues(alpha: .40),
            size: AppSpacing.predictionHomeEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Không có sự kiện phù hợp',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Thử điều chỉnh bộ lọc hoặc xem sự kiện biến động',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: AppSpacing.x3),
            VitCtaButton(
              onPressed: onClearFilters,
              child: const Text('Xóa bộ lọc'),
            ),
          ],
          const SizedBox(height: AppSpacing.x2),
          TextButton(
            onPressed: onBreaking,
            child: Text(
              'Xem Breaking',
              style: AppTextStyles.caption.copyWith(color: _marketPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _timeRemaining(DateTime endDate) {
  final now = DateTime.utc(2026, 2, 27, 12);
  final diff = endDate.difference(now);
  if (diff.isNegative) return 'Đã đóng';
  final days = diff.inDays;
  if (days > 30) return 'Đóng ${days ~/ 30} tháng';
  if (days > 0) return 'Đóng $days ngày';
  return 'Đóng ${diff.inHours}h';
}
