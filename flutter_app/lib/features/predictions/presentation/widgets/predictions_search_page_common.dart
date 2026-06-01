part of '../pages/predictions_search_page.dart';

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? _predictionPrimary.withValues(alpha: .12)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _predictionPrimary.withValues(alpha: .30)
                : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? _predictionPrimary : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topOutcome = event.outcomes.first;
    final isResolved = event.status == PredictionEventStatus.resolved;
    final chanceColor = isResolved
        ? AppColors.text3
        : topOutcome.chance >= 50
        ? AppColors.buy
        : AppColors.sell;
    final changeColor = event.change24h >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: chanceColor.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Text(
              '${topOutcome.chance}%',
              style: AppTextStyles.body.copyWith(
                color: chanceColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyBadge(label: event.category),
                    if (isResolved) _TinyBadge(label: 'RESOLVED', muted: true),
                    _MetaText('Vol ${_formatVolume(event.volume24h)}'),
                    _MetaText(_timeRemaining(event.endDate)),
                    if (event.change24h != 0)
                      Text(
                        _formatPercent(event.change24h),
                        style: AppTextStyles.caption.copyWith(
                          color: changeColor,
                          fontSize: 16,
                          fontWeight: AppTextStyles.bold,
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

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.label, this.muted = false});

  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: muted
            ? AppColors.surface2
            : _predictionPrimary.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: muted ? AppColors.text3 : _predictionPrimary,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3, fontSize: 10),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              color: AppColors.text3.withValues(alpha: .42),
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              'No events match filters',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try adjusting your search or filter criteria',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

String _resultsLabel(int count) {
  return '$count event${count == 1 ? '' : 's'} found';
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
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
