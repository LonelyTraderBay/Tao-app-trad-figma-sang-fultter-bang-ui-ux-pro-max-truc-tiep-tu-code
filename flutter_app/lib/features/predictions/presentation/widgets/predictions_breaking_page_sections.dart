part of '../pages/predictions_breaking_page.dart';

class _MovementSummary extends StatelessWidget {
  const _MovementSummary({required this.snapshot});

  final PredictionBreakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.bolt_rounded, color: AppColors.warn, size: 18),
          const SizedBox(width: 8),
          Text(
            '24h Movement',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const Spacer(),
          _MovementCount(
            icon: Icons.trending_up_rounded,
            label: '${snapshot.upCount} up',
            color: AppColors.buy,
          ),
          const SizedBox(width: 12),
          _MovementCount(
            icon: Icons.trending_down_rounded,
            label: '${snapshot.downCount} down',
            color: AppColors.sell,
          ),
        ],
      ),
    );
  }
}

class _MovementCount extends StatelessWidget {
  const _MovementCount({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? activeCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (id: null, label: 'All', key: PredictionsBreakingPage.allTabKey),
      for (final category in categories)
        (
          id: category,
          label: category == 'Live Crypto' ? 'Crypto' : category,
          key: category == 'Live Crypto'
              ? PredictionsBreakingPage.cryptoTabKey
              : Key('sc029_category_$category'),
        ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < tabs.length; index += 1) ...[
            _CategoryTabButton(
              key: tabs[index].key,
              label: tabs[index].label,
              active: activeCategory == tabs[index].id,
              onTap: () => onSelected(tabs[index].id),
            ),
            if (index != tabs.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _CategoryTabButton extends StatelessWidget {
  const _CategoryTabButton({
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
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _predictionPrimary.withValues(alpha: .14)
              : AppColors.transparent,
          border: Border.all(
            color: active
                ? _predictionPrimary.withValues(alpha: .36)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _predictionPrimary : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}

class _MoverCard extends StatelessWidget {
  const _MoverCard({
    super.key,
    required this.event,
    required this.rank,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topOutcome = event.outcomes.first;
    final isUp = event.change24h > 0;
    final rankColor = switch (rank) {
      1 => AppColors.warn,
      2 => AppColors.medalSilverBlue,
      3 => AppColors.medalBronze,
      _ => AppColors.text3,
    };
    final changeColor = isUp ? AppColors.buy : AppColors.sell;

    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? rankColor.withValues(alpha: .12)
                  : AppColors.surface2,
              borderRadius: AppRadii.smRadius,
            ),
            child: Text(
              '$rank',
              style: AppTextStyles.caption.copyWith(
                color: rankColor,
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
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Yes: ',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: '${topOutcome.chance}%',
                            style: TextStyle(
                              color: topOutcome.chance >= 50
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ChangeBadge(value: event.change24h, color: changeColor),
                  ],
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyBadge(event.category),
                    _MetaIcon(
                      icon: Icons.bar_chart_rounded,
                      label: _formatVolume(event.volume24h),
                    ),
                    _MetaIcon(
                      icon: Icons.schedule_rounded,
                      label: _timeRemaining(event.endDate),
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

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isUp = value > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            _formatPercent(value),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: _predictionPrimary.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: _predictionPrimary,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _MetaIcon extends StatelessWidget {
  const _MetaIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: 10),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
